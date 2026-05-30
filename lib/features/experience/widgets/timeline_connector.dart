import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TimelineNode extends StatelessWidget {
  const TimelineNode({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dot
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.secondary,
            border: Border.all(
              color: AppColors.background,
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
        ),
      ],
    );
  }
}

class TimelineTrack extends StatelessWidget {
  const TimelineTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.secondary,
            AppColors.secondary,
            Colors.transparent,
          ],
          stops: [0.0, 0.1, 0.9, 1.0],
        ),
      ),
    );
  }
}
