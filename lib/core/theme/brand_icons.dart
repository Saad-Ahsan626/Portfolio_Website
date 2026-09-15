import 'package:flutter/widgets.dart';

/// The handful of brand logos the site uses.
///
/// `assets/fonts/BrandIcons.ttf` is a subset of the Simple Icons font (CC0)
/// containing only these glyphs — about 3 KB instead of the full 1.3 MB font,
/// which Flutter web downloads before the first frame.
///
/// To add an icon, find its code point in the `simple_icons` package and
/// re-run the subset with fontTools, adding it to `--unicodes`.
class BrandIcons {
  BrandIcons._();

  static const _family = 'BrandIcons';

  static const IconData dart = IconData(0xecba, fontFamily: _family);
  static const IconData firebase = IconData(0xedd7, fontFamily: _family);
  static const IconData flutter = IconData(0xedf4, fontFamily: _family);
  static const IconData github = IconData(0xee5e, fontFamily: _family);
  static const IconData nestjs = IconData(0xf1ac, fontFamily: _family);
  static const IconData prisma = IconData(0xf329, fontFamily: _family);
  static const IconData typescript = IconData(0xf62a, fontFamily: _family);
}
