import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ColorsWidget {
  static Color generateRandomColor() {
    final random = Random();

    return HSVColor.fromAHSV(
      1.0, // Alpha
      random.nextDouble() * 360, // Hue (0–360)
      0.8 + random.nextDouble() * 0.2, // Saturation (0.8–1.0)
      0.6 + random.nextDouble() * 0.4, // Value (brightness, 0.6–1.0)
    ).toColor();
  }
}
