import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/scroll_provider.dart';
import '../../../providers/theme_provider.dart';

/// NavBar implements PreferredSizeWidget so it can be used directly in
/// Scaffold.appBar via PreferredSize — giving it a guaranteed fixed height
/// with zero overflow risk on any platform or first-frame timing.
class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  static const double navHeight = 80;

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
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) return;
      // localToGlobal gives position relative to screen; adding the current
      // scroll offset converts it to the document-absolute position.
      final absoluteOffset =
          box.localToGlobal(Offset.zero).dy + scrollController.offset;
      // Subtract 20px breathing room (nav height handled by Scaffold now).
      final targetOffset = (absoluteOffset - 20).clamp(0.0, double.infinity);
      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        height: navHeight,
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          border: Border(
            bottom: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),
        child: Stack(
          children: [
            // ── Nav content row ────────────────────────────────────
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context)
                      ? AppSpacing.md
                      : AppSpacing.xl,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Text(
                      '',
                      style: AppTypography.display.copyWith(
                        fontSize: 28, // Scaled down for nav
                        color: AppColors.onSurface,
                      ),
                    ),

                    if (Responsive.isDesktop(context))
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              ..._navItems.map((item) {
                                final isActive = activeSection == item.index;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppSpacing.lg),
                                  child: InkWell(
                                    onTap: () => scrollTo(item.index),
                                    borderRadius: BorderRadius.circular(4),
                                    child: AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      style: AppTypography.labelCaps.copyWith(
                                        color: isActive
                                            ? AppColors.tertiary
                                            : AppColors.onSurfaceVariant,
                                      ),
                                      child: Text(item.label.toUpperCase()),
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(width: AppSpacing.lg),
                              IconButton(
                                splashRadius: 24,
                                icon: Icon(
                                  ref.watch(isDarkModeProvider)
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                  color: AppColors.onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: () => ref
                                    .read(isDarkModeProvider.notifier)
                                    .update((s) => !s),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Mobile hamburger
                    if (!Responsive.isDesktop(context))
                      Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu,
                              color: AppColors.onSurface),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Scroll progress bar pinned to bottom ──────────────
            // Positioned widget is outside layout flow → zero overflow risk.
            Positioned(
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Scroll progress indicator drawn with CustomPainter — no Material widget,
// no internal minimum-height constraints.
// ─────────────────────────────────────────────────────────────────────────────
class _ScrollProgressBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);

    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        double progress = 0;
        if (scrollController.hasClients &&
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
      Paint()..color = AppColors.tertiary, // Updated to Gold
    );
  }

  @override
  bool shouldRepaint(_ProgressPainter old) => old.progress != progress;
}
