import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // 如果在桌面端运行，需要初始化 ffi 工厂
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDB('app_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE investments (
            id TEXT PRIMARY KEY,
            name TEXT,
            totalAmount REAL,
            ratio REAL,
            sortOrder INTEGER,
            parentId TEXT,
            subToolName TEXT,
            subToolRatio REAL,
            lastUpdated TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE investments ADD COLUMN totalAmount REAL');
          await db.execute('ALTER TABLE investments ADD COLUMN ratio REAL');
          await db.execute('ALTER TABLE investments ADD COLUMN sortOrder INTEGER');
          await db.execute('ALTER TABLE investments ADD COLUMN parentId TEXT');
          await db.execute('ALTER TABLE investments ADD COLUMN subToolName TEXT');
          await db.execute('ALTER TABLE investments ADD COLUMN subToolRatio REAL');
        }
      },
    );
  }
}