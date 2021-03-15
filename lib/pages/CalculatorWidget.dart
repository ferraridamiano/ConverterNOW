import 'package:converterpro/models/Calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:provider/provider.dart';

class CalculatorWidget extends StatefulWidget {
  CalculatorWidget(this.color, this.width, this.brightness);
  final Color color;
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

  @override
  void initState() {
    super.initState();
    focusKeyboard.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    context.select<Calculator, String>((calc) => calc.currentNumber);
    double calcWidth = widget.width < 800 ? widget.width : 800;
    Color textButtonColor = Color(widget.brightness == Brightness.dark ? 0xFFBBBBBB : 0xFF777777);
    String text = context.select<Calculator, String>((calc) => calc.currentNumber);
    String decimalSeparator = numberFormatSymbols[Localizations.localeOf(context).languageCode]?.DECIMAL_SEP ?? '.';
    return Container(
      height: 5 * buttonHeight,
      child: RawKeyboardListener(
        focusNode: focusKeyboard,
        onKey: (RawKeyEvent event) {
          if (event.runtimeType.toString() == 'RawKeyDownEvent') {
            if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
              context.read<Calculator>().adaptiveDeleteClear();
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
                width: (calcWidth * 0.9),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: (calcWidth * 0.9 * 3) / 4,
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
                      width: (calcWidth * 0.9) / 4,
                      alignment: Alignment.center,
                      child: context.select<Calculator, bool>((calc) => calc.isResult)
                          ? IconButton(
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
            Container(
              width: calcWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                              buttonHeight,
                              textButtonColor,
                              calcWidth,
                            );
                          }),
                        );
                      }),
                    ),
                    Row(children: <Widget>[
                      _button(decimalSeparator, () {
                        context.read<Calculator>().submitChar(decimalSeparator);
                      }, buttonHeight, textButtonColor, calcWidth),
                      _button('0', () {
                        context.read<Calculator>().submitChar('0');
                      }, buttonHeight, textButtonColor, calcWidth),
                      _button('=', () {
                        context.read<Calculator>().submitChar('=');
                      }, buttonHeight, textButtonColor, calcWidth),
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
                      }, buttonOpSize, widget.color, calcWidth),
                      _button('÷', () {
                        context.read<Calculator>().submitChar('/');
                      }, buttonOpSize, widget.color, calcWidth),
                      _button('×', () {
                        context.read<Calculator>().submitChar('*');
                      }, buttonOpSize, widget.color, calcWidth),
                      _button('−', () {
                        context.read<Calculator>().submitChar('-');
                      }, buttonOpSize, widget.color, calcWidth),
                      _button('+', () {
                        context.read<Calculator>().submitChar('+');
                      }, buttonOpSize, widget.color, calcWidth),
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

  Widget _button(String number, Function() onPressed, double size, Color color, width) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.transparent,
      primary: Colors.transparent,
      minimumSize: Size((width * 0.9) / 4, size),
      elevation: 0,
      animationDuration: Duration(milliseconds: 60),
    );

    return ButtonTheme(
      minWidth: (width * 0.9) / 4,
      height: size,
      child: ElevatedButton(
        child: number == "←"
            ? Icon(
                Icons.backspace,
                color: color,
              )
            : Text(
                number,
                style: TextStyle(
                  fontSize: textSize,
                  color: color,
                ),
              ),
        style: raisedButtonStyle,
        onPressed: onPressed,
      ),
    );
  }
}
