// --- Constants ---
// Layout dimensions

import 'package:flutter/material.dart';

class AppConstants {
  // --- Constants ---
  AppConstants._();

  // Layout dimensions
  static const double kMenuWidth = 200.0;
  static const double kMenuHeight = 200.0;
  static const double kButtonSize = 50.0;
  static const double kMenuOffset = 16.0; // Top offset for the first button
  static const double kSideButtonTop =
      80.0; // Vertical position for side buttons
  static const double kSideButtonEdgeOffset =
      24.0; // Horizontal offset from edge
  static const double kSideButtonSelectedOffset =
      4.0; // Horizontal offset when selected

  // Interaction tuning
  static const double kTouchRadiusMultiplier = 0.85;
  static const double kPadding = 16.0;

  // Animation durations
  static const Duration kAnimationDuration = Duration(milliseconds: 350);
  static const Duration kButtonAnimationDuration = Duration(milliseconds: 250);
  static const Duration kSnackBarDuration = Duration(milliseconds: 1500);
  static const Duration kMotionDuration = Duration(milliseconds: 400);
  static const Curve kMotionCurve = Curves.easeOutCubic;
  // Colors
  static const Color kPinterestRed = Color(0xFFC8232C);
  static const Color kMenuBackground = Colors.white;
  static const Color kIconActive = Colors.grey; // shade800
  static const Color kIconInactive = Colors.white;

  static final List<String> actions = ['Favorite', 'Share', 'Search image'];
}
