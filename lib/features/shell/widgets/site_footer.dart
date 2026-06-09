import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  static const _links = [
    (label: 'GitHub', icon: Icons.terminal),
    (label: 'LinkedIn', icon: Icons.link_rounded),
    (label: 'Twitter', icon: Icons.alternate_email_rounded),
    (label: 'Email', icon: Icons.mail_outline_rounded),
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
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 1),
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
        // Wrap prevents overflow when viewport is between 768–1024px by
        // letting links flow onto a second line instead of hard-clipping.
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
      'YourName.dev',
      style: AppTypography.headlineMd.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _Links extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 0, // horizontal gap handled by each link's own padding
      runSpacing: AppSpacing.sm,
      children: SiteFooter._links
          .map(
            (link) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _FooterLink(label: link.label, icon: link.icon),
            ),
          )
          .toList(),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: AppTypography.labelCaps.copyWith(
          color: _hovered ? AppColors.electricCyan : AppColors.onSurfaceVariant,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 14,
              color: _hovered
                  ? AppColors.electricCyan
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}

class _Copyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2024 Flutter Developer Portfolio. Built with precision.',
      style: AppTypography.bodyMd.copyWith(
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
      ),
      textAlign: TextAlign.center,
    );
  }
}
