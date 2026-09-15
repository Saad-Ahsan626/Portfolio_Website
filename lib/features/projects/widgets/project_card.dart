import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/project_model.dart';
import '../../../shared/widgets/hover_card.dart';
import '../../../shared/widgets/hover_link.dart';
import 'phone_mockup.dart';
import 'tech_tag.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.fillHeight = false,
  });

  final ProjectModel project;

  /// Stretch to the row's height and pin the actions to the bottom edge, so
  /// cards side by side line up. Only valid under a bounded height.
  final bool fillHeight;

  @override
  Widget build(BuildContext context) {
    void openCaseStudy() => context.go(AppRoutes.project(project.id));

    return HoverCard(
      onTap: openCaseStudy,
      semanticLabel: '${project.title} — view case study',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: fillHeight ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Center(
              child: SizedBox(
                width: 140,
                child: PhoneMockup(imageUrl: project.imageUrl),
              ),
            ),
          ),
          Text(
            project.title,
            style: AppTypography.headlineMd.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 12),
          Text(
            project.description,
            style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: project.techStack.map((t) => TechTag(t)).toList(),
          ),
          // Tight flexible gap: pins the actions to the bottom, and absorbs a
          // few pixels if IntrinsicHeight's estimate runs short.
          if (fillHeight)
            const Expanded(child: SizedBox(height: 24))
          else
            const SizedBox(height: 24),
          Row(
            children: [
              CaseStudyLink(onTap: openCaseStudy),
              const Spacer(),
              if (project.githubUrl != null)
                SourceButton(url: project.githubUrl!),
            ],
          ),
        ],
      ),
    );
  }
}

/// "CASE STUDY →" gold underlined link.
class CaseStudyLink extends StatelessWidget {
  const CaseStudyLink({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverLink(
      onTap: onTap,
      color: AppColors.accent,
      hoverColor: AppColors.onSurface,
      builder: (context, color, _) => Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: color)),
        ),
        child: Text(
          'CASE STUDY →',
          style: AppTypography.labelSm.copyWith(color: color, height: 1),
        ),
      ),
    );
  }
}

/// 44px circular "</>" button that opens the repository.
class SourceButton extends StatelessWidget {
  const SourceButton({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'View source',
      child: HoverLink(
        onTap: () => launchUrl(Uri.parse(url)),
        semanticLabel: 'View source on GitHub',
        builder: (context, _, hovered) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hovered ? AppColors.accentWash : Colors.transparent,
            border: Border.all(color: AppColors.outline),
          ),
          child: Text(
            '</>',
            style: AppTypography.codeSm.copyWith(color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}
