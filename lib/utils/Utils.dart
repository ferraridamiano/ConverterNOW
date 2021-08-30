import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:units_converter/Unit.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

Brightness getBrightness(ThemeMode themeMode, Brightness platformBrightness) {
  if (themeMode == ThemeMode.light) {
    return Brightness.light;
  } else if (themeMode == ThemeMode.dark) {
    return Brightness.dark;
  }
  return platformBrightness;
}

abstract class ListItem {}

class MyCard implements ListItem {
  MyCard({this.symbol, required this.textField});

  String? symbol;
  final Widget textField;
}

class BigHeader implements ListItem {
  BigHeader({required this.title, required this.subTitle});
  String title;
  String subTitle;
}

class BigTitle extends StatelessWidget {
  BigTitle({
    required this.text,
    required this.subtitle,
    required this.isCurrenciesLoading,
    required this.brightness,
  });
  final String text;
  final String subtitle;
  final bool isCurrenciesLoading;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            maxLines: 2,
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              color: brightness == Brightness.dark ? Color(0xFFDDDDDD) : Color(0xFF666666),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            subtitle != ''
                ? Container(
                    height: 17.0,
                    alignment: Alignment.bottomRight,
                    child: (isCurrenciesLoading && subtitle != "")
                        ? Container(
                            padding: EdgeInsets.only(right: 10),
                            child: CircularProgressIndicator(),
                            height: 15.0,
                            width: 25.0,
                          )
                        : Text(
                            subtitle,
                            style: TextStyle(fontSize: 15.0, color: Color(0xFF999999)),
                          ),
                  )
                : SizedBox(),
            Divider(
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }
}

class UnitCard extends StatelessWidget {
  UnitCard({required this.symbol, required this.textField});

  final String? symbol;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top: 14.0),
          child: new Card(
            child: Padding(padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0), child: this.textField),
            elevation: 4.0,
          ),
        ),
        symbol == null
            ? SizedBox()
            : Align(
                alignment: Alignment(0.95, -0.9),
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      symbol!,
                      style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              ),
      ],
    );
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

bool getBoolWithProbability(int probability) {
  Random random = new Random();
  int num = random.nextInt(100); //numero da 0 a 99
  return num < probability;
}

class SearchUnit {
  String iconAsset;
  String unitName;
  GestureTapCallback onTap;
  SearchUnit({required this.iconAsset, required this.unitName, required this.onTap});
}

class SearchUnitTile extends StatelessWidget {
  final SearchUnit searchUnit;
  final bool darkMode;
  SearchUnitTile(this.searchUnit, this.darkMode);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(searchUnit.iconAsset, height: 26.0, color: darkMode ? Colors.white : Colors.grey),
      title: Text(searchUnit.unitName),
      onTap: searchUnit.onTap,
    );
  }
}

class SuggestionList extends StatelessWidget {
  final List<SearchUnit> suggestions;
  final bool darkMode;
  SuggestionList({required this.suggestions, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[for (int i = 0; i < suggestions.length; i++) SearchUnitTile(suggestions[i], darkMode)],
    );
  }
}

class SearchGridTile extends StatelessWidget {
  final String iconAsset;
  final String footer;
  final GestureTapCallback onTap;
  final bool darkMode;
  SearchGridTile({
    required this.iconAsset,
    required this.footer,
    required this.onTap,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: GridTile(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 55.0,
                height: 55.0,
                child: Image.asset(iconAsset, color: darkMode ? Colors.white : Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                footer,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListTileConversion extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool selected;
  final GestureTapCallback onTap;
  final Brightness brightness;
  ListTileConversion({
    required this.text,
    required this.imagePath,
    required this.selected,
    required this.onTap,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: ListTile(
        title: Row(
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 30.0,
              height: 30.0,
              color: (selected ? Theme.of(context).accentColor : (brightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54)),
              filterQuality: FilterQuality.medium,
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              text,
              style: TextStyle(
                color: selected ? Theme.of(context).accentColor : (brightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          ],
        ),
        selected: selected,
        onTap: onTap,
      ),
      selectedColor: Theme.of(context).accentColor,
    );
  }
}

///Saves the key value with SharedPreferences
saveSettings(String key, dynamic value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(value is bool){
    prefs.setBool(key, value);
  } else if(value is int){
    prefs.setInt(key, value);
  } else if(value is String){
    prefs.setString(key, value);
  } else if(value is double){
    prefs.setDouble(key, value);
  } else if(value is List<String>){
    prefs.setStringList(key, value);
  }
}

enum VALIDATOR { BINARY, DECIMAL, OCTAL, HEXADECIMAL, RATIONAL, RATIONAL_NON_NEGATIVE }

class UnitData {
  Unit unit;
  TextEditingController tec;
  TextInputType textInputType;
  VALIDATOR validator;
  PROPERTYX? property;

  UnitData(
    this.unit, {
    required this.tec,
    this.property,
    this.validator = VALIDATOR.RATIONAL_NON_NEGATIVE,
    this.textInputType = const TextInputType.numberWithOptions(decimal: true, signed: false),
  });

  RegExp getValidator() {
    switch (validator) {
      case VALIDATOR.BINARY:
        return RegExp(r'^[0-1]+$');
      case VALIDATOR.OCTAL:
        return RegExp(r'^[0-7]+$');
      case VALIDATOR.DECIMAL:
        return RegExp(r'^[0-9]+$');
      case VALIDATOR.HEXADECIMAL:
        return RegExp(r'^[0-9A-Fa-f]+$');
      case VALIDATOR.RATIONAL:
        return RegExp(r'^([+-]?\d+)\.?(\d*)(e[+-]?\d+)?$');
      case VALIDATOR.RATIONAL_NON_NEGATIVE:
      default:
        return RegExp(r'^(\+?\d+)\.?(\d*)(e[+-]?\d+)?$');
    }
  }
}

class CurrenciesObject {
  String lastUpdateString = '2021-02-01';
  late DateTime lastUpdate;
  Map<CURRENCIES, double> values = {
    CURRENCIES.EUR: 1.0,
    CURRENCIES.CAD: 1.5474,
    CURRENCIES.HKD: 9.3687,
    CURRENCIES.RUB: 91.6248,
    CURRENCIES.PHP: 58.083,
    CURRENCIES.DKK: 7.4373,
    CURRENCIES.NZD: 1.6844,
    CURRENCIES.CNY: 7.8143,
    CURRENCIES.AUD: 1.5831,
    CURRENCIES.RON: 4.8735,
    CURRENCIES.SEK: 10.1627,
    CURRENCIES.IDR: 17011.92,
    CURRENCIES.INR: 88.345,
    CURRENCIES.BRL: 6.5765,
    CURRENCIES.USD: 1.2084,
    CURRENCIES.ILS: 3.9739,
    CURRENCIES.JPY: 126.77,
    CURRENCIES.THB: 36.228,
    CURRENCIES.CHF: 1.0816,
    CURRENCIES.CZK: 25.975,
    CURRENCIES.MYR: 4.885,
    CURRENCIES.TRY: 8.6902,
    CURRENCIES.MXN: 24.5157,
    CURRENCIES.NOK: 10.389,
    CURRENCIES.HUF: 356.35,
    CURRENCIES.ZAR: 18.1574,
    CURRENCIES.SGD: 1.6092,
    CURRENCIES.GBP: 0.882,
    CURRENCIES.KRW: 1351.21,
    CURRENCIES.PLN: 4.508,
    CURRENCIES.BGN: 1.9558,
    CURRENCIES.HRK: 7.5715,
    CURRENCIES.ISK: 151.9,
    CURRENCIES.TWD: 32.93,
  };

  CurrenciesObject(){
    lastUpdate = DateTime.parse(lastUpdateString);
  }

  CurrenciesObject.fromJsonResponse(Map<String, dynamic> jsonData) {
    lastUpdateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
    lastUpdate = DateTime.parse(lastUpdateString);
    for (int i = 0; i < CURRENCIES.values.length - 1; i++) {
      //-1 because in this list there is not EUR because int is the base unit
      double value = jsonData['dataSets'][0]['series']['0:$i:0:0:0']['observations']['0'][0];
      String name = jsonData['structure']['dimensions']['series'][1]['values'][i]['id'];
      values[getCurrenciesFromString(name)] = value;
    }
  }

  /// This method is useful because it transform a previous stored data (with the toJson method) into this object
  CurrenciesObject.fromJson(Map<String, dynamic> jsonData, String lastUpdate) {
    this.lastUpdateString = lastUpdate;
    this.lastUpdate = DateTime.parse(lastUpdateString);

    for (String key in jsonData.keys) {
      values[getCurrenciesFromString(key)] = jsonData[key]!;
    }
  }

  /// This method is useful because it transform the values map into a json that can be stored
  String toJson() {
    Map<String, double> currenciesString = {};
    for (CURRENCIES currency in values.keys) {
      currenciesString[currency.toString()] = values[currency]!;
    }
    return jsonEncode(currenciesString);
  }
}

/// Returns a CURRENCIES froma string. e.g. getCurrenciesFromString(EUR)=CURRENCIES.EUR; getCurrenciesFromString(CURRENCIES.EUR)=CURRENCIES.EUR;
CURRENCIES getCurrenciesFromString(String name) => CURRENCIES.values.singleWhere((element) => element.toString().endsWith(name));

/// PROPERTYX stands for PROPERTY extended and want to extends the PROPERTY enum defined in units_converter package
enum PROPERTYX {
  ANGLE,
  AREA,
  CURRENCIES,
  DIGITAL_DATA,
  ENERGY,
  FORCE,
  FUEL_CONSUMPTION,
  LENGTH,
  MASS,
  NUMERAL_SYSTEMS,
  POWER,
  PRESSURE,
  SHOE_SIZE,
  SI_PREFIXES,
  SPEED,
  TEMPERATURE,
  TIME,
  TORQUE,
  VOLUME,
}

enum CURRENCIES {
  EUR,
  USD,
  CAD,
  HKD,
  RUB,
  PHP,
  DKK,
  NZD,
  CNY,
  AUD,
  RON,
  SEK,
  IDR,
  INR,
  BRL,
  ILS,
  JPY,
  THB,
  CHF,
  CZK,
  MYR,
  TRY,
  MXN,
  NOK,
  HUF,
  ZAR,
  SGD,
  GBP,
  KRW,
  PLN,
  HRK,
  ISK,
  BGN,
  TWD,
}

class PropertyUi {
  final PROPERTYX property;
  final String name; //uman readable name
  final String imagePath;

  PropertyUi(this.property, this.name, this.imagePath);
}

class UnitUi {
  final unit; //name of the unit
  final String name; //uman readable name
  final String imagePath;
  final PROPERTYX property;

  UnitUi(this.unit, this.name, this.imagePath, this.property);
}
