import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'fixed_investment_repository.dart';
import 'dart:convert';

class FixedInvestmentRepositoryImpl implements IFixedInvestmentRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'fixed_investment.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE fixed_assets(id TEXT PRIMARY KEY, data TEXT)',
        );
      },
    );
  }

  @override
  Future<List<FixedInvestmentAssetModel>> getAllFixedAssets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fixed_assets');
    return maps.map((map) {
      return FixedInvestmentAssetModel.fromJson(
        jsonDecode(map['data'] as String),
      );
    }).toList();
  }

  @override
  Future<void> saveFixedAsset(FixedInvestmentAssetModel asset) async {
    final db = await database;
    await db.insert(
      'fixed_assets',
      {'id': asset.id, 'data': jsonEncode(asset.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteFixedAsset(String id) async {
    final db = await database;
    await db.delete('fixed_assets', where: 'id = ?', whereArgs: [id]);
  }
}
