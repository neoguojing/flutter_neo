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
}
