import 'package:flutter/material.dart';

/// Colour tokens taken from the design files in `plan/`.
class AppColors {
  AppColors._();

  // --- Surfaces ---
  static const Color background = Color(0xFF09090B); // page ground
  static const Color surface = background;
  static const Color panel = Color(0xFF0E0E11); // contact form, approach panel
  static const Color surfaceContainer = Color(0xFF121212);
  static const Color surfaceContainerHigh = Color(0xFF1E1E1E); // pills, portrait
  static const Color card = Color(0xB31E1E1E); // rgba(30,30,30,.7) project/experience cards
  static const Color tile = Color(0x661E293B); // rgba(30,41,59,.4) toolkit, features, workspace frame
  static const Color badge = Color(0xE61E1E1E); // rgba(30,30,30,.9)
  static const Color tag = Color(0x8027272A); // rgba(39,39,42,.5)
  static const Color tagSubtle = Color(0x4D27272A); // rgba(39,39,42,.3)

  // --- Text ---
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFA1A1AA);
  static const Color placeholder = Color(0xFF52525B);
  static const Color onAccent = Color(0xFF000000);

  // --- Lines ---
  static const Color outline = Color(0xFFFFFFFF); // footer rule, ghost buttons
  static const Color outlineVariant = Color(0xFF3F3F46); // borders, rails
  static const Color divider = Color(0x663F3F46); // rgba(63,63,70,.4)
  static const Color hairline = Color(0x0DFFFFFF); // 5% white card border
  static const Color hairlineStrong = Color(0x14FFFFFF); // 8% white badge border

  // --- Accent (gold) ---
  static const Color accent = Color(0xFFC6A87C);
  static const Color accentBorder = Color(0x73C6A87C); // .45 hover border
  static const Color accentGlow = Color(0x2EC6A87C); // .18 portrait glow
  static const Color accentRing = Color(0x26C6A87C); // .15 timeline node ring
  static const Color accentWash = Color(0x1AC6A87C); // .10 icon button hover

  // --- Material roles ---
  static const Color primary = onSurface;
  static const Color onPrimary = onAccent;
  static const Color secondary = onSurfaceVariant;
  static const Color secondaryContainer = Color(0xFF27272A);

  // --- Error ---
  static const Color error = Color(0xFFFF453A);
  static const Color onError = Color(0xFF000000);
  static const Color errorContainer = Color(0xFF3B0703);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
}
