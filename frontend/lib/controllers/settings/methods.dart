import 'package:anymex/controllers/settings/settings.dart';
import 'package:get/get.dart';

extension UIMultiplierExtension on num {
  double multiplyRadius() {
    final settings = Get.find<Settings>();
    return toDouble() * settings.glowMultiplier.value;
  }

  double multiplyGlow() {
    final settings = Get.find<Settings>();
    return toDouble() * settings.glowMultiplier.value;
  }

  double multiplyRoundness() {
    final settings = Get.find<Settings>();
    return toDouble() * settings.glowMultiplier.value;
  }

  double multiplyBlur() {
    final settings = Get.find<Settings>();
    return toDouble() * settings.glowMultiplier.value;
  }
}

int getAnimationDuration() {
  return 200;
}

