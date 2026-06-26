import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

class GhostButton extends StatefulWidget {
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
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.onSurface // Stark white on hover
              : Colors.transparent,
          borderRadius: BorderRadius.zero, // Sharp corners
          border: Border.all(
              color: _hovered ? AppColors.onSurface : AppColors.outline, 
              width: 1), // 1px border
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: _hovered ? AppColors.surface : AppColors.onSurface,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Sharp corners
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(widget.label.toUpperCase(), style: AppTypography.labelCaps),
            ],
          ),
        ),
      ),
    );
  }
}
