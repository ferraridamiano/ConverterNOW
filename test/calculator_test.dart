import 'dart:math';
import 'package:converterpro/models/Calculator.dart';
import 'package:test/test.dart';

const int MAXVALUE = 200000000;
const Map<OPERATION, String> mapOperation = {
  OPERATION.PRODUCT: '*',
  OPERATION.DIVISION: '/',
  OPERATION.ADDITION: '+',
  OPERATION.SUBTRACTION: '-',
};

void main() {
  test('Display number test', () {
    Random rnd = Random();
    Calculator calc = Calculator();
    String randomNumber = rnd.nextInt(MAXVALUE).toString() + '.' + rnd.nextInt(MAXVALUE).toString();
    for (int i = 0; i < randomNumber.length; i++) {
      String char = randomNumber[i];
      calc.submitChar(char);
      expect(calc.currentNumber, randomNumber.substring(0, i + 1));
    }
  });

  /// It tests all the binary operation such as 2+3, 2*3, 2-3, etc.
  group('Binary operation', () {
    for (OPERATION operation in mapOperation.keys) {
      testBinaryOperation(operation);
    }
  });

  /// It tests for example that operation such as 2*3+7=13 works
  test('Chained operations', () {
    Random rnd = Random();
    double firstNumber = rnd.nextDouble() * MAXVALUE + 1;
    double secondNumber = rnd.nextDouble() * MAXVALUE + 1;
    double thirdNumber = rnd.nextDouble() * MAXVALUE + 1;
    Calculator calc = Calculator();
    for (OPERATION op1 in OPERATION.values) {
      for (OPERATION op2 in OPERATION.values) {
        calc.clearAll();
        expect(calc.selectedOperation, null);
        double result = getResultBinaryOperation(firstNumber, secondNumber, op1);
        String stringNumber = firstNumber.toStringAsFixed(11);
        calc.submitString(stringNumber);
        expect(calc.currentNumber, stringNumber);
        calc.submitString(mapOperation[op1]!); //first operation
        expect(calc.currentNumber, stringNumber);
        expect(calc.selectedOperation, op1);
        stringNumber = secondNumber.toStringAsFixed(11);
        calc.submitString(stringNumber);
        expect(calc.currentNumber, stringNumber);
        calc.submitString(mapOperation[op2]!); //second operation
        expect(isAcceptable(result, calc.currentNumber), true);
        expect(calc.selectedOperation, op2);
        stringNumber = thirdNumber.toStringAsFixed(11);
        calc.submitString(stringNumber);
        expect(calc.currentNumber, stringNumber);
        calc.submitString('=');
        result = getResultBinaryOperation(result, thirdNumber, op2);
        expect(isAcceptable(result, calc.currentNumber), true, reason: 'Expected:$result\nActual:  ${calc.currentNumber}');
      }
    }
  });

  test('Change a wrong operation in binary operation', () {
    Random rnd = Random();
    double firstNumber = rnd.nextDouble() * MAXVALUE + 1;
    double secondNumber = rnd.nextDouble() * MAXVALUE + 1;
    OPERATION op1 = getRandomOperation();
    OPERATION op2 = getRandomOperation();
    while (op1 != op2) op2 = getRandomOperation();
    Calculator calc = Calculator();
    expect(calc.selectedOperation, null);
    String stringNumber = firstNumber.toStringAsFixed(11);
    calc.submitString(stringNumber);
    expect(calc.currentNumber, stringNumber);
    calc.submitString(mapOperation[op1]!); //first operation
    expect(calc.currentNumber, stringNumber);
    expect(calc.selectedOperation, op1);
    calc.submitString(mapOperation[op2]!); //change of operation
    expect(calc.currentNumber, stringNumber);
    expect(calc.selectedOperation, op1);
    stringNumber = secondNumber.toStringAsFixed(11);
    calc.submitString(stringNumber);
    expect(calc.currentNumber, stringNumber);
    calc.submitString('=');
    double result = getResultBinaryOperation(firstNumber, secondNumber, op2);
    expect(isAcceptable(result, calc.currentNumber), true, reason: 'Expected:$result\nActual:  ${calc.currentNumber}');
  });

  test('Start a second computation after the end of the first', () {
    Random rnd = Random();
    Calculator calc = Calculator();
    for (int i = 0; i < 5; i++) {
      double firstNumber = rnd.nextDouble() * MAXVALUE + 1;
      double secondNumber = rnd.nextDouble() * MAXVALUE + 1;
      OPERATION op = getRandomOperation();
      double result = getResultBinaryOperation(firstNumber, secondNumber, op);
      String stringNumber = firstNumber.toStringAsFixed(11);
      calc.submitString(stringNumber);
      expect(calc.currentNumber, stringNumber);
      calc.submitString(mapOperation[op]!); //first operation
      expect(calc.currentNumber, stringNumber);
      expect(calc.selectedOperation, op);
      stringNumber = secondNumber.toStringAsFixed(11);
      calc.submitString(stringNumber);
      expect(calc.currentNumber, stringNumber);
      calc.submitString('=');
      expect(isAcceptable(result, calc.currentNumber), true, reason: 'Expected:$result\nActual:  ${calc.currentNumber}');
    }
  });

  test('Different decimal separator', () {
    String decimalSeparator = ',';
    Calculator calc = Calculator(decimalSeparator: decimalSeparator);
    double firstNumber = 12345.6789;
    double secondNumber = 9876543.21;
    OPERATION op = OPERATION.ADDITION;
    String result = '9888888,8889';
    String stringNumber = firstNumber.toStringAsFixed(11).replaceFirst(RegExp('[.]'), decimalSeparator);
    calc.submitString(stringNumber);
    expect(calc.currentNumber, stringNumber);
    calc.submitString(mapOperation[op]!);
    expect(calc.currentNumber, stringNumber);
    expect(calc.selectedOperation, op);
    stringNumber = secondNumber.toStringAsFixed(11);
    calc.submitString(stringNumber);
    expect(calc.currentNumber, stringNumber);
    calc.submitString('=');
    expect(result, calc.currentNumber, reason: 'Expected:$result\nActual:  ${calc.currentNumber}');
  });

  test('Multiple press = after result returns the result applied the last operation', () {
    Calculator calc = Calculator();
    double result = 3;
    double secondNumber = 2;
    OPERATION op = OPERATION.PRODUCT;
    calc.submitString(result.toString());
    calc.submitString(mapOperation[op]!);
    calc.submitString(secondNumber.toString());
    calc.submitString('=');
    result = getResultBinaryOperation(result, secondNumber, op);
    expect(isAcceptable(result, calc.currentNumber), true, reason: 'Expected:$result\nActual:  ${calc.currentNumber}');
    for (int i = 0; i < 5; i++) {
      calc.submitChar('=');
      result = getResultBinaryOperation(result, secondNumber, op);
      expect(isAcceptable(result, calc.currentNumber), true, reason: 'Expected:$result\nActual:  ${calc.currentNumber}');
    }
  });

  /// e.g. 2*3=-1 --> 5
  test('Execute an operation on the result', () {
    Calculator calc = Calculator();
    calc..submitString('2')..submitString('*')..submitString('3')..submitString('=');
    expect(calc.currentNumber, '6');
    calc..submitString('-')..submitString('1')..submitString('=');
    expect(calc.currentNumber, '5');
  });

  test('π submission', () {
    Calculator calc = Calculator();
    calc.submitChar('π');
    expect(calc.currentNumber, pi.toString());
    calc..submitString('*')..submitString('2')..submitString('=');
    expect(calc.currentNumber, (2*pi).toString());
  });

  test('e submission', () {
    Calculator calc = Calculator();
    calc.submitChar('e');
    expect(calc.currentNumber, e.toString());
    calc..submitString('*')..submitString('2')..submitString('=');
    expect(calc.currentNumber, (2*e).toString());
  });

  test('Square root', () {
    Calculator calc = Calculator();
    calc..submitString('10000')..squareRoot();
    expect(calc.currentNumber, '100');

  });
}

bool isAcceptable(double convertedValue, String expectedValue, {double sensibility = 1e10}) {
  final double accuracy = convertedValue.abs() / sensibility;
  final double? expectedValueDouble = double.tryParse(expectedValue);
  if (expectedValueDouble == null) return false; // if the result is invalid, then it is not acceptable
  final double upperConstraint = expectedValueDouble + accuracy;
  final double lowerConstraint = expectedValueDouble - accuracy;
  return convertedValue >= lowerConstraint && convertedValue <= upperConstraint;
}

void testBinaryOperation(OPERATION operation) {
  test('${operation.toString()} test', () {
    Random rnd = Random();
    Calculator calc = Calculator();
    expect(calc.selectedOperation, null);
    double firstNumber = rnd.nextDouble() * MAXVALUE;
    double secondNumber = rnd.nextDouble() * MAXVALUE;
    String stringNumber = firstNumber.toStringAsFixed(11);
    calc.submitString(stringNumber);
    expect(calc.currentNumber, stringNumber);
    calc.submitString(mapOperation[operation]!);
    expect(calc.currentNumber, stringNumber);
    expect(calc.selectedOperation, operation);
    stringNumber = secondNumber.toStringAsFixed(11);
    calc.submitString(stringNumber);
    expect(calc.currentNumber, stringNumber);
    calc.submitString('=');
    double result = getResultBinaryOperation(firstNumber, secondNumber, operation);
    expect(isAcceptable(result, calc.currentNumber), true, reason: 'Expected:$result\nActual:  ${calc.currentNumber}');
  });
}

/// Returns the result of a binary operation op between 2 numbers a and b
double getResultBinaryOperation(double a, double b, OPERATION op) {
  switch (op) {
    case OPERATION.ADDITION:
      return a + b;
    case OPERATION.SUBTRACTION:
      return a - b;
    case OPERATION.PRODUCT:
      return a * b;
    case OPERATION.DIVISION:
      return a / b;
  }
}

OPERATION getRandomOperation() {
  Random rnd = Random();
  return OPERATION.values[rnd.nextInt(4)];
}
