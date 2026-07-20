import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class AppInputDecoration {
  AppInputDecoration._();

  static InputDecoration build({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? suffix,
    String? errorText,
  }) {
    const border = OutlineInputBorder(
      borderRadius: AppRadius.lg,
      borderSide: BorderSide(color: AppColors.border),
    );

    const focusedBorder = OutlineInputBorder(
      borderRadius: AppRadius.lg,
      borderSide: BorderSide(color: AppColors.borderStrong, width: 1.2),
    );

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      errorText: errorText,

      filled: true,
      fillColor: AppColors.surface,

      border: border,
      enabledBorder: border,
      disabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: focusedBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.error, width: 1.2),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),

      floatingLabelBehavior: FloatingLabelBehavior.auto,
      alignLabelWithHint: true,

      hintStyle: AppTextStyles.bodySecondary.copyWith(
        color: AppColors.textTertiary,
      ),

      labelStyle: AppTextStyles.label.copyWith(color: AppColors.textSecondary),

      floatingLabelStyle: AppTextStyles.label.copyWith(
        color: AppColors.textPrimary,
      ),

      prefixIcon: prefixIcon,
      prefixIconColor: AppColors.iconSecondary,

      suffixIcon: suffixIcon,
      suffixIconColor: AppColors.iconSecondary,

      suffix: suffix,

      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      errorMaxLines: 2,
    );
  }
}
