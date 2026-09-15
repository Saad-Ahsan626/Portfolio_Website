import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/hover_card.dart';
import '../../projects/widgets/tech_tag.dart';

/// Left-rail timeline shared by every breakpoint: a 2px rail with hollow gold
/// nodes, a date column and a card.
class ExperienceTimeline extends StatelessWidget {
  const ExperienceTimeline({super.key, required this.children});

  final List<Widget> children;

  static const double nodeSize = 14;
  static const double itemGap = 48;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Rail: centred on the nodes, inset 8px top and bottom.
        const Positioned(
          left: (nodeSize - 2) / 2,
          top: 8,
          bottom: 8,
          width: 2,
          child: ColoredBox(color: AppColors.outlineVariant),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, child) in children.indexed) ...[
              if (index > 0) const SizedBox(height: itemGap),
              child,
            ],
          ],
        ),
      ],
    );
  }
}

/// One node on the timeline: date on the left, card on the right. Used for
/// both work experience and education.
class TimelineEntry extends StatelessWidget {
  const TimelineEntry({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.description,
    this.tags = const [],
  });

  /// Role or degree.
  final String title;

  /// Company or institution.
  final String subtitle;
  final String duration;
  final String description;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final date = Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        duration.toUpperCase(),
        style: AppTypography.labelCaps.copyWith(
          color: AppColors.accent,
          height: 1.5,
        ),
      ),
    );

    final card = _TimelineCard(
      title: title,
      subtitle: subtitle,
      description: description,
      tags: tags,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: _Node(),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Design: auto-fit minmax(200px) with the card spanning two
              // tracks — three tracks fit from 648px, otherwise they stack.
              if (constraints.maxWidth >= 648) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: date),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: card),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [date, const SizedBox(height: 16), card],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Node extends StatelessWidget {
  const _Node();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ExperienceTimeline.nodeSize,
      height: ExperienceTimeline.nodeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.accentRing, spreadRadius: 4),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
  });

  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle.toUpperCase(),
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final tag in tags) TechTag(tag, subtle: true),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
