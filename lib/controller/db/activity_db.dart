import 'dart:convert';

import 'package:cocoa_rehab_monitor/controller/model/activity_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ActivityDatabaseHelper {
  static final ActivityDatabaseHelper instance = ActivityDatabaseHelper._init();

  static Database? _database;

  ActivityDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('activity.db');
    return _database!;
  }

  static const String tableName = 'activity_db';
  static const String code = "code";
  static const String main_activity = "main_activity";

  static const String sub_activity = "sub_activity";

  static const String required_equipment = "required_equipment";

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
        $code INTEGER,
        $main_activity TEXT,
        $sub_activity TEXT
      )
    ''');
  }

  Future<int> saveData(ActivityModel activity) async {
    Map<String, dynamic> data = activity.toJson();
    final db = await instance.database;
    return await db.insert(tableName, data);
  }

  Future<int> bulkInsertData(List<ActivityModel> allData) async {
    final db = await instance.database;
    int count = 0;
    await db.transaction((txn) async {
      for (final data in allData) {
        // Convert requiredEquipment to an integer in the toJson() method
        final dataMap = data.toJson();

        await txn.insert(tableName, dataMap);
        count++;
      }
    });
    return count;
  }

  getActivityCodeByMainActivity(String mainActivity) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$main_activity = ?',
      whereArgs: [mainActivity],
    );
    if (result.isNotEmpty) {
      return result.first[code];
    }
    return null;
  }

  Future<List<ActivityModel>> getAllActivityWithMainActivityList(List<String> mainActivityList) async {
    final db = await instance.database;

    // Convert the list to a comma-separated string for the SQL query
    String placeholders = List.filled(mainActivityList.length, '?').join(', ');

    // Prepare the SQL query
    String sql = 'SELECT DISTINCT * FROM $tableName WHERE $main_activity IN ($placeholders)';

    // Execute the query
    final List<Map<String, dynamic>> result = await db.rawQuery(sql, mainActivityList);

    // Convert the result to a list of ActivityModel
    return result.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
  }

  Future<List<ActivityModel>> getActivityByCode(int code) async {
    final db = await instance.database;
    final result = await db.query(tableName, where: '$code = ?', whereArgs: [code]);
    return result.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
  }

  Future<List<ActivityModel>> getSubActivityByCode(int c) async {
    final db = await instance.database;
    final result = await db.query(tableName, where: '$code = ?', whereArgs: [c]);
    return result.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
  }

  // get activity by sub_Activity
  Future<List<ActivityModel>> getActivityBySubActivity(String subActivity) async {
    final db = await instance.database;
    final result = await db.query(tableName, where: '$sub_activity = ?', whereArgs: [subActivity]);
    return result.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
  }

  Future<List<ActivityModel>> getMainActivityBySubActivity(String subActivity) async {
    final db = await instance.database;
    final result = await db.query(tableName, where: '$sub_activity = ?', whereArgs: [subActivity]);
    return result.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
  }

  Future<List<ActivityModel>> getSubActivityByMainActivity(String activity) async {
    final db = await instance.database;
    final result = await db.query(tableName, where: '$main_activity = ?', whereArgs: [activity]);
    return result.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
  }

  Future<List<ActivityModel>> getAllData() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    // final Set<Map<String, dynamic>> uniqueResult = Set.from(result);
    // final List<Map<String, dynamic>> uniqueList = uniqueResult.toList();
    return result.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
  }

  Future<List<ActivityModel>> getAllSubActivityData() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    final Set<Map<String, dynamic>> uniqueResult = Set.from(result);
    final List<Map<String, dynamic>> uniqueList = uniqueResult.toList();
    return uniqueList.isNotEmpty
        ? result.map((json) => activityFromJsonM(jsonEncode(json))).toList()
        : [];
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
