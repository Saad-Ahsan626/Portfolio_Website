import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Realistic device frame: metallic gradient rim, near-black bezel,
/// side buttons and a glass sheen. Intentionally island/notch-free so
/// screenshots stay unobstructed.
class PhoneMockup extends StatelessWidget {
  const PhoneMockup({
    super.key,
    this.imageUrl,
    this.placeholderIcon = Icons.phone_iphone_rounded,
  });

  final String? imageUrl;
  final IconData placeholderIcon;

  /// Width ÷ height of the device body.
  static const double aspectRatio = 9 / 19.5;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Side buttons (drawn first, peeking out from the body) ──
          const _SideButton(right: -2, top: 0.22, heightFactor: 0.055),
          const _SideButton(left: -2, top: 0.18, heightFactor: 0.04),
          const _SideButton(left: -2, top: 0.245, heightFactor: 0.04),

          // ── Device body ───────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              // Metallic rim: subtle top-light gradient instead of flat color.
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3A3A3E),
                  Color(0xFF1C1C1F),
                  Color(0xFF2A2A2E),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                // Deep ground shadow
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 28,
                  offset: Offset(0, 14),
                ),
                // Tight contact shadow for weight
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(2.5), // metallic rim thickness
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0C), // bezel
                borderRadius: BorderRadius.circular(27),
              ),
              padding: const EdgeInsets.all(5), // bezel thickness
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // App content / image
                    imageUrl != null
                        ? Image.asset(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),

                    // Glass sheen — diagonal highlight across the top corner
                    IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.center,
                            colors: [
                              Colors.white.withValues(alpha: 0.09),
                              Colors.white.withValues(alpha: 0.02),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.25, 0.5],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceContainer,
      child: Center(
        child: Icon(
          placeholderIcon,
          size: 64,
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

/// Power / volume button peeking out from the device edge.
class _SideButton extends StatelessWidget {
  const _SideButton({
    this.left,
    this.right,
    required this.top,
    required this.heightFactor,
  });

  final double? left;
  final double? right;
  final double top; // fraction of body height
  final double heightFactor; // fraction of body height

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      bottom: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          return Padding(
            padding: EdgeInsets.only(top: h * top),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 2.5,
                height: h * heightFactor,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3E),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
