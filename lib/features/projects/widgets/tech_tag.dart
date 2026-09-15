import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Small uppercase technology chip used on project and experience cards.
class TechTag extends StatelessWidget {
  const TechTag(this.label, {super.key, this.subtle = false});

  final String label;

  /// Lighter background and 10px type, as on experience cards.
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: subtle ? AppColors.tagSubtle : AppColors.tag,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.labelSm.copyWith(
          color: AppColors.onSurfaceVariant,
          fontSize: subtle ? 10 : 11,
          letterSpacing: (subtle ? 10 : 11) * 0.2,
          height: 1.3,
        ),
      ),
    );
  }
}
