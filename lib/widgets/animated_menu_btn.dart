import 'package:flutter/material.dart';

/// Wrapper for animating the button's position in the stack.
class AnimatedMenuButton extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Widget child;

  final Duration duration;
  final Curve curve;
  final bool isActive;

  const AnimatedMenuButton({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
    this.isActive = false,
  }) : assert(
         !(left != null && right != null),
         'AnimatedMenuButton cannot have both left and right set at the same time.',
       );

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: duration,
      curve: curve,
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: RepaintBoundary(
        child: AnimatedScale(
          scale: isActive ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: child,
        ),
      ),
    );
  }
}
