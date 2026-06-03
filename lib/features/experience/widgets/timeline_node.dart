import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/experience_model.dart';
import 'timeline_connector.dart';

class TimelineNodeRow extends StatelessWidget {
  const TimelineNodeRow({
    super.key,
    required this.experience,
    required this.index,
    required this.isLast,
  });

  final ExperienceModel experience;
  final int index;
  final bool isLast;

  // Even index → card on RIGHT side; Odd → card on LEFT
  bool get _cardOnRight => index.isEven;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return isMobile
        ? _MobileRow(
            experience: experience,
            isLast: isLast,
            animDelay: Duration(milliseconds: index * 150),
          )
        : _DesktopRow(
            experience: experience,
            index: index,
            isLast: isLast,
            cardOnRight: _cardOnRight,
            animDelay: Duration(milliseconds: index * 150),
          );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop: centre-split alternating layout
// ─────────────────────────────────────────────────────────────────────────────
class _DesktopRow extends StatelessWidget {
  const _DesktopRow({
    required this.experience,
    required this.index,
    required this.isLast,
    required this.cardOnRight,
    required this.animDelay,
  });

  final ExperienceModel experience;
  final int index;
  final bool isLast;
  final bool cardOnRight;
  final Duration animDelay;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT half
          Expanded(
            child: cardOnRight
                // Date label on left when card is on right
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: AppSpacing.lg, top: AppSpacing.md),
                      child: Text(
                        experience.duration,
                        style: AppTypography.labelCaps.copyWith(
                          color: experience.isCurrent
                              ? AppColors.electricCyan
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                // Card on left
                : Padding(
                    padding: const EdgeInsets.only(
                        right: AppSpacing.lg, bottom: AppSpacing.xl),
                    child: _ExperienceCard(experience: experience)
                        .animate(delay: animDelay)
                        .fadeIn(duration: 500.ms)
                        .slideX(
                            begin: -0.1,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOut),
                  ),
          ),

          // Centre column: track + node
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Track above node (not for first item) — fixed height segment
              if (index > 0)
                SizedBox(
                  width: 2,
                  height: AppSpacing.md,
                  child: const TimelineTrack(),
                ),
              TimelineNode(isActive: experience.isCurrent),
              // Track below node fills remaining IntrinsicHeight space
              if (!isLast) Expanded(child: const TimelineTrack()),
            ],
          ),

          // RIGHT half
          Expanded(
            child: cardOnRight
                // Card on right
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: AppSpacing.lg, bottom: AppSpacing.xl),
                    child: _ExperienceCard(experience: experience)
                        .animate(delay: animDelay)
                        .fadeIn(duration: 500.ms)
                        .slideX(
                            begin: 0.1,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOut),
                  )
                // Date label on right when card is on left
                : Padding(
                    padding: const EdgeInsets.only(
                        left: AppSpacing.lg, top: AppSpacing.md),
                    child: Text(
                      experience.duration,
                      style: AppTypography.labelCaps.copyWith(
                        color: experience.isCurrent
                            ? AppColors.electricCyan
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile: left-rail single column
// ─────────────────────────────────────────────────────────────────────────────
class _MobileRow extends StatelessWidget {
  const _MobileRow({
    required this.experience,
    required this.isLast,
    required this.animDelay,
  });

  final ExperienceModel experience;
  final bool isLast;
  final Duration animDelay;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left rail: node + track
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TimelineNode(isActive: experience.isCurrent),
              if (!isLast) Expanded(child: const TimelineTrack()),
            ],
          ),

          const SizedBox(width: AppSpacing.md),

          // Card takes remaining width
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _ExperienceCard(experience: experience)
                  .animate(delay: animDelay)
                  .fadeIn(duration: 500.ms)
                  .slideX(
                      begin: 0.1,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOut),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Experience card
// ─────────────────────────────────────────────────────────────────────────────
class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({required this.experience});
  final ExperienceModel experience;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  IconData get _icon {
    return switch (widget.experience.icon) {
      'terminal' => Icons.terminal,
      'verified' => Icons.verified,
      'school' => Icons.school,
      'work' => Icons.work_outline_rounded,
      _ => Icons.circle_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xB31E293B),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(
                  color: _hovered
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + role row
                  Row(
                    children: [
                      Icon(
                        _icon,
                        size: 20,
                        color: widget.experience.isCurrent
                            ? AppColors.primary
                            : AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.experience.role,
                          style: AppTypography.headlineMd
                              .copyWith(color: AppColors.onSurface),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Company
                  Text(
                    widget.experience.company,
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Description
                  Text(
                    widget.experience.description,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),

                  // Tech tags (mobile only — desktop has more space)
                  if (widget.experience.techStack.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: widget.experience.techStack
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.base,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer
                                    .withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(
                                t.toUpperCase(),
                                style: AppTypography.labelCaps.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
