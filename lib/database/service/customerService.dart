// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:urban_rest/constants/databaseConstants.dart';
import 'package:urban_rest/database/databaseHelper.dart';
import 'package:urban_rest/model/customer.dart';

class CustomerService {
  /// Insert a customer
  Future<void> insertCustomer(Customer customer) async {
    final db = await DatabaseHelper().database;

    await db.insert(
      DatabaseConstants.TABLE_CUSTOMER,
      customer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all customers
  Future<List<Customer>> getAllCustomers() async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.TABLE_CUSTOMER,
    );

    return maps.map((map) => Customer.fromJson(map)).toList();
  }

  /// Get customer by ID
  Future<Customer?> getCustomerById(int id) async {
    final db = await DatabaseHelper().database;

    final List<Map<String, dynamic>> result = await db.query(
      DatabaseConstants.TABLE_CUSTOMER,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Customer.fromJson(result.first);
    } else {
      return null;
    }
  }

  /// Delete customer by ID
  Future<void> deleteCustomer(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      DatabaseConstants.TABLE_CUSTOMER,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update customer
  Future<void> updateCustomer(Customer customer) async {
    final db = await DatabaseHelper().database;
    await db.update(
      DatabaseConstants.TABLE_CUSTOMER,
      customer.toJson(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }
}
