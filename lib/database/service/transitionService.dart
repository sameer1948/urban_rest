// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/transition.dart';

class Transitionservice {
  /// Insert a new transition and ensure only one is active
  Future<void> insertTransition(Transition transition) async {
    final db = await DatabaseHelper().database;

    // If the new transition is marked as active, set all others to inactive
    if (transition.isActive == Transition.VALUE_YES) {
      await db.update(DatabaseConstants.TABLE_TRANSITION, {
        'isActive': Transition.VALUE_NO,
      });
    }

    await db.insert(
      DatabaseConstants.TABLE_TRANSITION,
      transition.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get the active transition
  Future<Transition?> getActiveTransition() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      DatabaseConstants.TABLE_TRANSITION,
      where: 'isActive = ?',
      whereArgs: [Transition.VALUE_YES],
    );
    if (result.isNotEmpty) {
      return Transition.fromJson(result.first);
    }
    return null;
  }

  /// Get all transitions
  Future<List<Transition>> getAllTransitions() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(DatabaseConstants.TABLE_TRANSITION);
    return result.map((json) => Transition.fromJson(json)).toList();
  }

  Future<int> updateTransition(Transition transition) async {
    final db = await DatabaseHelper().database;

    final result = await db.query(
      DatabaseConstants.TABLE_TRANSITION,
      where: 'isActive = ?',
      whereArgs: [Transition.VALUE_YES],
    );

    if (result.isNotEmpty) {
      await db.update(
        DatabaseConstants.TABLE_TRANSITION,
        {'isActive': Transition.VALUE_NO},
        where: 'id = ?',
        whereArgs: [result.first['id']],
      );

      // Update the current transition row
      return await db.update(
        DatabaseConstants.TABLE_TRANSITION,
        transition.toJson(),
        where: 'id = ?',
        whereArgs: [transition.id],
      );
    }
    return 0;
  }
}
