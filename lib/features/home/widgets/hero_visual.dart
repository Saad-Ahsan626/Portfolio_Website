import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class HeroVisual extends StatelessWidget {
  const HeroVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow background blob
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricCyan.withValues(alpha: 0.12),
                    blurRadius: 120,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Main glass container
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.phone_iphone_rounded,
                    size: 160,
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),

          // Floating top-right badge — phone icon
          Positioned(
            top: 24,
            right: 24,
            child: const _FloatingBadge(
              child: Icon(Icons.phone_iphone,
                  color: AppColors.primary, size: 32),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                begin: 0, end: -8, duration: 3000.ms, curve: Curves.easeInOut),
          ),

          // Floating bottom-left badge — code icon
          Positioned(
            bottom: 24,
            left: 24,
            child: const _FloatingBadge(
              child: Icon(Icons.code, color: AppColors.secondary, size: 28),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .fadeIn()
                .then()
                .shimmer(
                    duration: 2000.ms,
                    color: AppColors.electricCyan.withValues(alpha: 0.3)),
          ),

          // Pulsing ring in center
          Positioned.fill(
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .scaleXY(begin: 0.8, end: 1.4, duration: 2000.ms)
                  .fadeOut(begin: 1, duration: 2000.ms),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
