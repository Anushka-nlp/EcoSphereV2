import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ===============================================================
/// EchoSphere Design System (EDS)
/// App Shadows
/// ===============================================================
///
/// Centralized shadow definitions.
///
/// Every shadow used throughout the application should originate
/// from this file.
///
/// ===============================================================

class AppShadows {
  AppShadows._();

  // ===========================================================
  // Shadow Tokens
  // ===========================================================

  static const double glassBlur = 32.0;
  static const double glassSpread = 0.0;
  static const Offset glassOffset = Offset(0, 18);

  static const double ambientBlur = 12.0;
  static const double ambientSpread = -2.0;
  static const Offset ambientOffset = Offset(0, 6);

  static const double floatingBlur = 48.0;
  static const double floatingSpread = 0.0;
  static const Offset floatingOffset = Offset(0, 24);

  // ===========================================================
  // Shadows
  // ===========================================================

  /// Default shadow for all glass surfaces.
  static const BoxShadow glass = BoxShadow(
    color: AppColors.shadow,
    blurRadius: glassBlur,
    spreadRadius: glassSpread,
    offset: glassOffset,
  );

  /// Soft ambient shadow for subtle depth.
  static const BoxShadow ambient = BoxShadow(
    color: AppColors.ambientShadow,
    blurRadius: ambientBlur,
    spreadRadius: ambientSpread,
    offset: ambientOffset,
  );

  /// Used for dialogs, bottom sheets and floating panels.
  static const BoxShadow floating = BoxShadow(
    color: AppColors.shadow,
    blurRadius: floatingBlur,
    spreadRadius: floatingSpread,
    offset: floatingOffset,
  );

  /// No shadow.
  static const List<BoxShadow> none = [];
}
