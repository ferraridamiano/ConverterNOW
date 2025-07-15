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
void saveSettings(String key, dynamic value) async {
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
        VALIDATOR.rational =>
          RegExp(r'^[+-]?\d{1,3}(?: ?\d{3})*(?:\.\d*)?(?:e[+-]?\d+)?$'),
        _ => RegExp(r'^\+?\d{1,3}(?: ?\d{3})*(?:\.\d*)?(?:e[+-]?\d+)?$'),
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

typedef PropertyUi = ({String name, String icon, String selectedIcon});

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

String formatNumberWithThousandsSeparator(
  String numberString, {
  String thousandsSeparator = ' ', // Default to space
  String decimalSeparator = '.', // Default to dot
}) {
  // Try to parse the string into a double.
  double? number = double.tryParse(numberString);

  if (number == null) {
    print("Warning: '$numberString' is not a valid number string.");
    return numberString;
  }

  // Convert the number to its string representation.
  // This will naturally handle exponential notation expansion for reasonable ranges,
  // e.g., 1e+6 becomes "1000000.0".
  String numStr = number.toString();

  // Handle scientific notation if it's still present after toString().
  // This can happen for very large or very small numbers where Dart's toString()
  // still opts for scientific notation. In these cases, applying thousands
  // separators to the mantissa might not be the desired output.
  if (numStr.contains('e') || numStr.contains('E')) {
    // For simplicity, we return the number as is in scientific notation.
    // If you need to convert all scientific notation to full decimal form
    // before formatting, that would require a more complex number-to-string
    // conversion logic.
    return numStr;
  }

  // Split the string into integer and fractional parts based on the default decimal separator ('.').
  // We parse the string first to double, then convert back to string,
  // so the internal representation will use '.' as decimal separator.
  List<String> parts = numStr.split('.');
  String integerPart = parts[0];
  String? fractionalPart = parts.length > 1 ? parts[1] : null;

  // Add thousands separators to the integer part
  String formattedIntegerPart = '';
  // Check for a leading minus sign
  bool isNegative = integerPart.startsWith('-');
  String digitsOnlyIntegerPart =
      isNegative ? integerPart.substring(1) : integerPart;

  for (int i = 0; i < digitsOnlyIntegerPart.length; i++) {
    formattedIntegerPart += digitsOnlyIntegerPart[i];
    // Add separator every three digits from the right, but not at the very beginning
    if ((digitsOnlyIntegerPart.length - 1 - i) % 3 == 0 &&
        (digitsOnlyIntegerPart.length - 1 - i) != 0) {
      formattedIntegerPart += thousandsSeparator;
    }
  }

  // Add back the minus sign if it was present
  if (isNegative) {
    formattedIntegerPart = '-' + formattedIntegerPart;
  }

  // Combine integer and fractional parts, using the configurable decimalSeparator
  if (fractionalPart != null) {
    return '$formattedIntegerPart$decimalSeparator$fractionalPart';
  } else {
    return formattedIntegerPart;
  }
}
