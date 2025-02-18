import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/rehab_assistant_model.dart';

class RehabAssistantDatabaseHelper {
  static final RehabAssistantDatabaseHelper instance =
  RehabAssistantDatabaseHelper._init();

  static Database? _database;

  RehabAssistantDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('rehab_assistant.db');
    return _database!;
  }

  // Table and Column Definitions
  static const String tableName = "rehab_assistant";


  final String rehabName = 'rehab_name';
  final String rehabCode = 'rehab_code';
  final String phoneNumber = 'phone_number';
  final String salaryBankName = 'salary_bank_name';
  final String bankAccountNumber = 'bank_account_number';
  final String gender = 'gender';
  final String ssnitNumber = 'ssnit_number';
  final String momoNumber = 'momo_number';
  final String momoAccountName = 'momo_account_name';
  final String dob = 'dob';
  final String poFirstName = 'po_first_name';
  final String poLastName = 'po_last_name';
  final String districtName = 'district_name';
  final String districtId = 'district_id';
  final String image = 'image';
  final String paymentOption = 'payment_option';
  final String designation = 'designation';
  final String regionId = 'region_id';
  final String regionName = 'region_name';
  final String staffId = 'staff_id';
  final String po = 'po';

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
        $rehabName TEXT,
        $rehabCode INTEGER,
        $phoneNumber TEXT,
        $salaryBankName TEXT,
        $bankAccountNumber TEXT,
        $gender TEXT,
        $ssnitNumber TEXT,
        $momoNumber TEXT,
        $momoAccountName TEXT,
        $dob TEXT,
        $poFirstName TEXT,
        $poLastName TEXT,
        $districtName TEXT,
        $districtId INTEGER,
        $image TEXT,
        $paymentOption TEXT,
        $designation TEXT,
        $regionId TEXT,
        $regionName TEXT,
        $staffId TEXT,
        $po TEXT
      )
    ''');
  }

  Future<int> saveData(RehabAssistantModel data) async {
    final db = await instance.database;
    return await db.insert(tableName, data.toJson());
  }

  Future<List<RehabAssistantModel>> getAllData() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => RehabAssistantModel.fromJson(json)).toList();
  }

  Future<RehabAssistantModel?> getDataById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$this.id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty
        ? RehabAssistantModel.fromJson(result.first)
        : null;
  }

  Future<RehabAssistantModel?> getRehabAssistantByRehabCode(code) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$rehabCode = ?',
      whereArgs: [code],
    );
    return result.isNotEmpty
        ? RehabAssistantModel.fromJson(result.first)
        : null;
  }

  Future<int> deleteData(int id) async {
    final db = await instance.database;
    return await db.delete(tableName, where: '$this.id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete(tableName);
  }

  Future<int> bulkInsertData(List<RehabAssistantModel> allData) async {
    final db = await instance.database;
    int count = 0;
    await db.transaction((txn) async {
      for (final data in allData) {
        final dataMap = data.toJson();
        await txn.insert(tableName, dataMap);
        count++;
      }
    });
    return count;
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
