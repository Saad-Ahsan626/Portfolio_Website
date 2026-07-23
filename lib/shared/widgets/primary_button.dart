import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.onSurface, // Stark white
        foregroundColor: AppColors.surface, // Pure black text
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Sharp corners
        ),
        elevation: 0,
      ).copyWith(
        // Gold sweep on hover/focus, subtle press feedback — 200ms built-in.
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return AppColors.tertiary;
          }
          return AppColors.onSurface;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.black.withValues(alpha: 0.12);
          }
          return Colors.transparent;
        }),
      ),
      // FittedBox lets the label scale down instead of striping with a
      // RenderFlex overflow when the button is squeezed below its
      // intrinsic width (e.g. half-width panels on tablet).
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label.toUpperCase(), style: AppTypography.labelCaps),
          ],
        ),
      ),
    );
  }
}
