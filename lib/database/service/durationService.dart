// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/duration_hour.dart';

class DurationHourService {
  /// Insert a new DurationHour
  Future<int> insertDurationHour(DurationHour durationHour) async {
    try {
      final db = await DatabaseHelper().database;

      return await db.insert(
        DatabaseConstants.TABLE_DURATION_HOUR,
        durationHour.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting bed: $e");
      return -1;
    }
  }

  /// Fetch all DurationHours
  Future<List<DurationHour>> getDurationHours() async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.TABLE_DURATION_HOUR,
    );

    return maps.map((map) => DurationHour.fromJson(map)).toList();
  }

  /// Get DurationHour by ID
  Future<DurationHour?> getDurationHourById(int id) async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> result = await db.query(
      DatabaseConstants.TABLE_DURATION_HOUR,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return DurationHour.fromJson(result.first);
    } else {
      return null;
    }
  }

  /// Delete a DurationHour by ID
  Future<void> deleteDurationHour(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      DatabaseConstants.TABLE_DURATION_HOUR,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
