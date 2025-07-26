import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class CommonWidgets {
  static Color generateRandomColor() {
    final random = Random();

    return HSVColor.fromAHSV(
      1.0, // Alpha
      random.nextDouble() * 360, // Hue (0–360)
      0.8 + random.nextDouble() * 0.2, // Saturation (0.8–1.0)
      0.6 + random.nextDouble() * 0.4, // Value (brightness, 0.6–1.0)
    ).toColor();
  }

  static Widget getRefreshIndicator(
    void showBookings, {
    required Future<void> Function() onRefresh,
    required Widget child,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: generateRandomColor(),
      backgroundColor: Colors.white,
      displacement: 50,
      edgeOffset: 50,
      child: child,
    );
  }
}
