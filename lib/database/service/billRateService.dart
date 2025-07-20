// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/bedRate.dart';

class BedRateservice {
  /// Insert a new Rate
  Future<void> insertRate(BedRate bedRate) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      DatabaseConstants.TABLE_BED_RATE,
      bedRate.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all BedRates
  Future<List<BedRate>> getAllBedRates() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(DatabaseConstants.TABLE_BED_RATE);

    return result.map((json) => BedRate.fromJson(json)).toList();
  }

  /// Get a BedRate by ID
  Future<BedRate?> getBedRateById(int id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      DatabaseConstants.TABLE_BED_RATE,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return BedRate.fromJson(result.first);
    }
    return null;
  }

  /// Delete a BedRate by ID
  Future<void> deleteBedRate(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      DatabaseConstants.TABLE_BED_RATE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update a BedRate
  Future<void> updateBedRate(BedRate bedRate) async {
    final db = await DatabaseHelper().database;
    await db.update(
      DatabaseConstants.TABLE_BED_RATE,
      bedRate.toJson(),
      where: 'id = ?',
      whereArgs: [bedRate.id],
    );
  }
}
