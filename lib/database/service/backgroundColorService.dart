// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/background_color.dart';

class Backgroundcolorservice {
  /// Insert a new Backgroud Color
  Future<void> insertBackgroundColor(BackgroundColor backgroundColor) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      DatabaseConstants.TABLE_BACKGROUND_COLOR,
      backgroundColor.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all Backgroud Color
  Future<List<BackgroundColor>> getBackgroundColors() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(DatabaseConstants.TABLE_BACKGROUND_COLOR);

    return result.map((json) => BackgroundColor.fromJson(json)).toList();
  }

  Future<BackgroundColor?> getActiveBackgroundColor() async {
    final db = await DatabaseHelper().database;

    final result = await db.query(
      DatabaseConstants.TABLE_BACKGROUND_COLOR,
      where: 'isActive = ?',
      whereArgs: [BackgroundColor.VALUE_YES],
    );

    if (result.isNotEmpty) {
      return BackgroundColor.fromJson(result.first);
    }

    return null;
  }

  /// update Backgroud Color
  Future<int> updateBackgroundColor(BackgroundColor backgroundColor) async {
    final db = await DatabaseHelper().database;

    final result = await db.query(
      DatabaseConstants.TABLE_BACKGROUND_COLOR,
      where: 'isActive = ?',
      whereArgs: [BackgroundColor.VALUE_YES],
    );

    if (result.isNotEmpty) {
      await db.update(
        DatabaseConstants.TABLE_BACKGROUND_COLOR,
        {'isActive': BackgroundColor.VALUE_NO},
        where: 'id = ?',
        whereArgs: [result.first['id']],
      );

      // Update the current Backgroud Color row
      return await db.update(
        DatabaseConstants.TABLE_BACKGROUND_COLOR,
        backgroundColor.toJson(),
        where: 'id = ?',
        whereArgs: [backgroundColor.id],
      );
    }
    return 0;
  }
}
