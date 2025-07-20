// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/booking.dart';

class Bookingservice {
  /// Insert a new Booking record
  Future<void> insertUsage(Booking booking) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      DatabaseConstants.TABLE_BOOKING,
      booking.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all Bookings
  Future<List<Booking>> getAllUsages() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(DatabaseConstants.TABLE_BOOKING);

    return result.map((json) => Booking.fromJson(json)).toList();
  }

  /// Get current Booking for a Id
  Future<Booking?> getBookingById(int bookingId) async {
    final db = await DatabaseHelper().database;

    final result = await db.query(
      DatabaseConstants.TABLE_BOOKING,
      where: 'id = ?',
      whereArgs: [bookingId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Booking.fromJson(result.first);
    }
    return null;
  }

  /// Get current Booking for a bed
  Future<Booking?> getCurrentUsageForBed(int bedId) async {
    final db = await DatabaseHelper().database;
    final now = DateTime.now().toIso8601String();

    final result = await db.query(
      DatabaseConstants.TABLE_BOOKING,
      where: 'bookingId = ? AND status = ? AND startTime <= ? AND endTime >= ?',
      whereArgs: [bedId, 'Occupied', now, now],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Booking.fromJson(result.first);
    }
    return null;
  }

  /// Delete Booking by ID
  Future<void> deleteBooking(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      DatabaseConstants.TABLE_BOOKING,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update Booking
  Future<void> updateBooking(Booking booking) async {
    final db = await DatabaseHelper().database;
    await db.update(
      DatabaseConstants.TABLE_BOOKING,
      booking.toJson(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  /// Update Booking status
  Future<void> updateUsageStatus(int id, String status) async {
    final db = await DatabaseHelper().database;
    await db.update(
      DatabaseConstants.TABLE_BOOKING,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update end time of a Booking
  Future<int> updateEndTime(int id, DateTime newEndTime) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      DatabaseConstants.TABLE_BOOKING,
      {'endTime': newEndTime.toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
