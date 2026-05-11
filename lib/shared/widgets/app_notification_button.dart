import 'package:flutter/material.dart';

class AppNotificationButton extends StatelessWidget {
  final double size;
  final BorderRadius borderRadius;
  final Color badgeColor;
  final IconData icon;

  const AppNotificationButton({
    super.key,
    this.size = 42,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.badgeColor = const Color(0xFFFF6B6B),
    this.icon = Icons.notifications_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          Center(child: Icon(icon, color: Colors.white, size: 24)),
          Positioned(
            top: 8,
            right: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
