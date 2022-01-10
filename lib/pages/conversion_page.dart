import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/conversions.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/utils/property_unit_list.dart';
import 'package:intl/intl.dart';

class ConversionPage extends StatelessWidget {

  final int page;

  const ConversionPage(this.page, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    Map<PROPERTYX, String> propertyTranslationMap = getPropertyTranslationMap(context);
    final bool isConversionsLoaded = context.select<Conversions, bool>((conversions) => conversions.isConversionsLoaded);

    // if we remove the following check, if you enter the site directly to
    // '/conversions/:property' an error will occur
    if(!isConversionsLoaded){
      return const SplashScreenWidget();
    }
    
    List<UnitData> unitDataList = context.read<Conversions>().getUnitDataListAtPage(page);


    PROPERTYX currentProperty =
        context.read<Conversions>().getPropertyNameAtPage(page);

    final Brightness brightness = Theme.of(context).brightness;

    String subTitle = '';
    if (currentProperty == PROPERTYX.currencies) {
      subTitle = _getLastUpdateString(context);
    }

    List<Widget> gridTiles = [];

    for (UnitData unitData in unitDataList) {
      gridTiles.add(UnitCard(
        symbol: unitData.unit.symbol,
        textField: TextFormField(
          key: Key(unitData.unit.name.toString()),
          style: TextStyle(
            fontSize: 16.0,
            color: brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          keyboardType: unitData.textInputType,
          controller: unitData.tec,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String? input) {
            if (input != null && input != '' && !unitData.getValidator().hasMatch(input)) {
              return AppLocalizations.of(context)!.invalidCharacters;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: unitTranslationMap[unitData.unit.name],
          ),
          onChanged: (String txt) {
            if (txt == '' || unitData.getValidator().hasMatch(txt)) {
              Conversions conversions = context.read<Conversions>();
              //just numeral system uses a string for conversion
              if (unitData.property == PROPERTYX.numeralSystems) {
                conversions.convert(unitData, txt == "" ? null : txt, page);
              } else {
                conversions.convert(unitData, txt == "" ? null : double.parse(txt), page);
              }
            }
          },
        ),
      ));
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraint) {
      final int numCols = responsiveNumCols(constraint.maxWidth);
      final double xPadding = responsivePadding(constraint.maxWidth);
      return Column(
        children: [
          BigTitle(
            text: propertyTranslationMap[currentProperty]!,
            subtitle: subTitle,
            isSubtitleLoading: context.select<Conversions, bool>((conversions) => conversions.isCurrenciesLoading),
            center: true,
          ),
          Expanded(
            child: GridView.count(
              childAspectRatio: responsiveChildAspectRatio(constraint.maxWidth, numCols),
              crossAxisCount: numCols,
              crossAxisSpacing: 15.0,
              children: gridTiles,
              padding: EdgeInsets.only(
                left: xPadding,
                right: xPadding,
                bottom: 22, //So FAB doesn't overlap the card
              ), 
              shrinkWrap: true,
            ),
          ),
        ],
      );
    });
  }
}

String _getLastUpdateString(BuildContext context) {
  DateTime lastUpdateCurrencies = context.select<Conversions, DateTime>((settings) => settings.lastUpdateCurrency);
  DateTime dateNow = DateTime.now();
  if (lastUpdateCurrencies.day == dateNow.day &&
      lastUpdateCurrencies.month == dateNow.month &&
      lastUpdateCurrencies.year == dateNow.year) {
    return AppLocalizations.of(context)!.lastCurrenciesUpdate + AppLocalizations.of(context)!.today;
  }
  return AppLocalizations.of(context)!.lastCurrenciesUpdate +
      DateFormat.yMd(Localizations.localeOf(context).languageCode).format(lastUpdateCurrencies);
}
