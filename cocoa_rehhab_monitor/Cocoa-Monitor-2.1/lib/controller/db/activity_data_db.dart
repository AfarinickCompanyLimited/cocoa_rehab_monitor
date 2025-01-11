import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/activity_data_model.dart';

class InitialTreatmentMonitorDatabaseHelper {
  static final InitialTreatmentMonitorDatabaseHelper instance =
  InitialTreatmentMonitorDatabaseHelper._init();

  static Database? _database;

  InitialTreatmentMonitorDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('initial_treatment_monitor.db');
    return _database!;
  }

  // Table and Column Definitions
  static const String tableName = "initial_treatment_monitor";

  final String uid = 'uid';
  final String agent = 'agent';
  final String activity = 'activity';
  final String mainActivity = 'main_activity';
  final String completionDate = 'completion_date';
  final String reportingDate = 'reporting_date';
  final String noRehabAssistants = 'no_rehab_assistants';
  final String areaCoveredHa = 'area_covered_ha';
  final String remark = 'remark';
  final String ras = 'ras';
  final String status = 'submission_status';
  final String farmRefNumber = 'farm_ref_number';
  final String farmSizeHa = 'farm_size_ha';
  final String community = 'community';
  final String numberOfPeopleInGroup = 'number_of_people_in_group';
  final String groupWork = 'group_work';
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
        $agent TEXT,
        $activity INTEGER,
        $mainActivity INTEGER,
        $completionDate TEXT,
        $reportingDate TEXT,
        $noRehabAssistants INTEGER,
        $areaCoveredHa REAL,
        $remark TEXT,
        $ras TEXT,
        $status INTEGER,
        $farmRefNumber TEXT,
        $farmSizeHa REAL,
        $community TEXT,
        $numberOfPeopleInGroup INTEGER,
        $groupWork TEXT,
        $sector INTEGER
      )
    ''');
  }

  Future<int> saveData(InitialTreatmentMonitorModel data) async {
    final db = await instance.database;
    return await db.insert(tableName, data.toJson());
  }

  Future<List<InitialTreatmentMonitorModel>> getAllData() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => InitialTreatmentMonitorModel.fromJson(json)).toList();
  }

  Future<InitialTreatmentMonitorModel?> getDataById(String id) async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      where: '$uid = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty
        ? InitialTreatmentMonitorModel.fromJson(result.first)
        : null;
  }

  Future<int> updateData(InitialTreatmentMonitorModel data) async {
    final db = await instance.database;
    return await db.update(
      tableName,
      data.toJson(),
      where: '$uid = ?',
      whereArgs: [data.uid],
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
