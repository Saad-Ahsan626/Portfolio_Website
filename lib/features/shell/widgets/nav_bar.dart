import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../providers/scroll_provider.dart';

/// NavBar implements PreferredSizeWidget so it can be used directly in
/// Scaffold.appBar via PreferredSize — giving it a guaranteed fixed height
/// with zero overflow risk on any platform or first-frame timing.
class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  static const double navHeight = 80;
  static const double navHeightMobile = 60;

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
    final isMobile = Responsive.isMobile(context);

    void scrollTo(int index) {
      final ctx = sectionKeys[index].currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) return;
      final appBarHeight = isMobile ? navHeightMobile : navHeight;
      final absoluteOffset =
          (box.localToGlobal(Offset.zero).dy - appBarHeight) +
              scrollController.offset;
      // Subtract 20px breathing room.
      final targetOffset = (absoluteOffset - 20)
          .clamp(0.0, scrollController.position.maxScrollExtent);
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
        height: isMobile ? navHeightMobile : navHeight,
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
                  horizontal: isMobile ? AppSpacing.md : AppSpacing.xl,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo — scrolls back to top
                    _NavLogo(onTap: () => scrollTo(SectionIndex.home)),

                    if (Responsive.isDesktop(context))
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              ..._navItems.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppSpacing.lg),
                                  child: _NavItem(
                                    label: item.label,
                                    isActive: activeSection == item.index,
                                    onTap: () => scrollTo(item.index),
                                  ),
                                );
                              }),
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
                          tooltip: 'Open navigation menu',
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
// Logo — name with gold accent dot, clickable back-to-top
// ─────────────────────────────────────────────────────────────────────────────
class _NavLogo extends StatefulWidget {
  const _NavLogo({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_NavLogo> createState() => _NavLogoState();
}

class _NavLogoState extends State<_NavLogo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Semantics(
          button: true,
          label: 'Back to top',
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTypography.display.copyWith(
              fontSize: 22,
              letterSpacing: 1.5,
              color: _hovered ? AppColors.tertiary : AppColors.onSurface,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('SAAD'),
                Text(
                  '.AHSAN',
                  style: AppTypography.display.copyWith(
                    fontSize: 22,
                    letterSpacing: 1.5,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav item — label with animated gold indicator bar (hover + active)
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.isActive || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTypography.labelCaps.copyWith(
                  color: highlighted
                      ? AppColors.tertiary
                      : AppColors.onSurfaceVariant,
                ),
                child: Text(widget.label.toUpperCase()),
              ),
              const SizedBox(height: 4),
              // Indicator bar grows from the left on hover/active.
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                height: 2,
                width: highlighted ? 20 : 0,
                color: AppColors.tertiary,
              ),
            ],
          ),
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
