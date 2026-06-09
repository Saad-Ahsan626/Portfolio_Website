import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class FloatingLabelField extends StatefulWidget {
  const FloatingLabelField({
    super.key,
    required this.label,
    required this.onChanged,
    this.errorText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final int maxLines;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  State<FloatingLabelField> createState() => _FloatingLabelFieldState();
}

class _FloatingLabelFieldState extends State<FloatingLabelField>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focus;
  late final AnimationController _animController;
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _focus.addListener(() {
      setState(() => _hasFocus = _focus.hasFocus);
      if (_focus.hasFocus || _hasText) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _isFloated => _hasFocus || _hasText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Floating label
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              top: _isFloated ? -AppSpacing.sm : AppSpacing.md,
              left: AppSpacing.sm,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: _isFloated
                    ? AppTypography.labelCaps.copyWith(
                        color: _hasFocus
                            ? AppColors.electricCyan
                            : AppColors.primary,
                      )
                    : AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                child: Text(widget.label),
              ),
            ),

            // Input field
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                maxLines: widget.maxLines,
                keyboardType: widget.keyboardType,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurface,
                ),
                onChanged: (v) {
                  setState(() => _hasText = v.isNotEmpty);
                  if (v.isNotEmpty) {
                    _animController.forward();
                  } else if (!_hasFocus) {
                    _animController.reverse();
                  }
                  widget.onChanged(v);
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.md,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.outlineVariant,
                      width: 2,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.outlineVariant,
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.electricCyan,
                      width: 2,
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Error text
        if (widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.errorText!,
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.error,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}
