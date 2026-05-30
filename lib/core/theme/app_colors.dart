import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Surfaces ---
  static const Color surface = Color(0xFF101415);
  static const Color surfaceDim = Color(0xFF101415);
  static const Color surfaceBright = Color(0xFF363A3B);
  static const Color surfaceContainerLowest = Color(0xFF0B0F10);
  static const Color surfaceContainerLow = Color(0xFF191C1E);
  static const Color surfaceContainer = Color(0xFF1D2022);
  static const Color surfaceContainerHigh = Color(0xFF272A2C);
  static const Color surfaceContainerHighest = Color(0xFF323537);

  // --- On Surface ---
  static const Color onSurface = Color(0xFFE0E3E5);
  static const Color onSurfaceVariant = Color(0xFFBDC8D2);
  static const Color inverseSurface = Color(0xFFE0E3E5);
  static const Color inverseOnSurface = Color(0xFF2D3133);

  // --- Outline ---
  static const Color outline = Color(0xFF87929C);
  static const Color outlineVariant = Color(0xFF3E4851);

  // --- Primary ---
  static const Color primary = Color(0xFF89CEFF);
  static const Color onPrimary = Color(0xFF00344D);
  static const Color primaryContainer = Color(0xFF00B4FF);
  static const Color onPrimaryContainer = Color(0xFF004361);
  static const Color inversePrimary = Color(0xFF006591);
  static const Color primaryFixed = Color(0xFFC9E6FF);
  static const Color primaryFixedDim = Color(0xFF89CEFF);
  static const Color onPrimaryFixed = Color(0xFF001E2F);
  static const Color onPrimaryFixedVariant = Color(0xFF004C6E);
  static const Color surfaceTint = Color(0xFF89CEFF);

  // --- Secondary ---
  static const Color secondary = Color(0xFFB7C8E1);
  static const Color onSecondary = Color(0xFF213145);
  static const Color secondaryContainer = Color(0xFF3A4A5F);
  static const Color onSecondaryContainer = Color(0xFFA9BAD3);
  static const Color secondaryFixed = Color(0xFFD3E4FE);
  static const Color secondaryFixedDim = Color(0xFFB7C8E1);
  static const Color onSecondaryFixed = Color(0xFF0B1C30);
  static const Color onSecondaryFixedVariant = Color(0xFF38485D);

  // --- Tertiary ---
  static const Color tertiary = Color(0xFFBEC6E0);
  static const Color onTertiary = Color(0xFF283044);
  static const Color tertiaryContainer = Color(0xFFA1A9C2);
  static const Color onTertiaryContainer = Color(0xFF363E53);
  static const Color tertiaryFixed = Color(0xFFDAE2FD);
  static const Color tertiaryFixedDim = Color(0xFFBEC6E0);
  static const Color onTertiaryFixed = Color(0xFF131B2E);
  static const Color onTertiaryFixedVariant = Color(0xFF3F465C);

  // --- Error ---
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // --- Background ---
  static const Color background = Color(0xFF101415);
  static const Color onBackground = Color(0xFFE0E3E5);
  static const Color surfaceVariant = Color(0xFF323537);

  // --- Semantic Aliases (use these in UI code) ---
  static const Color electricCyan = primaryContainer;   // #00B4FF — CTAs, highlights
  static const Color slateBlue = secondary;             // decorative, secondary text
  static const Color midnightNavy = Color(0xFF0F172A);  // deepest background
  static const Color iceWhite = Color(0xFFF8FAFC);      // body text in dark mode

  // --- Glass & Overlay Utilities ---
  static const Color glassBackground = Color(0x4D101415);   // 30% surface
  static const Color glassBorder = Color(0x0DFFFFFF);        // white 5%
  static const Color glassBorderHover = Color(0x33FFFFFF);   // white 20%
  static const Color navBackground = Color(0xB3101415);      // 70% surface
}