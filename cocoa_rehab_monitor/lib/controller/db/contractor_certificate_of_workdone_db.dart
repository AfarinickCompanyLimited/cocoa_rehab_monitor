import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/contractor_certificate_of_workdone_model.dart';

class ContractorCertificateDatabaseHelper {
  static final ContractorCertificateDatabaseHelper instance = ContractorCertificateDatabaseHelper._init();

  static Database? _database;

  ContractorCertificateDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('contractor_certificate.db');
    return _database!;
  }

  // Table and Column Definitions
  static const String tableName = "contractor_certificate";

  final String uid = 'uid';
  final String currentYear = 'current_year';
  final String currentMonth = 'current_month';
  final String currentWeek = 'currrent_week';
  final String activity = 'activity';
  final String reportingDate = 'reporting_date';
  final String farmRefNumber = 'farm_ref_number';
  final String farmSizeHa = 'farm_size_ha';
  final String community = 'community';
  final String contractor = 'contractor';
  final String status = 'submission_status';
  final String district = 'district';
  final String userId = 'userid';
  final String farmerName = 'farmer_name';
  final String roundsOfWeeding = 'weeding_rounds';
  final String subActivityString = 'sub_activity_string';
  final String mainActivity = 'main_activity';
  final String sector = 'sector';

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $uid TEXT PRIMARY KEY,
        $currentYear TEXT,
        $currentMonth TEXT,
        $currentWeek INTEGER,
        $activity TEXT,
        $reportingDate TEXT,
        $farmRefNumber INTEGER,
        $farmSizeHa REAL,
        $community TEXT,
        $contractor INTEGER,
        $status INTEGER,
        $district INTEGER,
        $userId INTEGER,
        $farmerName TEXT,
        $roundsOfWeeding INTEGER,
        $subActivityString TEXT,
        $mainActivity TEXT,
        $sector INTEGER
      )
    ''');
  }

  Future<int> saveData(ContractorCertificateModel contractorCertificateVerification) async {
    final db = await instance.database;
    return await db.insert(tableName, contractorCertificateVerification.toJson());
  }

  /// change toJson to toJsonOffline in-case this would be used offline
  // Future<int> bulkInsertData(List<ContractorCertificateModel> allData) async {
  //   final db = await instance.database;
  //   int count = 0;
  //   await db.transaction((txn) async {
  //     for (final data in allData) {
  //       await txn.insert(tableName, data.toJson());
  //       count++;
  //     }
  //   });
  //   return count;
  // }

  Future<List<Map<String, dynamic>>?> getDataByFarmRef(String ref) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$farmRefNumber = ?',
      whereArgs: [ref],
    );
    return result.isNotEmpty ? result : null;
  }

  Future<List<ContractorCertificateModel>> getPendingData() async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$status = ?',
      whereArgs: [0],
    );
    return result.isNotEmpty
        ? result.map((json) => ContractorCertificateModel.fromJson(json)).toList()
        : [];
  }

  Future<List<ContractorCertificateModel>> getSubmittedData() async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$status = ?',
      whereArgs: [1],
    );
    return result.isNotEmpty
        ? result.map((json) => ContractorCertificateModel.fromJson(json)).toList()
        : [];
  }

  Future<List<ContractorCertificateModel>> getAllData() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => ContractorCertificateModel.fromJson(json)).toList();
  }


  Future<List<ContractorCertificateModel>> getAllDataWithLimitAndStatus(int limit, int status) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$status = ?',
      whereArgs: [status],
      limit: limit,
    );
    return result.isNotEmpty
        ? result.map((json) => ContractorCertificateModel.fromJson(json)).toList()
        : [];
  }

  Future<int> updateData(ContractorCertificateModel contractorCertificate) async {
    final db = await instance.database;
    return await db.update(
      tableName,
      contractorCertificate.toJson(),
      where: '$uid = ?',
      whereArgs: [contractorCertificate.uid],
    );
  }

  Future<int> deleteData(String id) async {
    final db = await instance.database;
    return await db.delete(tableName, where: '$uid = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete(tableName);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
