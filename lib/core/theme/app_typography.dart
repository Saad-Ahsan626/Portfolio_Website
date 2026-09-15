import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  // --- Font Families ---
  // Explicit normal style so these don't inherit italics from an ancestor's
  // DefaultTextStyle (ListTile and TextField merge in theme bodyLarge).
  static TextStyle get _displayFont =>
      GoogleFonts.oswald(fontStyle: FontStyle.normal);
  static TextStyle get _serifFont =>
      GoogleFonts.playfairDisplay(fontStyle: FontStyle.normal);
  static TextStyle get _monoFont =>
      GoogleFonts.jetBrainsMono(fontStyle: FontStyle.normal);

  // --- Scale ---
  // Oswald tops out at 700, so heavier weights would only be synthesised.
  static TextStyle get display => _displayFont.copyWith(
        fontSize: 100,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: -0.02 * 100,
      );

  static TextStyle get headlineLg => _displayFont.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.1,
      );

  static TextStyle get headlineLgMobile => _displayFont.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
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
        fontWeight: FontWeight.w700,
        height: 1.5,
      );

  /// 12px uppercase label with .2em tracking (nav, buttons, pills).
  static TextStyle get labelCaps => _monoFont.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.0,
        letterSpacing: 0.2 * 12,
      );

  /// 11px variant used for form labels, tags and meta keys.
  static TextStyle get labelSm => _monoFont.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.2 * 11,
      );
}
