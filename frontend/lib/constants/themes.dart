import 'package:anymex/widgets/animation/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color seedColor = Color(0xFF7C3AED);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
    surface: const Color(0xFFF8FAFC),
  ),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      for (var platform in TargetPlatform.values)
        if (platform != TargetPlatform.iOS)
          platform: const SharedAxisTransition(),
    },
  ),
  textTheme: GoogleFonts.plusJakartaSansTextTheme(
    const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF0F172A)),
      bodyMedium: TextStyle(color: Color(0xFF1E293B)),
      titleLarge: TextStyle(
          color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 24),
      bodySmall: TextStyle(color: Color(0xFF64748B), fontSize: 12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade100,
    hintStyle: TextStyle(color: Colors.grey.shade500),
    prefixIconColor: Colors.grey.shade700,
    suffixIconColor: Colors.grey.shade700,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: seedColor,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: seedColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF0F172A),
    size: 24,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: seedColor,
    foregroundColor: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0A0D18),
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
    surface: const Color(0xFF0A0D18),
  ),
  textTheme: GoogleFonts.plusJakartaSansTextTheme(
    const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFE2E8F0)),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
    ),
  ),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      for (var platform in TargetPlatform.values)
        if (platform != TargetPlatform.iOS)
          platform: const SharedAxisTransition(),
    },
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF161B2E),
    hintStyle: const TextStyle(color: Color(0xFF64748B)),
    prefixIconColor: const Color(0xFF94A3B8),
    suffixIconColor: const Color(0xFF94A3B8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: seedColor,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: seedColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
    size: 24,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: seedColor,
    foregroundColor: Colors.white,
  ),
);
