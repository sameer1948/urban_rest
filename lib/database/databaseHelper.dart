// ignore_for_file: file_names

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  /// Returns the singleton instance of the database.
  /// If the database is not initialized, it will be created.
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize database if not already initialized
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      // Get the application's document directory
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(
        documentsDirectory.path,
        DatabaseConstants.DATABASE_NAME,
      );

      // Open the database (create if it doesn't exist)
      return await openDatabase(
        path,
        version: 1,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: _onCreate,
        //onUpgrade: _onUpgrade,
      );
    } catch (e) {
      print("Error opening database: $e");
      rethrow; // You can handle the error more gracefully here.
    }
  }

  // Create tables when the database is created for the first time
  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute(DatabaseConstants.CREATE_TABLE_DURATION_HOUR);
      await db.execute(DatabaseConstants.CREATE_TABLE_TRANSITION);
      await db.execute(DatabaseConstants.CREATE_TABLE_BED);
      await db.execute(DatabaseConstants.CREATE_TABLE_CUSTOMER);
      await db.execute(DatabaseConstants.CREATE_TABLE_BOOKING);
      await db.execute(DatabaseConstants.CREATE_TABLE_INVOICE);
      await db.execute(DatabaseConstants.CREATE_TABLE_BED_RATE);
    } catch (e) {
      print("Error creating tables: $e");
      rethrow;
    }
  }

  // // Handle database upgrades (e.g., schema changes) when version is incremented
  // Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < newVersion) {
  //     // Example of handling upgrades, add more migration steps as needed.
  //     print('Upgrading database from version $oldVersion to $newVersion');
  //     // Example: db.execute("ALTER TABLE ...");
  //   }
  // }

  // Close the database when no longer needed
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
