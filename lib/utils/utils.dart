// ignore_for_file: constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  CurrenciesObject() {
    lastUpdate = DateTime.parse(lastUpdateString);
  }

  CurrenciesObject.fromJsonResponse(Map<String, dynamic> jsonData) {
    lastUpdateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
    lastUpdate = DateTime.parse(lastUpdateString);
    for (int i = 0; i < CURRENCIES.values.length - 1; i++) {
      //-1 because in this list there is not EUR because int is the base unit
      double value = jsonData['dataSets'][0]['series']['0:$i:0:0:0']['observations'].values.first[0];
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
