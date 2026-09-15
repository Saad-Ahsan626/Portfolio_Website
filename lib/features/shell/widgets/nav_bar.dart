import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/section_navigation.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/scroll_provider.dart';
import '../../../shared/widgets/hover_link.dart';
import '../../../shared/widgets/section_container.dart';

/// Sticky top bar shared by the one-page shell and the case-study pages.
class NavBar extends ConsumerWidget {
  const NavBar({
    super.key,
    this.activeOverride,
    this.showProgress = true,
  });

  /// Forces the highlighted item (case-study pages highlight "Projects").
  final int? activeOverride;
  final bool showProgress;

  static const double navHeight = 72;
  static const double navHeightMobile = 64;

  static double heightFor(BuildContext context) =>
      Responsive.isMobile(context) ? navHeightMobile : navHeight;

  // The hero introduces Saad, so "About" stays lit from the top of the page
  // down through the About section.
  static const _navItems = [
    (label: 'About', target: SectionIndex.about, activeFor: {SectionIndex.home, SectionIndex.about}),
    (label: 'Projects', target: SectionIndex.projects, activeFor: {SectionIndex.projects}),
    (label: 'Experience', target: SectionIndex.experience, activeFor: {SectionIndex.experience}),
    (label: 'Contact', target: SectionIndex.contact, activeFor: {SectionIndex.contact}),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSection = activeOverride ?? ref.watch(activeSectionProvider);

    return Material(
      color: AppColors.background,
      child: Container(
        height: heightFor(context),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SectionContainer.horizontalPadding(context),
                    ),
                    child: Row(
                      children: [
                        _NavLogo(onTap: () => _goHome(context)),
                        const Spacer(),
                        if (Responsive.isDesktop(context))
                          Row(
                            children: [
                              for (final item in _navItems)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: Responsive.fluid(context,
                                        min: 16, vw: 3, max: 40),
                                  ),
                                  child: _NavItem(
                                    label: item.label,
                                    isActive:
                                        item.activeFor.contains(activeSection),
                                    onTap: () =>
                                        context.goToSection(item.target),
                                  ),
                                ),
                            ],
                          )
                        else
                          Builder(
                            builder: (ctx) => IconButton(
                              icon: const Icon(Icons.menu,
                                  color: AppColors.onSurface),
                              tooltip: 'Open navigation menu',
                              onPressed: () => Scaffold.of(ctx).openDrawer(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Scroll progress bar pinned to the bottom edge ──
            if (showProgress)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _ScrollProgressBar(),
              ),
          ],
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.state.uri.path == AppRoutes.home) {
      context.goToSection(SectionIndex.home);
    } else {
      router.go(AppRoutes.home);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo — "SAAD.AHSAN", gold on hover, back to top
// ─────────────────────────────────────────────────────────────────────────────
class _NavLogo extends StatelessWidget {
  const _NavLogo({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.headlineMd.copyWith(
      fontSize: 22,
      letterSpacing: 0.07 * 22,
      height: 1,
    );
    return HoverLink(
      onTap: onTap,
      semanticLabel: 'Back to top',
      builder: (context, color, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('SAAD', style: style.copyWith(color: color)),
          Text('.AHSAN', style: style.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav item — gold label with a full-width 2px underline when active
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverLink(
      onTap: onTap,
      color: isActive ? AppColors.accent : AppColors.onSurfaceVariant,
      builder: (context, color, _) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.only(top: 6, bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.labelCaps.copyWith(color: color),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scroll progress indicator drawn with CustomPainter — no Material widget,
// no internal minimum-height constraints.
// ─────────────────────────────────────────────────────────────────────────────
class _ScrollProgressBar extends ConsumerWidget {
  const _ScrollProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);

    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        double progress = 0;
        if (scrollController.hasClients &&
            scrollController.positions.length == 1 &&
            scrollController.position.hasPixels &&
            scrollController.position.hasContentDimensions &&
            scrollController.position.maxScrollExtent > 0) {
          progress = (scrollController.offset /
                  scrollController.position.maxScrollExtent)
              .clamp(0.0, 1.0);
        }
        return CustomPaint(
          size: const Size(double.infinity, 2),
          painter: _ProgressPainter(progress: progress),
        );
      },
    );
  }
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * progress, size.height),
      Paint()..color = AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter old) => old.progress != progress;
}
