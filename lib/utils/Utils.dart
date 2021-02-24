import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  MyCard({this.symbol, this.textField});

  String symbol;
  final Widget textField;
}

class BigHeader implements ListItem {
  BigHeader({this.title, this.subTitle});
  String title;
  String subTitle;
}

class BigTitle extends StatelessWidget {
  BigTitle({this.text, this.subtitle, this.isCurrenciesLoading, this.brightness});
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
  UnitCard({this.symbol, this.textField});

  final String symbol;
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
                      symbol,
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
  Function onTap;
  SearchUnit({this.iconAsset, this.unitName, this.onTap});
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
  const SuggestionList({this.suggestions, this.darkMode});

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
  final onTap;
  final bool darkMode;
  SearchGridTile({this.iconAsset, this.footer, this.onTap, this.darkMode});

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
  final Function onTapFunction;
  final Brightness brightness;
  ListTileConversion({this.text, this.imagePath, this.selected, this.onTapFunction, this.brightness});

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
        onTap: onTapFunction,
      ),
      selectedColor: Theme.of(context).accentColor,
    );
  }
}

enum VALIDATOR { BINARY, DECIMAL, OCTAL, HEXADECIMAL, RATIONAL_NON_NEGATIVE }

class UnitData {
  Unit unit;
  TextEditingController tec;
  TextInputType textInputType;
  VALIDATOR validator;
  PROPERTYX property;

  UnitData(
    this.unit, {
    this.tec,
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
      case VALIDATOR.RATIONAL_NON_NEGATIVE:
      default:
        return RegExp(r'^[0-9/./e/+/-]+$');
    }
  }
}

class CurrencyObject {
  DoubleCurrencyConversion results;
  CurrencyObject({this.results});

  factory CurrencyObject.fromJson(Map<String, dynamic> json) {
    return CurrencyObject(results: DoubleCurrencyConversion.fromJson(json['property']));
  }
}

class DoubleCurrencyConversion {
  CurrencyConversion conversion1;
  CurrencyConversion conversion2;
  DoubleCurrencyConversion({
    this.conversion1,
    this.conversion2,
  });

  factory DoubleCurrencyConversion.fromJson(Map<String, dynamic> json) {
    return DoubleCurrencyConversion(conversion1: CurrencyConversion.fromJson(json['USD_EUR']), conversion2: CurrencyConversion.fromJson(json['USD_GBP']));
  }
}

class CurrencyConversion {
  String id, to, fr;
  double val;

  CurrencyConversion({this.id, this.val, this.to, this.fr});

  factory CurrencyConversion.fromJson(Map<String, dynamic> json) {
    return CurrencyConversion(id: json['id'], val: json['val'], to: json['to'], fr: json['fr']);
  }
}

class CurrencyJSONObject {
  String base;
  Map<CURRENCIES, double> rates;
  String date;

  Map<CURRENCIES, String> encodeMap = {
    CURRENCIES.USD: 'USD',
    CURRENCIES.GBP: 'GBP',
    CURRENCIES.INR: 'INR',
    CURRENCIES.CNY: 'CNY',
    CURRENCIES.JPY: 'JPY',
    CURRENCIES.RUB: 'RUB',
    CURRENCIES.CHF: 'CHF',
    CURRENCIES.SEK: 'SEK',
    CURRENCIES.KRW: 'KRW',
    CURRENCIES.BRL: 'BRL',
    CURRENCIES.CAD: 'CAD',
    CURRENCIES.HKD: 'HKD',
    CURRENCIES.AUD: 'AUD',
    CURRENCIES.NZD: 'NZD',
    CURRENCIES.MXN: 'MXN',
    CURRENCIES.SGD: 'SGD',
    CURRENCIES.NOK: 'NOK',
    CURRENCIES.TRY: 'TRY',
    CURRENCIES.ZAR: 'ZAR',
    CURRENCIES.DKK: 'DKK',
    CURRENCIES.PLN: 'PLN',
    CURRENCIES.THB: 'THB',
    CURRENCIES.MYR: 'MYR',
    CURRENCIES.HUF: 'HUF',
    CURRENCIES.CZK: 'CZK',
    CURRENCIES.ILS: 'ILS',
    CURRENCIES.IDR: 'IDR',
    CURRENCIES.PHP: 'PHP',
    CURRENCIES.RON: 'RON',
  };

  CurrencyJSONObject({this.base, this.rates, this.date});

  factory CurrencyJSONObject.fromJson(Map<String, dynamic> parsedJson) {
    Map<String, dynamic> ratesJson = parsedJson['rates'];
    return CurrencyJSONObject(base: parsedJson['base'], date: parsedJson['date'], rates: {
      CURRENCIES.USD: ratesJson['USD'],
      CURRENCIES.GBP: ratesJson['GBP'],
      CURRENCIES.INR: ratesJson['INR'],
      CURRENCIES.CNY: ratesJson['CNY'],
      CURRENCIES.JPY: ratesJson['JPY'],
      CURRENCIES.RUB: ratesJson['RUB'],
      CURRENCIES.CHF: ratesJson['CHF'],
      CURRENCIES.SEK: ratesJson['SEK'],
      CURRENCIES.KRW: ratesJson['KRW'],
      CURRENCIES.BRL: ratesJson['BRL'],
      CURRENCIES.CAD: ratesJson['CAD'],
      CURRENCIES.HKD: ratesJson['HKD'],
      CURRENCIES.AUD: ratesJson['AUD'],
      CURRENCIES.NZD: ratesJson['NZD'],
      CURRENCIES.MXN: ratesJson['MXN'],
      CURRENCIES.SGD: ratesJson['SGD'],
      CURRENCIES.NOK: ratesJson['NOK'],
      CURRENCIES.TRY: ratesJson['TRY'],
      CURRENCIES.ZAR: ratesJson['ZAR'],
      CURRENCIES.DKK: ratesJson['DKK'],
      CURRENCIES.PLN: ratesJson['PLN'],
      CURRENCIES.THB: ratesJson['THB'],
      CURRENCIES.MYR: ratesJson['MYR'],
      CURRENCIES.HUF: ratesJson['HUF'],
      CURRENCIES.CZK: ratesJson['CZK'],
      CURRENCIES.ILS: ratesJson['ILS'],
      CURRENCIES.IDR: ratesJson['IDR'],
      CURRENCIES.PHP: ratesJson['PHP'],
      CURRENCIES.RON: ratesJson['RON']
    });
  }

  ///Recreates the body of the http response (json format) as a String
  String toString() {
    String myString = '{"rates":{';
    rates.forEach((key, value) => myString += '"${encodeMap[key]}":${value.toString()},'); //add all the currency values
    myString = myString.replaceRange(myString.length - 1, myString.length, ''); //remove latest comma
    myString += '},"base":"$base","date":"$date"}';
    return myString;
  }
}

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
  USD,
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
