// ===============================================================
// EchoSphere Design System (EDS)
// App Durations
// ===============================================================
// Centralized animation durations used throughout the app.
// ===============================================================

class AppDurations {
  AppDurations._();

  /// Very quick UI feedback
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast interactions (button presses, icon changes)
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard UI transitions
  static const Duration normal = Duration(milliseconds: 200);

  /// Slightly slower animations
  static const Duration medium = Duration(milliseconds: 300);

  /// Screen transitions and larger animations
  static const Duration slow = Duration(milliseconds: 500);

  /// Intro animations and splash effects
  static const Duration extraSlow = Duration(milliseconds: 800);

  static const Duration typewriter = Duration(milliseconds: 80);
}
