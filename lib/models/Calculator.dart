enum OPERATION {
  PRODUCT,
  DIVISION,
  ADDITION,
  SUBTRACTION,
}

class Calculator {
  final RegExp regExpValidatingChar = RegExp(r'^[0-9,.+-/=*]+$');
  final RegExp regExpDotComma = RegExp(r'^[.,]+$');
  final RegExp regExpOperator = RegExp(r'^[+*/-]+$');
  final RegExp regExpNumber = RegExp(r'^[0-9]+$');
  static const Map<String, OPERATION> mapOperation = {
    '*': OPERATION.PRODUCT,
    '/': OPERATION.DIVISION,
    '+': OPERATION.ADDITION,
    '-': OPERATION.SUBTRACTION,
  };

  String currentNumber = '';
  double? firstNumber;
  double? secondNumber;
  OPERATION? selectedOperation;
  bool _endNumber = false;

  /// With this function you can subit any char from 0-9, [, . + - * / = backspace canc]
  void submitChar(String char) {
    //if string is not valid then return
    if (!(char.length == 1 && regExpValidatingChar.hasMatch(char))) {
      return;
    }
    //if it is a number
    if (regExpNumber.hasMatch(char)) {
      if (_endNumber) {
        currentNumber = '';
        _endNumber = false;
      }
      currentNumber += char;
    }
    //if char is a comma or a dot
    else if (regExpDotComma.hasMatch(char)) {
      //if it is already submitted a decimal value ignore it
      if (regExpDotComma.hasMatch(currentNumber)) {
        return;
      }
      //otherwise
      currentNumber += char; //append the poin/comma at the end
    }
    //if it is an operator
    else if (regExpOperator.hasMatch(char)) {
      if (currentNumber.isNotEmpty && firstNumber == null) {
        firstNumber = double.parse(currentNumber);
        selectedOperation = mapOperation[char];
        _endNumber = true;
      } else if (currentNumber.isNotEmpty && firstNumber != null) {
        //chained operation
        selectedOperation = mapOperation[char];
        secondNumber = double.parse(currentNumber);
        _endNumber = true;
        _computeResult();
      }
    }
    // if it is equal symbol
    else if (char == '=') {
      if (firstNumber != null && currentNumber.isNotEmpty && selectedOperation != null) {
        secondNumber = double.parse(currentNumber);
        _computeResult();
      }
    }
  }

  void submitString(String string) {
    for (int i = 0; i < string.length; i++) {
      submitChar(string.substring(i, i + 1));
    }
  }

  ///Given firstNumber, secondNumber and selectedOperation in computes the result and put it in currentNumber string
  _computeResult() {
    late double result;
    assert(firstNumber != null && secondNumber != null, 'firstNumber/secondNumber is null');

    switch (selectedOperation) {
      case OPERATION.ADDITION:
        result = firstNumber! + secondNumber!;
        break;
      case OPERATION.SUBTRACTION:
        result = firstNumber! - secondNumber!;
        break;
      case OPERATION.PRODUCT:
        result = firstNumber! * secondNumber!;
        break;
      case OPERATION.DIVISION:
        result = firstNumber! / secondNumber!;
        break;
      case null:
        assert(selectedOperation != null, 'selectedOperation is null');
    }
    firstNumber = result;
    currentNumber = result.toString();
    _endNumber = true;
  }
}
