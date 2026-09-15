import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/links.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/hover_link.dart';
import '../../../shared/widgets/section_container.dart';

/// Full-width footer. [compact] is the slimmer case-study variant.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final name = Text(
      'MUHAMMAD SAAD AHSAN',
      textAlign: TextAlign.center,
      style: compact
          ? AppTypography.labelCaps.copyWith(color: AppColors.onSurface)
          : AppTypography.headlineMd.copyWith(
              fontSize: 32,
              letterSpacing: -0.02 * 32,
              color: AppColors.onSurface,
            ),
    );

    final links = Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 12,
      children: [
        for (final link in Links.social)
          HoverLink(
            onTap: () => launchUrl(Uri.parse(link.url)),
            builder: (context, color, _) => Text(
              link.label.toUpperCase(),
              style: AppTypography.labelCaps.copyWith(color: color),
            ),
          ),
      ],
    );

    final copyright = Text(
      '© 2026. ALL RIGHTS RESERVED.',
      textAlign: TextAlign.center,
      style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: compact ? 48 : 80),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: compact
              ? const BorderSide(color: AppColors.divider)
              : const BorderSide(color: AppColors.outline, width: 2),
        ),
      ),
      // Same 1200px column + side padding as the sections, so the footer
      // lines up with the content above it.
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SectionContainer.horizontalPadding(context),
            ),
            child: isMobile
              ? Column(
                  children: [
                    name,
                    const SizedBox(height: 32),
                    links,
                    const SizedBox(height: 32),
                    copyright,
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    name,
                    const SizedBox(width: 48),
                    Flexible(child: links),
                    const SizedBox(width: 48),
                    copyright,
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
