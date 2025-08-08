// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:urban_rest/database/service/backgroundColorService.dart';
import 'package:urban_rest/model/background_color.dart';

class Backgroundcolorprovider with ChangeNotifier {
  final Backgroundcolorservice _backgroundColorService =
      Backgroundcolorservice();
  BackgroundColor? _activeBackgroundColor;

  BackgroundColor? get activeBackgroundColor => _activeBackgroundColor;
  String get activeColor => _activeBackgroundColor?.key ?? 'Color - 1';

  Future<void> load() async {
    final backgroundColors =
        await _backgroundColorService.getBackgroundColors();
    _activeBackgroundColor = backgroundColors.firstWhere(
      (color) => color.isActive == BackgroundColor.VALUE_YES,
      orElse: () => backgroundColors.first,
    );
    notifyListeners();
  }

  Future<void> update(BackgroundColor backgroundColor) async {
    await _backgroundColorService.updateBackgroundColor(backgroundColor);
    _activeBackgroundColor = backgroundColor;
    notifyListeners();
  }
}
