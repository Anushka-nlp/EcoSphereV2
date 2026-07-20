import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../decoration/app_input_decoration.dart';

class ApptextFormField extends StatelessWidget {
  const ApptextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.maxLines = 1,
    this.minLines,
    this.borderRadius = AppRadius.lg,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;

  final String? hintText;
  final String? labelText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;

  final AutovalidateMode autovalidateMode;

  final int maxLines;
  final int? minLines;

  final BorderRadius borderRadius;

  final Iterable<String>? autofillHints;

  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: controller == null ? initialValue : null,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: autovalidateMode,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      cursorColor: AppColors.textPrimary,
      style: AppTextStyles.body,
      decoration: AppInputDecoration.build(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
