import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/links.dart';
import '../../../core/router/section_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/scroll_provider.dart';

class MobileDrawer extends ConsumerWidget {
  const MobileDrawer({super.key, this.activeOverride});

  /// Forces the highlighted item (case-study pages highlight "Projects").
  final int? activeOverride;

  static const _navItems = [
    (label: 'About', index: SectionIndex.about, icon: Icons.person_outline),
    (label: 'Projects', index: SectionIndex.projects, icon: Icons.work_outline),
    (label: 'Experience', index: SectionIndex.experience, icon: Icons.timeline),
    (label: 'Contact', index: SectionIndex.contact, icon: Icons.mail_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSection = activeOverride ?? ref.watch(activeSectionProvider);

    void navigate(int index) {
      // Capture everything before the drawer closes and this context unmounts.
      final container = ProviderScope.containerOf(context, listen: false);
      final router = GoRouter.of(context);

      Navigator.of(context).pop();

      Future.delayed(const Duration(milliseconds: 300), () {
        goToSection(container: container, router: router, index: index);
      });
    }

    return Drawer(
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Muhammad Saad Ahsan',
                      style: AppTypography.headlineMd
                          .copyWith(color: AppColors.onSurface),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.onSurfaceVariant),
                    tooltip: 'Close menu',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'FULL-STACK MOBILE ENGINEER',
                style: AppTypography.labelSm
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Nav items
              ..._navItems.asMap().entries.map((e) {
                final item = e.value;
                final isActive = activeSection == item.index ||
                    (item.index == SectionIndex.about &&
                        activeSection == SectionIndex.home);
                return _DrawerNavItem(
                  label: item.label,
                  icon: item.icon,
                  isActive: isActive,
                  onTap: () => navigate(item.index),
                  delay: Duration(milliseconds: e.key * 80),
                );
              }),

              const Spacer(),

              // Footer social links
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final link in Links.social)
                    _SocialLink(label: link.label, icon: link.icon, url: link.url),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                '© 2026 Built with Flutter',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  const _DrawerNavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.delay,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentWash : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isActive ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.accent : AppColors.onSurfaceVariant,
          size: 20,
        ),
        title: Text(
          label.toUpperCase(),
          style: AppTypography.labelCaps.copyWith(
            color: isActive ? AppColors.accent : AppColors.onSurface,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}

class _SocialLink extends StatelessWidget {
  const _SocialLink({required this.label, required this.icon, required this.url});
  final String label;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label.toUpperCase(),
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
