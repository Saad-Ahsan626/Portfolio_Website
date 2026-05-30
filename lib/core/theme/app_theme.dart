import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          tertiary: AppColors.tertiary,
          onTertiary: AppColors.onTertiary,
          error: AppColors.error,
          onError: AppColors.onError,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
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
