import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/scroll_provider.dart';

class MobileDrawer extends ConsumerWidget {
  const MobileDrawer({super.key});

  static const _navItems = [
    (label: 'About', index: SectionIndex.home, icon: Icons.person_outline),
    (label: 'Projects', index: SectionIndex.projects, icon: Icons.work_outline),
    (label: 'Experience', index: SectionIndex.experience, icon: Icons.timeline),
    (label: 'Contact', index: SectionIndex.contact, icon: Icons.mail_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSection = ref.watch(activeSectionProvider);
    final sectionKeys = ref.watch(sectionKeysProvider);

    void scrollTo(int index) {
      Navigator.of(context).pop(); // close drawer first
      Future.delayed(const Duration(milliseconds: 300), () {
        final ctx = sectionKeys[index].currentContext;
        if (ctx == null) return;
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Drawer(
          backgroundColor: AppColors.navBackground,
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
                      Text(
                        'YourName.dev',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppColors.onSurfaceVariant),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Nav items
                  ..._navItems.asMap().entries.map((e) {
                    final item = e.value;
                    final isActive = activeSection == item.index;
                    return _DrawerNavItem(
                      label: item.label,
                      icon: item.icon,
                      isActive: isActive,
                      onTap: () => scrollTo(item.index),
                      delay: Duration(milliseconds: e.key * 80),
                    );
                  }),

                  const Spacer(),

                  // Footer social links
                  Wrap(
                    spacing: AppSpacing.md,
                    children: [
                      _SocialLink(label: 'GitHub', icon: Icons.terminal),
                      _SocialLink(label: 'LinkedIn', icon: Icons.link_rounded),
                      _SocialLink(label: 'Email', icon: Icons.mail_outline),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    '© 2024 Built with Flutter',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
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
        color: isActive
            ? AppColors.electricCyan.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isActive
              ? AppColors.electricCyan.withOpacity(0.3)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.electricCyan : AppColors.onSurfaceVariant,
          size: 20,
        ),
        title: Text(
          label.toUpperCase(),
          style: AppTypography.labelCaps.copyWith(
            color: isActive ? AppColors.electricCyan : AppColors.onSurface,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}

class _SocialLink extends StatelessWidget {
  const _SocialLink({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
