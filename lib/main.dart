import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow Google Fonts to fetch from network on web
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const ProviderScope(child: App()));
}
