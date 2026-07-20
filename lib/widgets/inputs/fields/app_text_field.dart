import 'package:flutter/material.dart';

import 'package:ecosphere/core/theme/app_colors.dart';
import 'package:ecosphere/core/theme/app_radius.dart';
import 'package:ecosphere/core/theme/app_text_styles.dart';
import 'package:ecosphere/widgets/inputs/decoration/app_input_decoration.dart';
import 'package:ecosphere/widgets/surfaces/app_card.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? hintText;
  final String? labelText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final VoidCallback? onSuffixPressed;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;

  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.lg,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        readOnly: readOnly,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: obscureText ? 1 : maxLines,
        minLines: minLines,
        cursorColor: AppColors.textPrimary,
        style: AppTextStyles.body,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: AppInputDecoration.build(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
