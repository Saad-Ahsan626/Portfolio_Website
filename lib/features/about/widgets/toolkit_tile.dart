import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/hover_card.dart';

/// Square Technical Toolkit tile: icon over an uppercase label.
class ToolkitTile extends StatelessWidget {
  const ToolkitTile({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: HoverCard(
        color: AppColors.tile,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: AppColors.onSurface),
            const SizedBox(height: 12),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.onSurface,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
