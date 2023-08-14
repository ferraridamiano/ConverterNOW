import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

enum OPERATION {
  product,
  division,
  addition,
  subtraction;

  @override
  String toString() {
    return switch (this) {
      product => '×',
      division => '÷',
      addition => '+',
      subtraction => '−'
    };
  }
}

class CalculatorNotifier extends Notifier<String> {
  final RegExp _regExpValidatingChar = RegExp(r'^[0-9πe,.+-/=*×÷−]+$');
  final RegExp _regExpNumber = RegExp(r'^[0-9πe]+$');

  Decimal? _firstNumber;
  Decimal? _secondNumber;
  late final Map<String, OPERATION> mapOperation;

  @override
  String build() {
    mapOperation = ref.read(selectedOperationProvider.notifier).mapOperation;
    return '';
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

    switch (ref.read(selectedOperationProvider)) {
      case OPERATION.addition:
        result = _firstNumber! + _secondNumber!;
        break;
      case OPERATION.subtraction:
        result = _firstNumber! - _secondNumber!;
        break;
      case OPERATION.product:
        result = _firstNumber! * _secondNumber!;
        break;
      case OPERATION.division:
        result = (_firstNumber! / _secondNumber!)
            .toDecimal(scaleOnInfinitePrecision: 15);
        break;
      case null:
        assert(false, 'selectedOperation is null');
    }
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
      state = operation(Decimal.parse(state));
      ref.read(endNumberProvider.notifier).state = true;
      ref.read(isResultProvider.notifier).state = true;
    }
  }
}

String _getStringFromDecimal(Decimal value) {
  String stringValue = value.toString();
  if (stringValue.endsWith('.0')) {
    stringValue = stringValue.substring(0, stringValue.length - 2);
  }
  return stringValue;
}

String _getStringFromNum(num value) {
  String stringValue = value.toString();
  if (stringValue.endsWith('.0')) {
    stringValue = stringValue.substring(0, stringValue.length - 2);
  }
  return stringValue;
}

int _myFactorialFunction(int x) => x == 0 ? 1 : x * _myFactorialFunction(x - 1);

final calculatorProvider =
    NotifierProvider<CalculatorNotifier, String>(() => CalculatorNotifier());

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
