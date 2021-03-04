import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calculator extends StatefulWidget {
  Calculator(this.color, this.width, this.brightness);
  final Color color;
  final double width;
  final Brightness brightness;
  @override
  _Calculator createState() => new _Calculator();
}

class _Calculator extends State<Calculator> {
  String text = "";
  static const double buttonHeight = 70.0;
  static const double buttonOpSize = buttonHeight * 0.8;
  static const double textSize = 35.0;

  double? result = 0;
  bool alreadyDeleted = false;
  bool isResult = false;
  double? firstNumber, secondNumber;
  int operation = 0;
  @override
  Widget build(BuildContext context) {
    double calcWidth = widget.width < 800 ? widget.width : 800;
    Color textButtonColor = Color(widget.brightness == Brightness.dark ? 0xFFBBBBBB : 0xFF777777);
    return Container(
      height: 5 * buttonHeight,
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
                    child: isResult
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
                            operation == 1
                                ? "+"
                                : operation == 2
                                    ? "−"
                                    : operation == 3
                                        ? "×"
                                        : operation == 4
                                            ? "÷"
                                            : "",
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
            color: Colors.black.withAlpha(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _button("7", () {
                          addChar("7");
                        }, buttonHeight, textButtonColor, calcWidth),
                        _button("8", () {
                          addChar("8");
                        }, buttonHeight, textButtonColor, calcWidth),
                        _button("9", () {
                          addChar("9");
                        }, buttonHeight, textButtonColor, calcWidth),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _button("4", () {
                          addChar("4");
                        }, buttonHeight, textButtonColor, calcWidth),
                        _button("5", () {
                          addChar("5");
                        }, buttonHeight, textButtonColor, calcWidth),
                        _button("6", () {
                          addChar("6");
                        }, buttonHeight, textButtonColor, calcWidth),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        _button("1", () {
                          addChar("1");
                        }, buttonHeight, textButtonColor, calcWidth),
                        _button("2", () {
                          addChar("2");
                        }, buttonHeight, textButtonColor, calcWidth),
                        _button("3", () {
                          addChar("3");
                        }, buttonHeight, textButtonColor, calcWidth),
                      ],
                    ),
                    Row(children: <Widget>[
                      _button(".", () {
                        addChar(".");
                      }, buttonHeight, textButtonColor, calcWidth),
                      _button("0", () {
                        addChar("0");
                      }, buttonHeight, textButtonColor, calcWidth),
                      _button("=", () {
                        computeCalculus();
                      }, buttonHeight, textButtonColor, calcWidth),
                    ])
                  ],
                ),
                Container(
                  //divider
                  width: 1.0,
                  height: buttonHeight * 3.9,
                  color: Color(0xFFBBBBBB),
                ),
                Column(
                  children: <Widget>[
                    _button(isResult ? "CE" : "←", () {
                      if (isResult) {
                        operation = 0;
                        firstNumber = secondNumber = null;
                        setState(() {
                          text = "";
                        });
                      }
                      isResult = false;
                      deleteLastChar();
                    }, buttonOpSize, widget.color, calcWidth),
                    _button("÷", () {
                      setOperation(4);
                    }, buttonOpSize, widget.color, calcWidth),
                    _button("×", () {
                      setOperation(3);
                    }, buttonOpSize, widget.color, calcWidth),
                    _button("−", () {
                      setOperation(2);
                    }, buttonOpSize, widget.color, calcWidth),
                    _button("+", () {
                      setOperation(1);
                    }, buttonOpSize, widget.color, calcWidth),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addChar(String char) {
    isResult = false;

    //Se premo un tasto dopo aver premuto su un operazione devo cancellare
    if (!alreadyDeleted && firstNumber != null && text.length > 0) {
      alreadyDeleted = true;
      setState(() {
        text = "";
      });
    }
    //Se premo un tasto devo aggiornare il testo dei numeri visualizzati
    if (char != "." || (char == "." && !text.contains(".") && text.length > 0)) {
      setState(() {
        text += char;
      });
    }
  }

  void deleteLastChar() {
    if (text.length > 0) {
      setState(() {
        text = text.substring(0, text.length - 1);
      });
    }
  }

  void setOperation(int op) {
    //Se voglio usare il risulato concatenandolo a una nuova operazione
    isResult = false;
    firstNumber = double.parse(text);
    secondNumber = null;
    alreadyDeleted = false;

    setState(() {
      operation = op;
    });
  }

  void computeCalculus() {
    secondNumber = double.parse(text);
    if (firstNumber == null || secondNumber == null || operation == 0 || (operation == 4 && secondNumber == 0))
      result = null;
    else {
      switch (operation) {
        case 1:
          result = firstNumber! + secondNumber!;
          break;
        case 2:
          result = firstNumber! - secondNumber!;
          break;
        case 3:
          result = firstNumber! * secondNumber!;
          break;
        case 4:
          result = firstNumber! / secondNumber!;
          break;
      }
    }
    if (result != null) {
      String stringResult = result.toString();
      if (stringResult.endsWith(".0")) stringResult = stringResult.substring(0, stringResult.length - 2);
      setState(() {
        text = stringResult;
      });
    }
    alreadyDeleted = false;
    isResult = true;
    operation = 0;
  }

  Widget _button(String number, Function() f, double size, Color color, width) {
    // Creating a method of return type Widget with number and function f as a parameter
    return ButtonTheme(
      minWidth: (width * 0.9) / 4,
      height: size,
      child: RaisedButton(
        child: number == "←"
            ? Icon(
                Icons.backspace,
                color: color,
              )
            : Text(
                number,
                style: TextStyle(fontSize: textSize),
              ),
        textColor: color,
        color: Colors.transparent,
        elevation: 0.0,
        onPressed: f,
      ),
    );
  }
}