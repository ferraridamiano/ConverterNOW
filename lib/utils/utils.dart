// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:units_converter/models/unit.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

///Saves the key value with SharedPreferences
saveSettings(String key, dynamic value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (value is bool) {
    prefs.setBool(key, value);
  } else if (value is int) {
    prefs.setInt(key, value);
  } else if (value is String) {
    prefs.setString(key, value);
  } else if (value is double) {
    prefs.setDouble(key, value);
  } else if (value is List<String>) {
    prefs.setStringList(key, value);
  }
}

enum VALIDATOR { binary, decimal, octal, hexadecimal, rational, rationalNonNegative }

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
    this.validator = VALIDATOR.rationalNonNegative,
    this.textInputType = const TextInputType.numberWithOptions(decimal: true, signed: false),
  });

  RegExp getValidator() {
    switch (validator) {
      case VALIDATOR.binary:
        return RegExp(r'^[0-1]+$');
      case VALIDATOR.octal:
        return RegExp(r'^[0-7]+$');
      case VALIDATOR.decimal:
        return RegExp(r'^[0-9]+$');
      case VALIDATOR.hexadecimal:
        return RegExp(r'^[0-9A-Fa-f]+$');
      case VALIDATOR.rational:
        return RegExp(r'^([+-]?\d+)\.?(\d*)(e[+-]?\d+)?$');
      case VALIDATOR.rationalNonNegative:
      default:
        return RegExp(r'^(\+?\d+)\.?(\d*)(e[+-]?\d+)?$');
    }
  }
}

class CurrenciesObject {
  String lastUpdateString = '2021-12-08';
  late DateTime lastUpdate;
  Map<CURRENCIES, double> values = {
    CURRENCIES.EUR: 1.0,
    CURRENCIES.AUD: 1.5841,
    CURRENCIES.BGN: 1.9558,
    CURRENCIES.BRL: 6.335,
    CURRENCIES.CAD: 1.4281,
    CURRENCIES.CHF: 1.0432,
    CURRENCIES.CNY: 7.1726,
    CURRENCIES.CZK: 25.475,
    CURRENCIES.DKK: 7.4362,
    CURRENCIES.GBP: 0.85603,
    CURRENCIES.HKD: 8.8088,
    CURRENCIES.HRK: 7.525,
    CURRENCIES.HUF: 368.13,
    CURRENCIES.IDR: 16205.54,
    CURRENCIES.ILS: 3.5176,
    CURRENCIES.INR: 85.2345,
    CURRENCIES.ISK: 147.4,
    CURRENCIES.JPY: 128.57,
    CURRENCIES.KRW: 1328.25,
    CURRENCIES.MAD: 10.7485,
    CURRENCIES.MXN: 23.6365,
    CURRENCIES.MYR: 4.7733,
    CURRENCIES.NOK: 10.096,
    CURRENCIES.NZD: 1.6659,
    CURRENCIES.PHP: 56.784,
    CURRENCIES.PLN: 4.5962,
    CURRENCIES.RON: 4.9488,
    CURRENCIES.RUB: 83.3019,
    CURRENCIES.SEK: 10.2513,
    CURRENCIES.SGD: 1.5415,
    CURRENCIES.THB: 37.829,
    CURRENCIES.TRY: 15.4796,
    CURRENCIES.TWD: 33.4243,
    CURRENCIES.USD: 1.1299,
    CURRENCIES.ZAR: 17.8168,
  };

  CurrenciesObject() {
    lastUpdate = DateTime.parse(lastUpdateString);
  }

  CurrenciesObject.fromJsonResponse(Map<String, dynamic> jsonData) {
    lastUpdateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
    lastUpdate = DateTime.parse(lastUpdateString);
    for (int i = 0; i < CURRENCIES.values.length - 1; i++) {
      //-1 because in this list there is not EUR because int is the base unit
      double value = jsonData['dataSets'][0]['series']['0:$i:0:0:0']['observations'].values.first[0].toDouble();
      String name = jsonData['structure']['dimensions']['series'][1]['values'][i]['id'];
      values[getCurrenciesFromString(name)] = value;
    }
  }

  /// This method is useful because it transform a previous stored data (with the toJson method) into this object
  CurrenciesObject.fromJson(Map<String, dynamic> jsonData, String lastUpdate) {
    lastUpdateString = lastUpdate;
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
CURRENCIES getCurrenciesFromString(String name) =>
    CURRENCIES.values.singleWhere((element) => element.toString().endsWith(name));

/// Maps a string (path of the url) to a number value. This should be in the
/// same order as in property_unit_list.dart
const Map<String, int> pageNumberMap = {
  'length': 0,
  'area': 1,
  'volume': 2,
  'currencies': 3,
  'time': 4,
  'temperature': 5,
  'speed': 6,
  'mass': 7,
  'force': 8,
  'fuel-consumption': 9,
  'numeral-systems': 10,
  'pressure': 11,
  'energy': 12,
  'power': 13,
  'angle': 14,
  'shoe-size': 15,
  'digital-data': 16,
  'si-prefixes': 17,
  'torque': 18,
};

/// Contains the same information of [pageNumberMap] but reversed. So I can
/// access to the strings faster.
final List<String> reversePageNumberListMap = pageNumberMap.keys.toList();

enum AppPage { conversions, settings, reorder, reorder_details }

/// PROPERTYX stands for PROPERTY extended and want to extends the PROPERTY enum defined in units_converter package
enum PROPERTYX {
  angle,
  area,
  currencies,
  digitalData,
  energy,
  force,
  fuelConsumption,
  length,
  mass,
  numeralSystems,
  power,
  pressure,
  shoeSize,
  siPrefixes,
  speed,
  temperature,
  time,
  torque,
  volume,
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
  MAD,
}

class PropertyUi {
  final PROPERTYX property;

  ///uman readable name
  final String name;
  final String imagePath;

  PropertyUi(this.property, this.name, this.imagePath);
}

class UnitUi {
  ///name of the unit
  final dynamic unit;

  ///human readable name
  final String name;
  final String imagePath;
  final PROPERTYX property;

  UnitUi(this.unit, this.name, this.imagePath, this.property);
}

void initializeQuickAction(
    {required void Function(String index) onActionSelection,
    required List<int> conversionsOrderDrawer,
    required List<PropertyUi> propertyUiList}) {
  final int index1 = conversionsOrderDrawer.indexWhere((val) => val == 1);
  final int index2 = conversionsOrderDrawer.indexWhere((val) => val == 2);
  final int index3 = conversionsOrderDrawer.indexWhere((val) => val == 3);
  const QuickActions quickActions = QuickActions();
  quickActions.initialize(onActionSelection);
  quickActions.setShortcutItems(<ShortcutItem>[
    ShortcutItem(
      type: index1.toString(),
      localizedTitle: propertyUiList[index1].name,
      icon: 'splash',
    ),
    ShortcutItem(
      type: index2.toString(),
      localizedTitle: propertyUiList[index2].name,
      icon: 'splash',
    ),
    ShortcutItem(
      type: index3.toString(),
      localizedTitle: propertyUiList[index3].name,
      icon: 'splash',
    ),
  ]);
}
