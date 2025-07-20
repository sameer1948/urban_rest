// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/invoice.dart';

class InvoiceService {
  /// Insert a new Invoice
  Future<void> insertInvoice(Invoice invoice) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      DatabaseConstants.CREATE_TABLE_INVOICE,
      invoice.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all Invoices
  Future<List<Invoice>> getAllInvoices() async {
    final db = await DatabaseHelper().database;
    final result = await db.query(DatabaseConstants.CREATE_TABLE_INVOICE);

    return result.map((json) => Invoice.fromJson(json)).toList();
  }

  /// Get a Invoice by ID
  Future<Invoice?> getInvoiceById(int id) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      DatabaseConstants.CREATE_TABLE_INVOICE,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Invoice.fromJson(result.first);
    }
    return null;
  }

  /// Delete a Invoice by ID
  Future<void> deleteInvoice(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      DatabaseConstants.CREATE_TABLE_INVOICE,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update a Invoice
  Future<int> updateInvoice(Invoice invoice) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      DatabaseConstants.CREATE_TABLE_INVOICE,
      invoice.toJson(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }
}
