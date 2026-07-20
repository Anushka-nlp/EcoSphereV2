import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_opacity.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.width = double.infinity,
    this.height = 56,
    this.borderRadius = AppRadius.lg,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  final bool isLoading;
  final bool isEnabled;

  final double width;
  final double height;

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final enabled = isEnabled && !isLoading && onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : AppOpacity.disabled,
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            disabledBackgroundColor: AppColors.surface,
            disabledForegroundColor: AppColors.textSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: const BorderSide(color: AppColors.borderStrong),
            ),
            animationDuration: AppDurations.normal,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textPrimary,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: AppColors.iconPrimary),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(label, style: AppTextStyles.button),
                  ],
                ),
        ),
      ),
    );
  }
}
