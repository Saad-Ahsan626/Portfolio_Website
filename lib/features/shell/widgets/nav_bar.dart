import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/scroll_provider.dart';

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  static const _navItems = [
    (label: 'About', index: SectionIndex.home),
    (label: 'Projects', index: SectionIndex.projects),
    (label: 'Experience', index: SectionIndex.experience),
    (label: 'Contact', index: SectionIndex.contact),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSection = ref.watch(activeSectionProvider);
    final scrollController = ref.watch(scrollControllerProvider);
    final sectionKeys = ref.watch(sectionKeysProvider);

    void scrollTo(int index) {
      final ctx = sectionKeys[index].currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.navBackground,
            border: Border(
              bottom: BorderSide(
                color: AppColors.outlineVariant.withOpacity(0.4),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isMobile(context)
                        ? AppSpacing.md
                        : AppSpacing.xl,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo / Name
                      Text(
                        'YourName.dev',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Nav links (desktop only)
                      if (Responsive.isDesktop(context))
                        Row(
                          children: _navItems.map((item) {
                            final isActive = activeSection == item.index;
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: AppSpacing.lg),
                              child: InkWell(
                                onTap: () => scrollTo(item.index),
                                borderRadius: BorderRadius.circular(4),
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: AppTypography.labelCaps.copyWith(
                                    color: isActive
                                        ? AppColors.electricCyan
                                        : AppColors.onSurfaceVariant,
                                  ),
                                  child: Text(item.label.toUpperCase()),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      // Mobile: hamburger (placeholder for Phase 1)
                      if (!Responsive.isDesktop(context))
                        Icon(
                          Icons.menu,
                          color: AppColors.onSurface,
                        ),
                    ],
                  ),
                ),
              ),

              // Scroll progress indicator (1px, primary color)
              _ScrollProgressBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollProgressBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);

    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        double progress = 0;
        if (scrollController.hasClients &&
            scrollController.position.maxScrollExtent > 0) {
          progress = scrollController.offset /
              scrollController.position.maxScrollExtent;
        }
        return LinearProgressIndicator(
          value: progress,
          minHeight: 1,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation(AppColors.electricCyan),
        );
      },
    );
  }
}
