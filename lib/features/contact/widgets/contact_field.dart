import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Label above an underlined input — the design's contact form field.
class ContactField extends StatelessWidget {
  const ContactField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.placeholder,
    this.errorText,
    this.lines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final String? errorText;
  final int lines;
  final int? maxLength;
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    const underline = UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.outlineVariant, width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSm.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          minLines: lines,
          maxLines: lines,
          keyboardType: lines > 1 ? TextInputType.multiline : keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          inputFormatters: [
            if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
          ],
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurface,
            height: 1.5,
          ),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            isDense: true,
            hintText: placeholder,
            hintStyle: AppTypography.bodyMd.copyWith(
              color: AppColors.placeholder,
              height: 1.5,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: underline,
            enabledBorder: underline,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            errorText: errorText,
            errorStyle: AppTypography.labelSm.copyWith(
              color: AppColors.error,
              letterSpacing: 0.5,
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
