import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // --- Font Families ---
  static TextStyle get _hanken => GoogleFonts.hankenGrotesk();
  static TextStyle get _inter => GoogleFonts.inter();
  static TextStyle get _jetbrains => GoogleFonts.jetBrainsMono();

  // --- Scale ---
  static TextStyle get display => _hanken.copyWith(
        fontSize: 64,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.02 * 64,
      );

  static TextStyle get headlineLg => _hanken.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get headlineLgMobile => _hanken.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get headlineMd => _hanken.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get bodyLg => _inter.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get bodyMd => _inter.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get codeSm => _jetbrains.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get labelCaps => _jetbrains.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0.1 * 12,
      );
}
