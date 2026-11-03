import 'package:flutter/services.dart';

/// Removes every occurrence of [groupingSeparator] from [text].
String stripGroupingSeparator(String text, String? groupingSeparator) {
  if (groupingSeparator == null || groupingSeparator.isEmpty) return text;
  return text.replaceAll(groupingSeparator, '');
}

/// Converts [text] to the canonical form used internally: '.' as decimal
/// separator and no grouping separators.
String normalizeNumber(
  String text, {
  required String decimalSeparator,
  String? groupingSeparator,
}) {
  var result = stripGroupingSeparator(text, groupingSeparator);
  if (decimalSeparator != '.') {
    result = result.replaceAll(decimalSeparator, '.');
  }
  return result;
}

/// Inserts [groupingSeparator] between groups of three digits in the integer
/// part of [text].
///
/// [text] is expected to use [decimalSeparator] and must not contain grouping
/// separators. The exponent part (if any) is left untouched.
String formatNumber(
  String text, {
  required String decimalSeparator,
  String? groupingSeparator,
}) {
  if (text.isEmpty) return text;

  final exponentIndex = text.indexOf(RegExp('[eE]'));
  final mantissa = exponentIndex == -1
      ? text
      : text.substring(0, exponentIndex);
  final exponent = exponentIndex == -1 ? '' : text.substring(exponentIndex);

  final decimalIndex = mantissa.indexOf(decimalSeparator);
  var integerPart = decimalIndex == -1
      ? mantissa
      : mantissa.substring(0, decimalIndex);
  final decimalPart = decimalIndex == -1
      ? ''
      : mantissa.substring(decimalIndex);

  var sign = '';
  if (integerPart.startsWith('-') || integerPart.startsWith('+')) {
    sign = integerPart[0];
    integerPart = integerPart.substring(1);
  }

  if (integerPart.isEmpty || !_isDigits(integerPart)) return text;

  final grouped = groupingSeparator == null || groupingSeparator.isEmpty
      ? integerPart
      : _groupDigits(integerPart, groupingSeparator);

  return '$sign$grouped$decimalPart$exponent';
}

/// Formats [raw], which uses '.' as decimal separator (the canonical form
/// returned by [normalizeNumber]), using the separators of the current locale.
String formatCanonicalNumber(
  String raw, {
  required String decimalSeparator,
  String? groupingSeparator,
}) {
  final text = decimalSeparator == '.'
      ? raw
      : raw.replaceFirst('.', decimalSeparator);
  return formatNumber(
    text,
    decimalSeparator: decimalSeparator,
    groupingSeparator: groupingSeparator,
  );
}

/// Groups a binary number every four bits, using [separator].
///
/// When [grouping] is false, any existing separator is removed.
String formatBinary(
  String text, {
  bool grouping = true,
  String separator = ' ',
}) {
  final digits = text.replaceAll(separator, '');
  if (!grouping) return digits;
  if (digits.isEmpty || !_isBinaryDigits(digits)) return text;
  return _groupBinary(digits, 4, separator);
}

/// Formats the value of a conversion field while the user is typing.
///
/// The formatter always returns a valid [TextSelection]. This is important on
/// desktop and web, where a programmatic change with an invalid selection
/// makes `EditableText` select the whole text (see
/// https://github.com/flutter/flutter/issues/137659).
class ThousandsSeparatorFormatter extends TextInputFormatter {
  ThousandsSeparatorFormatter({
    required this.decimalSeparator,
    this.groupingSeparator,
  });

  /// The decimal separator of the current locale.
  final String decimalSeparator;

  /// The grouping separator of the current locale, or null to disable the
  /// grouping while still normalizing the decimal separator.
  final String? groupingSeparator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final insertedIndex = _singleInsertionIndex(oldValue.text, text);
    // When the text grows by more than one character it is a paste: use the
    // grouping-position heuristic to tell grouping separators from decimal
    // ones. In every other case (typing, deleting) any grouping separator that
    // is not the character just typed was inserted by this formatter.
    final isPaste = text.length > oldValue.text.length + 1;

    final buffer = StringBuffer();
    int? cursorRaw;
    final cursor = newValue.selection.isValid
        ? newValue.selection.baseOffset
        : text.length;

    var hasDecimal = false;
    var hasUnknown = false;
    var multipleDecimals = false;
    var inExponent = false;

    for (var i = 0; i < text.length; i++) {
      if (i == cursor) cursorRaw = buffer.length;
      final char = text[i];

      if (char == 'e' || char == 'E') {
        inExponent = true;
        buffer.write(char);
        continue;
      }
      if (_isDigit(char)) {
        buffer.write(char);
        continue;
      }
      if (char == '+' || char == '-') {
        buffer.write(char);
        continue;
      }

      // A separator can be the locale decimal separator, the locale grouping
      // separator, or one of the two common separators typed by the user.
      final isGroupingChar =
          groupingSeparator != null &&
          groupingSeparator!.isNotEmpty &&
          text.startsWith(groupingSeparator!, i);
      final isDecimalChar = text.startsWith(decimalSeparator, i);
      final isCommonSeparator = char == '.' || char == ',';

      if (isGroupingChar || isDecimalChar || isCommonSeparator) {
        if (inExponent) {
          buffer.write(char);
          continue;
        }

        // If the user explicitly typed the "other" separator, keep the legacy
        // behaviour and treat it as a decimal separator, not as grouping.
        final isInserted = i == insertedIndex;
        final isGrouping =
            !isDecimalChar &&
            !isInserted &&
            isGroupingChar &&
            (!isPaste ||
                _isGroupingSeparatorAt(
                  text,
                  i,
                  groupingSeparator!,
                  decimalSeparator,
                ));

        if (isGrouping) continue;

        if (hasDecimal) {
          multipleDecimals = true;
          buffer.write(char);
          continue;
        }

        if (buffer.isEmpty) {
          buffer.write('0');
        } else if (buffer.length == 1) {
          final first = buffer.toString();
          if (first == '+' || first == '-') buffer.write('0');
        }

        buffer.write(decimalSeparator);
        hasDecimal = true;
        continue;
      }

      hasUnknown = true;
      buffer.write(char);
    }

    if (cursor >= text.length) cursorRaw = buffer.length;

    if (hasUnknown || multipleDecimals) return newValue;

    var raw = buffer.toString();
    var rawCursor = cursorRaw ?? raw.length;

    // When the user deletes a grouping separator, remove the adjacent digit as
    // well: otherwise the formatter would immediately insert the separator
    // again and the backspace/delete key would appear to do nothing.
    if (groupingSeparator != null && groupingSeparator!.isNotEmpty) {
      final deletedIndex = _singleDeletionIndex(
        oldValue.text,
        text,
        groupingSeparator!.length,
      );
      if (deletedIndex != -1 &&
          oldValue.text.startsWith(groupingSeparator!, deletedIndex)) {
        final rawIndex = _rawOffsetOf(
          oldValue.text,
          deletedIndex,
          groupingSeparator!,
        );
        final bool backspace =
            oldValue.selection.baseOffset ==
            deletedIndex + groupingSeparator!.length;
        final removeIndex = backspace ? rawIndex - 1 : rawIndex;
        if (removeIndex >= 0 && removeIndex < raw.length) {
          raw = raw.replaceRange(removeIndex, removeIndex + 1, '');
          rawCursor = removeIndex;
        }
      }
    }

    final formatted = formatNumber(
      raw,
      decimalSeparator: decimalSeparator,
      groupingSeparator: groupingSeparator,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: _formattedOffset(formatted, rawCursor, groupingSeparator),
      ),
      composing: TextRange.empty,
    );
  }
}

/// Formats the value of the binary numeral system field, grouping the bits
/// every four positions with [separator].
///
/// Like [ThousandsSeparatorFormatter], it always returns a valid selection.
class BinaryGroupingFormatter extends TextInputFormatter {
  const BinaryGroupingFormatter({this.grouping = true, this.separator = ' '});

  /// Whether the bits are grouped every four positions.
  final bool grouping;

  final String separator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    int? cursorRaw;
    final cursor = newValue.selection.isValid
        ? newValue.selection.baseOffset
        : text.length;
    var hasInvalid = false;

    for (var i = 0; i < text.length; i++) {
      if (i == cursor) cursorRaw = buffer.length;
      final char = text[i];
      if (char == '0' || char == '1') {
        buffer.write(char);
        continue;
      }
      if (text.startsWith(separator, i)) {
        // Skip the grouping separator.
        continue;
      }
      hasInvalid = true;
      buffer.write(char);
    }

    if (cursor >= text.length) cursorRaw = buffer.length;
    if (hasInvalid) return newValue;

    var raw = buffer.toString();
    var rawCursor = cursorRaw ?? raw.length;

    // When the user deletes a grouping separator, remove the adjacent bit as
    // well, otherwise the separator would be inserted again immediately.
    final deletedIndex = _singleDeletionIndex(
      oldValue.text,
      text,
      separator.length,
    );
    if (deletedIndex != -1 &&
        oldValue.text.startsWith(separator, deletedIndex)) {
      final rawIndex = _rawOffsetOf(oldValue.text, deletedIndex, separator);
      final bool backspace =
          oldValue.selection.baseOffset == deletedIndex + separator.length;
      final removeIndex = backspace ? rawIndex - 1 : rawIndex;
      if (removeIndex >= 0 && removeIndex < raw.length) {
        raw = raw.replaceRange(removeIndex, removeIndex + 1, '');
        rawCursor = removeIndex;
      }
    }

    final formatted = formatBinary(
      raw,
      grouping: grouping,
      separator: separator,
    );
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: _formattedOffset(formatted, rawCursor, separator),
      ),
      composing: TextRange.empty,
    );
  }
}

bool _isBinaryDigits(String text) {
  for (final codeUnit in text.codeUnits) {
    if (codeUnit != 0x30 && codeUnit != 0x31) return false;
  }
  return true;
}

String _groupBinary(String digits, int groupSize, String separator) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % groupSize == 0) {
      buffer.write(separator);
    }
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String _groupDigits(String digits, String groupingSeparator) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(groupingSeparator);
    }
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

bool _isDigits(String text) {
  for (final codeUnit in text.codeUnits) {
    if (codeUnit < 0x30 || codeUnit > 0x39) return false;
  }
  return true;
}

bool _isDigit(String char) {
  final codeUnit = char.codeUnitAt(0);
  return codeUnit >= 0x30 && codeUnit <= 0x39;
}

/// Returns the index of the single inserted character, or -1 if [newText] is
/// not the result of a single-character insertion.
int _singleInsertionIndex(String oldText, String newText) {
  if (newText.length != oldText.length + 1) return -1;
  var i = 0;
  while (i < oldText.length && oldText[i] == newText[i]) {
    i++;
  }
  return i;
}

/// Returns the index where [length] characters were removed from [oldText] to
/// obtain [newText], or -1 if that is not the only change.
int _singleDeletionIndex(String oldText, String newText, int length) {
  if (newText.length != oldText.length - length) return -1;
  var i = 0;
  while (i < newText.length && oldText[i] == newText[i]) {
    i++;
  }
  return i;
}

/// Whether the separator at [index] is a grouping separator: it must be in the
/// integer part and be followed by exactly three digits.
bool _isGroupingSeparatorAt(
  String text,
  int index,
  String groupingSeparator,
  String decimalSeparator,
) {
  var digits = 0;
  for (var i = index + groupingSeparator.length; i < text.length; i++) {
    if (_isDigit(text[i])) {
      digits++;
      continue;
    }
    break;
  }
  if (digits != 3) return false;

  for (var i = 0; i < index; i++) {
    final char = text[i];
    if (char == decimalSeparator || char == 'e' || char == 'E') return false;
  }
  return true;
}

/// Counts the characters of [text] before [formattedOffset] that are not part
/// of a grouping separator.
int _rawOffsetOf(String text, int formattedOffset, String groupingSeparator) {
  var raw = 0;
  var i = 0;
  while (i < formattedOffset) {
    if (text.startsWith(groupingSeparator, i)) {
      i += groupingSeparator.length;
      continue;
    }
    raw++;
    i++;
  }
  return raw;
}

/// Maps [rawOffset] (a position in the ungrouped text) to a position in
/// [formatted].
int _formattedOffset(
  String formatted,
  int rawOffset,
  String? groupingSeparator,
) {
  if (rawOffset <= 0) return 0;
  if (groupingSeparator == null || groupingSeparator.isEmpty) {
    return rawOffset.clamp(0, formatted.length);
  }

  var raw = 0;
  var i = 0;
  while (i < formatted.length) {
    if (raw == rawOffset) return i;
    if (formatted.startsWith(groupingSeparator, i)) {
      i += groupingSeparator.length;
      continue;
    }
    raw++;
    i++;
  }
  return formatted.length;
}
