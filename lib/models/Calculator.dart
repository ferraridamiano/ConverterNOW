import 'package:flutter/foundation.dart';

enum OPERATION {
  PRODUCT,
  DIVISION,
  ADDITION,
  SUBTRACTION,
}

class Calculator with ChangeNotifier {
  final RegExp _regExpValidatingChar = RegExp(r'^[0-9,.+-/=*×÷−]+$'); //da capire se va bene
  final RegExp _regExpNumber = RegExp(r'^[0-9]+$');
  static const Map<String, OPERATION> mapOperation = {
    '*': OPERATION.PRODUCT,
    '/': OPERATION.DIVISION,
    '+': OPERATION.ADDITION,
    '-': OPERATION.SUBTRACTION,
    '×': OPERATION.PRODUCT,
    '÷': OPERATION.DIVISION,
    '−': OPERATION.SUBTRACTION,
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
      currentNumber += char;
    }
    //if char is a comma or a dot
    else if (char == '.' || char == ',') {
      //if it is already submitted a decimal value ignore it
      if (currentNumber.contains('.') || currentNumber.contains(',')) {
        return;
      }
      //otherwise
      currentNumber += char; //append the poin/comma at the end
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
      } else if (_firstNumber != null && currentNumber.isNotEmpty && selectedOperation != null && isResult && _secondNumber!= null) {
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
      case OPERATION.ADDITION:
        result = _firstNumber! + _secondNumber!;
        break;
      case OPERATION.SUBTRACTION:
        result = _firstNumber! - _secondNumber!;
        break;
      case OPERATION.PRODUCT:
        result = _firstNumber! * _secondNumber!;
        break;
      case OPERATION.DIVISION:
        result = _firstNumber! / _secondNumber!;
        break;
      case null:
        assert(selectedOperation != null, 'selectedOperation is null');
    }
    _firstNumber = result;
    currentNumber = result.toString();
    if (currentNumber.endsWith('.0')) {
      currentNumber = currentNumber.substring(0, currentNumber.length - 2);
    }
    if (currentNumber.contains('.') && decimalSeparator != '.') {
      currentNumber = currentNumber.replaceFirst(RegExp('[.]'), decimalSeparator);
    }
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
    if (isResult) {
      clearAll();
    } else {
      deleteLastChar();
    }
  }
}

_getDoubleFromString(String string) {
  if (string.contains(',')) {
    string = string.replaceAll(RegExp(','), '.');
  }
  return double.parse(string);
}