import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinterest/pinterest_menu/pinterest_menu_controller.dart';
import 'package:pinterest/widgets/animated_menu_btn.dart';
import 'package:pinterest/widgets/content_card.dart';
import 'package:pinterest/widgets/menu_btn.dart';
import 'package:pinterest/core/app_constants.dart';

/// A Pinterest-style gesture detector that reveals a menu on long-press.
///
/// This widget implements a long-press interaction pattern where a menu
/// smoothly animates out from the touch point.
/// It supports drag-to-select functionality with haptic feedback and smart boundary detection.
class PinterestGestureMenu extends StatefulWidget {
  const PinterestGestureMenu({super.key});

  @override
  State<PinterestGestureMenu> createState() => _PinterestGestureMenuState();
}

class _PinterestGestureMenuState extends State<PinterestGestureMenu>
    with SingleTickerProviderStateMixin {
  // --- State ---
  int? get _selectedIndex => _menuController.selectedIndex;
  bool isAnimating = false;

  // Coordinates
  Offset get _menuPosition => _menuController.menuPosition;

  // Controllers
  late final AnimationController _menuAnimationController;

  final GlobalKey _stackKey = GlobalKey();
  late RenderBox _stackBox;
  late final PinterestMenuController _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = PinterestMenuController(
      menuWidth: AppConstants.kMenuWidth,
      menuHeight: AppConstants.kMenuHeight,
    );

    _menuController.addListener(() {
      if (mounted) setState(() {});
    });

    _initializeAnimations();
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  /// Sets up the spring-based animations for the menu entrance.
  void _initializeAnimations() {
    _menuAnimationController = AnimationController(
      duration: AppConstants.kAnimationDuration,
      vsync: this,
    );

    _menuAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        isAnimating = false;
      } else {
        isAnimating = true;
      }
    });
  }

  /// Converts global touch coordinates to local stack coordinates.
  void _updateLongPressPosition(TapDownDetails details) {
    final box = _stackKey.currentContext?.findRenderObject();
    if (box is! RenderBox) return;

    final local = box.globalToLocal(details.globalPosition);
    _menuController.updateLongPressPosition(local);
  }

  // --- Event Handlers ---
  void _handleLongPressStart() {
    if (_menuController.showMenu || isAnimating) return;

    final box = _stackKey.currentContext?.findRenderObject();
    if (box is! RenderBox) return;

    _stackBox = box;

    _menuController.showMenuAt(_stackBox.size);

    _menuAnimationController.forward(from: 0);
  }

  void _handleLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (!_menuController.showMenu || isAnimating) return;

    final local = _stackBox.globalToLocal(details.globalPosition);

    final relativeTouch = Offset(
      local.dx - _menuController.menuPosition.dx,
      local.dy - _menuController.menuPosition.dy,
    );

    if (!_isTouchWithinBounds(relativeTouch.dx, relativeTouch.dy)) {
      _menuController.clearSelection();
      return;
    }

    _menuController.updateSelection(relativeTouch);
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    if (!_menuController.showMenu) return;

    final index = _menuController.selectedIndex;
    if (index != null) {
      _triggerHaptic(HapticFeedback.lightImpact);
      _onActionSelected(index);
    }

    _dismissMenu();
  }

  void _handleLongPressCancel() => _dismissMenu();

  void _dismissMenu() async {
    await _menuAnimationController.reverse();
    if (!mounted) return;
    _menuController.hideMenu();
  }

  /// Helper to check if touch is within an extended interaction area.
  bool _isTouchWithinBounds(double dx, double dy) {
    const double buffer = AppConstants.kButtonSize;
    return dx >= -buffer &&
        dx <= AppConstants.kMenuWidth + buffer &&
        dy >= -buffer &&
        dy <= AppConstants.kMenuHeight + buffer;
  }

  void _triggerHaptic(Future<void> Function() feedbackFunction) {
    // Wrap to prevent crashes on unsupported devices/platforms
    try {
      feedbackFunction();
    } catch (_) {}
  }

  void _onActionSelected(int index) {
    if (index < 0 || index >= AppConstants.actions.length) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppConstants.actions[index]),
        duration: AppConstants.kSnackBarDuration,
      ),
    );
  }

  Widget _executeAction(int? index) {
    if (!mounted || index == null) return const SizedBox.shrink();
    if (index < 0 || index >= AppConstants.actions.length) {
      return const SizedBox.shrink();
    }
    return Text(
      AppConstants.actions[index],
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppConstants.kPinterestRed,
        title: Text(
          'Pinterest Gesture Detector',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Stack(
        key: _stackKey,
        children: [
          if (_menuController.showMenu)
            Container(
              width: size.width,
              height: size.height,
              color: Colors.black87,
            ),
          GestureDetector(
            key: const ValueKey('gesture_detector'),
            onTapDown: _updateLongPressPosition,
            onLongPress: _handleLongPressStart,
            onLongPressMoveUpdate: _handleLongPressMoveUpdate,
            onLongPressEnd: _handleLongPressEnd,
            onLongPressCancel: _handleLongPressCancel,
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: ContentCard(showMenu: _menuController.showMenu),
            ),
          ),

          if (_menuController.showMenu) _buildMenu(),
          Positioned(
            left: size.width * 0.1,
            bottom: size.height * 0.1,
            child: Center(child: _executeAction(_menuController.selectedIndex)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return AnimatedBuilder(
      animation: _menuAnimationController,
      builder: (context, child) {
        return Positioned(
          left: _menuPosition.dx,
          top: _menuPosition.dy,
          child: IgnorePointer(
            ignoring: isAnimating,
            child: SizedBox(
              width: AppConstants.kMenuWidth,
              height: AppConstants.kMenuHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Top Button (Heart)
                  AnimatedMenuButton(
                    top: _selectedIndex == 0
                        ? AppConstants.kMenuOffset
                        : AppConstants.kMenuOffset * 2,
                    child: MenuButton(
                      icon: Icons.favorite_rounded,
                      isSelected: _selectedIndex == 0,
                    ),
                  ),
                  // Left Button (Share)
                  AnimatedMenuButton(
                    top: AppConstants.kSideButtonTop,
                    left: _selectedIndex == 1
                        ? AppConstants.kSideButtonSelectedOffset
                        : AppConstants.kSideButtonEdgeOffset,
                    child: MenuButton(
                      icon: Icons.share_rounded,
                      isSelected: _selectedIndex == 1,
                    ),
                  ),
                  // Right Button (Search)
                  AnimatedMenuButton(
                    top: AppConstants.kSideButtonTop,
                    right: _selectedIndex == 2
                        ? AppConstants.kSideButtonSelectedOffset
                        : AppConstants.kSideButtonEdgeOffset,
                    child: MenuButton(
                      icon: Icons.search_rounded,
                      isSelected: _selectedIndex == 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
