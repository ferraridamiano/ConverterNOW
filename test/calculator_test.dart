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

  group('Binary operation', () {
    for (OPERATION operation in mapOperation.keys) {
      testBinaryOperation(operation);
    }
  });

  test('Chained operations', () {
    Random rnd = Random();
    double firstNumber = rnd.nextDouble() * MAXVALUE + 1;
    double secondNumber = rnd.nextDouble() * MAXVALUE + 1;
    double thirdNumber = rnd.nextDouble() * MAXVALUE + 1;
    for (OPERATION op1 in OPERATION.values) {
      for (OPERATION op2 in OPERATION.values) {
        Calculator calc = Calculator();
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

void testMultiOperation(OPERATION operation) {}

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
