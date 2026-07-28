import 'package:flutter/material.dart';
import 'package:get/get.dart';

Settings get settingsController => Get.find<Settings>();

class Settings extends GetxController {
  final RxBool translucentBar = true.obs;
  final RxBool transculentBar = true.obs;
  final RxBool useLegacyHeader = false.obs;
  final RxDouble glowMultiplier = 1.0.obs;

  final RxInt playerStyle = 0.obs;
  final RxBool disableGradient = false.obs;
  final RxBool isTV = false.obs;

  final RxBool usePosterColor = false.obs;
  String liquidBackgroundPath = '';
  final RxBool liquidMode = false.obs;
  final RxBool useGrainTexture = false.obs;
  final RxDouble grainIntensity = 0.1.obs;
  final RxBool retainOriginalColor = false.obs;

  String selectedProfile = 'MID-END';
  String selectedShader = '';

  void checkForUpdates(BuildContext context) {}
  void showWelcomeDialog(BuildContext context) {}
}
