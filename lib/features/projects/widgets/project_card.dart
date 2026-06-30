import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/project_model.dart';
import 'phone_mockup.dart';
import 'tech_tag.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.animationDelay = Duration.zero,
  });

  final ProjectModel project;
  final Duration animationDelay;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        transform: _hovered
            ? Matrix4.translationValues(0.0, -4.0, 0.0)
            : Matrix4.identity(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                // Design: rgba(30, 41, 59, 0.7)
                color: const Color(0xB31E293B),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                border: Border.all(
                  color: _hovered
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppColors.electricCyan.withValues(alpha: 0.06),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Phone mockup visual
                  Center(
                    child: SizedBox(
                      width: 140,
                      child: PhoneMockup(imageUrl: widget.project.imageUrl),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Title
                  Text(
                    widget.project.title,
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Description
                  Text(
                    widget.project.description,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Tech tags
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: widget.project.techStack
                        .map((t) => TechTag(t))
                        .toList(),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Action buttons
                  Row(
                    children: [
                      _ActionButton(
                        icon: Icons.code_rounded,
                        tooltip: 'View Source',
                        onTap: () {
                          final uri = Uri.tryParse(widget.project.githubUrl);
                          if (uri != null) launchUrl(uri);
                        },
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (widget.project.liveUrl != null)
                        _ActionButton(
                          icon: Icons.open_in_new_rounded,
                          tooltip: 'Live Demo',
                          onTap: () {
                            final uri = Uri.tryParse(widget.project.liveUrl!);
                            if (uri != null) launchUrl(uri);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .animate(delay: widget.animationDelay)
          .fadeIn(duration: 500.ms)
          .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circular icon action button
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? AppColors.electricCyan.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: AppColors.primary,
                width: 1,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
