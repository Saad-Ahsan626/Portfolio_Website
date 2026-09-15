import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Minimal dark browser window for web and dashboard screenshots: traffic
/// lights, an address bar and the page below, sized by [aspectRatio] so it
/// never jumps when the image loads.
class BrowserMockup extends StatelessWidget {
  const BrowserMockup({
    super.key,
    required this.imageUrl,
    required this.aspectRatio,
    this.url,
  });

  final String imageUrl;

  /// Width ÷ height of the page screenshot.
  final double aspectRatio;
  final String? url;

  static const double _barHeight = 36;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Window bar ──
          Container(
            height: _barHeight,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
            ),
            child: Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ],
                const SizedBox(width: 16),
                if (url != null)
                  Flexible(
                    child: Container(
                      height: 22,
                      constraints: const BoxConstraints(maxWidth: 320),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        url!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Page ──
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) =>
                  const ColoredBox(color: AppColors.surfaceContainerHigh),
            ),
          ),
        ],
      ),
    );
  }
}
