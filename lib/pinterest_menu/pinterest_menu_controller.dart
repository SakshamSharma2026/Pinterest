import 'package:flutter/material.dart';
import 'package:pinterest/core/app_constants.dart';

class PinterestMenuController extends ChangeNotifier {
  bool showMenu = false;
  int? selectedIndex;

  Offset longPressPosition = Offset.zero;
  Offset menuPosition = Offset.zero;

  late final List<Offset> _buttonCenters;

  PinterestMenuController({
    required double menuWidth,
    required double menuHeight,
  }) {
    _buttonCenters = _buildButtonCenters(menuWidth, menuHeight);
  }

  // --- Public API ---

  void showMenuAt(Size stackSize) {
    _updateMenuPosition(stackSize);
    showMenu = true;
    selectedIndex = null;
    notifyListeners();
  }

  void hideMenu() {
    showMenu = false;
    selectedIndex = null;
    notifyListeners();
  }

  void clearSelection() {
    if (selectedIndex == null) return;
    selectedIndex = null;
    notifyListeners();
  }

  void updateLongPressPosition(Offset position) {
    longPressPosition = position;
  }

  void updateSelection(Offset localTouch) {
    int? newIndex;
    double minDistance = double.infinity;

    final double touchRadius =
        AppConstants.kButtonSize * AppConstants.kTouchRadiusMultiplier;

    for (int i = 0; i < _buttonCenters.length; i++) {
      final distance = (localTouch - _buttonCenters[i]).distance;
      if (distance <= touchRadius && distance < minDistance) {
        minDistance = distance;
        newIndex = i;
      }
    }

    if (newIndex != selectedIndex) {
      selectedIndex = newIndex;
      notifyListeners();
    }
  }

  // --- Internals ---

  void _updateMenuPosition(Size stackSize) {
    double widthFactor = longPressPosition.dx < stackSize.width / 2
        ? 0.25
        : 0.75;

    double left =
        longPressPosition.dx - (AppConstants.kMenuWidth * widthFactor);
    double top =
        longPressPosition.dy -
        (AppConstants.kMenuHeight / 2) -
        AppConstants.kMenuOffset;

    left = left.clamp(
      AppConstants.kPadding,
      stackSize.width - AppConstants.kMenuWidth - AppConstants.kPadding,
    );
    top = top.clamp(
      AppConstants.kPadding,
      stackSize.height - AppConstants.kMenuHeight - AppConstants.kPadding,
    );

    menuPosition = Offset(left, top);
  }

  static List<Offset> _buildButtonCenters(double menuWidth, double menuHeight) {
    return const [
      Offset(
        AppConstants.kMenuWidth / 2,
        AppConstants.kMenuOffset + AppConstants.kButtonSize / 2,
      ),
      Offset(
        AppConstants.kSideButtonEdgeOffset + AppConstants.kButtonSize / 2,
        AppConstants.kSideButtonTop + AppConstants.kButtonSize / 2,
      ),
      Offset(
        AppConstants.kMenuWidth -
            (AppConstants.kSideButtonEdgeOffset + AppConstants.kButtonSize / 2),
        AppConstants.kSideButtonTop + AppConstants.kButtonSize / 2,
      ),
    ];
  }
}
