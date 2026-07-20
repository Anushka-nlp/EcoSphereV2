import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';
import 'package:ecosphere/core/transitions/fade_page_transition_builder.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Background
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        surface: AppColors.background,
        primary: Colors.white,
        secondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onPrimary: Colors.black,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display,
        headlineLarge: AppTextStyles.headline,
        titleLarge: AppTextStyles.title,
        titleMedium: AppTextStyles.subtitle,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.bodySecondary,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.label,
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textPrimary,
      ),

      // Card
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
      ),

      // Divider
      dividerColor: AppColors.divider,

      // Icons
      iconTheme: const IconThemeData(color: AppColors.iconPrimary, size: 22),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.2),
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textPrimary;
          }

          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(AppColors.background),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.lg,
          borderSide: const BorderSide(
            color: AppColors.borderStrong,
            width: 1.2,
          ),
        ),
        hintStyle: AppTextStyles.bodySecondary,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        ),
      ),

      // Splash / Highlight
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,

      // Page Transition
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadePageTransitionBuilder(),
          TargetPlatform.windows: FadePageTransitionBuilder(),
          TargetPlatform.iOS: FadePageTransitionBuilder(),
          TargetPlatform.macOS: FadePageTransitionBuilder(),
          TargetPlatform.linux: FadePageTransitionBuilder(),
        },
      ),
    );
  }
}
