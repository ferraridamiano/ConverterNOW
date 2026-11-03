import 'package:converterpro/utils/number_format.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _type(
  TextInputFormatter formatter,
  String current,
  String char,
  int cursor,
) {
  final newText =
      current.substring(0, cursor) + char + current.substring(cursor);
  return formatter.formatEditUpdate(
    TextEditingValue(
      text: current,
      selection: TextSelection.collapsed(offset: cursor),
    ),
    TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursor + char.length),
    ),
  );
}

TextEditingValue _backspace(
  TextInputFormatter formatter,
  String current,
  int cursor,
) {
  final newText = current.substring(0, cursor - 1) + current.substring(cursor);
  return formatter.formatEditUpdate(
    TextEditingValue(
      text: current,
      selection: TextSelection.collapsed(offset: cursor),
    ),
    TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursor - 1),
    ),
  );
}

TextEditingValue _paste(
  TextInputFormatter formatter,
  String current,
  String pasted,
  int cursor,
) {
  final newText =
      current.substring(0, cursor) + pasted + current.substring(cursor);
  return formatter.formatEditUpdate(
    TextEditingValue(
      text: current,
      selection: TextSelection.collapsed(offset: cursor),
    ),
    TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursor + pasted.length),
    ),
  );
}

void main() {
  group('formatNumber', () {
    test('groups the integer part in groups of three', () {
      expect(
        formatNumber('1234', decimalSeparator: '.', groupingSeparator: ','),
        '1,234',
      );
      expect(
        formatNumber('1234567', decimalSeparator: '.', groupingSeparator: ','),
        '1,234,567',
      );
      expect(
        formatNumber('-1234.5', decimalSeparator: '.', groupingSeparator: ','),
        '-1,234.5',
      );
      expect(
        formatNumber('1234.', decimalSeparator: '.', groupingSeparator: ','),
        '1,234.',
      );
      expect(
        formatNumber('1234,5', decimalSeparator: ',', groupingSeparator: '.'),
        '1.234,5',
      );
    });

    test('does not group the exponent', () {
      expect(
        formatNumber(
          '1234567e+30',
          decimalSeparator: '.',
          groupingSeparator: ',',
        ),
        '1,234,567e+30',
      );
      expect(
        formatNumber('1.2e+30', decimalSeparator: '.', groupingSeparator: ','),
        '1.2e+30',
      );
    });

    test('formats a canonical number with the locale separators', () {
      expect(
        formatCanonicalNumber(
          '1609.344',
          decimalSeparator: ',',
          groupingSeparator: '.',
        ),
        '1.609,344',
      );
      expect(
        formatCanonicalNumber(
          '1609.344',
          decimalSeparator: '.',
          groupingSeparator: ',',
        ),
        '1,609.344',
      );
    });

    test('does not group when the separator is null', () {
      expect(
        formatNumber('1234567', decimalSeparator: '.', groupingSeparator: null),
        '1234567',
      );
    });
  });

  group('ThousandsSeparatorFormatter', () {
    test('groups while typing', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: ',',
      );
      var value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      for (final char in '1234567'.split('')) {
        value = _type(formatter, value.text, char, value.selection.baseOffset);
      }
      expect(value.text, '1,234,567');
      expect(value.selection, const TextSelection.collapsed(offset: 9));
    });

    test('groups while typing with the Italian separators', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: ',',
        groupingSeparator: '.',
      );
      var value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      for (final char in '1234567,5'.split('')) {
        value = _type(formatter, value.text, char, value.selection.baseOffset);
      }
      expect(value.text, '1.234.567,5');
      expect(value.selection, const TextSelection.collapsed(offset: 11));
    });

    test('keeps the cursor position when typing in the middle', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: ',',
      );
      final value = _type(formatter, '1,234', '5', 1);
      expect(value.text, '15,234');
      expect(value.selection, const TextSelection.collapsed(offset: 2));
    });

    test('deletes a digit when backspacing on a grouping separator', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: ',',
      );
      final value = _backspace(formatter, '1,234', 2);
      expect(value.text, '234');
      expect(value.selection, const TextSelection.collapsed(offset: 0));
    });

    test('pastes a formatted number', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: ',',
      );
      final value = _paste(formatter, '', '1,234.56', 0);
      expect(value.text, '1,234.56');
      expect(value.selection, const TextSelection.collapsed(offset: 8));
    });

    test('treats a pasted non-locale separator as decimal', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: ',',
      );
      final value = _paste(formatter, '', '1,5', 0);
      expect(value.text, '1.5');
    });

    test('normalizes a typed non-locale separator as decimal', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: ',',
        groupingSeparator: '.',
      );
      final value = _type(formatter, '1', '.', 1);
      expect(value.text, '1,');
    });

    test('adds the leading zero', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: ',',
      );
      final decimal = _type(formatter, '', '.', 0);
      expect(decimal.text, '0.');
      final value = _type(formatter, decimal.text, '5', 2);
      expect(value.text, '0.5');
    });

    test('keeps invalid input untouched', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: ',',
      );
      final value = _type(formatter, '1', 'a', 1);
      expect(value.text, '1a');
    });

    test('normalizes the decimal separator when grouping is disabled', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '.',
        groupingSeparator: null,
      );
      var value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      for (final char in '1234,5'.split('')) {
        value = _type(formatter, value.text, char, value.selection.baseOffset);
      }
      expect(value.text, '1234.5');
    });

    test('supports a non-punctuation grouping separator', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: ',',
        groupingSeparator: '\u00A0',
      );
      var value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      for (final char in '1234567'.split('')) {
        value = _type(formatter, value.text, char, value.selection.baseOffset);
      }
      expect(value.text, '1\u00A0234\u00A0567');
      expect(value.selection, const TextSelection.collapsed(offset: 9));
    });

    test('supports a non-punctuation decimal separator', () {
      final formatter = ThousandsSeparatorFormatter(
        decimalSeparator: '\u066B',
        groupingSeparator: '\u066C',
      );
      var value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      for (final char in '1234\u066B5'.split('')) {
        value = _type(formatter, value.text, char, value.selection.baseOffset);
      }
      expect(value.text, '1\u066C234\u066B5');
    });
  });

  group('formatBinary', () {
    test('groups every four bits from the right', () {
      expect(formatBinary('1010'), '1010');
      expect(formatBinary('10101'), '1 0101');
      expect(formatBinary('10101010'), '1010 1010');
      expect(formatBinary('1010 1010'), '1010 1010');
    });

    test('removes the grouping when disabled', () {
      expect(formatBinary('1010 1010', grouping: false), '10101010');
      expect(formatBinary('1010', grouping: false), '1010');
    });
  });

  group('BinaryGroupingFormatter', () {
    test('groups while typing', () {
      const formatter = BinaryGroupingFormatter();
      var value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      for (final char in '10101010'.split('')) {
        value = _type(formatter, value.text, char, value.selection.baseOffset);
      }
      expect(value.text, '1010 1010');
      expect(value.selection, const TextSelection.collapsed(offset: 9));
    });

    test('deletes a bit when backspacing on a separator', () {
      const formatter = BinaryGroupingFormatter();
      final value = _backspace(formatter, '1010 1010', 5);
      expect(value.text, '101 1010');
    });

    test('groups a pasted binary number', () {
      const formatter = BinaryGroupingFormatter();
      final value = _paste(formatter, '', '10101010', 0);
      expect(value.text, '1010 1010');
    });

    test('removes separators when grouping is disabled', () {
      const formatter = BinaryGroupingFormatter(grouping: false);
      final value = _paste(formatter, '', '1010 1010', 0);
      expect(value.text, '10101010');
    });
  });
}
