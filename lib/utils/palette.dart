import 'package:flutter/material.dart';

class Palette extends StatefulWidget {
  const Palette(
      {super.key,
      required this.onSelected,
      required this.initial,
      this.enabled = true});

  final Function(Color color) onSelected;
  final Color initial;
  final bool enabled;

  @override
  State<Palette> createState() => _PaletteState();
}

class _PaletteState extends State<Palette> {
  Color? hoveredColor;
  late Color selectedColor;

  static const double squareSize = 43;
  static const double checkSize = 24;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final palette = Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        Colors.red,
        Colors.pink,
        Colors.purple,
        Colors.deepPurple,
        Colors.indigo,
        Colors.blue,
        Colors.lightBlue,
        Colors.cyan,
        Colors.teal,
        Colors.green,
        Colors.lightGreen,
        Colors.lime,
        Colors.yellow,
        Colors.amber,
        Colors.orange,
        Colors.deepOrange,
        Colors.brown,
        Colors.blueGrey,
      ].map(
        (e) {
          final selectedColorValue = selectedColor.value;
          final isHovered = hoveredColor == e;
          return MouseRegion(
            onEnter: (_) {
              setState(() => hoveredColor = e);
            },
            onExit: (_) {
              setState(() => hoveredColor = null);
            },
            child: InkWell(
              onTap: () {
                setState(() => selectedColor = e);
                widget.onSelected(e);
              },
              borderRadius: BorderRadius.circular(squareSize / 2),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: squareSize,
                    height: squareSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        isHovered ? squareSize / 2 : squareSize / 4,
                      ),
                      color: Color.lerp(
                        widget.enabled
                            ? e
                            : HSVColor.fromColor(e)
                                .withSaturation(0.02)
                                .toColor(),
                        Colors.white,
                        isHovered ? 0.5 : 0,
                      ),
                    ),
                  ),
                  if (widget.enabled && selectedColorValue == e.value)
                    Positioned(
                      top: (squareSize - checkSize) / 2,
                      left: (squareSize - checkSize) / 2,
                      child: Icon(
                        Icons.check,
                        size: checkSize,
                        color: e.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black,
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
    return widget.enabled
        ? palette
        : AbsorbPointer(absorbing: true, child: palette);
  }
}
