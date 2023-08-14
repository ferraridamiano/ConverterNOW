import 'package:calculator_widget/animated_button.dart';
import 'package:calculator_widget/calculator_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translations/app_localizations.dart';

enum ButtonType { number, operation, clear }

const double _buttonsSpacing = 5;

class CalculatorWidget extends StatelessWidget {
  const CalculatorWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      ProviderScope(child: _CalculatorWidget());
}

class _CalculatorWidget extends ConsumerWidget {
  final FocusNode focusKeyboard = FocusNode();

  _CalculatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 450,
      child: Builder(
        builder: (context) {
          focusKeyboard.requestFocus();
          return KeyboardListener(
            focusNode: focusKeyboard,
            onKeyEvent: (KeyEvent event) {
              if (event.runtimeType.toString() == 'KeyDownEvent') {
                if (event.logicalKey == LogicalKeyboardKey.backspace) {
                  ref.read(calculatorProvider.notifier).adaptiveDeleteClear();
                } else if (event.logicalKey == LogicalKeyboardKey.delete) {
                  ref.read(calculatorProvider.notifier).clearAll();
                } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                  ref.read(calculatorProvider.notifier).submitChar('=');
                } else {
                  ref
                      .read(calculatorProvider.notifier)
                      .submitChar(event.character ?? '');
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

class CalculatorHeader extends ConsumerWidget {
  const CalculatorHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String text = ref.watch(calculatorProvider);

    var operation = ref.watch(selectedOperationProvider);

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
                color: Theme.of(context).colorScheme.onBackground,
              ),
              maxLines: 1,
              textScaleFactor: 1,
              scrollPhysics: const ClampingScrollPhysics(),
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Center(
            child: ref.watch(isResultProvider)
                ? IconButton(
                    tooltip: AppLocalizations.of(context)?.copy,
                    icon: Icon(
                      Icons.content_copy,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                    },
                  )
                : Text(
                    operation != null ? operation.toString() : '',
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    textScaleFactor: 1,
                    maxLines: 1,
                  ),
          ),
        ),
      ],
    );
  }
}

class CalculatorNumpad extends ConsumerWidget {
  const CalculatorNumpad({super.key});

  static const double breakPoint1 = 500;
  static const double breakPoint2 = 610;
  static const decimalSeparator = '.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      ref.read(calculatorProvider.notifier).square();
                    }),
                CalculatorButton(
                    text: 'ln',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).ln();
                    }),
                CalculatorButton(
                    text: 'n!',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).factorial();
                    }),
                CalculatorButton(
                    text: '1/x',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).reciprocal();
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
                      ref.read(calculatorProvider.notifier).squareRoot();
                    }),
                CalculatorButton(
                    text: 'log',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).log10();
                    }),
                CalculatorButton(
                    text: 'e',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).submitChar('e');
                    }),
                CalculatorButton(
                    text: 'π',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).submitChar('π');
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
                        ref.read(calculatorProvider.notifier).submitChar(char);
                      },
                    );
                  },
                ),
                if (columnIndex == 0)
                  CalculatorButton(
                    text: decimalSeparator,
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref
                          .read(calculatorProvider.notifier)
                          .submitChar(decimalSeparator);
                    },
                  )
                else if (columnIndex == 1)
                  CalculatorButton(
                    text: '0',
                    buttonType: ButtonType.number,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).submitChar('0');
                    },
                  )
                else if (columnIndex == 2)
                  CalculatorButton(
                    text: '=',
                    buttonType: ButtonType.operation,
                    onPressed: () {
                      ref.read(calculatorProvider.notifier).submitChar('=');
                    },
                  )
              ].map((e) => Expanded(child: e)).toList(),
            ),
          ),
          Column(
            children: <Widget>[
              CalculatorButton(
                  text: ref.read(endNumberProvider) ? 'AC' : '←',
                  buttonType: ButtonType.clear,
                  onPressed: () {
                    ref.read(calculatorProvider.notifier).adaptiveDeleteClear();
                  },
                  onLongPress: () {
                    ref.read(calculatorProvider.notifier).clearAll();
                  }),
              CalculatorButton(
                  text: '÷',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    ref.read(calculatorProvider.notifier).submitChar('/');
                  }),
              CalculatorButton(
                  text: '×',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    ref.read(calculatorProvider.notifier).submitChar('*');
                  }),
              CalculatorButton(
                  text: '−',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    ref.read(calculatorProvider.notifier).submitChar('-');
                  }),
              CalculatorButton(
                  text: '+',
                  buttonType: ButtonType.operation,
                  onPressed: () {
                    ref.read(calculatorProvider.notifier).submitChar('+');
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
    final foregroundColor = switch (buttonType) {
      ButtonType.number => Theme.of(context).colorScheme.onPrimaryContainer,
      ButtonType.operation =>
        Theme.of(context).colorScheme.onSecondaryContainer,
      ButtonType.clear => Theme.of(context).colorScheme.onTertiaryContainer,
    };

    final backgroundColor = switch (buttonType) {
      ButtonType.number => Theme.of(context).colorScheme.primaryContainer,
      ButtonType.operation => Theme.of(context).colorScheme.secondaryContainer,
      ButtonType.clear => Theme.of(context).colorScheme.tertiaryContainer,
    };

    return Padding(
      padding: const EdgeInsets.all(_buttonsSpacing),
      child: AnimatedButton(
        initialRadius: 60,
        finalRadius: 20,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
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
                    style: const TextStyle(fontSize: 27),
                    maxLines: 1,
                    textScaleFactor: 1,
                  ),
          ),
        ),
      ),
    );
  }
}
