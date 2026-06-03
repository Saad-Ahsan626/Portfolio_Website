import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TimelineNode extends StatelessWidget {
  const TimelineNode({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class TimelineTrack extends StatelessWidget {
  const TimelineTrack({super.key});

  @override
  Widget build(BuildContext context) {
    // No fixed height — must always be placed inside an Expanded so the
    // parent (IntrinsicHeight row) can measure it correctly without hitting
    // double.infinity which causes a 99999px RenderFlex overflow.
    return DecoratedBox(
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
      child: const SizedBox(width: 2),
    );
  }
}
