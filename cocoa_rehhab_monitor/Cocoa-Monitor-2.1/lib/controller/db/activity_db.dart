import 'dart:convert';

import 'package:cocoa_monitor/controller/model/activity_model.dart';
import 'package:cocoa_monitor/controller/model/contractor_certificate_of_workdone_model.dart';
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
    print('THIS IS Contractor Certificate Verification DATA DETAILS:::: $data');
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
       dataMap.remove("required_equipment");

        await txn.insert(tableName, dataMap);
        count++;
      }
    });
    return count;
  }


  // Future<List<Map<String, dynamic>>?> getDataByFarmRef(String ref) async {
  //   final db = await instance.database;
  //   final result = await db.query(
  //     tableName,
  //     where: '$farm_ref_number = ?',
  //     whereArgs: [ref],
  //   );
  //   return result.isNotEmpty ? result : null;
  // }
  //
  //
  // Future<List<ContractorCertificateVerificationModel>>? getPendingData()async{
  //   final db = await instance.database;
  //   int s = 0;
  //   final result = await db.query(
  //     tableName,
  //     where: '$submission_status = ?',
  //     whereArgs: [s],
  //   );
  //   return result.isNotEmpty
  //       ? result.map((json) => ContractorCertificateVerificationModel.fromJson(json)).toList()
  //       : [];
  // }
  //
  // Future<List<ContractorCertificateVerificationModel>>? getSubmittedData()async{
  //   final db = await instance.database;
  //   int s = 1;
  //   final result = await db.query(
  //     tableName,
  //     where: '$submission_status = ?',
  //     whereArgs: [s],
  //   );
  //   return result.isNotEmpty
  //       ? result.map((json) => ContractorCertificateVerificationModel.fromJson(json)).toList()
  //       : [];
  // }
  //
  // Future<List<Map<String, dynamic>>> getDataByStatus(int status)async{
  //   final db = await instance.database;
  //   final result = await db.query(
  //     tableName,
  //     where: '$submission_status = ?',
  //     whereArgs: [status],
  //   );
  //   return result;
  // }


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

  Future<List<ActivityModel>> getSubActivityByCode(int code) async {
    final db = await instance.database;
    final result = await db.query(tableName, where: '$code = ?', whereArgs: [code]);
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

  // Future<List<ContractorCertificateVerificationModel>> getAllDataWithLimitAndStatus(int limit, int status) async {
  //   final db = await instance.database;
  //   final result = await db.query(tableName, limit: limit, where: '$status = ?', whereArgs: [status]);
  //   return result.isNotEmpty
  //       ? result.map((json) => ContractorCertificateVerificationModel.fromJson(json)).toList()
  //       : [];
  // }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete(tableName);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
