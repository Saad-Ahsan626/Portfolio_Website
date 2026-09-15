import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_icons.dart';
import '../../core/utils/responsive.dart';
import '../../shared/widgets/pulsing_dot.dart';
import '../../shared/widgets/reveal_on_scroll.dart';
import '../../shared/widgets/section_container.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/section_label.dart';
import 'widgets/toolkit_tile.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RevealOnScroll(id: 'about-panel', child: _AboutPanel()),
          SizedBox(height: 80),
          RevealOnScroll(id: 'toolkit', child: _Toolkit()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About Me — statement on the left, workspace photo with badge on the right
// ─────────────────────────────────────────────────────────────────────────────
class _AboutPanel extends StatelessWidget {
  const _AboutPanel();

  static const double _gap = 48;

  @override
  Widget build(BuildContext context) {
    final titleStyle = SectionHeader.titleStyle(context);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('About Me'),
        const SizedBox(height: 24),
        Text.rich(
          TextSpan(
            style: titleStyle,
            children: const [
              TextSpan(text: 'Architecting mobile products from '),
              TextSpan(
                text: 'interface to infrastructure',
                style: TextStyle(color: AppColors.accent),
              ),
              TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'I am a Full-Stack Mobile Engineer and Computer Science student at '
          'UET Lahore. I build production-ready Flutter apps with clean '
          'architecture and offline-first data, and design the secure, '
          'well-structured APIs behind them with TypeScript, NestJS and Prisma. '
          'Right now I\'m focused on system design: software that scales, stays '
          'reliable under load and remains easy to evolve. I\'m available for '
          'freelance projects and collaborations.',
          style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 320 * 2 + _gap;
        if (!twoColumns) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [text, const SizedBox(height: _gap), const _WorkspaceVisual()],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: text),
            const SizedBox(width: _gap),
            const Expanded(child: _WorkspaceVisual()),
          ],
        );
      },
    );
  }
}

class _WorkspaceVisual extends StatelessWidget {
  const _WorkspaceVisual();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 24px left/bottom inset leaves room for the badge.
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 24),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.tile,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(color: AppColors.hairline),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: Image.asset(
                  'assets/images/workspace.webp',
                  fit: BoxFit.cover,
                  semanticLabel: 'Workspace',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.badge,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.hairlineStrong),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PulsingDot(color: AppColors.onSurface, size: 10),
                const SizedBox(width: 12),
                Text(
                  'AVAILABLE FOR PROJECTS',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.onSurface,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Technical Toolkit — auto-fit minmax(140px, 1fr) square tiles
// ─────────────────────────────────────────────────────────────────────────────
class _Toolkit extends StatelessWidget {
  const _Toolkit();

  static const _items = [
    (label: 'Flutter', icon: BrandIcons.flutter),
    (label: 'Dart', icon: BrandIcons.dart),
    (label: 'TypeScript', icon: BrandIcons.typescript),
    (label: 'NestJS', icon: BrandIcons.nestjs),
    (label: 'Prisma', icon: BrandIcons.prisma),
    (label: 'Firebase', icon: BrandIcons.firebase),
  ];

  static const double _gap = 24;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const RuledHeading('Technical Toolkit'),
        const SizedBox(height: 48),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = Responsive.autoFitColumns(
              width: constraints.maxWidth,
              minItemWidth: 140,
              gap: _gap,
              itemCount: _items.length,
            );
            final itemWidth =
                (constraints.maxWidth - _gap * (columns - 1)) / columns;
            return Wrap(
              spacing: _gap,
              runSpacing: _gap,
              children: [
                for (final item in _items)
                  SizedBox(
                    width: itemWidth,
                    child: ToolkitTile(label: item.label, icon: item.icon),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
