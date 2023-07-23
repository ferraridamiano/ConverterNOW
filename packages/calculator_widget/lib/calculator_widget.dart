import 'package:calculator_widget/calculator_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:translations/app_localizations.dart';

enum ButtonType { number, operation }

const double _buttonsSpacing = 5;

class CalculatorWidget extends StatelessWidget {
  final FocusNode focusKeyboard = FocusNode();

  CalculatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider(
        create: (_) => Calculator(),
        builder: (context, child) {
          // Request focus on this widget, otherwise we are not able to use the
          // HW keyboard immediately when the calculator pops up.
          focusKeyboard.requestFocus();
          return KeyboardListener(
            focusNode: focusKeyboard,
            onKeyEvent: (KeyEvent event) {
              if (event.runtimeType.toString() == 'KeyDownEvent') {
                if (event.logicalKey == LogicalKeyboardKey.backspace) {
                  context.read<Calculator>().adaptiveDeleteClear();
                } else if (event.logicalKey == LogicalKeyboardKey.delete) {
                  context.read<Calculator>().clearAll();
                } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                  context.read<Calculator>().submitChar('=');
                } else {
                  context.read<Calculator>().submitChar(event.character ?? '');
                }
              }
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        // handle
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              width: 32,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        const CalculatorHeader(),
                      ],
                    ),
                  ),
                ),
                const Expanded(flex: 7, child: CalculatorNumpad()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CalculatorHeader extends StatelessWidget {
  const CalculatorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    String text =
        context.select<Calculator, String>((calc) => calc.currentNumber);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SelectableText(
              text,
              style: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.bold,
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
              maxLines: 1,
              scrollPhysics: const ClampingScrollPhysics(),
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Center(
            child: context.select<Calculator, bool>((calc) => calc.isResult)
                ? IconButton(
                    tooltip: AppLocalizations.of(context)?.copy,
                    icon: Icon(
                      Icons.content_copy,
                      color: brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.black54,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                    },
                  )
                : Text(
                    context.select<Calculator, String>(
                        (calc) => calc.stringOperation),
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                      color: brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.black54,
                    ),
                    maxLines: 1,
                  ),
          ),
        ),
      ],
    );
  }
}

class CalculatorNumpad extends StatelessWidget {
  const CalculatorNumpad({super.key});

  static const double breakPoint1 = 500;
  static const double breakPoint2 = 610;
  static const decimalSeparator = '.';

  @override
  Widget build(BuildContext context) {
    final calcWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(_buttonsSpacing),
      child: Row(
        children: <Widget>[
          if (calcWidth > breakPoint2)
            Column(
              children: <Widget>[
                CalculatorButton(
                    text: 'x²',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().square();
                    }),
                CalculatorButton(
                    text: 'ln',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().ln();
                    }),
                CalculatorButton(
                    text: 'n!',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().factorial();
                    }),
                CalculatorButton(
                    text: '1/x',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().reciprocal();
                    }),
              ].map((e) => Expanded(child: e)).toList(),
            ),
          if (calcWidth > breakPoint1)
            Column(
              children: <Widget>[
                CalculatorButton(
                    text: '√',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().squareRoot();
                    }),
                CalculatorButton(
                    text: 'log',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().log10();
                    }),
                CalculatorButton(
                    text: 'e',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().submitChar('e');
                    }),
                CalculatorButton(
                    text: 'π',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().submitChar('π');
                    }),
              ].map((e) => Expanded(child: e)).toList(),
            ),
          ...List.generate(
            3,
            (columnIndex) => Column(
              children: [
                ...List.generate(
                  3,
                  (rowIndex) {
                    final char = (7 - 3 * rowIndex + columnIndex).toString();
                    return CalculatorButton(
                      text: char,
                      buttonType: ButtonType.number,
                      onPressed: () {
                        context.read<Calculator>().submitChar(char);
                      },
                    );
                  },
                ),
                if (columnIndex == 0)
                  CalculatorButton(
                    text: decimalSeparator,
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().submitChar(decimalSeparator);
                    },
                  )
                else if (columnIndex == 1)
                  CalculatorButton(
                    text: '0',
                    buttonType: ButtonType.number,
                    onPressed: () {
                      context.read<Calculator>().submitChar('0');
                    },
                  )
                else if (columnIndex == 2)
                  CalculatorButton(
                    text: '=',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      context.read<Calculator>().submitChar('=');
                    },
                  )
              ].map((e) => Expanded(child: e)).toList(),
            ),
          ),
          Column(
            children: <Widget>[
              CalculatorButton(
                  text:
                      context.select<Calculator, bool>((calc) => calc.endNumber)
                          ? 'AC'
                          : '←',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    context.read<Calculator>().adaptiveDeleteClear();
                  },
                  onLongPress: () {
                    context.read<Calculator>().clearAll();
                  }),
              CalculatorButton(
                  text: '÷',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    context.read<Calculator>().submitChar('/');
                  }),
              CalculatorButton(
                  text: '×',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    context.read<Calculator>().submitChar('*');
                  }),
              CalculatorButton(
                  text: '−',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    context.read<Calculator>().submitChar('-');
                  }),
              CalculatorButton(
                  text: '+',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    context.read<Calculator>().submitChar('+');
                  }),
            ].map((e) => Expanded(child: e)).toList(),
          ),
        ].map((e) => Expanded(child: e)).toList(),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final ButtonType buttonType;

  const CalculatorButton({
    Key? key,
    this.text,
    this.onLongPress,
    this.onPressed,
    required this.buttonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle filledButtonStyle = switch (buttonType) {
      ButtonType.number => FilledButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        ),
      ButtonType.operation => FilledButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
    };
    return Padding(
      padding: const EdgeInsets.all(_buttonsSpacing),
      child: FilledButton.tonal(
        style: filledButtonStyle,
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: SizedBox.expand(
          child: Center(
            child: text == "←"
                ? const Icon(
                    Icons.backspace_outlined,
                  )
                : Text(
                    text ?? '',
                    style: const TextStyle(fontSize: 30),
                    maxLines: 1,
                    textScaleFactor: 1,
                  ),
          ),
        ),
      ),
    );
  }
}
