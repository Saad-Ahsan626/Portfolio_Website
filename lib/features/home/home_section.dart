import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';

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

class _HeroContent extends StatelessWidget {
  const _HeroContent({this.isMobile = false});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.md),

        // Massive Brutalist Text
        Text(
          "HEY, I'M",
          style: AppTypography.display.copyWith(color: AppColors.onSurface),
          textAlign: TextAlign.left,
        )
            .animate(delay: 100.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0),

        // Text inside a white box (Inverted)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            "MUHAMMAD SAAD AHSAN",
            style: AppTypography.display.copyWith(
              color: AppColors.onSurface,
              height: 1.1,
            ),
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.1, end: 0),

        const SizedBox(height: AppSpacing.xl),

        // Thick White Divider
        Container(
          height: 6,
          color: AppColors.onSurface,
          width: double.infinity,
        )
            .animate(delay: 300.ms)
            .scaleX(alignment: Alignment.centerLeft, duration: 400.ms),

        const SizedBox(height: AppSpacing.lg),

        // Italic Subheading
        Text(
          'I AM A FLUTTER DEVELOPER',
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

        const SizedBox(height: AppSpacing.xl),

        // Social Links Vertical List
        _SocialLinks(),

        const SizedBox(height: AppSpacing.xl),

        // Action Buttons
      ],
    );
  }
}

class _SocialLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [],
    ).animate(delay: 500.ms).fadeIn(duration: 400.ms);
  }
}

class _HeroVisualRight extends StatelessWidget {
  const _HeroVisualRight({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            textAlign: TextAlign.right,
          ),
        ),

        // Portrait Image
        Align(
          alignment: isMobile ? Alignment.center : Alignment.centerRight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 380, // Much smaller professional size
              maxHeight: 480,
            ),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(
                      color: AppColors.outlineVariant,
                      width: 1), // Subtle sharp border
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
        ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
      ],
    );
  }
}
