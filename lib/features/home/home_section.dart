import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/router/section_navigation.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../providers/scroll_provider.dart';
import '../../shared/widgets/ghost_button.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_container.dart';
import 'widgets/typing_text.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = Responsive.fluid(context, min: 40, vw: 5, max: 80);
    final vertical = Responsive.fluid(context, min: 56, vw: 7, max: 100);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SectionContainer.horizontalPadding(context),
        vertical: vertical,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Design grid: repeat(auto-fit, minmax(340px, 1fr)).
          final twoColumns = constraints.maxWidth >= 340 * 2 + gap;

          const content = _HeroContent();
          const visual = _HeroVisual();

          if (!twoColumns) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                SizedBox(height: gap),
                const Align(alignment: Alignment.center, child: visual),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: content),
              SizedBox(width: gap),
              const Expanded(
                child: Align(alignment: Alignment.topRight, child: visual),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent();

  static const _roles = [
    'MOBILE EXPERIENCES.',
    'SCALABLE BACKENDS.',
    'FULL-STACK PRODUCTS.',
    'RESILIENT SYSTEMS.',
  ];

  @override
  Widget build(BuildContext context) {
    final blockGap = Responsive.fluid(context, min: 32, vw: 4, max: 56);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I BUILD',
          style: AppTypography.headlineLg.copyWith(
            fontSize: Responsive.fluid(context, min: 40, vw: 4.4, max: 56),
            height: 1,
            letterSpacing: -0.02 * 56,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TypingText(
          texts: _roles,
          style: AppTypography.headlineLg.copyWith(
            fontSize: Responsive.fluid(context, min: 40, vw: 5.2, max: 68),
            height: 1,
            letterSpacing: -0.02 * 68,
            color: AppColors.accent,
          ),
        ),
        SizedBox(height: blockGap),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(
            'I am Muhammad Saad Ahsan, a Full-Stack Mobile Engineer building '
            'scalable products, from intuitive Flutter interfaces to resilient '
            'backend systems.',
            style: AppTypography.bodyLg.copyWith(color: AppColors.onSurface),
          ),
        ),
        SizedBox(height: blockGap),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            PrimaryButton(
              label: 'View Projects',
              onPressed: () => context.goToSection(SectionIndex.projects),
            ),
            GhostButton(
              label: 'Contact Me',
              onPressed: () => context.goToSection(SectionIndex.contact),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut).slideY(
        begin: 0.05, end: 0, duration: 600.ms, curve: Curves.easeOut);
  }
}

class _HeroVisual extends StatefulWidget {
  const _HeroVisual();

  @override
  State<_HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<_HeroVisual> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MOBILE + BACKEND • OPEN TO FREELANCE',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Portrait — gold frame + soft glow on hover
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
                    color: _hovered ? AppColors.accent : AppColors.outlineVariant,
                  ),
                  boxShadow: _hovered
                      ? const [
                          BoxShadow(
                            color: AppColors.accentGlow,
                            blurRadius: 32,
                            offset: Offset(0, 8),
                          ),
                        ]
                      : const [],
                ),
                child: Image.asset(
                  'assets/images/saad.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  semanticLabel: 'Portrait of Muhammad Saad Ahsan',
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: 300.ms)
        .fadeIn(duration: 800.ms, curve: Curves.easeOut)
        .slideY(begin: 0.05, end: 0, duration: 800.ms, curve: Curves.easeOut);
  }
}
