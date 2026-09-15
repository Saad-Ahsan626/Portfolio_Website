import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // Desktop platforms default to compact density, which trims 8px off
        // button padding — keep the design's 20px × 36px buttons everywhere.
        visualDensity: VisualDensity.standard,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onAccent,
          secondaryContainer: AppColors.secondaryContainer,
          tertiary: AppColors.accent,
          onTertiary: AppColors.onAccent,
          error: AppColors.error,
          onError: AppColors.onError,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.accent,
          selectionColor: AppColors.accentBorder,
          selectionHandleColor: AppColors.accent,
        ),
        textTheme: TextTheme(
          displayLarge: AppTypography.display,
          headlineLarge: AppTypography.headlineLg,
          headlineMedium: AppTypography.headlineMd,
          bodyLarge: AppTypography.bodyLg,
          bodyMedium: AppTypography.bodyMd,
          labelSmall: AppTypography.labelCaps,
        ),
      );
}
