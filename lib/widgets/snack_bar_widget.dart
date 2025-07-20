import 'package:flutter/material.dart';

class SnackBarWidget {
  static void show(
    BuildContext context, {
    required String message,
    Color color = Colors.black87,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: duration,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
