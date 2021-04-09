import 'package:converterpro/models/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculatorWidget extends StatefulWidget {
  CalculatorWidget(this.width, this.brightness);
  final double width;
  final Brightness brightness;
  @override
  _CalculatorWidget createState() => new _CalculatorWidget();
}

class _CalculatorWidget extends State<CalculatorWidget> {
  static const double buttonHeight = 70.0;
  static const double buttonOpSize = buttonHeight * 0.8;
  static const double textSize = 35.0;
  FocusNode focusKeyboard = FocusNode();
  late Color accentColor;

  @override
  void initState() {
    super.initState();
    focusKeyboard.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    accentColor = Theme.of(context).accentColor;

    final double calcWidth = _getCalcWidth(widget.width);
    final int columnsNumber = _getColumnsNumber(calcWidth);
    final double buttonWidth = _getButtonWidth(calcWidth, columnsNumber);
    Color textButtonColor = Color(widget.brightness == Brightness.dark ? 0xFFBBBBBB : 0xFF777777);
    String text = context.select<Calculator, String>((calc) => calc.currentNumber);
    String decimalSeparator = '.'; //numberFormatSymbols[Localizations.localeOf(context).languageCode]?.DECIMAL_SEP ?? '.';
    return Container(
      height: 5 * buttonHeight,
      child: RawKeyboardListener(
        focusNode: focusKeyboard,
        onKey: (RawKeyEvent event) {
          if (event.runtimeType.toString() == 'RawKeyDownEvent') {
            if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
              context.read<Calculator>().adaptiveDeleteClear();
            } else if(event.isKeyPressed(LogicalKeyboardKey.delete)) {
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
              alignment: Alignment(0, 0),
              child: Container(
                width: calcWidth,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: calcWidth - buttonWidth,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SelectableText(
                        text,
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                          color: widget.brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                        scrollPhysics: ClampingScrollPhysics(),
                        toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
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
                                color: widget.brightness == Brightness.dark ? Colors.white54 : Colors.black54,
                              ),
                              onPressed: () {
                                Clipboard.setData(new ClipboardData(text: text));
                              },
                            )
                          : Text(
                              context.select<Calculator, String>((calc) => calc.stringOperation),
                              style: TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold,
                                color: widget.brightness == Brightness.dark ? Colors.white54 : Colors.black54,
                              ),
                              maxLines: 1,
                            ),
                    ),
                  ],
                ),
              ),
              decoration: new BoxDecoration(color: widget.brightness == Brightness.dark ? Color(0xFF2e2e2e) : Colors.white, boxShadow: [
                new BoxShadow(
                  color: Colors.black,
                  blurRadius: 5.0,
                ),
              ]),
            ),
            //start of butttons
            Container(
              width: calcWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  columnsNumber < 6
                      ? SizedBox()
                      : Column(
                          children: <Widget>[
                            _button('x²', () {
                              context.read<Calculator>().square();
                            }, buttonWidth, buttonHeight, accentColor),
                            _button('ln', () {
                              context.read<Calculator>().ln();
                            }, buttonWidth, buttonHeight, accentColor),
                            _button('n!', () {
                              context.read<Calculator>().factorial();
                            }, buttonWidth, buttonHeight, accentColor),
                            _button('1/x', () {
                              context.read<Calculator>().reciprocal();
                            }, buttonWidth, buttonHeight, accentColor),
                          ],
                        ),
                  columnsNumber < 5
                      ? SizedBox()
                      : Column(
                          children: <Widget>[
                            _button('√', () {
                              context.read<Calculator>().squareRoot();
                            }, buttonWidth, buttonHeight, accentColor),
                            _button('log', () {
                              context.read<Calculator>().log10();
                            }, buttonWidth, buttonHeight, accentColor),
                            _button('e', () {
                              context.read<Calculator>().submitChar('e');
                            }, buttonWidth, buttonHeight, accentColor),
                            _button('π', () {
                              context.read<Calculator>().submitChar('π');
                            }, buttonWidth, buttonHeight, accentColor),
                          ],
                        ),
                  columnsNumber > 4
                      ? Container(
                          //divider
                          width: 1.0,
                          height: buttonHeight * 3.9,
                          color: Color(0xFFBBBBBB),
                        )
                      : SizedBox(),
                  Column(children: [
                    Column(
                      //creates numbers buttons from 1 to 9
                      children: List<Widget>.generate(3, (i) {
                        return Row(
                          children: List.generate(3, (j) {
                            String char = (7 - 3 * i + j).toString(); // (2-i)*3 + j+1 = 7-3*i+j
                            return _button(
                              char,
                              () {
                                context.read<Calculator>().submitChar(char);
                              },
                              buttonWidth,
                              buttonHeight,
                              textButtonColor,
                            );
                          }),
                        );
                      }),
                    ),
                    Row(children: <Widget>[
                      _button(decimalSeparator, () {
                        context.read<Calculator>().submitChar(decimalSeparator);
                      }, buttonWidth, buttonHeight, textButtonColor),
                      _button('0', () {
                        context.read<Calculator>().submitChar('0');
                      }, buttonWidth, buttonHeight, textButtonColor),
                      _button('=', () {
                        context.read<Calculator>().submitChar('=');
                      }, buttonWidth, buttonHeight, textButtonColor),
                    ]),
                  ]),
                  Container(
                    //divider
                    width: 1.0,
                    height: buttonHeight * 3.9,
                    color: Color(0xFFBBBBBB),
                  ),
                  Column(
                    children: <Widget>[
                      _button(context.select<Calculator, bool>((calc) => calc.endNumber) ? 'CE' : '←', () {
                        context.read<Calculator>().adaptiveDeleteClear();
                      }, buttonWidth, buttonOpSize, accentColor),
                      _button('÷', () {
                        context.read<Calculator>().submitChar('/');
                      }, buttonWidth, buttonOpSize, accentColor),
                      _button('×', () {
                        context.read<Calculator>().submitChar('*');
                      }, buttonWidth, buttonOpSize, accentColor),
                      _button('−', () {
                        context.read<Calculator>().submitChar('-');
                      }, buttonWidth, buttonOpSize, accentColor),
                      _button('+', () {
                        context.read<Calculator>().submitChar('+');
                      }, buttonWidth, buttonOpSize, accentColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, Function() onPressed, double buttonWidth, double buttonHeight, Color color) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: widget.brightness == Brightness.dark ? Colors.white24 : Colors.black26,
      primary: Colors.transparent,
      minimumSize: Size(buttonWidth, buttonHeight),
      elevation: 0,
      animationDuration: Duration(milliseconds: 60),
    );

    return ElevatedButton(
      child: text == "←"
          ? Icon(
              Icons.backspace,
              color: color,
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: color,
              ),
            ),
      style: raisedButtonStyle,
      onPressed: onPressed,
    );
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
