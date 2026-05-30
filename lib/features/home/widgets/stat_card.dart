import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.delay = Duration.zero,
  });

  final String value;
  final String label;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.electricCyan,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label.toUpperCase(),
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    )
        .animate(delay: delay)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}
