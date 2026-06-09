import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PhoneMockup extends StatelessWidget {
  const PhoneMockup({
    super.key,
    this.imageUrl,
    this.placeholderIcon = Icons.phone_iphone_rounded,
  });

  final String? imageUrl;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 19.5,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.surfaceContainer,
            width: 8,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // App content / image
              Positioned.fill(
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),

              // Dynamic island / notch at top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceContainerLow,
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
