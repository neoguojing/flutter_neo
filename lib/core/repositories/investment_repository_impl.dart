import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';
import '../models/investment.dart';
import 'investment_repository.dart';

class InvestmentRepositoryImpl implements IInvestmentRepository {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Investment>> getAllInvestments() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('investments');
    return maps.map((m) => Investment.fromJson(m)).toList();
  }

  @override
  Future<void> saveInvestment(Investment investment) async {
    final db = await dbHelper.database;
    await db.insert(
      'investments',
      investment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteInvestment(String id) async {
    final db = await dbHelper.database;
    await db.delete('investments', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> saveGlobalTotal(double amount) async {
    final db = await dbHelper.database;
    await db.insert(
      'settings',
      {'key': 'global_total_amount', 'value': amount},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<double> getGlobalTotal() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['global_total_amount'],
    );
    if (maps.isNotEmpty) {
      return (maps.first['value'] as num).toDouble();
    }
    return 1000000.0; // Default value
  }
}
