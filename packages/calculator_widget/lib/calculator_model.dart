import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import 'package:rational/rational.dart';

enum OPERATION {
  product,
  division,
  addition,
  subtraction;

  @override
  String toString() => switch (this) {
        product => '×',
        division => '÷',
        addition => '+',
        subtraction => '−'
      };
}

class Calculator extends Notifier<String> {
  final RegExp _regExpValidatingChar = RegExp(r'^[0-9πe,.+-/=*×÷−]+$');
  final RegExp _regExpNumber = RegExp(r'^[0-9πe]+$');

  static final provider = NotifierProvider<Calculator, String>(Calculator.new);

  Decimal? _firstNumber;
  Decimal? _secondNumber;
  late final Map<String, OPERATION> mapOperation;

  @override
  String build() {
    mapOperation = ref.read(selectedOperationProvider.notifier).mapOperation;
    return '';
  }

  void submitString(String string) {
    for (final char in string.split('')) {
      submitChar(char);
    }
  }

  /// With this function you can subit any char from 0-9, [, . + - * / =
  /// backspace canc]
  void submitChar(String char) {
    //if string is not valid then return
    if (!(char.length == 1 && _regExpValidatingChar.hasMatch(char))) {
      return;
    }

    // if it is a number
    if (_regExpNumber.hasMatch(char)) {
      if (ref.read(isResultProvider)) {
        ref.read(isResultProvider.notifier).state = false;
        ref.read(selectedOperationProvider.notifier).state = null;
        _firstNumber = _secondNumber = null;
      }

      if (ref.read(endNumberProvider)) {
        state = '';
        ref.read(endNumberProvider.notifier).state = false;
      }
      if (char == 'π') {
        state = math.pi.toString();
      } else if (char == 'e') {
        state = math.e.toString();
      } else {
        // is a number
        state += char;
      }
    }
    //if char is a comma or a dot
    else if (char == '.' || char == ',') {
      // if it is already submitted a decimal value ignore it
      if (state.contains('.') || state.contains(',')) {
        return;
      }
      // otherwise
      state += '.'; //append the point at the end
    }
    // if it is an operator
    else if (mapOperation.containsKey(char)) {
      if (ref.read(isResultProvider)) {
        ref.read(isResultProvider.notifier).state = false;
        ref.read(selectedOperationProvider.notifier).state = null;
        _firstNumber = _secondNumber = null;
      }

      // if it is the first operation submitted
      if (state.isNotEmpty &&
          _firstNumber == null &&
          ref.read(selectedOperationProvider) == null) {
        _firstNumber = Decimal.parse(state);
        ref.read(selectedOperationProvider.notifier).state = mapOperation[char];
        ref.read(endNumberProvider.notifier).state = true;
      } else if (state.isNotEmpty &&
          _firstNumber != null &&
          ref.read(selectedOperationProvider) != null &&
          !ref.read(endNumberProvider)) {
        // chained operation
        // Compute the result with the previous operator
        _secondNumber = Decimal.parse(state);
        _computeResult();
        ref.read(endNumberProvider.notifier).state = true;
        ref.read(selectedOperationProvider.notifier).state = mapOperation[char];
      } else if (state.isNotEmpty &&
          _firstNumber != null &&
          ref.read(selectedOperationProvider) != null) {
        // change of operation
        ref.read(selectedOperationProvider.notifier).state = mapOperation[char];
      }
    }
    // if it is equal symbol
    else if (char == '=') {
      if (_firstNumber != null &&
          state.isNotEmpty &&
          ref.read(selectedOperationProvider) != null &&
          !ref.read(isResultProvider)) {
        _secondNumber = Decimal.parse(state);
        _computeResult();
        ref.read(isResultProvider.notifier).state = true;
      } else if (_firstNumber != null &&
          state.isNotEmpty &&
          ref.read(selectedOperationProvider) != null &&
          ref.read(isResultProvider) &&
          _secondNumber != null) {
        _firstNumber = Decimal.parse(state);
        _computeResult();
      }
    }
  }

  /// Given firstNumber, secondNumber and selectedOperation in computes the
  /// result and put it in currentNumber string
  _computeResult() {
    late Decimal result;
    assert(_firstNumber != null && _secondNumber != null,
        'firstNumber/secondNumber is null');

    result = switch (ref.read(selectedOperationProvider)) {
      OPERATION.addition => _firstNumber! + _secondNumber!,
      OPERATION.subtraction => _firstNumber! - _secondNumber!,
      OPERATION.product => _firstNumber! * _secondNumber!,
      OPERATION.division => (_firstNumber! / _secondNumber!)
          .toDecimal(scaleOnInfinitePrecision: 15),
      null => throw Exception('selectedOperation is null'),
    };
    _firstNumber = result;
    state = _getStringFromDecimal(result);
    ref.read(endNumberProvider.notifier).state = true;
  }

  /// This method bring the calculator to the initial state (nothing submitted,
  /// no selected operation)
  void clearAll() {
    state = '';
    _firstNumber = null;
    _secondNumber = null;
    ref.read(selectedOperationProvider.notifier).state = null;
    ref.read(endNumberProvider.notifier).state = false;
    ref.read(isResultProvider.notifier).state = false;
  }

  /// This method delete the last character of currentNumber
  void deleteLastChar() {
    if (state.isNotEmpty) {
      state = state.substring(0, state.length - 1);
    }
  }

  /// This method either clearAll() or deleteLastChar() depending on the state
  /// of the calculator.
  void adaptiveDeleteClear() =>
      ref.read(endNumberProvider) ? clearAll() : deleteLastChar();

  void percentage() => _unaryOperation(
      (Decimal x) => _getStringFromRational(x / Decimal.fromInt(100)));

  /// Computes the square root of currentNumber
  void squareRoot() => _unaryOperation(
      (Decimal x) => _getStringFromNum(math.sqrt(x.toDouble())));

  /// Computes the base-10 logarithm of currentNumber
  void log10() => _unaryOperation((Decimal x) =>
      _getStringFromNum((math.log(x.toDouble()) / math.log(10))));

  /// Computes the square of currentNumber
  void square() =>
      _unaryOperation((Decimal x) => _getStringFromDecimal((x * x)));

  /// Computes the natural logarithm (base e) of currentNumber
  void ln() =>
      _unaryOperation((Decimal x) => _getStringFromNum(math.log(x.toDouble())));

  /// Computes the reciprocal (multiplicative inverse) of currentNumber
  void reciprocal() => _unaryOperation((Decimal x) =>
      x.inverse.toDecimal(scaleOnInfinitePrecision: 15).toString());

  /// Computes the factorial of currentNumber
  void factorial() => _unaryOperation((Decimal x) =>
      _getStringFromNum(_myFactorialFunction(x.toBigInt().toInt())));

  /// General function that applies to all the unary operations, just pass the
  /// function
  void _unaryOperation(String Function(Decimal) operation) {
    //if it is the first operation submitted
    if (state.isNotEmpty) {
      if (_firstNumber != null) {
        // If the previous operation is not completed, compute it before
        // computing the new unary operation
        submitChar('=');
      }
      state = operation(Decimal.parse(state));
      ref.read(endNumberProvider.notifier).state = true;
      ref.read(isResultProvider.notifier).state = true;
    }
  }
}

String _getStringFromRational(Rational rational) {
  String stringValue = (rational.numerator / rational.denominator).toString();
  if (stringValue.endsWith('.0')) {
    stringValue = stringValue.substring(0, stringValue.length - 2);
  }
  return stringValue;
}

String _getStringFromDecimal(Decimal value) =>
    _getStringFromRational(value.toRational());

String _getStringFromNum(num value) {
  String stringValue = value.toString();
  if (stringValue.endsWith('.0')) {
    stringValue = stringValue.substring(0, stringValue.length - 2);
  }
  return stringValue;
}

int _myFactorialFunction(int x) => x == 0 ? 1 : x * _myFactorialFunction(x - 1);

class SelectedOperationNotifier extends Notifier<OPERATION?> {
  static const Map<String, OPERATION> _mapOperation = {
    '*': OPERATION.product,
    '/': OPERATION.division,
    '+': OPERATION.addition,
    '-': OPERATION.subtraction,
    '×': OPERATION.product,
    '÷': OPERATION.division,
    '−': OPERATION.subtraction,
  };

  @override
  OPERATION? build() => null;

  Map<String, OPERATION> get mapOperation => _mapOperation;
}

final selectedOperationProvider =
    NotifierProvider<SelectedOperationNotifier, OPERATION?>(
        () => SelectedOperationNotifier());

final endNumberProvider = StateProvider<bool>((ref) => false);
final isResultProvider = StateProvider<bool>((ref) => false);
