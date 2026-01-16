import 'package:flutter/material.dart';

/// A reusable animated button for the menu.
class MenuButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const MenuButton({super.key, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween<double>(begin: 1.0, end: isSelected ? 1.15 : 1.0),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: isSelected ? scale : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : Colors.grey.shade800,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.grey.shade800 : Colors.white,
              size: 26,
            ),
          ),
        );
      },
    );
  }
}
