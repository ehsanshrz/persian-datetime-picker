import 'package:flutter/material.dart';

/// A custom dialog widget that wraps Flutter's [Dialog] with a fixed width of 320.
class CDialog extends StatelessWidget {
  const CDialog({
    super.key,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.shape,
    this.child,
  });

  final Color? backgroundColor;
  final double? elevation;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final ShapeBorder? shape;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      insetAnimationDuration: insetAnimationDuration,
      insetAnimationCurve: insetAnimationCurve,
      shape: shape,
      child: SizedBox(
        width: 320,
        child: child,
      ),
    );
  }
}
