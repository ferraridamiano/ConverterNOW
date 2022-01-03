import 'dart:math' as math;
import 'package:flutter/foundation.dart';

enum OPERATION {
  product,
  division,
  addition,
  subtraction,
}

class Calculator with ChangeNotifier {
  final RegExp _regExpValidatingChar = RegExp(r'^[0-9πe,.+-/=*×÷−]+$'); //da capire se va bene
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
  double? _firstNumber;
  double? _secondNumber;
  OPERATION? selectedOperation;
  bool endNumber = false;
  bool isResult = false;
  String decimalSeparator;

  Calculator({this.decimalSeparator = '.'});

  /// With this function you can subit any char from 0-9, [, . + - * / = backspace canc]
  void submitChar(String char) {
    //if string is not valid then return
    if (!(char.length == 1 && _regExpValidatingChar.hasMatch(char))) {
      return;
    }

    //if it is a number
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
        //is a number
        currentNumber += char;
      }
    }
    //if char is a comma or a dot
    else if (char == '.' || char == ',') {
      //if it is already submitted a decimal value ignore it
      if (currentNumber.contains('.') || currentNumber.contains(',')) {
        return;
      }
      //otherwise
      currentNumber += '.'; //append the point at the end
    }
    //if it is an operator
    else if (mapOperation.containsKey(char)) {
      if (isResult) {
        isResult = false;
        selectedOperation = _firstNumber = _secondNumber = null;
      }
      //if it is the first operation submitted
      if (currentNumber.isNotEmpty && _firstNumber == null && selectedOperation == null) {
        _firstNumber = _getDoubleFromString(currentNumber);
        selectedOperation = mapOperation[char];
        endNumber = true;
      } else if (currentNumber.isNotEmpty && _firstNumber != null && selectedOperation != null && !endNumber) {
        //chained operation
        // Compute the result with the previous operator
        _secondNumber = _getDoubleFromString(currentNumber);
        _computeResult();
        endNumber = true;
        selectedOperation = mapOperation[char];
      } else if (currentNumber.isNotEmpty && _firstNumber != null && selectedOperation != null) {
        //change of operation
        selectedOperation = mapOperation[char];
      }
    }
    // if it is equal symbol
    else if (char == '=') {
      if (_firstNumber != null && currentNumber.isNotEmpty && selectedOperation != null && !isResult) {
        _secondNumber = _getDoubleFromString(currentNumber);
        _computeResult();
        isResult = true;
      } else if (_firstNumber != null && currentNumber.isNotEmpty && selectedOperation != null && isResult && _secondNumber != null) {
        _firstNumber = _getDoubleFromString(currentNumber);
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

  ///Returns the symbol of the current operation if an operation is selected otherwise it will return an empty string
  String get stringOperation {
    if (selectedOperation == null) {
      return '';
    }
    return mapOperation.keys.where((string) => mapOperation[string] == selectedOperation).last;
  }

  ///Given firstNumber, secondNumber and selectedOperation in computes the result and put it in currentNumber string
  _computeResult() {
    late double result;
    assert(_firstNumber != null && _secondNumber != null, 'firstNumber/secondNumber is null');

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
        result = _firstNumber! / _secondNumber!;
        break;
      case null:
        assert(selectedOperation != null, 'selectedOperation is null');
    }
    _firstNumber = result;
    currentNumber = _getStringFromDouble(result, decimalSeparator);
    endNumber = true;
  }

  /// this method bring the calculator to the initial state (nothing submitted, no selected operation)
  void clearAll() {
    currentNumber = '';
    _firstNumber = null;
    _secondNumber = null;
    selectedOperation = null;
    endNumber = false;
    isResult = false;
    notifyListeners();
  }

  ///this method delete the last character of currentNumber
  void deleteLastChar() {
    int length = currentNumber.length;
    if (length > 0) {
      currentNumber = currentNumber.substring(0, length - 1);
      notifyListeners();
    }
  }

  /// This method either clearAll() or deleteLastChar() depending on the state of the calculator.
  void adaptiveDeleteClear() {
    if (endNumber) {
      clearAll();
    } else {
      deleteLastChar();
    }
  }

  /// Computes the square root of currentNumber
  void squareRoot() => _unaryOperation(math.sqrt);

  /// Computes the base-10 logarithm of currentNumber
  void log10() => _unaryOperation((double x) => math.log(x) / math.log(10));

  /// Computes the square of currentNumber
  void square() => _unaryOperation((double x) => x * x);

  /// Computes the natural logarithm (base e) of currentNumber
  void ln() => _unaryOperation(math.log);

  /// Computes the reciprocal (multiplicative inverse) of currentNumber
  void reciprocal() => _unaryOperation((double x) => 1/x);

  /// Computes the factorial of currentNumber
  void factorial() => _unaryOperation((double x) => _myFactorialFunction(x.truncate()).toDouble());

  /// General function that applies to all the unary operations, just pass the function
  void _unaryOperation(double Function(double) operation) {
    //if it is the first operation submitted
    if (currentNumber.isNotEmpty) {
      currentNumber = _getStringFromDouble(operation(double.parse(currentNumber)), decimalSeparator);
      endNumber = isResult = true;
      notifyListeners();
    }
  }
}

double _getDoubleFromString(String string) {
  if (string.contains(',')) {
    string = string.replaceAll(RegExp(','), '.');
  }
  return double.parse(string);
}

String _getStringFromDouble(double value, [String decimalSeparator = '.']) {
  String stringValue = value.toString();
  if (stringValue.endsWith('.0')) {
    stringValue = stringValue.substring(0, stringValue.length - 2);
  }
  /*if (stringValue.contains('.') && decimalSeparator != '.') {
    stringValue = stringValue.replaceFirst(RegExp('[.]'), decimalSeparator);
  }*/
  return stringValue;
}

int _myFactorialFunction(int x) => x == 0 ? 1 : x * _myFactorialFunction(x - 1);