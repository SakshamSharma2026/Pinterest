import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pinterest/core/app_constants.dart';

/// The main content card that responds to the menu state.
class ContentCard extends StatelessWidget {
  final bool showMenu;

  const ContentCard({super.key, required this.showMenu});

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;
    final duration = reduceMotion
        ? Duration.zero
        : AppConstants.kMotionDuration;
    final curve = reduceMotion ? Curves.linear : AppConstants.kMotionCurve;

    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        duration: duration,
        curve: curve,
        tween: Tween<double>(begin: 0, end: showMenu ? pi / 40 : 0),
        builder: (context, angle, child) {
          return AnimatedScale(
            scale: showMenu ? 0.92 : 1.0,
            duration: duration,
            curve: curve,
            child: Transform.rotate(
              alignment: Alignment.center,
              angle: angle,
              child: child,
            ),
          );
        },
        child: _defaultCard(),
      ),
    );
  }

  Widget _defaultCard() {
    return SizedBox(
      width: 300,
      height: 400,
      child: Card(
        color: AppConstants.kPinterestRed,
        elevation: 6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pinterest_icon.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.broken_image_rounded, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Long Press Me',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Hold to reveal options',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
