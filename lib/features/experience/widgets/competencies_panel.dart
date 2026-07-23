import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';
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
              const _SkillsPanel(),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _VisualPanel()),
              const SizedBox(width: AppSpacing.lg),
              const Expanded(child: _SkillsPanel()),
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
            // Background Image
            Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
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
                      AppColors.background.withValues(alpha: 0.85),
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
    final skillsAsync = ref.watch(skillsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Core Competencies',
          style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: AppSpacing.md),

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
                  (e) => _SkillPill(label: e.value.name)
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
          label: 'View GitHub',
          icon: SimpleIcons.github,
          onPressed: () {
            launchUrl(Uri.parse('https://github.com/Saad-Ahsan626'));
          },
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

IconData _getIconForSkill(String label) {
  final lower = label.toLowerCase();
  if (lower.contains('flutter')) return SimpleIcons.flutter;
  if (lower.contains('dart')) return SimpleIcons.dart;
  if (lower.contains('python')) return SimpleIcons.python;
  if (lower.contains('firebase')) return SimpleIcons.firebase;
  if (lower.contains('mongo')) return SimpleIcons.mongodb;
  if (lower.contains('sql')) return SimpleIcons.mysql;
  if (lower.contains('github')) return SimpleIcons.github;
  if (lower.contains('git')) return SimpleIcons.git;
  if (lower.contains('ci/cd')) return SimpleIcons.githubactions;
  if (lower.contains('api') || lower.contains('gemini')) return SimpleIcons.googlegemini;
  if (lower.contains('mvvm') || lower.contains('architecture')) return Icons.architecture;
  if (lower.contains('riverpod') || lower.contains('cubit') || lower.contains('provider')) return Icons.layers_outlined;
  return Icons.check_circle_outline;
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForSkill(widget.label),
              size: 14,
              color: _hovered ? AppColors.electricCyan : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              widget.label,
              style: AppTypography.labelCaps.copyWith(
                color: _hovered ? AppColors.electricCyan : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
