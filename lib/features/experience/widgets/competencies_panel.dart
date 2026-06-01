import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/portfolio_provider.dart';

class CompetenciesPanel extends StatelessWidget {
  const CompetenciesPanel({super.key});


  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _VisualPanel(),
              const SizedBox(height: AppSpacing.lg),
              _SkillsPanel(),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _VisualPanel()),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _SkillsPanel()),
            ],
          );
  }
}

class _VisualPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: SizedBox(
        height: Responsive.isMobile(context) ? 220 : 340,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient placeholder (replace with Image.network if you have an asset)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceContainerHigh,
                    AppColors.midnightNavy,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.code_rounded,
                  size: 80,
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
            ),

            // Gradient overlay from bottom
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withOpacity(0.85),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),

            // "Always building." label
            Positioned(
              bottom: AppSpacing.md,
              left: AppSpacing.md,
              child: Text(
                'Always building.',
                style: AppTypography.headlineMd.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.1, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}

class _SkillsPanel extends ConsumerWidget {
  const _SkillsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── NEW: Watch the provider ──
    final skillsAsync = ref.watch(skillsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Core Competencies',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── NEW: Handle async states ──
        skillsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.electricCyan),
          ),
          error: (e, _) => Text(
            'Failed to load skills.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.error),
          ),
          data: (skills) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: skills
                .asMap()
                .entries
                .map(
                  (e) => _SkillPill(label: e.value.name) // Use .name from SkillModel
                      .animate(delay: Duration(milliseconds: 200 + e.key * 60))
                      .fadeIn(duration: 300.ms)
                      .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 300.ms,
                          curve: Curves.easeOut),
                )
                .toList(),
          ),
        ),

        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'Download Full Resume',
          icon: Icons.download_rounded,
          onPressed: () {},
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(
        begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}

class _SkillPill extends StatefulWidget {
  const _SkillPill({required this.label});
  final String label;

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: _hovered ? AppColors.electricCyan : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: AppTypography.labelCaps.copyWith(
            color: _hovered ? AppColors.electricCyan : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
