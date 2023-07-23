import 'dart:io';
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final double initialRadius;
  final double finalRadius;
  final Duration animationDuration;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  const AnimatedButton({
    super.key,
    required this.child,
    required this.initialRadius,
    required this.finalRadius,
    required this.onPressed,
    this.onLongPress,
    this.foregroundColor,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;
  late final MaterialStatesController _materialStatesController =
      MaterialStatesController();

  late Color backgroundColor;
  late Color foregroundColor;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
      _materialStatesController.addListener(() {
        if (_materialStatesController.value.contains(MaterialState.pressed)) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }
    _animationController = AnimationController(
      duration: widget.animationDuration,
      reverseDuration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.initialRadius,
      end: widget.finalRadius,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = widget.backgroundColor ??
        Theme.of(context).colorScheme.secondaryContainer;
    foregroundColor = widget.foregroundColor ??
        Theme.of(context).colorScheme.onSecondaryContainer;

    return _ElevatedButtonTransition(
      radius: _animation,
      materialStatesController: _materialStatesController,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      onHover: (isHovered) => isHovered
          ? _animationController.forward()
          : _animationController.reverse(),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _materialStatesController.dispose();
    super.dispose();
  }
}

class _ElevatedButtonTransition extends AnimatedWidget {
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final MaterialStatesController? materialStatesController;
  final Widget child;
  final Color foregroundColor;
  final Color backgroundColor;

  const _ElevatedButtonTransition({
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.materialStatesController,
    required this.foregroundColor,
    required this.backgroundColor,
    required Animation<double> radius,
    required this.child,
  }) : super(listenable: radius);

  Animation<double> get radius => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = FilledButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.value),
      ),
    ).copyWith(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) => Colors.transparent,
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) => states.contains(MaterialState.pressed)
            ? Color.alphaBlend(
                Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.18)
                    : Colors.white30,
                backgroundColor)
            : backgroundColor,
      ),
    );

    return FilledButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      statesController: materialStatesController,
      onHover: onHover,
      style: style,
      child: child,
    );
  }
}
