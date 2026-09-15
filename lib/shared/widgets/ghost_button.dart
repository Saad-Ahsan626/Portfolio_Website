import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Outlined white button whose border and label turn gold on hover/focus.
class GhostButton extends StatelessWidget {
  const GhostButton({
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
    bool highlighted(Set<WidgetState> states) =>
        states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused);

    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 36, vertical: 20),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => highlighted(states) ? AppColors.accent : AppColors.onSurface,
        ),
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
            color: highlighted(states) ? AppColors.accent : AppColors.outline,
          ),
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 8),
            ],
            Text(label.toUpperCase(), style: AppTypography.labelCaps),
          ],
        ),
      ),
    );
  }
}
