import 'package:converterpro/helpers/responsive_helper.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/utils/PropertyUnitList.dart';
import 'package:intl/intl.dart';

class ConversionPage extends StatelessWidget {

  final List<UnitData> unitDataList;
  final PROPERTYX currentProperty;

  ConversionPage(this.currentProperty, this.unitDataList);

  @override
  Widget build(BuildContext context) {
    Map<dynamic, String> unitTranslationMap = getUnitTranslationMap(context);
    Map<PROPERTYX, String> propertyTranslationMap = getPropertyTranslationMap(context);
    List<ListItem> itemList = [];

    Brightness brightness = getBrightness(
      context.select<AppModel, ThemeMode>((AppModel appModel) => appModel.currentThemeMode),
      MediaQuery.of(context).platformBrightness,
    );

    String subTitle = '';
    if (currentProperty == PROPERTYX.CURRENCIES) {
      subTitle = getLastUpdateString(context);
    }

    itemList.add(
      BigHeader(
        title: propertyTranslationMap[currentProperty]!,
        subTitle: subTitle,
      ),
    );
    for (UnitData unitData in unitDataList) {
      itemList.add(
        MyCard(
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
                if (unitData.property == PROPERTYX.NUMERAL_SYSTEMS) {
                  conversions.convert(unitData, txt == "" ? null : txt);
                } else {
                  conversions.convert(unitData, txt == "" ? null : double.parse(txt));
                }
              }
            },
          ),
        ),
      );
    }

    List<Widget> gridTiles = [];
    for (ListItem item in itemList) {
      if (item is MyCard) {
        gridTiles.add(UnitCard(
          symbol: item.symbol,
          textField: item.textField,
        ));
      } else if (item is BigHeader) {
        gridTiles.add(
          BigTitle(
            text: item.title,
            subtitle: item.subTitle,
            isCurrenciesLoading: context.select<Conversions, bool>((conversions) => conversions.isCurrenciesLoading),
            brightness: brightness,
          ),
        );
      }
    }

    double displayWidth = MediaQuery.of(context).size.width;
    double xPadding = responsivePadding(displayWidth);

    return GridView.count(
      controller: ScrollController(),
      childAspectRatio: responsiveChildAspectRatio(displayWidth),
      crossAxisCount: responsiveNumGridTiles(displayWidth),
      shrinkWrap: true,
      crossAxisSpacing: 15.0,
      children: gridTiles,
      padding: EdgeInsets.only(right: xPadding, left: xPadding, bottom: 22), //bottom so FAB doesn't overlap the card
    );
  }
}

String getLastUpdateString(BuildContext context) {
  DateTime lastUpdateCurrencies = context.select<Conversions, DateTime>((settings) => settings.lastUpdateCurrency);
  DateTime dateNow = DateTime.now();
  if (lastUpdateCurrencies.day == dateNow.day && lastUpdateCurrencies.month == dateNow.month && lastUpdateCurrencies.year == dateNow.year) {
    return AppLocalizations.of(context)!.lastCurrenciesUpdate + AppLocalizations.of(context)!.today;
  }
  return AppLocalizations.of(context)!.lastCurrenciesUpdate + DateFormat.yMd(Localizations.localeOf(context).languageCode).format(lastUpdateCurrencies);
}
