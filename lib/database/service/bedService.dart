// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/bed.dart';

class BedService {
  /// Insert a new bed
  Future<int> insertBed(Bed bed) async {
    try {
      final db = await DatabaseHelper().database;

      return await db.insert(
        DatabaseConstants.TABLE_BED,
        bed.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting bed: $e");
      return -1;
    }
  }

  /// Fetch all beds
  Future<List<Bed>> getAllBeds() async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.TABLE_BED,
    );

    return maps.map((map) => Bed.fromJson(map)).toList();
  }

  /// Get bed by ID
  Future<Bed?> getBedById(int id) async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> result = await db.query(
      DatabaseConstants.TABLE_BED,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Bed.fromJson(result.first);
    } else {
      return null;
    }
  }

  /// Delete a bed by ID
  Future<void> deleteBed(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      DatabaseConstants.TABLE_BED,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
