// ignore_for_file: camel_case_types

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';

class Commonservices {
  /// Fetch number of rows in a table
  Future<int> getRowCount(String tableName) async {
    final db = await DatabaseHelper().database;
    final result = Sqflite.firstIntValue(
      await db.rawQuery('${DatabaseConstants.SELECT_COUNT_FROM}$tableName'),
    );
    return result ?? 0;
  }
}
