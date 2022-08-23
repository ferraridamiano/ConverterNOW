import 'dart:math' as math;
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';

enum OPERATION {
  product,
  division,
  addition,
  subtraction,
}

class Calculator with ChangeNotifier {
  final RegExp _regExpValidatingChar = RegExp(r'^[0-9πe,.+-/=*×÷−]+$');
  final RegExp _regExpNumber = RegExp(r'^[0-9πe]+$');
  static const Map<String, OPERATION> mapOperation = {
    '*': OPERATION.product,
    '/': OPERATION.division,
    '+': OPERATION.addition,
    '-': OPERATION.subtraction,
    '×': OPERATION.product,
    '÷': OPERATION.division,
    '−': OPERATION.subtraction,
  };

  String currentNumber = '';
  Decimal? _firstNumber;
  Decimal? _secondNumber;
  OPERATION? selectedOperation;
  bool endNumber = false;
  bool isResult = false;

  Calculator();

  /// With this function you can subit any char from 0-9, [, . + - * / =
  /// backspace canc]
  void submitChar(String char) {
    //if string is not valid then return
    if (!(char.length == 1 && _regExpValidatingChar.hasMatch(char))) {
      return;
    }

    // if it is a number
    if (_regExpNumber.hasMatch(char)) {
      if (isResult) {
        isResult = false;
        selectedOperation = _firstNumber = _secondNumber = null;
      }

      if (endNumber) {
        currentNumber = '';
        endNumber = false;
      }
      if (char == 'π') {
        currentNumber = math.pi.toString();
      } else if (char == 'e') {
        currentNumber = math.e.toString();
      } else {
        // is a number
        currentNumber += char;
      }
    }
    //if char is a comma or a dot
    else if (char == '.' || char == ',') {
      // if it is already submitted a decimal value ignore it
      if (currentNumber.contains('.') || currentNumber.contains(',')) {
        return;
      }
      // otherwise
      currentNumber += '.'; //append the point at the end
    }
    // if it is an operator
    else if (mapOperation.containsKey(char)) {
      if (isResult) {
        isResult = false;
        selectedOperation = _firstNumber = _secondNumber = null;
      }
      // if it is the first operation submitted
      if (currentNumber.isNotEmpty &&
          _firstNumber == null &&
          selectedOperation == null) {
        _firstNumber = Decimal.parse(currentNumber);
        selectedOperation = mapOperation[char];
        endNumber = true;
      } else if (currentNumber.isNotEmpty &&
          _firstNumber != null &&
          selectedOperation != null &&
          !endNumber) {
        // chained operation
        // Compute the result with the previous operator
        _secondNumber = Decimal.parse(currentNumber);
        _computeResult();
        endNumber = true;
        selectedOperation = mapOperation[char];
      } else if (currentNumber.isNotEmpty &&
          _firstNumber != null &&
          selectedOperation != null) {
        // change of operation
        selectedOperation = mapOperation[char];
      }
    }
    // if it is equal symbol
    else if (char == '=') {
      if (_firstNumber != null &&
          currentNumber.isNotEmpty &&
          selectedOperation != null &&
          !isResult) {
        _secondNumber = Decimal.parse(currentNumber);
        _computeResult();
        isResult = true;
      } else if (_firstNumber != null &&
          currentNumber.isNotEmpty &&
          selectedOperation != null &&
          isResult &&
          _secondNumber != null) {
        _firstNumber = Decimal.parse(currentNumber);
        _computeResult();
      }
    }
    notifyListeners();
  }

  void submitString(String string) {
    for (int i = 0; i < string.length; i++) {
      submitChar(string.substring(i, i + 1));
    }
  }

  /// Returns the symbol of the current operation if an operation is selected
  /// otherwise it will return an empty string
  String get stringOperation {
    if (selectedOperation == null) {
      return '';
    }
    return mapOperation.keys
        .where((string) => mapOperation[string] == selectedOperation)
        .last;
  }

  /// Given firstNumber, secondNumber and selectedOperation in computes the
  /// result and put it in currentNumber string
  _computeResult() {
    late Decimal result;
    assert(_firstNumber != null && _secondNumber != null,
        'firstNumber/secondNumber is null');

    switch (selectedOperation) {
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
        assert(selectedOperation != null, 'selectedOperation is null');
    }
    _firstNumber = result;
    currentNumber = _getStringFromDecimal(result);
    endNumber = true;
  }

  /// This method bring the calculator to the initial state (nothing submitted,
  /// no selected operation)
  void clearAll() {
    currentNumber = '';
    _firstNumber = null;
    _secondNumber = null;
    selectedOperation = null;
    endNumber = false;
    isResult = false;
    notifyListeners();
  }

  /// This method delete the last character of currentNumber
  void deleteLastChar() {
    int length = currentNumber.length;
    if (length > 0) {
      currentNumber = currentNumber.substring(0, length - 1);
      notifyListeners();
    }
  }

  /// This method either clearAll() or deleteLastChar() depending on the state
  /// of the calculator.
  void adaptiveDeleteClear() => endNumber ? clearAll() : deleteLastChar();

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
    if (currentNumber.isNotEmpty) {
      currentNumber = operation(Decimal.parse(currentNumber));
      endNumber = isResult = true;
      notifyListeners();
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
