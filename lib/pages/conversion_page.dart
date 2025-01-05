import 'package:converterpro/app_router.dart';
import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/models/currencies.dart';
import 'package:converterpro/models/hide_units.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:converterpro/data/property_unit_maps.dart';
import 'package:intl/intl.dart';

class ConversionPage extends ConsumerWidget {
  final PROPERTYX property;

  const ConversionPage(this.property, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if we remove the following check, if you enter the site directly to
    // '/conversions/:property' an error will occur
    if (!ref.watch(isEverythingLoadedProvider)) {
      return const SplashScreenWidget();
    }

    final unitDataList =
        ref.watch(ConversionsNotifier.provider).value![property]!;
    final propertyUiMap = getPropertyUiMap(context);
    final unitMap = getUnitUiMap(context)[property]!;
    final hiddenUnits =
        ref.watch(HiddenUnitsNotifier.provider).value![property]!;
    final hiddenUnitData =
        unitDataList.where((e) => hiddenUnits.contains(e.unit.name));
    final unhiddenUnitData =
        unitDataList.where((e) => !hiddenUnits.contains(e.unit.name));

    Widget? subtitleWidget;
    if (property == PROPERTYX.currencies) {
      Currencies? currencies = ref.watch(CurrenciesNotifier.provider).value;
      if (currencies == null) {
        subtitleWidget = const SizedBox(
          height: 30,
          child: Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      } else {
        subtitleWidget = Text(
          _getLastUpdateString(context, currencies.lastUpdate),
          style: Theme.of(context).textTheme.titleSmall,
        );
      }
    }

    UnitWidget unitWidgetBuilder(UnitData unitData) => UnitWidget(
          tffKey: unitData.unit.name.toString(),
          unitName: unitMap[unitData.unit.name]!,
          unitSymbol: unitData.unit.symbol,
          keyboardType: unitData.textInputType,
          controller: unitData.tec,
          validator: (String? input) {
            if (input != null) {
              if (input != '' && !unitData.getValidator().hasMatch(input)) {
                return AppLocalizations.of(context)!.invalidCharacters;
              }
            }
            return null;
          },
          onChanged: (String txt) {
            if (txt.contains(',')) {
              txt = txt.replaceAll(',', '.');
              unitData.tec.text = txt;
            }
            if (txt.startsWith('.')) {
              txt = '0$txt';
              unitData.tec.text = txt;
            }
            if (txt == '' || unitData.getValidator().hasMatch(txt)) {
              var conversions = ref.read(ConversionsNotifier.provider.notifier);
              //just numeral system uses a string for conversion
              if (unitData.property == PROPERTYX.numeralSystems) {
                conversions.convert(unitData, txt == "" ? null : txt, property);
              } else {
                conversions.convert(
                  unitData,
                  txt == "" ? null : double.parse(txt),
                  property,
                );
              }
            }
          },
        );

    final unhiddenGridTiles = unhiddenUnitData.map(unitWidgetBuilder).toList();
    final hiddenGridTiles = hiddenUnitData.map(unitWidgetBuilder).toList();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      final int numCols = responsiveNumCols(constraint.maxWidth);
      return CustomScrollView(slivers: <Widget>[
        SliverAppBar.large(
          title: Text(propertyUiMap[property]!.name),
        ),
        if (subtitleWidget != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [subtitleWidget],
              ),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.only(top: 10),
          sliver: SliverGrid.count(
            crossAxisCount: numCols,
            childAspectRatio: responsiveChildAspectRatio(
              constraint.maxWidth,
              numCols,
            ),
            children: unhiddenGridTiles,
          ),
        ),
        if (hiddenUnitData.isNotEmpty)
          SliverToBoxAdapter(
            child: ExpansionTile(
              title: Text(
                'Hidden units', // TODO
                style: Theme.of(context).textTheme.titleLarge,
              ),
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: numCols,
                  childAspectRatio:
                      responsiveChildAspectRatio(constraint.maxWidth, numCols),
                  children: hiddenGridTiles,
                ),
              ],
            ),
          ),
        if (isDrawerFixed(MediaQuery.sizeOf(context).width))
          SliverToBoxAdapter(child: SizedBox(height: 70)),
      ]);
    });
  }
}

String _getLastUpdateString(BuildContext context, String lastUpdate) {
  DateTime lastUpdateCurrencies = DateTime.parse(lastUpdate);
  DateTime dateNow = DateTime.now();
  if (lastUpdateCurrencies.day == dateNow.day &&
      lastUpdateCurrencies.month == dateNow.month &&
      lastUpdateCurrencies.year == dateNow.year) {
    return AppLocalizations.of(context)!.lastCurrenciesUpdate +
        AppLocalizations.of(context)!.today;
  }
  return AppLocalizations.of(context)!.lastCurrenciesUpdate +
      DateFormat.yMd(Localizations.localeOf(context).languageCode)
          .format(lastUpdateCurrencies);
}
