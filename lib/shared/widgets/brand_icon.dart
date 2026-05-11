import 'package:flutter/material.dart';

enum BrandIconType {
  upwork,
  avatar,
  paypal,
  youtube,
  electricity,
  house,
  spotify,
}

BrandIconType brandIconTypeFromKey(String key) {
  return switch (key.toLowerCase()) {
    'upwork' => BrandIconType.upwork,
    'paypal' => BrandIconType.paypal,
    'youtube' || 'netflix' => BrandIconType.youtube,
    'electricity' => BrandIconType.electricity,
    'house' => BrandIconType.house,
    'spotify' => BrandIconType.spotify,
    _ => BrandIconType.avatar,
  };
}

String brandIconKeyFromName(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('upwork')) return 'upwork';
  if (lower.contains('paypal')) return 'paypal';
  if (lower.contains('youtube') || lower.contains('netflix')) return 'youtube';
  if (lower.contains('electric')) return 'electricity';
  if (lower.contains('house') || lower.contains('rent')) return 'house';
  if (lower.contains('spotify')) return 'spotify';
  return 'avatar';
}

class BrandIcon extends StatelessWidget {
  final BrandIconType type;
  final double size;

  const BrandIcon({super.key, required this.type, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      BrandIconType.upwork => _IconBox(
        size: size,
        color: const Color(0xFF6FDA44),
        child: const Text(
          'Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      BrandIconType.avatar => _IconBox(
        size: size,
        color: const Color(0xFFE8E8E8),
        child: const Icon(Icons.person, color: Color(0xFF888888), size: 24),
      ),
      BrandIconType.paypal => _IconBox(
        size: size,
        color: const Color(0xFF003087),
        child: const Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      BrandIconType.youtube => _IconBox(
        size: size,
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        child: const Icon(
          Icons.play_circle_fill,
          color: Color(0xFFFF0000),
          size: 26,
        ),
      ),
      BrandIconType.electricity => _IconBox(
        size: size,
        color: const Color(0xFFFFF3E0),
        child: const Icon(Icons.bolt, color: Color(0xFFFF9800), size: 26),
      ),
      BrandIconType.house => _IconBox(
        size: size,
        color: const Color(0xFFE3F2FD),
        child: const Icon(Icons.home, color: Color(0xFF1976D2), size: 24),
      ),
      BrandIconType.spotify => _IconBox(
        size: size,
        color: const Color(0xFF1DB954),
        child: const Icon(Icons.music_note, color: Colors.white, size: 24),
      ),
    };
  }
}

class _IconBox extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;
  final BoxBorder? border;

  const _IconBox({
    required this.size,
    required this.color,
    required this.child,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: border,
      ),
      child: Center(child: child),
    );
  }
}
