// ===============================================================
// EchoSphere Design System (EDS)
// App Radius
// ===============================================================

import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // Small Elements
  static const BorderRadius xs = BorderRadius.all(Radius.circular(8));

  static const BorderRadius sm = BorderRadius.all(Radius.circular(12));

  // Standard Components
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));

  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));

  // Glass Cards
  static const BorderRadius xl = BorderRadius.all(Radius.circular(24));

  // Large Panels / Bottom Sheets
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(28));

  // Hero Cards / Desktop Panels
  static const BorderRadius huge = BorderRadius.all(Radius.circular(32));

  // Circular
  static const BorderRadius circular = BorderRadius.all(Radius.circular(999));
}
