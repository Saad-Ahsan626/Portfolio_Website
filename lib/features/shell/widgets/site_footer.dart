import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  static const _links = [
    (
      label: 'GitHub',
      icon: Icons.terminal,
      url: 'https://github.com/Saad-Ahsan626'
    ),
    (
      label: 'LinkedIn',
      icon: Icons.link_rounded,
      url: 'https://www.linkedin.com/in/saad-ahsan-55201336a/'
    ),
    (
      label: 'Email',
      icon: Icons.mail_outline_rounded,
      url: 'mailto:saadahsan039@gmail.com'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface, // Stark black
        border: Border(
          top: BorderSide(
              color: AppColors.outline, width: 2), // Sharp thick border
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.containerMax),
        child: isMobile ? _MobileFooter() : _DesktopFooter(),
      ),
    );
  }
}

class _DesktopFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Logo(),
        Flexible(child: _Links()),
        _Copyright(),
      ],
    );
  }
}

class _MobileFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Logo(),
        const SizedBox(height: AppSpacing.lg),
        _Links(),
        const SizedBox(height: AppSpacing.lg),
        _Copyright(),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'MUHAMMAD SAAD AHSAN', // Brutalist short name
      style: AppTypography.display.copyWith(
        fontSize: 32, // Slightly smaller display font for footer
        color: AppColors.onSurface,
      ),
    );
  }
}

class _Links extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0,
      runSpacing: AppSpacing.sm,
      children: SiteFooter._links
          .map(
            (link) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _FooterLink(
                  label: link.label, icon: link.icon, url: link.url),
            ),
          )
          .toList(),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink(
      {required this.label, required this.icon, required this.url});
  final String label;
  final IconData icon;
  final String url;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 100), // snappy
            style: AppTypography.labelCaps.copyWith(
              color: _hovered
                  ? AppColors.tertiary // Gold
                  : AppColors.onSurface,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 14,
                  color: _hovered ? AppColors.tertiary : AppColors.onSurface,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(widget.label.toUpperCase()), // Ensure uppercase
              ],
            ),
          ),
        ));
  }
}

class _Copyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2026. ALL RIGHTS RESERVED.',
      style: AppTypography.labelCaps.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }
}
