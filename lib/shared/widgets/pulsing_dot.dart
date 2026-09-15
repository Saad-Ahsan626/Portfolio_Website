import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Dot that breathes between 80% and 120% scale — the design's `pulse`.
class PulsingDot extends StatelessWidget {
  const PulsingDot({super.key, required this.color, this.size = 8});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 0.8, end: 1.2, duration: 800.ms, curve: Curves.easeInOut)
        .fade(begin: 0.6, end: 1, duration: 800.ms, curve: Curves.easeInOut);
  }
}
