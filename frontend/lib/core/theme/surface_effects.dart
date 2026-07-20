import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_blur.dart';
import 'app_borders.dart';
import 'app_colors.dart';
import 'app_shadows.dart';

/// ===============================================================
/// EchoSphere Design System (EDS)
/// Glass Effect
/// ===============================================================
///
/// Centralized glassmorphism utilities.
///
/// Every reusable glass component (cards, buttons, text fields,
/// dialogs, navigation, etc.) should use this class.
///
/// ===============================================================

class SurfaceEffects {
  SurfaceEffects._();

  /// Default glass decoration.
  static BoxDecoration decoration({
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: borderRadius,
      border: Border.all(color: AppColors.border, width: AppBorders.thin),
      boxShadow: const [AppShadows.glass, AppShadows.ambient],
    );
  }

  /// Frosted glass backdrop blur.
  static Widget blur({
    required Widget child,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlur.lg, sigmaY: AppBlur.lg),
        child: child,
      ),
    );
  }
}
