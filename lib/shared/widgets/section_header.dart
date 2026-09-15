import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import 'section_label.dart';

/// Eyebrow + Oswald title (+ optional italic subtitle) used to open sections.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
    this.titleMaxWidth,
  });

  final String label;
  final String title;
  final String? subtitle;

  /// Roughly the design's `max-width: 22ch` on some titles.
  final double? titleMaxWidth;

  static TextStyle titleStyle(BuildContext context) =>
      AppTypography.headlineLg.copyWith(
        fontSize: Responsive.fluid(context, min: 36, vw: 4, max: 48),
        color: AppColors.onSurface,
      );

  @override
  Widget build(BuildContext context) {
    Widget titleText = Text(title, style: titleStyle(context));
    if (titleMaxWidth != null) {
      titleText = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: titleMaxWidth!),
        child: titleText,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(label),
        const SizedBox(height: 8),
        titleText,
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              subtitle!,
              style: AppTypography.bodyLg
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ],
    );
  }
}

/// "Technical Toolkit ———————" style heading with a trailing hairline.
class RuledHeading extends StatelessWidget {
  const RuledHeading(this.text, {super.key, this.trailing, this.uppercase = false});

  final String text;
  final String? trailing;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Not Flexible: sharing flex space with the rule would stop the rule
        // halfway across.
        Text(
          uppercase ? text.toUpperCase() : text,
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(width: 24),
        Expanded(child: Container(height: 1, color: AppColors.divider)),
        if (trailing != null) ...[
          const SizedBox(width: 24),
          Text(
            trailing!,
            style: AppTypography.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
