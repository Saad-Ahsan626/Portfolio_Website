import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/links.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/brand_icons.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../shared/widgets/primary_button.dart';

class CompetenciesPanel extends StatelessWidget {
  const CompetenciesPanel({super.key});

  static const double _gap = 48;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Design grid: auto-fit minmax(320px, 1fr) with a 48px gap.
        final twoColumns = constraints.maxWidth >= 320 * 2 + _gap;
        if (!twoColumns) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _VisualPanel(height: 280),
              SizedBox(height: _gap),
              _SkillsPanel(),
            ],
          );
        }
        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _VisualPanel(height: 340)),
            SizedBox(width: _gap),
            Expanded(child: _SkillsPanel()),
          ],
        );
      },
    );
  }
}

class _VisualPanel extends StatelessWidget {
  const _VisualPanel({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.webp',
            fit: BoxFit.cover,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xD909090B)],
                stops: [0.4, 1.0],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Text(
              'Always building.',
              style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
            ),
          ),
        ],
      ),
    );
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
          loading: () => const SizedBox(height: 120),
          error: (_, __) => Text(
            'Skills couldn\'t be loaded.',
            style: AppTypography.bodyMd.copyWith(color: AppColors.error),
          ),
          data: (skills) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final skill in skills) _SkillPill(label: skill.name),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: 'View GitHub',
          icon: BrandIcons.github,
          onPressed: () => launchUrl(Uri.parse(Links.github)),
        ),
      ],
    );
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
    final color = _hovered ? AppColors.accent : AppColors.onSurface;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: _hovered ? AppColors.accent : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          widget.label.toUpperCase(),
          style: AppTypography.labelCaps.copyWith(color: color, height: 1.4),
        ),
      ),
    );
  }
}
