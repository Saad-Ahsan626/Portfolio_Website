import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Surfaces ---
  static const Color surface = Color(0xFF09090B); // Deep brutalist black
  static const Color surfaceDim = Color(0xFF000000); // Pure black
  static const Color surfaceBright = Color(0xFF1E1E1E); 
  static const Color surfaceContainerLowest = Color(0xFF000000);
  static const Color surfaceContainerLow = Color(0xFF09090B);
  static const Color surfaceContainer = Color(0xFF121212);
  static const Color surfaceContainerHigh = Color(0xFF1E1E1E);
  static const Color surfaceContainerHighest = Color(0xFF2C2C2C);

  // --- On Surface ---
  static const Color onSurface = Color(0xFFFFFFFF); // Stark white
  static const Color onSurfaceVariant = Color(0xFFA1A1AA); // Light gray
  static const Color inverseSurface = Color(0xFFFFFFFF);
  static const Color inverseOnSurface = Color(0xFF000000);

  // --- Outline ---
  static const Color outline = Color(0xFFFFFFFF); // High contrast outline
  static const Color outlineVariant = Color(0xFF3F3F46); // Darker border

  // --- Primary ---
  // Using stark white as primary for brutalist feel
  static const Color primary = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFF000000);
  static const Color primaryContainer = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF000000);
  static const Color inversePrimary = Color(0xFF000000);
  static const Color primaryFixed = Color(0xFFFFFFFF);
  static const Color primaryFixedDim = Color(0xFFE4E4E7);
  static const Color onPrimaryFixed = Color(0xFF000000);
  static const Color onPrimaryFixedVariant = Color(0xFF18181B);
  static const Color surfaceTint = Color(0xFFFFFFFF);

  // --- Secondary ---
  // Using gray shades for secondary elements
  static const Color secondary = Color(0xFFA1A1AA);
  static const Color onSecondary = Color(0xFF000000);
  static const Color secondaryContainer = Color(0xFF27272A);
  static const Color onSecondaryContainer = Color(0xFFFFFFFF);
  static const Color secondaryFixed = Color(0xFFE4E4E7);
  static const Color secondaryFixedDim = Color(0xFFA1A1AA);
  static const Color onSecondaryFixed = Color(0xFF000000);
  static const Color onSecondaryFixedVariant = Color(0xFF18181B);

  // --- Tertiary (Accent) ---
  // Brutalist Gold/Yellow accent
  static const Color tertiary = Color(0xFFC6A87C);
  static const Color onTertiary = Color(0xFF000000);
  static const Color tertiaryContainer = Color(0xFFD4AF37);
  static const Color onTertiaryContainer = Color(0xFF000000);
  static const Color tertiaryFixed = Color(0xFFFDE68A);
  static const Color tertiaryFixedDim = Color(0xFFC6A87C);
  static const Color onTertiaryFixed = Color(0xFF000000);
  static const Color onTertiaryFixedVariant = Color(0xFF45350A);

  // --- Error ---
  static const Color error = Color(0xFFFF453A);
  static const Color onError = Color(0xFF000000);
  static const Color errorContainer = Color(0xFF3B0703);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // --- Background ---
  static const Color background = Color(0xFF09090B);
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFF18181B);

  // --- Semantic Aliases (use these in UI code) ---
  static const Color electricCyan = tertiary;           // Replaced with Gold
  static const Color slateBlue = secondary;             // Gray secondary
  static const Color midnightNavy = Color(0xFF000000);  // Deepest background
  static const Color iceWhite = Color(0xFFFFFFFF);      // Stark white

  // --- Glass & Overlay Utilities ---
  static const Color glassBackground = Color(0x33000000);   // Darker glass
  static const Color glassBorder = Color(0x1AFFFFFF);       
  static const Color glassBorderHover = Color(0x4DFFFFFF);   
  static const Color navBackground = Color(0xFF09090B);     // Solid dark for brutalism
}