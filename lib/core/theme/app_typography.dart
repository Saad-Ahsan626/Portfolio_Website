import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // --- Font Families ---
  static TextStyle get _displayFont => GoogleFonts.oswald();
  static TextStyle get _serifFont => GoogleFonts.playfairDisplay();
  static TextStyle get _monoFont => GoogleFonts.jetBrainsMono();

  // --- Scale ---
  static TextStyle get display => _displayFont.copyWith(
        fontSize: 100, // Massive for brutalist
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: -0.02 * 100,
      );

  static TextStyle get headlineLg => _displayFont.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 1.1,
      );

  static TextStyle get headlineLgMobile => _displayFont.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.1,
      );

  static TextStyle get headlineMd => _displayFont.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get bodyLg => _serifFont.copyWith(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMd => _serifFont.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  static TextStyle get codeSm => _monoFont.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get labelCaps => _monoFont.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0.2 * 12, // Wider tracking for brutalist labels
      );
}
