import 'package:cocoa_rehab_monitor/controller/model/contractor_certificate_of_workdone_verification_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContractorCertificateVerificationDatabaseHelper {
  static final ContractorCertificateVerificationDatabaseHelper instance = ContractorCertificateVerificationDatabaseHelper._init();

  static Database? _database;

  ContractorCertificateVerificationDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('contractor_certificate_verification.db');
    return _database!;
  }

  static const String uid = 'uid';
  static const String current_year = "current_year";
  static const String current_month = "current_month";
  static const String current_week = "currrent_week";
  static const String sub_activity_string = "sub_activity_string";
  static const String main_activity = "main_activity";
  static const String activity = "activity";
  static const String reporting_date = "reporting_date";
  static const String farm_ref_number = "farm_ref_number";
  static const String farm_size_ha = "farm_size_ha";
  static const String community =  "community";
  static const String submission_status = "status";
  static const String district = "district";
  static const String userid = "userid";
  static const String lat = "lat";
  static const String lng = "lng";
  static const String accuracy = "accuracy";
  static const String current_farm_pic = "current_farm_pic";
  static const String contractor = "contractor";
  static const String completed_by = "completed_by";
  static const String tableName = "contractor_certificate_verification";

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
        $uid TEXT PRIMARY KEY,
        $current_year TEXT,
        $current_month TEXT,
        $current_week TEXT,
        $sub_activity_string TEXT,
        $main_activity INTEGER,
        $activity TEXT,
        $reporting_date TEXT,
        $farm_ref_number TEXT,
        $farm_size_ha REAL, 
        $community TEXT,
        $submission_status INTEGER,
        $district INTEGER,
        $userid INTEGER,
        $lat REAL,
        $lng REAL,
        $accuracy REAL,
        $current_farm_pic TEXT,
        $contractor INTEGER,
        $completed_by TEXT
      )
    ''');
  }

  Future<int> saveData(ContractorCertificateVerificationModel contractorCertificateVerification) async {
    Map<String, dynamic> data = contractorCertificateVerification.toJson();
    print('THIS IS Contractor Certificate Verification DATA DETAILS:::: $data');
    final db = await instance.database;
    return await db.insert(tableName, data);
  }

  Future<int> bulkInsertData(List<ContractorCertificateVerificationModel> allData) async {
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

  Future<List<Map<String, dynamic>>?> getDataByFarmRef(String ref) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$farm_ref_number = ?',
      whereArgs: [ref],
    );
    return result.isNotEmpty ? result : null;
  }


  Future<List<ContractorCertificateVerificationModel>>? getPendingData()async{
    final db = await instance.database;
    int s = 0;
    final result = await db.query(
      tableName,
      where: '$submission_status = ?',
      whereArgs: [s],
    );
    return result.isNotEmpty
        ? result.map((json) => ContractorCertificateVerificationModel.fromJson(json)).toList()
        : [];
  }

  Future<List<ContractorCertificateVerificationModel>>? getSubmittedData()async{
    final db = await instance.database;
    int s = 1;
    final result = await db.query(
      tableName,
      where: '$submission_status = ?',
      whereArgs: [s],
    );
    return result.isNotEmpty
        ? result.map((json) => ContractorCertificateVerificationModel.fromJson(json)).toList()
        : [];
  }

  Future<List<Map<String, dynamic>>> getDataByStatus(int status)async{
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$submission_status = ?',
      whereArgs: [status],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await instance.database;
    return await db.query(tableName);
  }

  Future<List<ContractorCertificateVerificationModel>> getAllDataWithLimitAndStatus(int limit, int status) async {
    final db = await instance.database;
    final result = await db.query(tableName, limit: limit, where: '$status = ?', whereArgs: [status]);
    return result.isNotEmpty
        ? result.map((json) => ContractorCertificateVerificationModel.fromJson(json)).toList()
        : [];
  }

  // delete data by uid
  Future<int> deleteData(String id) async {
    final db = await instance.database;
    return await db.delete(tableName, where: '$uid = ?', whereArgs: [id]);
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
