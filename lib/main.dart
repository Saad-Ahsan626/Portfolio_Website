import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Real paths (/projects/campus-pulse) rather than /#/…: search engines
  // ignore everything after '#', so hash URLs can't be indexed as pages.
  usePathUrlStrategy();

  // Allow Google Fonts to fetch from network on web
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(const ProviderScope(child: App()));
}
