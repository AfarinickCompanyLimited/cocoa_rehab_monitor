// Sqflite Database Helper Class
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/job_order_farms_model.dart';

class JobOrderFarmsDbFarmDatabaseHelper {
  static final JobOrderFarmsDbFarmDatabaseHelper instance = JobOrderFarmsDbFarmDatabaseHelper._init();
  static Database? _database;

  JobOrderFarmsDbFarmDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('farm.db');
    return _database!;
  }

  static const String tableName = 'farms';
  static const String farmCode = "farm_code";
  static const String farmId = "farm_id";
  static const String farmerName = "farmer_nam";
  static const String districtId = "district_id";
  static const String districtName = "district_name";
  static const String regionId = "region_id";
  static const String regionName = "region_name";
  static const String sector = "sector";
  static const String location = "location";
  static const String farmSize = "farm_size";
  static const String e1 = "E1";
  static const String e2 = "E2";
  static const String e3 = "E3";
  static const String e4 = "E4";
  static const String e6 = "E6";
  static const String e7 = "E7";
  static const String m3 = "M3";
  static const String r1 = "R1";
  static const String r2 = "R2";
  static const String r4 = "R4";
  static const String t1 = "T1";
  static const String t2 = "T2";
  static const String t5 = "T5";
  static const String t7 = "T7";

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $farmCode INTEGER PRIMARY KEY,
        $farmId TEXT NOT NULL,
        $farmerName TEXT NOT NULL,
        $districtId INTEGER NOT NULL,
        $districtName TEXT NOT NULL,
        $regionId TEXT NOT NULL,
        $regionName TEXT NOT NULL,
        $sector INTEGER NOT NULL,
        $location TEXT NOT NULL,
        $farmSize REAL NOT NULL,
        $e1 INTEGER NOT NULL,
        $e2 INTEGER NOT NULL,
        $e3 INTEGER NOT NULL,
        $e4 INTEGER NOT NULL,
        $e6 INTEGER NOT NULL,
        $e7 INTEGER NOT NULL,
        $m3 INTEGER NOT NULL,
        $r1 INTEGER NOT NULL,
        $r2 INTEGER NOT NULL,
        $r4 INTEGER NOT NULL,
        $t1 INTEGER NOT NULL,
        $t2 INTEGER NOT NULL,
        $t5 INTEGER NOT NULL,
        $t7 INTEGER NOT NULL
      )
    ''');
  }

  Future<int> saveData(JobOrderFarmModel farm) async {
    final db = await instance.database;
    return await db.insert(tableName, farm.toJson());
  }

  Future<int> bulkInsertData(List<JobOrderFarmModel> allData) async {
    final db = await instance.database;
    int count = 0;
    await db.transaction((txn) async {
      for (final data in allData) {
        await txn.insert(tableName, data.toJson());
        count++;
      }
    });
    return count;
  }

  Future<JobOrderFarmModel?> getFarmByCode(int code) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$farmCode = ?',
      whereArgs: [code],
    );
    return result.isNotEmpty ? JobOrderFarmModel.fromJson(result.first) : null;
  }

  Future<List<JobOrderFarmModel>> getAllFarms() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => JobOrderFarmModel.fromJson(json)).toList();
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete(tableName);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}