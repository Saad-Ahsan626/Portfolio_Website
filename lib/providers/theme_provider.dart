import 'package:flutter_riverpod/flutter_riverpod.dart';

// Future-proof: wired now, toggled later
final isDarkModeProvider = StateProvider<bool>((_) => true);
