// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:units_converter/models/unit.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(
  Uri url, {
  LaunchMode mode = LaunchMode.platformDefault,
}) async {
  if (!await launchUrl(url, mode: mode)) throw 'Could not launch $url';
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

enum VALIDATOR {
  binary,
  decimal,
  octal,
  hexadecimal,
  rational,
  rationalNonNegative
}

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
    this.textInputType =
        const TextInputType.numberWithOptions(decimal: true, signed: false),
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

/// PROPERTYX stands for PROPERTY extended and want to extends the PROPERTY enum
/// defined in units_converter package
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

class PropertyUi {
  final PROPERTYX property;

  /// human readable name
  final String name;
  final String imagePath;

  PropertyUi(this.property, this.name, this.imagePath);
}

class UnitUi {
  /// name of the unit
  final dynamic unit;

  /// human readable name
  final String name;
  final String imagePath;
  final PROPERTYX property;

  UnitUi(this.unit, this.name, this.imagePath, this.property);
}

void initializeQuickAction(
    {required void Function(String index) onActionSelection,
    required List<int> conversionsOrderDrawer,
    required List<PropertyUi> propertyUiList}) {
  // If it is not on a mobile device, return, otherwise set the quick actions
  final bool isMobileDevice = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  if (!isMobileDevice) return;

  final int index1 = conversionsOrderDrawer.indexWhere((val) => val == 1);
  final int index2 = conversionsOrderDrawer.indexWhere((val) => val == 2);
  final int index3 = conversionsOrderDrawer.indexWhere((val) => val == 3);
  const QuickActions quickActions = QuickActions();
  quickActions.initialize(onActionSelection);
  quickActions.setShortcutItems(<ShortcutItem>[
    ShortcutItem(
      type: index1.toString(),
      localizedTitle: propertyUiList[index1].name,
      icon: 'launch_image',
    ),
    ShortcutItem(
      type: index2.toString(),
      localizedTitle: propertyUiList[index2].name,
      icon: 'launch_image',
    ),
    ShortcutItem(
      type: index3.toString(),
      localizedTitle: propertyUiList[index3].name,
      icon: 'launch_image',
    ),
  ]);
}

Color getIconColor(ThemeData theme) =>
    theme.brightness == Brightness.light ? Colors.black45 : Colors.white70;

void updateNavBarColor(ColorScheme colorscheme) {
  var mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: ElevationOverlay.applySurfaceTint(
    colorscheme.surfaceContainer,
    Colors.transparent,
    3,
  ));
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
}
