import 'package:converterpro/models/calculator.dart';
import 'package:converterpro/utils/utils_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({Key? key}) : super(key: key);

  @override
  _CalculatorWidget createState() => _CalculatorWidget();
}

class _CalculatorWidget extends State<CalculatorWidget> {
  static const double buttonHeight = 70.0;
  static const double buttonOpSize = buttonHeight * 0.8;
  final FocusNode focusKeyboard = FocusNode();
  static const String decimalSeparator = '.';
  //=numberFormatSymbols[Localizations.localeOf(context).languageCode]?.DECIMAL_SEP ?? '.';

  @override
  void initState() {
    super.initState();
    focusKeyboard.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    focusKeyboard.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Brightness brightness = Theme.of(context).brightness;
    final TextStyle buttonOpStyle = TextStyle(fontSize: 35, color: secondaryColor);
    final TextStyle buttonTextStyle =
        TextStyle(fontSize: 35, color: Color(brightness == Brightness.dark ? 0xFFBBBBBB : 0xFF777777));

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final double calcWidth = _getCalcWidth(constraints.maxWidth);
      final int columnsNumber = _getColumnsNumber(calcWidth);
      final double buttonWidth = _getButtonWidth(calcWidth, columnsNumber);

      String text = context.select<Calculator, String>((calc) => calc.currentNumber);

      return SizedBox(
        height: 5 * buttonHeight,
        child: RawKeyboardListener(
          focusNode: focusKeyboard,
          onKey: (RawKeyEvent event) {
            if (event.runtimeType.toString() == 'RawKeyDownEvent') {
              if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
                context.read<Calculator>().adaptiveDeleteClear();
              } else if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
                context.read<Calculator>().clearAll();
              } else if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                context.read<Calculator>().submitChar('=');
              } else {
                context.read<Calculator>().submitChar(event.character ?? '');
              }
            }
          },
          child: Column(
            children: <Widget>[
              Container(
                height: buttonHeight,
                alignment: const Alignment(0, 0),
                child: SizedBox(
                  width: calcWidth,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: calcWidth - buttonWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SelectableText(
                          text,
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold,
                            color: brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          scrollPhysics: const ClampingScrollPhysics(),
                          toolbarOptions: const ToolbarOptions(copy: true, selectAll: true),
                        ),
                      ),
                      Container(
                        width: buttonWidth,
                        alignment: Alignment.center,
                        child: context.select<Calculator, bool>((calc) => calc.isResult)
                            ? IconButton(
                                tooltip: AppLocalizations.of(context)?.copy,
                                icon: Icon(
                                  Icons.content_copy,
                                  color: brightness == Brightness.dark ? Colors.white54 : Colors.black54,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: text));
                                },
                              )
                            : Text(
                                context.select<Calculator, String>((calc) => calc.stringOperation),
                                style: TextStyle(
                                  fontSize: 45.0,
                                  fontWeight: FontWeight.bold,
                                  color: brightness == Brightness.dark ? Colors.white54 : Colors.black54,
                                ),
                                maxLines: 1,
                              ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    color: brightness == Brightness.dark ? const Color(0xFF2e2e2e) : Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                      ),
                    ]),
              ),
              //start of butttons
              SizedBox(
                width: calcWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (columnsNumber > 5)
                      Column(
                        children: <Widget>[
                          CalculatorButton(
                              text: 'x²',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().square();
                              }),
                          CalculatorButton(
                              text: 'ln',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().ln();
                              }),
                          CalculatorButton(
                              text: 'n!',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().factorial();
                              }),
                          CalculatorButton(
                              text: '1/x',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().reciprocal();
                              }),
                        ],
                      ),
                    if (columnsNumber > 4)
                      Column(
                        children: <Widget>[
                          CalculatorButton(
                              text: '√',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().squareRoot();
                              }),
                          CalculatorButton(
                              text: 'log',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().log10();
                              }),
                          CalculatorButton(
                              text: 'e',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().submitChar('e');
                              }),
                          CalculatorButton(
                              text: 'π',
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              style: buttonOpStyle,
                              onPressed: () {
                                context.read<Calculator>().submitChar('π');
                              }),
                        ],
                      ),
                    if (columnsNumber > 4)
                      Container(
                        //divider
                        width: 1.0,
                        height: buttonHeight * 3.9,
                        color: const Color(0xFFBBBBBB),
                      ),
                    Column(children: [
                      Column(
                        //creates numbers buttons from 1 to 9
                        children: List<Widget>.generate(3, (i) {
                          return Row(
                            children: List.generate(3, (j) {
                              String char = (7 - 3 * i + j).toString(); // (2-i)*3 + j+1 = 7-3*i+j
                              return CalculatorButton(
                                  text: char,
                                  buttonWidth: buttonWidth,
                                  buttonHeight: buttonHeight,
                                  style: buttonTextStyle,
                                  onPressed: () {
                                    context.read<Calculator>().submitChar(char);
                                  });
                            }),
                          );
                        }),
                      ),
                      Row(children: <Widget>[
                        CalculatorButton(
                            text: decimalSeparator,
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonHeight,
                            style: buttonTextStyle,
                            onPressed: () {
                              context.read<Calculator>().submitChar(decimalSeparator);
                            }),
                        CalculatorButton(
                            text: '0',
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonHeight,
                            style: buttonTextStyle,
                            onPressed: () {
                              context.read<Calculator>().submitChar('0');
                            }),
                        CalculatorButton(
                            text: '=',
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonHeight,
                            style: buttonTextStyle,
                            onPressed: () {
                              context.read<Calculator>().submitChar('=');
                            }),
                      ]),
                    ]),
                    Container(
                      //divider
                      width: 1.0,
                      height: buttonHeight * 3.9,
                      color: const Color(0xFFBBBBBB),
                    ),
                    Column(
                      children: <Widget>[
                        CalculatorButton(
                            text: context.select<Calculator, bool>((calc) => calc.endNumber) ? 'CE' : '←',
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonOpSize,
                            style: buttonTextStyle,
                            iconColor: secondaryColor,
                            onPressed: () {
                              context.read<Calculator>().adaptiveDeleteClear();
                            },
                            onLongPress: () {
                              context.read<Calculator>().clearAll();
                            }),
                        CalculatorButton(
                            text: '÷',
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonOpSize,
                            style: buttonOpStyle,
                            onPressed: () {
                              context.read<Calculator>().submitChar('/');
                            }),
                        CalculatorButton(
                            text: '×',
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonOpSize,
                            style: buttonOpStyle,
                            onPressed: () {
                              context.read<Calculator>().submitChar('*');
                            }),
                        CalculatorButton(
                            text: '−',
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonOpSize,
                            style: buttonOpStyle,
                            onPressed: () {
                              context.read<Calculator>().submitChar('-');
                            }),
                        CalculatorButton(
                            text: '+',
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonOpSize,
                            style: buttonOpStyle,
                            onPressed: () {
                              context.read<Calculator>().submitChar('+');
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

///Returns the width of one button given all the available width
double _getButtonWidth(double calcWidth, int columnNumber) {
  return (calcWidth * 0.9) / columnNumber;
}

///Returns the width of the calculator
double _getCalcWidth(double totalWidth) {
  const double maxCalcWidth = 800;
  return totalWidth < maxCalcWidth ? totalWidth : maxCalcWidth;
}

int _getColumnsNumber(double calcWidth) {
  if (calcWidth < 400) {
    return 4;
  } else if (calcWidth < 500) {
    return 5;
  }
  return 6;
}
