import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio/features/home/widgets/typing_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';
import "../../providers/scroll_provider.dart";

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    final horizontalPadding = isDesktop
        ? AppSpacing.xl
        : isMobile
            ? AppSpacing.md
            : AppSpacing.lg;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSpacing.containerMax),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),
            _HeroRow(
              isMobile: isMobile,
              isDesktop: isDesktop,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _HeroRow extends StatelessWidget {
  const _HeroRow({required this.isMobile, required this.isDesktop});

  final bool isMobile;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final content = _HeroContent(isMobile: isMobile);
    final visual = _HeroVisualRight(isMobile: isMobile);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          content,
          const SizedBox(height: AppSpacing.xl),
          visual,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: content),
        const SizedBox(width: AppSpacing.xl),
        Expanded(flex: 5, child: visual),
      ],
    );
  }
}

class _HeroContent extends ConsumerWidget {
  const _HeroContent({this.isMobile = false});
  final bool isMobile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void scrollTo(int index) {
      final sectionKeys = ref.read(sectionKeysProvider);
      final scrollController = ref.read(scrollControllerProvider);
      final ctx = sectionKeys[index].currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) return;

      final appBarHeight = Responsive.isMobile(context) ? 60.0 : 80.0;
      final absoluteOffset =
          (box.localToGlobal(Offset.zero).dy - appBarHeight) +
              scrollController.offset;
      final targetOffset = (absoluteOffset - 20)
          .clamp(0.0, scrollController.position.maxScrollExtent);
      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),

        // Dynamic Hero Header
        Text(
          "I BUILD",
          style: AppTypography.display
              .copyWith(color: AppColors.onSurfaceVariant, fontSize: 48),
        ).animate().fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),

        // Typing animation for professional roles
        const TypingText(
          texts: [
            "MOBILE EXPERIENCES.",
            "AI SOLUTIONS.",
            "FULL-STACK APPLICATIONS.",
            "SCALABLE ARCHITECTURE.",
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        // Professional Summary
        Text(
          "I am Muhammad Saad Ahsan, a Flutter Developer specializing in high-performance cross-platform apps and intelligent AI solutions.",
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurface,
          ),
        ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

        const SizedBox(height: AppSpacing.xl),

        // Action Buttons
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              PrimaryButton(
                label: 'View Projects',
                icon: Icons.work_outline,
                onPressed: () {
                  scrollTo(SectionIndex.projects);
                },
              ),
              const SizedBox(width: AppSpacing.md),
              GhostButton(
                label: 'Contact Me',
                icon: Icons.mail_outline,
                onPressed: () {
                  scrollTo(SectionIndex.contact);
                },
              ),
            ],
          ),
        ).animate(delay: 600.ms).fadeIn(duration: 400.ms).slideY(
            begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut),
      ],
    );
  }
}

class _HeroVisualRight extends StatefulWidget {
  const _HeroVisualRight({required this.isMobile});
  final bool isMobile;

  @override
  State<_HeroVisualRight> createState() => _HeroVisualRightState();
}

class _HeroVisualRightState extends State<_HeroVisualRight> {
  bool _hovered = false;

  bool get isMobile => widget.isMobile;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMobile ? Alignment.center : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 380,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top tracking text
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                'FLUTTER DEVELOPER • AVAILABLE FOR HIRE',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Portrait Image — gold frame + soft glow on hover
            MouseRegion(
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    border: Border.all(
                      color: _hovered
                          ? AppColors.tertiary
                          : AppColors.outlineVariant,
                      width: 1,
                    ),
                    boxShadow: _hovered
                        ? [
                            BoxShadow(
                              color:
                                  AppColors.tertiary.withValues(alpha: 0.18),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : const [],
                  ),
                  child: Image.asset(
                    'assets/images/saad.jpg',
                    fit: BoxFit.cover,
                    alignment:
                        Alignment.topCenter, // Usually better for portraits
                  ),
                ),
              ),
            ),
          ],
        ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
      ),
    );
  }
}
