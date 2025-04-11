// ignore_for_file: constant_identifier_names
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  RegExp getValidator() => switch (validator) {
        VALIDATOR.binary => RegExp(r'^[0-1]+$'),
        VALIDATOR.octal => RegExp(r'^[0-7]+$'),
        VALIDATOR.decimal => RegExp(r'^[0-9]+$'),
        VALIDATOR.hexadecimal => RegExp(r'^[0-9A-Fa-f]+$'),
        VALIDATOR.rational => RegExp(r'^([+-]?\d+)\.?(\d*)(e[+-]?\d+)?$'),
        _ => RegExp(r'^(\+?\d+)\.?(\d*)(e[+-]?\d+)?$'),
      };
}

/// PROPERTYX stands for PROPERTY extended and want to extends the PROPERTY enum
/// defined in units_converter package
enum PROPERTYX {
  angle,
  area,
  density,
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

typedef PropertyUi = ({String name, String imagePath});

void initializeQuickAction(
    {required void Function(String index) onActionSelection,
    required List<PROPERTYX> conversionsOrderDrawer,
    required Map<PROPERTYX, PropertyUi> propertyUiMap}) {
  // If it is not on a mobile device, return, otherwise set the quick actions
  final bool isMobileDevice = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  if (!isMobileDevice) return;
  const QuickActions()
    ..initialize(onActionSelection)
    ..setShortcutItems(
      conversionsOrderDrawer
          .take(3)
          .map((e) => ShortcutItem(
                type: e.toString(),
                localizedTitle: propertyUiMap[e]!.name,
                icon: 'launch_image',
              ))
          .toList(),
    );
}

Color getIconColor(ThemeData theme) =>
    theme.brightness == Brightness.light ? Colors.black45 : Colors.white70;

int _floatToInt8(double x) => (x * 255.0).round() & 0xff;

int color2Int(Color color) =>
    _floatToInt8(color.a) << 24 |
    _floatToInt8(color.r) << 16 |
    _floatToInt8(color.g) << 8 |
    _floatToInt8(color.b) << 0;

/// Converts PROPERTYX.digitalData to a kebab String like 'digital-data'
extension KebabCaseExtension on PROPERTYX {
  String toKebabCase() => toString().split('.').last.replaceAllMapped(
      RegExp(r'([A-Z])'), (match) => '-${match[0]!.toLowerCase()}');
}

PROPERTYX kebabStringToPropertyX(String string) {
  final lowerCaseString = string.replaceAll('-', '').toLowerCase();
  return PROPERTYX.values.firstWhere(
      (e) => e.toString().toLowerCase() == 'propertyx.$lowerCaseString');
}
