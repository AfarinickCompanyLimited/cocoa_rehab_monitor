// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ActivityDao? _activityDaoInstance;

  FarmDao? _farmDaoInstance;

  PersonnelDao? _personnelDaoInstance;

  RegionDistrictDao? _regionDistrictDaoInstance;

  RehabAssistantDao? _rehabAssistantDaoInstance;

  ContractorDao? _contractorDaoInstance;

  PersonnelAssignmentDao? _personnelAssignmentDaoInstance;

  FarmStatusDao? _farmStatusDaoInstance;

  AssignedFarmDao? _assignedFarmDaoInstance;

  NotificationDao? _notificationDaoInstance;

  AssignedOutbreakDao? _assignedOutbreakDaoInstance;

  CommunityDao? _communityDaoInstance;

  CocoaTypeDao? _cocoaTypeDaoInstance;

  CocoaAgeClassDao? _cocoaAgeClassDaoInstance;

  OutbreakFarmDao? _outbreakFarmDaoInstance;

  CalculatedAreaDao? _calculatedAreaDaoInstance;

  POLocationDao? _poLocationDaoInstance;

  InitialTreatmentMonitorDao? _initialTreatmentMonitorDaoInstance;

  ContractorCertificateDao? _contractorCertificateDaoInstance;

  OutbreakFarmFromServerDao? _outbreakFarmFromServerDaoInstance;

  MaintenanceFuelDao? _maintenanceFuelDaoInstance;

  InitialTreatmentFuelDao? _initialTreatmentFuelDaoInstance;

  EquipmentDao? _equipmentDaoInstance;

  ContractorCertificateVerificationDao?
      _contractorCertificateVerificationDaoInstance;

  MapFarmDao? _mapFarmDaoInstance;

  SocietyDao? _societyDaoInstance;

  FarmerFromServerDao? _farmerFromServerDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Activity` (`code` INTEGER, `mainActivity` TEXT, `subActivity` TEXT, `requiredEquipment` INTEGER, PRIMARY KEY (`code`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Farm` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `farmCode` INTEGER, `farmId` TEXT, `farmerNam` TEXT, `districtId` INTEGER, `districtName` TEXT, `regionId` TEXT, `regionName` TEXT, `farmSize` REAL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Personnel` (`uid` TEXT, `agent` TEXT, `submissionDate` TEXT, `lat` REAL, `lng` REAL, `accuracy` REAL, `designation` TEXT, `name` TEXT, `gender` TEXT, `dob` TEXT, `contact` TEXT, `region` TEXT, `district` INTEGER, `ssnitNumber` TEXT, `salaryBankName` TEXT, `bankBranch` TEXT, `bankAccountNumber` TEXT, `paymentOption` TEXT, `photoStaff` BLOB, `status` INTEGER, `isOwnerOfMomo` TEXT, `momoAccountName` TEXT, `momoNumber` TEXT, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RegionDistrict` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `districtId` INTEGER, `districtName` TEXT, `regionId` TEXT, `regionName` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RehabAssistant` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `rehabName` TEXT, `rehabCode` INTEGER, `phoneNumber` TEXT, `salaryBankName` TEXT, `bankAccountNumber` TEXT, `gender` TEXT, `ssnitNumber` TEXT, `momoNumber` TEXT, `momoAccountName` TEXT, `dob` TEXT, `poFirstName` TEXT, `poLastName` TEXT, `districtName` TEXT, `districtId` INTEGER, `image` TEXT, `paymentOption` TEXT, `designation` TEXT, `regionId` TEXT, `regionName` TEXT, `staffId` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Contractor` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `contractorName` TEXT, `contractorId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PersonnelAssignment` (`uid` TEXT, `farmid` TEXT, `activity` INTEGER, `rehabAssistants` TEXT, `rehabAssistantsObject` TEXT, `assignedDate` TEXT, `blocks` TEXT, `agent` INTEGER, `status` INTEGER, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FarmStatus` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `farmid` TEXT, `location` TEXT, `activity` TEXT, `area` REAL, `areaCovered` REAL, `farmerName` TEXT, `status` TEXT, `month` TEXT, `year` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AssignedFarm` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `farmBoundary` BLOB, `farmername` TEXT, `location` TEXT, `farmReference` TEXT, `farmSize` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `NotificationData` (`id` TEXT NOT NULL, `title` TEXT, `message` TEXT, `date` INTEGER NOT NULL, `read` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AssignedOutbreak` (`obId` INTEGER, `obCode` TEXT, `obSize` TEXT, `districtId` INTEGER, `districtName` TEXT, `regionId` TEXT, `regionName` TEXT, `obBoundary` BLOB, PRIMARY KEY (`obId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Community` (`communityId` INTEGER, `operationalArea` TEXT, `community` TEXT, `districtId` INTEGER, `districtName` TEXT, `regionId` TEXT, `regionName` TEXT, PRIMARY KEY (`communityId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CocoaType` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CocoaAgeClass` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OutbreakFarm` (`uid` TEXT, `agent` INTEGER, `inspectionDate` TEXT, `outbreaksForeignkey` INTEGER, `farmboundary` BLOB, `farmerName` TEXT, `farmerAge` INTEGER, `idType` TEXT, `idNumber` TEXT, `farmerContact` TEXT, `cocoaType` TEXT, `ageClass` TEXT, `farmArea` REAL, `communitytblForeignkey` INTEGER, `status` INTEGER, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CalculatedArea` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL, `title` TEXT NOT NULL, `value` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PoLocation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `lat` REAL NOT NULL, `lng` REAL NOT NULL, `accuracy` INTEGER NOT NULL, `uid` TEXT NOT NULL, `userid` INTEGER NOT NULL, `inspectionDate` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `InitialTreatmentMonitor` (`uid` TEXT, `agent` TEXT, `staffContact` TEXT, `mainActivity` INTEGER, `activity` INTEGER, `monitoringDate` TEXT, `noRehabAssistants` INTEGER, `areaCoveredHa` REAL, `remark` TEXT, `lat` REAL, `lng` REAL, `accuracy` REAL, `currentFarmPic` BLOB, `ras` TEXT, `status` INTEGER, `farmRefNumber` TEXT, `farmSizeHa` REAL, `cocoaSeedlingsAlive` INTEGER, `plantainSeedlingsAlive` INTEGER, `nameOfChedTa` TEXT, `contactOfChedTa` TEXT, `community` INTEGER, `operationalArea` TEXT, `contractorName` TEXT, `numberOfPeopleInGroup` INTEGER, `groupWork` TEXT, `completedByContractor` TEXT, `areaCoveredRx` TEXT, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ContractorCertificate` (`uid` TEXT, `currentYear` TEXT, `currentMonth` TEXT, `currrentWeek` TEXT, `mainActivity` INTEGER, `activity` TEXT NOT NULL, `reportingDate` TEXT, `farmRefNumber` TEXT, `farmSizeHa` REAL, `community` TEXT, `contractor` INTEGER, `status` INTEGER, `district` INTEGER, `userId` INTEGER, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OutbreakFarmFromServer` (`farmId` INTEGER, `outbreaksId` TEXT, `farmLocation` TEXT, `farmerName` TEXT, `farmerAge` INTEGER, `idType` TEXT, `idNumber` TEXT, `farmerContact` TEXT, `cocoaType` TEXT, `ageClass` TEXT, `farmArea` REAL, `communitytbl` TEXT, `inspectionDate` TEXT, `tempCode` TEXT, PRIMARY KEY (`farmId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MaintenanceFuel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userid` INTEGER, `farmdetailstblForeignkey` INTEGER, `dateReceived` TEXT, `rehabassistantsTblForeignkey` INTEGER, `fuelLtr` INTEGER, `remarks` TEXT, `uid` TEXT, `status` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `InitialTreatmentFuel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userid` INTEGER, `farmdetailstblForeignkey` INTEGER, `dateReceived` TEXT, `rehabassistantsTblForeignkey` INTEGER, `fuelLtr` INTEGER, `remarks` TEXT, `uid` TEXT, `status` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Equipment` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `equipmentCode` TEXT, `dateOfCapturing` INTEGER NOT NULL, `equipment` TEXT, `status` TEXT, `serialNumber` TEXT, `manufacturer` TEXT, `picSerialNumber` TEXT, `picEquipment` TEXT, `staffName` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ContractorCertificateVerification` (`uid` TEXT, `currentYear` TEXT, `currentMonth` TEXT, `currrentWeek` TEXT, `mainActivity` INTEGER, `activity` TEXT NOT NULL, `reportingDate` TEXT, `farmRefNumber` TEXT, `farmSizeHa` REAL, `community` TEXT, `status` INTEGER, `district` INTEGER, `userId` INTEGER, `lat` REAL, `lng` REAL, `accuracy` REAL, `currentFarmPic` TEXT, `contractor` INTEGER, `completedBy` TEXT, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MapFarm` (`uid` TEXT, `userid` TEXT, `farmboundary` BLOB, `farmerName` TEXT, `farmerContact` TEXT, `farmSize` REAL, `location` TEXT, `region` TEXT, `farmReference` TEXT, `status` INTEGER, PRIMARY KEY (`uid`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Society` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `societyCode` INTEGER, `societyName` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FarmerFromServer` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `farmerName` TEXT, `farmerId` INTEGER, `farmerCode` TEXT, `phoneNumber` TEXT, `societyName` TEXT, `nationalIdNumber` TEXT, `numberOfCocoaFarms` INTEGER, `numberOfCertifiedCrops` INTEGER, `cocoaBagsHarvestedPreviousYear` INTEGER, `cocoaBagsSoldToGroup` INTEGER, `currentYearYieldEstimate` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ActivityDao get activityDao {
    return _activityDaoInstance ??= _$ActivityDao(database, changeListener);
  }

  @override
  FarmDao get farmDao {
    return _farmDaoInstance ??= _$FarmDao(database, changeListener);
  }

  @override
  PersonnelDao get personnelDao {
    return _personnelDaoInstance ??= _$PersonnelDao(database, changeListener);
  }

  @override
  RegionDistrictDao get regionDistrictDao {
    return _regionDistrictDaoInstance ??=
        _$RegionDistrictDao(database, changeListener);
  }

  @override
  RehabAssistantDao get rehabAssistantDao {
    return _rehabAssistantDaoInstance ??=
        _$RehabAssistantDao(database, changeListener);
  }

  @override
  ContractorDao get contractorDao {
    return _contractorDaoInstance ??= _$ContractorDao(database, changeListener);
  }

  @override
  PersonnelAssignmentDao get personnelAssignmentDao {
    return _personnelAssignmentDaoInstance ??=
        _$PersonnelAssignmentDao(database, changeListener);
  }

  @override
  FarmStatusDao get farmStatusDao {
    return _farmStatusDaoInstance ??= _$FarmStatusDao(database, changeListener);
  }

  @override
  AssignedFarmDao get assignedFarmDao {
    return _assignedFarmDaoInstance ??=
        _$AssignedFarmDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }

  @override
  AssignedOutbreakDao get assignedOutbreakDao {
    return _assignedOutbreakDaoInstance ??=
        _$AssignedOutbreakDao(database, changeListener);
  }

  @override
  CommunityDao get communityDao {
    return _communityDaoInstance ??= _$CommunityDao(database, changeListener);
  }

  @override
  CocoaTypeDao get cocoaTypeDao {
    return _cocoaTypeDaoInstance ??= _$CocoaTypeDao(database, changeListener);
  }

  @override
  CocoaAgeClassDao get cocoaAgeClassDao {
    return _cocoaAgeClassDaoInstance ??=
        _$CocoaAgeClassDao(database, changeListener);
  }

  @override
  OutbreakFarmDao get outbreakFarmDao {
    return _outbreakFarmDaoInstance ??=
        _$OutbreakFarmDao(database, changeListener);
  }

  @override
  CalculatedAreaDao get calculatedAreaDao {
    return _calculatedAreaDaoInstance ??=
        _$CalculatedAreaDao(database, changeListener);
  }

  @override
  POLocationDao get poLocationDao {
    return _poLocationDaoInstance ??= _$POLocationDao(database, changeListener);
  }

  @override
  InitialTreatmentMonitorDao get initialTreatmentMonitorDao {
    return _initialTreatmentMonitorDaoInstance ??=
        _$InitialTreatmentMonitorDao(database, changeListener);
  }

  @override
  ContractorCertificateDao get contractorCertificateDao {
    return _contractorCertificateDaoInstance ??=
        _$ContractorCertificateDao(database, changeListener);
  }

  @override
  OutbreakFarmFromServerDao get outbreakFarmFromServerDao {
    return _outbreakFarmFromServerDaoInstance ??=
        _$OutbreakFarmFromServerDao(database, changeListener);
  }

  @override
  MaintenanceFuelDao get maintenanceFuelDao {
    return _maintenanceFuelDaoInstance ??=
        _$MaintenanceFuelDao(database, changeListener);
  }

  @override
  InitialTreatmentFuelDao get initialTreatmentFuelDao {
    return _initialTreatmentFuelDaoInstance ??=
        _$InitialTreatmentFuelDao(database, changeListener);
  }

  @override
  EquipmentDao get equipmentDao {
    return _equipmentDaoInstance ??= _$EquipmentDao(database, changeListener);
  }

  @override
  ContractorCertificateVerificationDao
      get contractorCertificateVerificationDao {
    return _contractorCertificateVerificationDaoInstance ??=
        _$ContractorCertificateVerificationDao(database, changeListener);
  }

  @override
  MapFarmDao get mapFarmDao {
    return _mapFarmDaoInstance ??= _$MapFarmDao(database, changeListener);
  }

  @override
  SocietyDao get societyDao {
    return _societyDaoInstance ??= _$SocietyDao(database, changeListener);
  }

  @override
  FarmerFromServerDao get farmerFromServerDao {
    return _farmerFromServerDaoInstance ??=
        _$FarmerFromServerDao(database, changeListener);
  }
}

class _$ActivityDao extends ActivityDao {
  _$ActivityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _activityInsertionAdapter = InsertionAdapter(
            database,
            'Activity',
            (Activity item) => <String, Object?>{
                  'code': item.code,
                  'mainActivity': item.mainActivity,
                  'subActivity': item.subActivity,
                  'requiredEquipment': item.requiredEquipment == null
                      ? null
                      : (item.requiredEquipment! ? 1 : 0)
                },
            changeListener),
        _activityDeletionAdapter = DeletionAdapter(
            database,
            'Activity',
            ['code'],
            (Activity item) => <String, Object?>{
                  'code': item.code,
                  'mainActivity': item.mainActivity,
                  'subActivity': item.subActivity,
                  'requiredEquipment': item.requiredEquipment == null
                      ? null
                      : (item.requiredEquipment! ? 1 : 0)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Activity> _activityInsertionAdapter;

  final DeletionAdapter<Activity> _activityDeletionAdapter;

  @override
  Stream<List<Activity>> findAllActivityStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Activity',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        queryableName: 'Activity',
        isView: false);
  }

  @override
  Future<List<Activity>> findAllActivity() async {
    return _queryAdapter.queryList('SELECT * FROM Activity',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0));
  }

  @override
  Future<List<Activity>> findAllMainActivity() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT mainActivity FROM Activity ORDER BY mainActivity ASC',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0));
  }

  @override
  Future<List<Activity>> findAllSubActivity() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT subActivity FROM Activity ORDER BY subActivity ASC',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0));
  }

  @override
  Future<List<Activity>> findAllActivityWithIdList(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM Activity WHERE code IN (' + _sqliteVariablesForIds + ')',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        arguments: [...ids]);
  }

  @override
  Future<List<Activity>> findAllActivityWithCodeList(List<int> code) async {
    const offset = 1;
    final _sqliteVariablesForCode =
        Iterable<String>.generate(code.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM Activity WHERE code IN (' +
            _sqliteVariablesForCode +
            ')',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        arguments: [...code]);
  }

  @override
  Future<List<Activity>> findAllActivityWithCodeList2(List<int> code) async {
    const offset = 1;
    final _sqliteVariablesForCode =
        Iterable<String>.generate(code.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT DISTINCT subActivity FROM Activity WHERE subActivity IN (' +
            _sqliteVariablesForCode +
            ')',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        arguments: [...code]);
  }

  @override
  Future<List<Activity>> findAllActivityWithMainActivityList(
      List<String> mainActivityList) async {
    const offset = 1;
    final _sqliteVariablesForMainActivityList = Iterable<String>.generate(
        mainActivityList.length, (i) => '?${i + offset}').join(',');
    return _queryAdapter.queryList(
        'SELECT DISTINCT mainActivity FROM Activity WHERE mainActivity IN (' +
            _sqliteVariablesForMainActivityList +
            ')',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        arguments: [...mainActivityList]);
  }

  @override
  Future<List<Activity>> nfindAllActivityWithMainActivityList(
      List<int> mainActivityList) async {
    const offset = 1;
    final _sqliteVariablesForMainActivityList = Iterable<String>.generate(
        mainActivityList.length, (i) => '?${i + offset}').join(',');
    return _queryAdapter.queryList(
        'SELECT DISTINCT mainActivity FROM Activity WHERE mainActivity IN (' +
            _sqliteVariablesForMainActivityList +
            ')',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        arguments: [...mainActivityList]);
  }

  @override
  Future<List<Activity>> findSubActivities(String mainActivity) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Activity WHERE mainActivity = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        arguments: [mainActivity]);
  }

  @override
  Future<List<Activity>> findActivityByCode(int code) async {
    return _queryAdapter.queryList('SELECT * FROM Activity WHERE code = ?1',
        mapper: (Map<String, Object?> row) => Activity(
            code: row['code'] as int?,
            mainActivity: row['mainActivity'] as String?,
            subActivity: row['subActivity'] as String?,
            requiredEquipment: row['requiredEquipment'] == null
                ? null
                : (row['requiredEquipment'] as int) != 0),
        arguments: [code]);
  }

  @override
  Future<int?> deleteActivityByCode(String code) async {
    return _queryAdapter.query('DELETE FROM Activity WHERE code = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [code]);
  }

  @override
  Future<void> deleteAllActivity() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Activity');
  }

  @override
  Future<void> insertActivity(Activity activity) async {
    await _activityInsertionAdapter.insert(
        activity, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertActivity(List<Activity> activityList) {
    return _activityInsertionAdapter.insertListAndReturnIds(
        activityList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteActivities(Activity activity) {
    return _activityDeletionAdapter.deleteAndReturnChangedRows(activity);
  }
}

class _$FarmDao extends FarmDao {
  _$FarmDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _farmInsertionAdapter = InsertionAdapter(
            database,
            'Farm',
            (Farm item) => <String, Object?>{
                  'id': item.id,
                  'farmCode': item.farmCode,
                  'farmId': item.farmId,
                  'farmerNam': item.farmerNam,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName,
                  'farmSize': item.farmSize
                },
            changeListener),
        _farmDeletionAdapter = DeletionAdapter(
            database,
            'Farm',
            ['id'],
            (Farm item) => <String, Object?>{
                  'id': item.id,
                  'farmCode': item.farmCode,
                  'farmId': item.farmId,
                  'farmerNam': item.farmerNam,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName,
                  'farmSize': item.farmSize
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Farm> _farmInsertionAdapter;

  final DeletionAdapter<Farm> _farmDeletionAdapter;

  @override
  Stream<List<Farm>> findAllFarmStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Farm',
        mapper: (Map<String, Object?> row) => Farm(
            id: row['id'] as int?,
            farmCode: row['farmCode'] as int?,
            farmId: row['farmId'] as String?,
            farmerNam: row['farmerNam'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            farmSize: row['farmSize'] as double?),
        queryableName: 'Farm',
        isView: false);
  }

  @override
  Future<List<Farm>> findAllFarm() async {
    return _queryAdapter.queryList('SELECT * FROM Farm',
        mapper: (Map<String, Object?> row) => Farm(
            id: row['id'] as int?,
            farmCode: row['farmCode'] as int?,
            farmId: row['farmId'] as String?,
            farmerNam: row['farmerNam'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            farmSize: row['farmSize'] as double?));
  }

  @override
  Future<List<Farm>> findFarmsInDistrict(String districtName) async {
    return _queryAdapter.queryList('SELECT * FROM Farm WHERE districtName = ?1',
        mapper: (Map<String, Object?> row) => Farm(
            id: row['id'] as int?,
            farmCode: row['farmCode'] as int?,
            farmId: row['farmId'] as String?,
            farmerNam: row['farmerNam'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            farmSize: row['farmSize'] as double?),
        arguments: [districtName]);
  }

  @override
  Future<List<Farm>> findFarmsInRegion(String regionName) async {
    return _queryAdapter.queryList('SELECT * FROM Farm WHERE regionName = ?1',
        mapper: (Map<String, Object?> row) => Farm(
            id: row['id'] as int?,
            farmCode: row['farmCode'] as int?,
            farmId: row['farmId'] as String?,
            farmerNam: row['farmerNam'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            farmSize: row['farmSize'] as double?),
        arguments: [regionName]);
  }

  @override
  Future<List<Farm>> findFarmByFarmId(String farmId) async {
    return _queryAdapter.queryList('SELECT * FROM Farm WHERE farmId = ?1',
        mapper: (Map<String, Object?> row) => Farm(
            id: row['id'] as int?,
            farmCode: row['farmCode'] as int?,
            farmId: row['farmId'] as String?,
            farmerNam: row['farmerNam'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            farmSize: row['farmSize'] as double?),
        arguments: [farmId]);
  }

  @override
  Future<List<Farm>> findFarmByFarmCode(int farmCode) async {
    return _queryAdapter.queryList('SELECT * FROM Farm WHERE farmCode = ?1',
        mapper: (Map<String, Object?> row) => Farm(
            id: row['id'] as int?,
            farmCode: row['farmCode'] as int?,
            farmId: row['farmId'] as String?,
            farmerNam: row['farmerNam'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            farmSize: row['farmSize'] as double?),
        arguments: [farmCode]);
  }

  @override
  Future<int?> deleteFarmByCode(String farmCode) async {
    return _queryAdapter.query('DELETE FROM Farm WHERE farmCode = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [farmCode]);
  }

  @override
  Future<void> deleteAllFarms() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Farm');
  }

  @override
  Future<void> insertFarm(Farm farm) async {
    await _farmInsertionAdapter.insert(farm, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertFarm(List<Farm> farmList) {
    return _farmInsertionAdapter.insertListAndReturnIds(
        farmList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteFarm(Farm farm) {
    return _farmDeletionAdapter.deleteAndReturnChangedRows(farm);
  }
}

class _$PersonnelDao extends PersonnelDao {
  _$PersonnelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _personnelInsertionAdapter = InsertionAdapter(
            database,
            'Personnel',
            (Personnel item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'submissionDate': item.submissionDate,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'designation': item.designation,
                  'name': item.name,
                  'gender': item.gender,
                  'dob': item.dob,
                  'contact': item.contact,
                  'region': item.region,
                  'district': item.district,
                  'ssnitNumber': item.ssnitNumber,
                  'salaryBankName': item.salaryBankName,
                  'bankBranch': item.bankBranch,
                  'bankAccountNumber': item.bankAccountNumber,
                  'paymentOption': item.paymentOption,
                  'photoStaff': item.photoStaff,
                  'status': item.status,
                  'isOwnerOfMomo': item.isOwnerOfMomo,
                  'momoAccountName': item.momoAccountName,
                  'momoNumber': item.momoNumber
                },
            changeListener),
        _personnelUpdateAdapter = UpdateAdapter(
            database,
            'Personnel',
            ['uid'],
            (Personnel item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'submissionDate': item.submissionDate,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'designation': item.designation,
                  'name': item.name,
                  'gender': item.gender,
                  'dob': item.dob,
                  'contact': item.contact,
                  'region': item.region,
                  'district': item.district,
                  'ssnitNumber': item.ssnitNumber,
                  'salaryBankName': item.salaryBankName,
                  'bankBranch': item.bankBranch,
                  'bankAccountNumber': item.bankAccountNumber,
                  'paymentOption': item.paymentOption,
                  'photoStaff': item.photoStaff,
                  'status': item.status,
                  'isOwnerOfMomo': item.isOwnerOfMomo,
                  'momoAccountName': item.momoAccountName,
                  'momoNumber': item.momoNumber
                },
            changeListener),
        _personnelDeletionAdapter = DeletionAdapter(
            database,
            'Personnel',
            ['uid'],
            (Personnel item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'submissionDate': item.submissionDate,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'designation': item.designation,
                  'name': item.name,
                  'gender': item.gender,
                  'dob': item.dob,
                  'contact': item.contact,
                  'region': item.region,
                  'district': item.district,
                  'ssnitNumber': item.ssnitNumber,
                  'salaryBankName': item.salaryBankName,
                  'bankBranch': item.bankBranch,
                  'bankAccountNumber': item.bankAccountNumber,
                  'paymentOption': item.paymentOption,
                  'photoStaff': item.photoStaff,
                  'status': item.status,
                  'isOwnerOfMomo': item.isOwnerOfMomo,
                  'momoAccountName': item.momoAccountName,
                  'momoNumber': item.momoNumber
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Personnel> _personnelInsertionAdapter;

  final UpdateAdapter<Personnel> _personnelUpdateAdapter;

  final DeletionAdapter<Personnel> _personnelDeletionAdapter;

  @override
  Stream<List<Personnel>> findAllPersonnelStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Personnel',
        mapper: (Map<String, Object?> row) => Personnel(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            submissionDate: row['submissionDate'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            designation: row['designation'] as String?,
            name: row['name'] as String?,
            gender: row['gender'] as String?,
            dob: row['dob'] as String?,
            contact: row['contact'] as String?,
            region: row['region'] as String?,
            district: row['district'] as int?,
            ssnitNumber: row['ssnitNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankBranch: row['bankBranch'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            paymentOption: row['paymentOption'] as String?,
            photoStaff: row['photoStaff'] as Uint8List?,
            status: row['status'] as int?,
            isOwnerOfMomo: row['isOwnerOfMomo'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            momoNumber: row['momoNumber'] as String?),
        queryableName: 'Personnel',
        isView: false);
  }

  @override
  Future<List<Personnel>> findAllPersonnel() async {
    return _queryAdapter.queryList('SELECT * FROM Personnel',
        mapper: (Map<String, Object?> row) => Personnel(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            submissionDate: row['submissionDate'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            designation: row['designation'] as String?,
            name: row['name'] as String?,
            gender: row['gender'] as String?,
            dob: row['dob'] as String?,
            contact: row['contact'] as String?,
            region: row['region'] as String?,
            district: row['district'] as int?,
            ssnitNumber: row['ssnitNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankBranch: row['bankBranch'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            paymentOption: row['paymentOption'] as String?,
            photoStaff: row['photoStaff'] as Uint8List?,
            status: row['status'] as int?,
            isOwnerOfMomo: row['isOwnerOfMomo'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            momoNumber: row['momoNumber'] as String?));
  }

  @override
  Future<List<Personnel>> findPersonnelWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList('SELECT * FROM Personnel LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => Personnel(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            submissionDate: row['submissionDate'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            designation: row['designation'] as String?,
            name: row['name'] as String?,
            gender: row['gender'] as String?,
            dob: row['dob'] as String?,
            contact: row['contact'] as String?,
            region: row['region'] as String?,
            district: row['district'] as int?,
            ssnitNumber: row['ssnitNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankBranch: row['bankBranch'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            paymentOption: row['paymentOption'] as String?,
            photoStaff: row['photoStaff'] as Uint8List?,
            status: row['status'] as int?,
            isOwnerOfMomo: row['isOwnerOfMomo'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            momoNumber: row['momoNumber'] as String?),
        arguments: [limit, offset]);
  }

  @override
  Stream<List<Personnel>> findPersonnelByStatusStream(int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Personnel WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Personnel(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            submissionDate: row['submissionDate'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            designation: row['designation'] as String?,
            name: row['name'] as String?,
            gender: row['gender'] as String?,
            dob: row['dob'] as String?,
            contact: row['contact'] as String?,
            region: row['region'] as String?,
            district: row['district'] as int?,
            ssnitNumber: row['ssnitNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankBranch: row['bankBranch'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            paymentOption: row['paymentOption'] as String?,
            photoStaff: row['photoStaff'] as Uint8List?,
            status: row['status'] as int?,
            isOwnerOfMomo: row['isOwnerOfMomo'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            momoNumber: row['momoNumber'] as String?),
        arguments: [status],
        queryableName: 'Personnel',
        isView: false);
  }

  @override
  Future<List<Personnel>> findPersonnelByStatus(int status) async {
    return _queryAdapter.queryList('SELECT * FROM Personnel WHERE status = ?1',
        mapper: (Map<String, Object?> row) => Personnel(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            submissionDate: row['submissionDate'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            designation: row['designation'] as String?,
            name: row['name'] as String?,
            gender: row['gender'] as String?,
            dob: row['dob'] as String?,
            contact: row['contact'] as String?,
            region: row['region'] as String?,
            district: row['district'] as int?,
            ssnitNumber: row['ssnitNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankBranch: row['bankBranch'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            paymentOption: row['paymentOption'] as String?,
            photoStaff: row['photoStaff'] as Uint8List?,
            status: row['status'] as int?,
            isOwnerOfMomo: row['isOwnerOfMomo'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            momoNumber: row['momoNumber'] as String?),
        arguments: [status]);
  }

  @override
  Future<List<Personnel>> findPersonnelByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Personnel WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => Personnel(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            submissionDate: row['submissionDate'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            designation: row['designation'] as String?,
            name: row['name'] as String?,
            gender: row['gender'] as String?,
            dob: row['dob'] as String?,
            contact: row['contact'] as String?,
            region: row['region'] as String?,
            district: row['district'] as int?,
            ssnitNumber: row['ssnitNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankBranch: row['bankBranch'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            paymentOption: row['paymentOption'] as String?,
            photoStaff: row['photoStaff'] as Uint8List?,
            status: row['status'] as int?,
            isOwnerOfMomo: row['isOwnerOfMomo'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            momoNumber: row['momoNumber'] as String?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<Personnel>> findPersonnelByUID(String id) async {
    return _queryAdapter.queryList('SELECT * FROM Personnel WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => Personnel(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            submissionDate: row['submissionDate'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            designation: row['designation'] as String?,
            name: row['name'] as String?,
            gender: row['gender'] as String?,
            dob: row['dob'] as String?,
            contact: row['contact'] as String?,
            region: row['region'] as String?,
            district: row['district'] as int?,
            ssnitNumber: row['ssnitNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankBranch: row['bankBranch'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            paymentOption: row['paymentOption'] as String?,
            photoStaff: row['photoStaff'] as Uint8List?,
            status: row['status'] as int?,
            isOwnerOfMomo: row['isOwnerOfMomo'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            momoNumber: row['momoNumber'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> deletePersonnelByUID(String id) async {
    return _queryAdapter.query('DELETE FROM Personnel WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllPersonnel() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Personnel');
  }

  @override
  Future<int?> updatePersonnelSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE Personnel SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertPersonnel(Personnel personnel) async {
    await _personnelInsertionAdapter.insert(
        personnel, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertPersonnel(List<Personnel> personnelList) {
    return _personnelInsertionAdapter.insertListAndReturnIds(
        personnelList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePersonnel(Personnel personnel) async {
    await _personnelUpdateAdapter.update(personnel, OnConflictStrategy.abort);
  }

  @override
  Future<int> deletePersonnel(Personnel personnel) {
    return _personnelDeletionAdapter.deleteAndReturnChangedRows(personnel);
  }
}

class _$RegionDistrictDao extends RegionDistrictDao {
  _$RegionDistrictDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _regionDistrictInsertionAdapter = InsertionAdapter(
            database,
            'RegionDistrict',
            (RegionDistrict item) => <String, Object?>{
                  'id': item.id,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName
                }),
        _regionDistrictDeletionAdapter = DeletionAdapter(
            database,
            'RegionDistrict',
            ['id'],
            (RegionDistrict item) => <String, Object?>{
                  'id': item.id,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RegionDistrict> _regionDistrictInsertionAdapter;

  final DeletionAdapter<RegionDistrict> _regionDistrictDeletionAdapter;

  @override
  Future<List<RegionDistrict>> findAllRegionDistrict() async {
    return _queryAdapter.queryList('SELECT * FROM RegionDistrict',
        mapper: (Map<String, Object?> row) => RegionDistrict(
            id: row['id'] as int?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?));
  }

  @override
  Future<List<RegionDistrict>> findRegions() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT regionId, regionName FROM RegionDistrict ORDER BY regionName ASC',
        mapper: (Map<String, Object?> row) => RegionDistrict(
            id: row['id'] as int?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?));
  }

  @override
  Future<List<RegionDistrict>> findRegionDistrictByRegionName(
      String regionName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RegionDistrict WHERE regionName = ?1',
        mapper: (Map<String, Object?> row) => RegionDistrict(
            id: row['id'] as int?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [regionName]);
  }

  @override
  Future<List<RegionDistrict>> findRegionDistrictByRegionId(
      String regionId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RegionDistrict WHERE regionId = ?1',
        mapper: (Map<String, Object?> row) => RegionDistrict(
            id: row['id'] as int?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [regionId]);
  }

  @override
  Future<List<RegionDistrict>> findRegionDistrictByDistrictId(
      int districtId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RegionDistrict WHERE districtId = ?1',
        mapper: (Map<String, Object?> row) => RegionDistrict(
            id: row['id'] as int?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [districtId]);
  }

  @override
  Future<List<RegionDistrict>> findDistrictsInRegion(String regionName) async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT districtId, districtName FROM RegionDistrict WHERE regionName = ?1 ORDER BY districtName ASC',
        mapper: (Map<String, Object?> row) => RegionDistrict(id: row['id'] as int?, districtId: row['districtId'] as int?, districtName: row['districtName'] as String?, regionId: row['regionId'] as String?, regionName: row['regionName'] as String?),
        arguments: [regionName]);
  }

  @override
  Future<List<RegionDistrict>> findRegionDistrictByDistrictName(
      String districtName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RegionDistrict WHERE districtName = ?1',
        mapper: (Map<String, Object?> row) => RegionDistrict(
            id: row['id'] as int?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [districtName]);
  }

  @override
  Future<void> deleteAllRegionDistrict() async {
    await _queryAdapter.queryNoReturn('DELETE FROM RegionDistrict');
  }

  @override
  Future<void> insertRegionDistrict(RegionDistrict regionDistrict) async {
    await _regionDistrictInsertionAdapter.insert(
        regionDistrict, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertRegionDistrict(
      List<RegionDistrict> regionDistrictList) {
    return _regionDistrictInsertionAdapter.insertListAndReturnIds(
        regionDistrictList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteRegionDistrict(RegionDistrict regionDistrict) {
    return _regionDistrictDeletionAdapter
        .deleteAndReturnChangedRows(regionDistrict);
  }
}

class _$RehabAssistantDao extends RehabAssistantDao {
  _$RehabAssistantDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _rehabAssistantInsertionAdapter = InsertionAdapter(
            database,
            'RehabAssistant',
            (RehabAssistant item) => <String, Object?>{
                  'id': item.id,
                  'rehabName': item.rehabName,
                  'rehabCode': item.rehabCode,
                  'phoneNumber': item.phoneNumber,
                  'salaryBankName': item.salaryBankName,
                  'bankAccountNumber': item.bankAccountNumber,
                  'gender': item.gender,
                  'ssnitNumber': item.ssnitNumber,
                  'momoNumber': item.momoNumber,
                  'momoAccountName': item.momoAccountName,
                  'dob': item.dob,
                  'poFirstName': item.poFirstName,
                  'poLastName': item.poLastName,
                  'districtName': item.districtName,
                  'districtId': item.districtId,
                  'image': item.image,
                  'paymentOption': item.paymentOption,
                  'designation': item.designation,
                  'regionId': item.regionId,
                  'regionName': item.regionName,
                  'staffId': item.staffId
                },
            changeListener),
        _rehabAssistantDeletionAdapter = DeletionAdapter(
            database,
            'RehabAssistant',
            ['id'],
            (RehabAssistant item) => <String, Object?>{
                  'id': item.id,
                  'rehabName': item.rehabName,
                  'rehabCode': item.rehabCode,
                  'phoneNumber': item.phoneNumber,
                  'salaryBankName': item.salaryBankName,
                  'bankAccountNumber': item.bankAccountNumber,
                  'gender': item.gender,
                  'ssnitNumber': item.ssnitNumber,
                  'momoNumber': item.momoNumber,
                  'momoAccountName': item.momoAccountName,
                  'dob': item.dob,
                  'poFirstName': item.poFirstName,
                  'poLastName': item.poLastName,
                  'districtName': item.districtName,
                  'districtId': item.districtId,
                  'image': item.image,
                  'paymentOption': item.paymentOption,
                  'designation': item.designation,
                  'regionId': item.regionId,
                  'regionName': item.regionName,
                  'staffId': item.staffId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RehabAssistant> _rehabAssistantInsertionAdapter;

  final DeletionAdapter<RehabAssistant> _rehabAssistantDeletionAdapter;

  @override
  Stream<List<RehabAssistant>> findAllRehabAssistantStream() {
    return _queryAdapter.queryListStream('SELECT * FROM RehabAssistant',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        queryableName: 'RehabAssistant',
        isView: false);
  }

  @override
  Stream<List<RehabAssistant>> streamAllRehabAssistantWithNamesLike(
      String rehabName) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM RehabAssistant WHERE LOWER(rehabName) LIKE ?1 OR LOWER(staffId) LIKE ?1',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        arguments: [rehabName],
        queryableName: 'RehabAssistant',
        isView: false);
  }

  @override
  Future<List<RehabAssistant>> findAllRehabAssistants() async {
    return _queryAdapter.queryList('SELECT * FROM RehabAssistant',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?));
  }

  @override
  Future<List<RehabAssistant>> findRehabAssistantsWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RehabAssistant LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        arguments: [limit, offset]);
  }

  @override
  Future<List<RehabAssistant>> findRehabAssistantsWithSearchAndLimit(
    String searchTerm,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RehabAssistant WHERE LOWER(rehabName) LIKE ?1 OR LOWER(staffId) LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => RehabAssistant(id: row['id'] as int?, rehabName: row['rehabName'] as String?, rehabCode: row['rehabCode'] as int?, phoneNumber: row['phoneNumber'] as String?, salaryBankName: row['salaryBankName'] as String?, bankAccountNumber: row['bankAccountNumber'] as String?, gender: row['gender'] as String?, ssnitNumber: row['ssnitNumber'] as String?, momoNumber: row['momoNumber'] as String?, momoAccountName: row['momoAccountName'] as String?, dob: row['dob'] as String?, poFirstName: row['poFirstName'] as String?, poLastName: row['poLastName'] as String?, districtName: row['districtName'] as String?, districtId: row['districtId'] as int?, image: row['image'] as String?, paymentOption: row['paymentOption'] as String?, designation: row['designation'] as String?, regionId: row['regionId'] as String?, regionName: row['regionName'] as String?, staffId: row['staffId'] as String?),
        arguments: [searchTerm, limit, offset]);
  }

  @override
  Future<List<RehabAssistant>> findRehabAssistantsInDistrict(
      String districtName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RehabAssistant WHERE districtName = ?1',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        arguments: [districtName]);
  }

  @override
  Future<List<RehabAssistant>> findRehabAssistantsInRegion(
      String regionName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RehabAssistant WHERE regionName = ?1',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        arguments: [regionName]);
  }

  @override
  Future<List<RehabAssistant>> findRehabAssistantByRehabCode(
      int rehabCode) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RehabAssistant WHERE rehabCode = ?1',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        arguments: [rehabCode]);
  }

  @override
  Future<List<RehabAssistant>> findRehabAssistantsByRehabCodes(
      List<int> rehabCodes) async {
    const offset = 1;
    final _sqliteVariablesForRehabCodes =
        Iterable<String>.generate(rehabCodes.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM RehabAssistant WHERE rehabCode IN (' +
            _sqliteVariablesForRehabCodes +
            ')',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        arguments: [...rehabCodes]);
  }

  @override
  Future<List<RehabAssistant>> findRehabAssistantById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM RehabAssistant WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RehabAssistant(
            id: row['id'] as int?,
            rehabName: row['rehabName'] as String?,
            rehabCode: row['rehabCode'] as int?,
            phoneNumber: row['phoneNumber'] as String?,
            salaryBankName: row['salaryBankName'] as String?,
            bankAccountNumber: row['bankAccountNumber'] as String?,
            gender: row['gender'] as String?,
            ssnitNumber: row['ssnitNumber'] as String?,
            momoNumber: row['momoNumber'] as String?,
            momoAccountName: row['momoAccountName'] as String?,
            dob: row['dob'] as String?,
            poFirstName: row['poFirstName'] as String?,
            poLastName: row['poLastName'] as String?,
            districtName: row['districtName'] as String?,
            districtId: row['districtId'] as int?,
            image: row['image'] as String?,
            paymentOption: row['paymentOption'] as String?,
            designation: row['designation'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            staffId: row['staffId'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteRehabAssistantByRehabCode(int rehabCode) async {
    return _queryAdapter.query(
        'DELETE FROM RehabAssistant WHERE rehabCode = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [rehabCode]);
  }

  @override
  Future<void> deleteAllRehabAssistants() async {
    await _queryAdapter.queryNoReturn('DELETE FROM RehabAssistant');
  }

  @override
  Future<void> insertRehabAssistant(RehabAssistant rehabAssistant) async {
    await _rehabAssistantInsertionAdapter.insert(
        rehabAssistant, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertRehabAssistants(
      List<RehabAssistant> rehabAssistantList) {
    return _rehabAssistantInsertionAdapter.insertListAndReturnIds(
        rehabAssistantList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteRehabAssistant(RehabAssistant rehabAssistant) {
    return _rehabAssistantDeletionAdapter
        .deleteAndReturnChangedRows(rehabAssistant);
  }
}

class _$ContractorDao extends ContractorDao {
  _$ContractorDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _contractorInsertionAdapter = InsertionAdapter(
            database,
            'Contractor',
            (Contractor item) => <String, Object?>{
                  'id': item.id,
                  'contractorName': item.contractorName,
                  'contractorId': item.contractorId
                },
            changeListener),
        _contractorDeletionAdapter = DeletionAdapter(
            database,
            'Contractor',
            ['id'],
            (Contractor item) => <String, Object?>{
                  'id': item.id,
                  'contractorName': item.contractorName,
                  'contractorId': item.contractorId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Contractor> _contractorInsertionAdapter;

  final DeletionAdapter<Contractor> _contractorDeletionAdapter;

  @override
  Stream<List<Contractor>> findAllContractorStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Contractor',
        mapper: (Map<String, Object?> row) => Contractor(
            id: row['id'] as int?,
            contractorName: row['contractorName'] as String?,
            contractorId: row['contractorId'] as int?),
        queryableName: 'Contractor',
        isView: false);
  }

  @override
  Stream<List<Contractor>> streamAllContractorWithNamesLike(
      String contractorName) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Contractor WHERE LOWER(contractorName) LIKE ?1 OR LOWER(contractorId) LIKE ?1',
        mapper: (Map<String, Object?> row) => Contractor(
            id: row['id'] as int?,
            contractorName: row['contractorName'] as String?,
            contractorId: row['contractorId'] as int?),
        arguments: [contractorName],
        queryableName: 'Contractor',
        isView: false);
  }

  @override
  Future<List<Contractor>> findAllContractors() async {
    return _queryAdapter.queryList('SELECT * FROM Contractor',
        mapper: (Map<String, Object?> row) => Contractor(
            id: row['id'] as int?,
            contractorName: row['contractorName'] as String?,
            contractorId: row['contractorId'] as int?));
  }

  @override
  Future<List<Contractor>> findContractorsWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Contractor LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => Contractor(
            id: row['id'] as int?,
            contractorName: row['contractorName'] as String?,
            contractorId: row['contractorId'] as int?),
        arguments: [limit, offset]);
  }

  @override
  Future<List<Contractor>> findContractorsWithSearchAndLimit(
    String searchTerm,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Contractor WHERE LOWER(contractorName) LIKE ?1 OR LOWER(staffId) LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => Contractor(id: row['id'] as int?, contractorName: row['contractorName'] as String?, contractorId: row['contractorId'] as int?),
        arguments: [searchTerm, limit, offset]);
  }

  @override
  Future<List<Contractor>> findContractorsInDistrict(
      String districtName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Contractor WHERE districtName = ?1',
        mapper: (Map<String, Object?> row) => Contractor(
            id: row['id'] as int?,
            contractorName: row['contractorName'] as String?,
            contractorId: row['contractorId'] as int?),
        arguments: [districtName]);
  }

  @override
  Future<List<Contractor>> findContractorsInRegion(String regionName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Contractor WHERE regionName = ?1',
        mapper: (Map<String, Object?> row) => Contractor(
            id: row['id'] as int?,
            contractorName: row['contractorName'] as String?,
            contractorId: row['contractorId'] as int?),
        arguments: [regionName]);
  }

  @override
  Future<List<Contractor>> findContractorById(int contractorId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Contractor WHERE contractorId = ?1',
        mapper: (Map<String, Object?> row) => Contractor(
            id: row['id'] as int?,
            contractorName: row['contractorName'] as String?,
            contractorId: row['contractorId'] as int?),
        arguments: [contractorId]);
  }

  @override
  Future<void> deleteAllContractors() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Contractor');
  }

  @override
  Future<void> insertContractor(Contractor contractor) async {
    await _contractorInsertionAdapter.insert(
        contractor, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertContractors(List<Contractor> contractorList) {
    return _contractorInsertionAdapter.insertListAndReturnIds(
        contractorList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteContractor(Contractor contractor) {
    return _contractorDeletionAdapter.deleteAndReturnChangedRows(contractor);
  }
}

class _$PersonnelAssignmentDao extends PersonnelAssignmentDao {
  _$PersonnelAssignmentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _personnelAssignmentInsertionAdapter = InsertionAdapter(
            database,
            'PersonnelAssignment',
            (PersonnelAssignment item) => <String, Object?>{
                  'uid': item.uid,
                  'farmid': item.farmid,
                  'activity': item.activity,
                  'rehabAssistants': item.rehabAssistants,
                  'rehabAssistantsObject': item.rehabAssistantsObject,
                  'assignedDate': item.assignedDate,
                  'blocks': item.blocks,
                  'agent': item.agent,
                  'status': item.status
                },
            changeListener),
        _personnelAssignmentUpdateAdapter = UpdateAdapter(
            database,
            'PersonnelAssignment',
            ['uid'],
            (PersonnelAssignment item) => <String, Object?>{
                  'uid': item.uid,
                  'farmid': item.farmid,
                  'activity': item.activity,
                  'rehabAssistants': item.rehabAssistants,
                  'rehabAssistantsObject': item.rehabAssistantsObject,
                  'assignedDate': item.assignedDate,
                  'blocks': item.blocks,
                  'agent': item.agent,
                  'status': item.status
                },
            changeListener),
        _personnelAssignmentDeletionAdapter = DeletionAdapter(
            database,
            'PersonnelAssignment',
            ['uid'],
            (PersonnelAssignment item) => <String, Object?>{
                  'uid': item.uid,
                  'farmid': item.farmid,
                  'activity': item.activity,
                  'rehabAssistants': item.rehabAssistants,
                  'rehabAssistantsObject': item.rehabAssistantsObject,
                  'assignedDate': item.assignedDate,
                  'blocks': item.blocks,
                  'agent': item.agent,
                  'status': item.status
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PersonnelAssignment>
      _personnelAssignmentInsertionAdapter;

  final UpdateAdapter<PersonnelAssignment> _personnelAssignmentUpdateAdapter;

  final DeletionAdapter<PersonnelAssignment>
      _personnelAssignmentDeletionAdapter;

  @override
  Stream<List<PersonnelAssignment>> findAllPersonnelAssignmentStream() {
    return _queryAdapter.queryListStream('SELECT * FROM PersonnelAssignment',
        mapper: (Map<String, Object?> row) => PersonnelAssignment(
            farmid: row['farmid'] as String?,
            activity: row['activity'] as int?,
            rehabAssistants: row['rehabAssistants'] as String?,
            rehabAssistantsObject: row['rehabAssistantsObject'] as String?,
            assignedDate: row['assignedDate'] as String?,
            uid: row['uid'] as String?,
            blocks: row['blocks'] as String?,
            agent: row['agent'] as int?,
            status: row['status'] as int?),
        queryableName: 'PersonnelAssignment',
        isView: false);
  }

  @override
  Future<List<PersonnelAssignment>> findAllPersonnelAssignment() async {
    return _queryAdapter.queryList('SELECT * FROM PersonnelAssignment',
        mapper: (Map<String, Object?> row) => PersonnelAssignment(
            farmid: row['farmid'] as String?,
            activity: row['activity'] as int?,
            rehabAssistants: row['rehabAssistants'] as String?,
            rehabAssistantsObject: row['rehabAssistantsObject'] as String?,
            assignedDate: row['assignedDate'] as String?,
            uid: row['uid'] as String?,
            blocks: row['blocks'] as String?,
            agent: row['agent'] as int?,
            status: row['status'] as int?));
  }

  @override
  Stream<List<PersonnelAssignment>> findPersonnelAssignmentByStatusStream(
      int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM PersonnelAssignment WHERE status = ?1',
        mapper: (Map<String, Object?> row) => PersonnelAssignment(
            farmid: row['farmid'] as String?,
            activity: row['activity'] as int?,
            rehabAssistants: row['rehabAssistants'] as String?,
            rehabAssistantsObject: row['rehabAssistantsObject'] as String?,
            assignedDate: row['assignedDate'] as String?,
            uid: row['uid'] as String?,
            blocks: row['blocks'] as String?,
            agent: row['agent'] as int?,
            status: row['status'] as int?),
        arguments: [status],
        queryableName: 'PersonnelAssignment',
        isView: false);
  }

  @override
  Future<List<PersonnelAssignment>> findPersonnelAssignmentByStatus(
      int status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM PersonnelAssignment WHERE status = ?1',
        mapper: (Map<String, Object?> row) => PersonnelAssignment(
            farmid: row['farmid'] as String?,
            activity: row['activity'] as int?,
            rehabAssistants: row['rehabAssistants'] as String?,
            rehabAssistantsObject: row['rehabAssistantsObject'] as String?,
            assignedDate: row['assignedDate'] as String?,
            uid: row['uid'] as String?,
            blocks: row['blocks'] as String?,
            agent: row['agent'] as int?,
            status: row['status'] as int?),
        arguments: [status]);
  }

  @override
  Future<List<PersonnelAssignment>> findPersonnelAssignmentByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM PersonnelAssignment WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => PersonnelAssignment(farmid: row['farmid'] as String?, activity: row['activity'] as int?, rehabAssistants: row['rehabAssistants'] as String?, rehabAssistantsObject: row['rehabAssistantsObject'] as String?, assignedDate: row['assignedDate'] as String?, uid: row['uid'] as String?, blocks: row['blocks'] as String?, agent: row['agent'] as int?, status: row['status'] as int?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<PersonnelAssignment>> findPersonnelAssignmentByUID(
      String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM PersonnelAssignment WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => PersonnelAssignment(
            farmid: row['farmid'] as String?,
            activity: row['activity'] as int?,
            rehabAssistants: row['rehabAssistants'] as String?,
            rehabAssistantsObject: row['rehabAssistantsObject'] as String?,
            assignedDate: row['assignedDate'] as String?,
            uid: row['uid'] as String?,
            blocks: row['blocks'] as String?,
            agent: row['agent'] as int?,
            status: row['status'] as int?),
        arguments: [id]);
  }

  @override
  Future<int?> deletePersonnelAssignmentByUID(String id) async {
    return _queryAdapter.query('DELETE FROM PersonnelAssignment WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllPersonnelAssignment() async {
    await _queryAdapter.queryNoReturn('DELETE FROM PersonnelAssignment');
  }

  @override
  Future<int?> updatePersonnelAssignmentSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE PersonnelAssignment SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertPersonnelAssignment(
      PersonnelAssignment personnelAssignment) async {
    await _personnelAssignmentInsertionAdapter.insert(
        personnelAssignment, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertPersonnelAssignment(
      List<PersonnelAssignment> personnelAssignmentList) {
    return _personnelAssignmentInsertionAdapter.insertListAndReturnIds(
        personnelAssignmentList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePersonnelAssignment(
      PersonnelAssignment personnelAssignment) async {
    await _personnelAssignmentUpdateAdapter.update(
        personnelAssignment, OnConflictStrategy.abort);
  }

  @override
  Future<int> deletePersonnelAssignment(
      PersonnelAssignment personnelAssignment) {
    return _personnelAssignmentDeletionAdapter
        .deleteAndReturnChangedRows(personnelAssignment);
  }
}

class _$FarmStatusDao extends FarmStatusDao {
  _$FarmStatusDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _farmStatusInsertionAdapter = InsertionAdapter(
            database,
            'FarmStatus',
            (FarmStatus item) => <String, Object?>{
                  'id': item.id,
                  'farmid': item.farmid,
                  'location': item.location,
                  'activity': item.activity,
                  'area': item.area,
                  'areaCovered': item.areaCovered,
                  'farmerName': item.farmerName,
                  'status': item.status,
                  'month': item.month,
                  'year': item.year
                },
            changeListener),
        _farmStatusDeletionAdapter = DeletionAdapter(
            database,
            'FarmStatus',
            ['id'],
            (FarmStatus item) => <String, Object?>{
                  'id': item.id,
                  'farmid': item.farmid,
                  'location': item.location,
                  'activity': item.activity,
                  'area': item.area,
                  'areaCovered': item.areaCovered,
                  'farmerName': item.farmerName,
                  'status': item.status,
                  'month': item.month,
                  'year': item.year
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FarmStatus> _farmStatusInsertionAdapter;

  final DeletionAdapter<FarmStatus> _farmStatusDeletionAdapter;

  @override
  Stream<List<FarmStatus>> findAllFarmStatusStream() {
    return _queryAdapter.queryListStream('SELECT * FROM FarmStatus',
        mapper: (Map<String, Object?> row) => FarmStatus(
            id: row['id'] as int?,
            farmid: row['farmid'] as String?,
            location: row['location'] as String?,
            activity: row['activity'] as String?,
            area: row['area'] as double?,
            areaCovered: row['areaCovered'] as double?,
            farmerName: row['farmerName'] as String?,
            status: row['status'] as String?,
            month: row['month'] as String?,
            year: row['year'] as int?),
        queryableName: 'FarmStatus',
        isView: false);
  }

  @override
  Stream<List<FarmStatus>> streamAllFarmStatusWithNamesLike(String farmerName) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM FarmStatus WHERE LOWER(farmerName) LIKE ?1 OR LOWER(farmid) LIKE ?1',
        mapper: (Map<String, Object?> row) => FarmStatus(
            id: row['id'] as int?,
            farmid: row['farmid'] as String?,
            location: row['location'] as String?,
            activity: row['activity'] as String?,
            area: row['area'] as double?,
            areaCovered: row['areaCovered'] as double?,
            farmerName: row['farmerName'] as String?,
            status: row['status'] as String?,
            month: row['month'] as String?,
            year: row['year'] as int?),
        arguments: [farmerName],
        queryableName: 'FarmStatus',
        isView: false);
  }

  @override
  Future<List<FarmStatus>> findFarmStatusWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FarmStatus LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => FarmStatus(
            id: row['id'] as int?,
            farmid: row['farmid'] as String?,
            location: row['location'] as String?,
            activity: row['activity'] as String?,
            area: row['area'] as double?,
            areaCovered: row['areaCovered'] as double?,
            farmerName: row['farmerName'] as String?,
            status: row['status'] as String?,
            month: row['month'] as String?,
            year: row['year'] as int?),
        arguments: [limit, offset]);
  }

  @override
  Future<List<FarmStatus>> findFarmStatusWithSearchAndLimit(
    String searchTerm,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FarmStatus WHERE LOWER(farmerName) LIKE ?1 OR LOWER(farmid) LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => FarmStatus(id: row['id'] as int?, farmid: row['farmid'] as String?, location: row['location'] as String?, activity: row['activity'] as String?, area: row['area'] as double?, areaCovered: row['areaCovered'] as double?, farmerName: row['farmerName'] as String?, status: row['status'] as String?, month: row['month'] as String?, year: row['year'] as int?),
        arguments: [searchTerm, limit, offset]);
  }

  @override
  Future<List<FarmStatus>> findAllFarmStatus() async {
    return _queryAdapter.queryList('SELECT * FROM FarmStatus',
        mapper: (Map<String, Object?> row) => FarmStatus(
            id: row['id'] as int?,
            farmid: row['farmid'] as String?,
            location: row['location'] as String?,
            activity: row['activity'] as String?,
            area: row['area'] as double?,
            areaCovered: row['areaCovered'] as double?,
            farmerName: row['farmerName'] as String?,
            status: row['status'] as String?,
            month: row['month'] as String?,
            year: row['year'] as int?));
  }

  @override
  Future<List<FarmStatus>> findFarmStatusByFarmId(String farmId) async {
    return _queryAdapter.queryList('SELECT * FROM FarmStatus WHERE farmid = ?1',
        mapper: (Map<String, Object?> row) => FarmStatus(
            id: row['id'] as int?,
            farmid: row['farmid'] as String?,
            location: row['location'] as String?,
            activity: row['activity'] as String?,
            area: row['area'] as double?,
            areaCovered: row['areaCovered'] as double?,
            farmerName: row['farmerName'] as String?,
            status: row['status'] as String?,
            month: row['month'] as String?,
            year: row['year'] as int?),
        arguments: [farmId]);
  }

  @override
  Future<void> deleteAllFarmStatus() async {
    await _queryAdapter.queryNoReturn('DELETE FROM FarmStatus');
  }

  @override
  Future<void> insertFarmStatus(FarmStatus farmStatus) async {
    await _farmStatusInsertionAdapter.insert(
        farmStatus, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertFarmStatus(List<FarmStatus> farmStatusList) {
    return _farmStatusInsertionAdapter.insertListAndReturnIds(
        farmStatusList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteFarmStatus(FarmStatus farmStatus) {
    return _farmStatusDeletionAdapter.deleteAndReturnChangedRows(farmStatus);
  }
}

class _$AssignedFarmDao extends AssignedFarmDao {
  _$AssignedFarmDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _assignedFarmInsertionAdapter = InsertionAdapter(
            database,
            'AssignedFarm',
            (AssignedFarm item) => <String, Object?>{
                  'id': item.id,
                  'farmBoundary': item.farmBoundary,
                  'farmername': item.farmername,
                  'location': item.location,
                  'farmReference': item.farmReference,
                  'farmSize': item.farmSize
                },
            changeListener),
        _assignedFarmDeletionAdapter = DeletionAdapter(
            database,
            'AssignedFarm',
            ['id'],
            (AssignedFarm item) => <String, Object?>{
                  'id': item.id,
                  'farmBoundary': item.farmBoundary,
                  'farmername': item.farmername,
                  'location': item.location,
                  'farmReference': item.farmReference,
                  'farmSize': item.farmSize
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AssignedFarm> _assignedFarmInsertionAdapter;

  final DeletionAdapter<AssignedFarm> _assignedFarmDeletionAdapter;

  @override
  Stream<List<AssignedFarm>> findAllAssignedFarmsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM AssignedFarm',
        mapper: (Map<String, Object?> row) => AssignedFarm(
            id: row['id'] as int?,
            farmBoundary: row['farmBoundary'] as Uint8List?,
            farmername: row['farmername'] as String?,
            location: row['location'] as String?,
            farmReference: row['farmReference'] as String?,
            farmSize: row['farmSize'] as String?),
        queryableName: 'AssignedFarm',
        isView: false);
  }

  @override
  Future<List<AssignedFarm>> findAllAssignedFarms() async {
    return _queryAdapter
        .queryList('SELECT * FROM AssignedFarm',
            mapper: (Map<String, Object?> row) => AssignedFarm(
                id: row['id'] as int?,
                farmBoundary: row['farmBoundary'] as Uint8List?,
                farmername: row['farmername'] as String?,
                location: row['location'] as String?,
                farmReference: row['farmReference'] as String?,
                farmSize: row['farmSize'] as String?))
        .onError((error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      FirebaseCrashlytics.instance.log('findAllAssignedFarms');

      throw "assgined farms erros";
    });
  }

  @override
  Future<List<AssignedFarm>> findAssignedFarmWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AssignedFarm LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => AssignedFarm(
            id: row['id'] as int?,
            farmBoundary: row['farmBoundary'] as Uint8List?,
            farmername: row['farmername'] as String?,
            location: row['location'] as String?,
            farmReference: row['farmReference'] as String?,
            farmSize: row['farmSize'] as String?),
        arguments: [limit, offset]);
  }

  @override
  Future<List<AssignedFarm>> findAssignedFarmsByFarmRef(String ref) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AssignedFarm WHERE farmReference = ?1',
        mapper: (Map<String, Object?> row) => AssignedFarm(
            id: row['id'] as int?,
            farmBoundary: row['farmBoundary'] as Uint8List?,
            farmername: row['farmername'] as String?,
            location: row['location'] as String?,
            farmReference: row['farmReference'] as String?,
            farmSize: row['farmSize'] as String?),
        arguments: [ref]);
  }

  @override
  Future<void> deleteAllAssignedFarms() async {
    await _queryAdapter.queryNoReturn('DELETE FROM AssignedFarm');
  }

  @override
  Future<void> insertAssignedFarms(AssignedFarm assignedFarm) async {
    await _assignedFarmInsertionAdapter.insert(
        assignedFarm, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertAssignedFarms(
      List<AssignedFarm> assignedFarmList) {
    return _assignedFarmInsertionAdapter.insertListAndReturnIds(
        assignedFarmList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteAssignedFarms(AssignedFarm assignedFarm) {
    return _assignedFarmDeletionAdapter
        .deleteAndReturnChangedRows(assignedFarm);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _notificationDataInsertionAdapter = InsertionAdapter(
            database,
            'NotificationData',
            (NotificationData item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'message': item.message,
                  'date': _dateTimeConverter.encode(item.date),
                  'read': item.read == null ? null : (item.read! ? 1 : 0)
                },
            changeListener),
        _notificationDataDeletionAdapter = DeletionAdapter(
            database,
            'NotificationData',
            ['id'],
            (NotificationData item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'message': item.message,
                  'date': _dateTimeConverter.encode(item.date),
                  'read': item.read == null ? null : (item.read! ? 1 : 0)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotificationData> _notificationDataInsertionAdapter;

  final DeletionAdapter<NotificationData> _notificationDataDeletionAdapter;

  @override
  Stream<List<NotificationData>> findAllNotificationsStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM NotificationData ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => NotificationData(
            row['id'] as String,
            row['title'] as String?,
            row['message'] as String?,
            _dateTimeConverter.decode(row['date'] as int),
            row['read'] == null ? null : (row['read'] as int) != 0),
        queryableName: 'NotificationData',
        isView: false);
  }

  @override
  Future<List<NotificationData>> findAllNotifications() async {
    return _queryAdapter.queryList(
        'SELECT * FROM NotificationData ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => NotificationData(
            row['id'] as String,
            row['title'] as String?,
            row['message'] as String?,
            _dateTimeConverter.decode(row['date'] as int),
            row['read'] == null ? null : (row['read'] as int) != 0));
  }

  @override
  Stream<List<NotificationData>> findNotificationByReadStream(bool read) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM NotificationData WHERE read = ?1',
        mapper: (Map<String, Object?> row) => NotificationData(
            row['id'] as String,
            row['title'] as String?,
            row['message'] as String?,
            _dateTimeConverter.decode(row['date'] as int),
            row['read'] == null ? null : (row['read'] as int) != 0),
        arguments: [read ? 1 : 0],
        queryableName: 'NotificationData',
        isView: false);
  }

  @override
  Future<List<NotificationData>> findNotificationByRead(bool read) async {
    return _queryAdapter.queryList(
        'SELECT * FROM NotificationData WHERE read = ?1',
        mapper: (Map<String, Object?> row) => NotificationData(
            row['id'] as String,
            row['title'] as String?,
            row['message'] as String?,
            _dateTimeConverter.decode(row['date'] as int),
            row['read'] == null ? null : (row['read'] as int) != 0),
        arguments: [read ? 1 : 0]);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await _queryAdapter.queryNoReturn('DELETE FROM NotificationData');
  }

  @override
  Future<int?> setNotificationRead(
    bool read,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE NotificationData SET read = ?1 WHERE id = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [read ? 1 : 0, id]);
  }

  @override
  Future<int?> setAllNotificationRead(bool read) async {
    return _queryAdapter.query('UPDATE NotificationData SET read = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [read ? 1 : 0]);
  }

  @override
  Future<void> insertNotificationData(NotificationData notification) async {
    await _notificationDataInsertionAdapter.insert(
        notification, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteNotification(NotificationData notification) {
    return _notificationDataDeletionAdapter
        .deleteAndReturnChangedRows(notification);
  }
}

class _$AssignedOutbreakDao extends AssignedOutbreakDao {
  _$AssignedOutbreakDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _assignedOutbreakInsertionAdapter = InsertionAdapter(
            database,
            'AssignedOutbreak',
            (AssignedOutbreak item) => <String, Object?>{
                  'obId': item.obId,
                  'obCode': item.obCode,
                  'obSize': item.obSize,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName,
                  'obBoundary': item.obBoundary
                },
            changeListener),
        _assignedOutbreakDeletionAdapter = DeletionAdapter(
            database,
            'AssignedOutbreak',
            ['obId'],
            (AssignedOutbreak item) => <String, Object?>{
                  'obId': item.obId,
                  'obCode': item.obCode,
                  'obSize': item.obSize,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName,
                  'obBoundary': item.obBoundary
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AssignedOutbreak> _assignedOutbreakInsertionAdapter;

  final DeletionAdapter<AssignedOutbreak> _assignedOutbreakDeletionAdapter;

  @override
  Stream<List<AssignedOutbreak>> findAllAssignedOutbreakStream() {
    return _queryAdapter.queryListStream('SELECT * FROM AssignedOutbreak',
        mapper: (Map<String, Object?> row) => AssignedOutbreak(
            obId: row['obId'] as int?,
            obCode: row['obCode'] as String?,
            obSize: row['obSize'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            obBoundary: row['obBoundary'] as Uint8List?),
        queryableName: 'AssignedOutbreak',
        isView: false);
  }

  @override
  Future<List<AssignedOutbreak>> findAllAssignedOutbreaks() async {
    return _queryAdapter.queryList('SELECT * FROM AssignedOutbreak',
        mapper: (Map<String, Object?> row) => AssignedOutbreak(
            obId: row['obId'] as int?,
            obCode: row['obCode'] as String?,
            obSize: row['obSize'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            obBoundary: row['obBoundary'] as Uint8List?));
  }

  @override
  Future<List<AssignedOutbreak>> findAssignedOutbreakWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AssignedOutbreak LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => AssignedOutbreak(
            obId: row['obId'] as int?,
            obCode: row['obCode'] as String?,
            obSize: row['obSize'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            obBoundary: row['obBoundary'] as Uint8List?),
        arguments: [limit, offset]);
  }

  @override
  Future<List<AssignedOutbreak>> findAssignedOutbreakById(int obId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AssignedOutbreak WHERE obId = ?1',
        mapper: (Map<String, Object?> row) => AssignedOutbreak(
            obId: row['obId'] as int?,
            obCode: row['obCode'] as String?,
            obSize: row['obSize'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            obBoundary: row['obBoundary'] as Uint8List?),
        arguments: [obId]);
  }

  @override
  Future<List<AssignedOutbreak>> findAssignedOutbreakByCode(
      String obCode) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AssignedOutbreak WHERE obCode = ?1',
        mapper: (Map<String, Object?> row) => AssignedOutbreak(
            obId: row['obId'] as int?,
            obCode: row['obCode'] as String?,
            obSize: row['obSize'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?,
            obBoundary: row['obBoundary'] as Uint8List?),
        arguments: [obCode]);
  }

  @override
  Future<void> deleteAllAssignedOutbreaks() async {
    await _queryAdapter.queryNoReturn('DELETE FROM AssignedOutbreak');
  }

  @override
  Future<void> insertAssignedOutbreak(AssignedOutbreak assignedOutbreak) async {
    await _assignedOutbreakInsertionAdapter.insert(
        assignedOutbreak, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertAssignedOutbreak(
      List<AssignedOutbreak> assignedOutbreakList) {
    return _assignedOutbreakInsertionAdapter.insertListAndReturnIds(
        assignedOutbreakList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteAssignedOutbreak(AssignedOutbreak assignedOutbreak) {
    return _assignedOutbreakDeletionAdapter
        .deleteAndReturnChangedRows(assignedOutbreak);
  }
}

class _$CommunityDao extends CommunityDao {
  _$CommunityDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _communityInsertionAdapter = InsertionAdapter(
            database,
            'Community',
            (Community item) => <String, Object?>{
                  'communityId': item.communityId,
                  'operationalArea': item.operationalArea,
                  'community': item.community,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName
                }),
        _communityDeletionAdapter = DeletionAdapter(
            database,
            'Community',
            ['communityId'],
            (Community item) => <String, Object?>{
                  'communityId': item.communityId,
                  'operationalArea': item.operationalArea,
                  'community': item.community,
                  'districtId': item.districtId,
                  'districtName': item.districtName,
                  'regionId': item.regionId,
                  'regionName': item.regionName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Community> _communityInsertionAdapter;

  final DeletionAdapter<Community> _communityDeletionAdapter;

  @override
  Future<List<Community>> findAllCommunity() async {
    return _queryAdapter.queryList('SELECT * FROM Community',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?));
  }

  @override
  Future<List<Community>> findCommunityById(int communityId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Community WHERE communityId = ?1',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [communityId]);
  }

  @override
  Future<List<Community>> findCommunityRegions() async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT regionId, regionName FROM Community ORDER BY regionName ASC',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?));
  }

  @override
  Future<List<Community>> findCommunityByRegionName(String regionName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Community WHERE regionName = ?1',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [regionName]);
  }

  @override
  Future<List<Community>> findCommunityByRegionId(String regionId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Community WHERE regionId = ?1',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [regionId]);
  }

  @override
  Future<List<Community>> findCommunityByDistrictId(String districtId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Community WHERE districtId = ?1',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [districtId]);
  }

  @override
  Future<List<Community>> findCommunityByDistrictName(
      String districtName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Community WHERE districtName = ?1',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [districtName]);
  }

  @override
  Future<List<Community>> findCommunityInRegion(String regionName) async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT communityId, community FROM Community WHERE regionName = ?1 ORDER BY community ASC',
        mapper: (Map<String, Object?> row) => Community(operationalArea: row['operationalArea'] as String?, communityId: row['communityId'] as int?, community: row['community'] as String?, districtId: row['districtId'] as int?, districtName: row['districtName'] as String?, regionId: row['regionId'] as String?, regionName: row['regionName'] as String?),
        arguments: [regionName]);
  }

  @override
  Future<List<Community>> findCommunityInDistrict(String districtName) async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT communityId, community FROM Community WHERE districtName = ?1 ORDER BY community ASC',
        mapper: (Map<String, Object?> row) => Community(operationalArea: row['operationalArea'] as String?, communityId: row['communityId'] as int?, community: row['community'] as String?, districtId: row['districtId'] as int?, districtName: row['districtName'] as String?, regionId: row['regionId'] as String?, regionName: row['regionName'] as String?),
        arguments: [districtName]);
  }

  @override
  Future<List<Community>> findCommunityByCommunityName(String community) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Community WHERE community = ?1',
        mapper: (Map<String, Object?> row) => Community(
            operationalArea: row['operationalArea'] as String?,
            communityId: row['communityId'] as int?,
            community: row['community'] as String?,
            districtId: row['districtId'] as int?,
            districtName: row['districtName'] as String?,
            regionId: row['regionId'] as String?,
            regionName: row['regionName'] as String?),
        arguments: [community]);
  }

  @override
  Future<void> deleteAllCommunity() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Community');
  }

  @override
  Future<void> insertCommunity(Community community) async {
    await _communityInsertionAdapter.insert(
        community, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertCommunity(List<Community> community) {
    return _communityInsertionAdapter.insertListAndReturnIds(
        community, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteCommunity(Community community) {
    return _communityDeletionAdapter.deleteAndReturnChangedRows(community);
  }
}

class _$CocoaTypeDao extends CocoaTypeDao {
  _$CocoaTypeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _cocoaTypeInsertionAdapter = InsertionAdapter(
            database,
            'CocoaType',
            (CocoaType item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _cocoaTypeDeletionAdapter = DeletionAdapter(
            database,
            'CocoaType',
            ['id'],
            (CocoaType item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CocoaType> _cocoaTypeInsertionAdapter;

  final DeletionAdapter<CocoaType> _cocoaTypeDeletionAdapter;

  @override
  Stream<List<CocoaType>> findAllCocoaTypeStream() {
    return _queryAdapter.queryListStream('SELECT * FROM CocoaType',
        mapper: (Map<String, Object?> row) =>
            CocoaType(id: row['id'] as int?, name: row['name'] as String?),
        queryableName: 'CocoaType',
        isView: false);
  }

  @override
  Future<List<CocoaType>> findAllCocoaType() async {
    return _queryAdapter.queryList('SELECT * FROM CocoaType',
        mapper: (Map<String, Object?> row) =>
            CocoaType(id: row['id'] as int?, name: row['name'] as String?));
  }

  @override
  Future<void> deleteAllCocoaType() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CocoaType');
  }

  @override
  Future<void> insertCocoaType(CocoaType cocoaType) async {
    await _cocoaTypeInsertionAdapter.insert(
        cocoaType, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertCocoaType(List<CocoaType> cocoaTypeList) {
    return _cocoaTypeInsertionAdapter.insertListAndReturnIds(
        cocoaTypeList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteCocoaType(CocoaType cocoaType) {
    return _cocoaTypeDeletionAdapter.deleteAndReturnChangedRows(cocoaType);
  }
}

class _$CocoaAgeClassDao extends CocoaAgeClassDao {
  _$CocoaAgeClassDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _cocoaAgeClassInsertionAdapter = InsertionAdapter(
            database,
            'CocoaAgeClass',
            (CocoaAgeClass item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _cocoaAgeClassDeletionAdapter = DeletionAdapter(
            database,
            'CocoaAgeClass',
            ['id'],
            (CocoaAgeClass item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CocoaAgeClass> _cocoaAgeClassInsertionAdapter;

  final DeletionAdapter<CocoaAgeClass> _cocoaAgeClassDeletionAdapter;

  @override
  Stream<List<CocoaAgeClass>> findAllCocoaAgeClassStream() {
    return _queryAdapter.queryListStream('SELECT * FROM CocoaAgeClass',
        mapper: (Map<String, Object?> row) =>
            CocoaAgeClass(id: row['id'] as int?, name: row['name'] as String?),
        queryableName: 'CocoaAgeClass',
        isView: false);
  }

  @override
  Future<List<CocoaAgeClass>> findAllCocoaAgeClass() async {
    return _queryAdapter.queryList('SELECT * FROM CocoaAgeClass',
        mapper: (Map<String, Object?> row) =>
            CocoaAgeClass(id: row['id'] as int?, name: row['name'] as String?));
  }

  @override
  Future<void> deleteAllCocoaAgeClass() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CocoaAgeClass');
  }

  @override
  Future<void> insertCocoaAgeClass(CocoaAgeClass cocoaAgeClass) async {
    await _cocoaAgeClassInsertionAdapter.insert(
        cocoaAgeClass, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertCocoaAgeClass(
      List<CocoaAgeClass> cocoaAgeClassList) {
    return _cocoaAgeClassInsertionAdapter.insertListAndReturnIds(
        cocoaAgeClassList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteCocoaAgeClass(CocoaAgeClass cocoaAgeClass) {
    return _cocoaAgeClassDeletionAdapter
        .deleteAndReturnChangedRows(cocoaAgeClass);
  }
}

class _$OutbreakFarmDao extends OutbreakFarmDao {
  _$OutbreakFarmDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _outbreakFarmInsertionAdapter = InsertionAdapter(
            database,
            'OutbreakFarm',
            (OutbreakFarm item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'inspectionDate': item.inspectionDate,
                  'outbreaksForeignkey': item.outbreaksForeignkey,
                  'farmboundary': item.farmboundary,
                  'farmerName': item.farmerName,
                  'farmerAge': item.farmerAge,
                  'idType': item.idType,
                  'idNumber': item.idNumber,
                  'farmerContact': item.farmerContact,
                  'cocoaType': item.cocoaType,
                  'ageClass': item.ageClass,
                  'farmArea': item.farmArea,
                  'communitytblForeignkey': item.communitytblForeignkey,
                  'status': item.status
                },
            changeListener),
        _outbreakFarmUpdateAdapter = UpdateAdapter(
            database,
            'OutbreakFarm',
            ['uid'],
            (OutbreakFarm item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'inspectionDate': item.inspectionDate,
                  'outbreaksForeignkey': item.outbreaksForeignkey,
                  'farmboundary': item.farmboundary,
                  'farmerName': item.farmerName,
                  'farmerAge': item.farmerAge,
                  'idType': item.idType,
                  'idNumber': item.idNumber,
                  'farmerContact': item.farmerContact,
                  'cocoaType': item.cocoaType,
                  'ageClass': item.ageClass,
                  'farmArea': item.farmArea,
                  'communitytblForeignkey': item.communitytblForeignkey,
                  'status': item.status
                },
            changeListener),
        _outbreakFarmDeletionAdapter = DeletionAdapter(
            database,
            'OutbreakFarm',
            ['uid'],
            (OutbreakFarm item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'inspectionDate': item.inspectionDate,
                  'outbreaksForeignkey': item.outbreaksForeignkey,
                  'farmboundary': item.farmboundary,
                  'farmerName': item.farmerName,
                  'farmerAge': item.farmerAge,
                  'idType': item.idType,
                  'idNumber': item.idNumber,
                  'farmerContact': item.farmerContact,
                  'cocoaType': item.cocoaType,
                  'ageClass': item.ageClass,
                  'farmArea': item.farmArea,
                  'communitytblForeignkey': item.communitytblForeignkey,
                  'status': item.status
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OutbreakFarm> _outbreakFarmInsertionAdapter;

  final UpdateAdapter<OutbreakFarm> _outbreakFarmUpdateAdapter;

  final DeletionAdapter<OutbreakFarm> _outbreakFarmDeletionAdapter;

  @override
  Stream<List<OutbreakFarm>> findAllOutbreakFarmStream() {
    return _queryAdapter.queryListStream('SELECT * FROM OutbreakFarm',
        mapper: (Map<String, Object?> row) => OutbreakFarm(
            uid: row['uid'] as String?,
            agent: row['agent'] as int?,
            inspectionDate: row['inspectionDate'] as String?,
            outbreaksForeignkey: row['outbreaksForeignkey'] as int?,
            farmboundary: row['farmboundary'] as Uint8List?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytblForeignkey: row['communitytblForeignkey'] as int?,
            status: row['status'] as int?),
        queryableName: 'OutbreakFarm',
        isView: false);
  }

  @override
  Future<List<OutbreakFarm>> findAllOutbreakFarm() async {
    return _queryAdapter.queryList('SELECT * FROM OutbreakFarm',
        mapper: (Map<String, Object?> row) => OutbreakFarm(
            uid: row['uid'] as String?,
            agent: row['agent'] as int?,
            inspectionDate: row['inspectionDate'] as String?,
            outbreaksForeignkey: row['outbreaksForeignkey'] as int?,
            farmboundary: row['farmboundary'] as Uint8List?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytblForeignkey: row['communitytblForeignkey'] as int?,
            status: row['status'] as int?));
  }

  @override
  Stream<List<OutbreakFarm>> findOutbreakFarmByStatusStream(int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM OutbreakFarm WHERE status = ?1',
        mapper: (Map<String, Object?> row) => OutbreakFarm(
            uid: row['uid'] as String?,
            agent: row['agent'] as int?,
            inspectionDate: row['inspectionDate'] as String?,
            outbreaksForeignkey: row['outbreaksForeignkey'] as int?,
            farmboundary: row['farmboundary'] as Uint8List?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytblForeignkey: row['communitytblForeignkey'] as int?,
            status: row['status'] as int?),
        arguments: [status],
        queryableName: 'OutbreakFarm',
        isView: false);
  }

  @override
  Future<List<OutbreakFarm>> findOutbreakFarmByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM OutbreakFarm WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => OutbreakFarm(
            uid: row['uid'] as String?,
            agent: row['agent'] as int?,
            inspectionDate: row['inspectionDate'] as String?,
            outbreaksForeignkey: row['outbreaksForeignkey'] as int?,
            farmboundary: row['farmboundary'] as Uint8List?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytblForeignkey: row['communitytblForeignkey'] as int?,
            status: row['status'] as int?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<OutbreakFarm>> findOutbreakFarmByStatus(int status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM OutbreakFarm WHERE status = ?1',
        mapper: (Map<String, Object?> row) => OutbreakFarm(
            uid: row['uid'] as String?,
            agent: row['agent'] as int?,
            inspectionDate: row['inspectionDate'] as String?,
            outbreaksForeignkey: row['outbreaksForeignkey'] as int?,
            farmboundary: row['farmboundary'] as Uint8List?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytblForeignkey: row['communitytblForeignkey'] as int?,
            status: row['status'] as int?),
        arguments: [status]);
  }

  @override
  Future<List<OutbreakFarm>> findOutbreakFarmByUID(String id) async {
    return _queryAdapter.queryList('SELECT * FROM OutbreakFarm WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => OutbreakFarm(
            uid: row['uid'] as String?,
            agent: row['agent'] as int?,
            inspectionDate: row['inspectionDate'] as String?,
            outbreaksForeignkey: row['outbreaksForeignkey'] as int?,
            farmboundary: row['farmboundary'] as Uint8List?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytblForeignkey: row['communitytblForeignkey'] as int?,
            status: row['status'] as int?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteOutbreakFarmByUID(String id) async {
    return _queryAdapter.query('DELETE FROM OutbreakFarm WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllOutbreakFarm() async {
    await _queryAdapter.queryNoReturn('DELETE FROM OutbreakFarm');
  }

  @override
  Future<int?> updateOutbreakFarmSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE OutbreakFarm SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertOutbreakFarm(OutbreakFarm outbreakFarm) async {
    await _outbreakFarmInsertionAdapter.insert(
        outbreakFarm, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertOutbreakFarm(
      List<OutbreakFarm> outbreakFarmList) {
    return _outbreakFarmInsertionAdapter.insertListAndReturnIds(
        outbreakFarmList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateOutbreakFarm(OutbreakFarm outbreakFarm) async {
    await _outbreakFarmUpdateAdapter.update(
        outbreakFarm, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteOutbreakFarm(OutbreakFarm outbreakFarm) {
    return _outbreakFarmDeletionAdapter
        .deleteAndReturnChangedRows(outbreakFarm);
  }
}

class _$CalculatedAreaDao extends CalculatedAreaDao {
  _$CalculatedAreaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _calculatedAreaInsertionAdapter = InsertionAdapter(
            database,
            'CalculatedArea',
            (CalculatedArea item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'title': item.title,
                  'value': item.value
                },
            changeListener),
        _calculatedAreaDeletionAdapter = DeletionAdapter(
            database,
            'CalculatedArea',
            ['id'],
            (CalculatedArea item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'title': item.title,
                  'value': item.value
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CalculatedArea> _calculatedAreaInsertionAdapter;

  final DeletionAdapter<CalculatedArea> _calculatedAreaDeletionAdapter;

  @override
  Stream<List<CalculatedArea>> findAllCalculatedAreaStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM CalculatedArea ORDER BY date',
        mapper: (Map<String, Object?> row) => CalculatedArea(
            id: row['id'] as int?,
            date: _dateTimeConverter.decode(row['date'] as int),
            title: row['title'] as String,
            value: row['value'] as String),
        queryableName: 'CalculatedArea',
        isView: false);
  }

  @override
  Future<List<CalculatedArea>> findAllCalculatedArea() async {
    return _queryAdapter.queryList('SELECT * FROM CalculatedArea ORDER BY date',
        mapper: (Map<String, Object?> row) => CalculatedArea(
            id: row['id'] as int?,
            date: _dateTimeConverter.decode(row['date'] as int),
            title: row['title'] as String,
            value: row['value'] as String));
  }

  @override
  Future<void> deleteAllCalculatedArea() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CalculatedArea');
  }

  @override
  Future<void> insertCalculatedArea(CalculatedArea calculatedArea) async {
    await _calculatedAreaInsertionAdapter.insert(
        calculatedArea, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteCalculatedArea(CalculatedArea calculatedArea) {
    return _calculatedAreaDeletionAdapter
        .deleteAndReturnChangedRows(calculatedArea);
  }
}

class _$POLocationDao extends POLocationDao {
  _$POLocationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _poLocationInsertionAdapter = InsertionAdapter(
            database,
            'PoLocation',
            (PoLocation item) => <String, Object?>{
                  'id': item.id,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'uid': item.uid,
                  'userid': item.userid,
                  'inspectionDate':
                      _dateTimeConverter.encode(item.inspectionDate)
                },
            changeListener),
        _poLocationDeletionAdapter = DeletionAdapter(
            database,
            'PoLocation',
            ['id'],
            (PoLocation item) => <String, Object?>{
                  'id': item.id,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'uid': item.uid,
                  'userid': item.userid,
                  'inspectionDate':
                      _dateTimeConverter.encode(item.inspectionDate)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PoLocation> _poLocationInsertionAdapter;

  final DeletionAdapter<PoLocation> _poLocationDeletionAdapter;

  @override
  Stream<List<PoLocation>> findAllPOLocationStream() {
    return _queryAdapter.queryListStream('SELECT * FROM PoLocation',
        mapper: (Map<String, Object?> row) => PoLocation(
            id: row['id'] as int?,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            accuracy: row['accuracy'] as int,
            uid: row['uid'] as String,
            userid: row['userid'] as int,
            inspectionDate:
                _dateTimeConverter.decode(row['inspectionDate'] as int)),
        queryableName: 'PoLocation',
        isView: false);
  }

  @override
  Future<List<PoLocation>> findAllPOLocations() async {
    return _queryAdapter.queryList('SELECT * FROM PoLocation',
        mapper: (Map<String, Object?> row) => PoLocation(
            id: row['id'] as int?,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            accuracy: row['accuracy'] as int,
            uid: row['uid'] as String,
            userid: row['userid'] as int,
            inspectionDate:
                _dateTimeConverter.decode(row['inspectionDate'] as int)));
  }

  @override
  Future<List<PoLocation>> findPoLocationWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM PoLocation LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => PoLocation(
            id: row['id'] as int?,
            lat: row['lat'] as double,
            lng: row['lng'] as double,
            accuracy: row['accuracy'] as int,
            uid: row['uid'] as String,
            userid: row['userid'] as int,
            inspectionDate:
                _dateTimeConverter.decode(row['inspectionDate'] as int)),
        arguments: [limit, offset]);
  }

  @override
  Future<void> deleteAllPOLocation() async {
    await _queryAdapter.queryNoReturn('DELETE FROM PoLocation');
  }

  @override
  Future<void> insertPOLocation(PoLocation poLocation) async {
    await _poLocationInsertionAdapter.insert(
        poLocation, OnConflictStrategy.replace);
  }

  @override
  Future<int> deletePOLocation(PoLocation poLocation) {
    return _poLocationDeletionAdapter.deleteAndReturnChangedRows(poLocation);
  }
}

class _$InitialTreatmentMonitorDao extends InitialTreatmentMonitorDao {
  _$InitialTreatmentMonitorDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _initialTreatmentMonitorInsertionAdapter = InsertionAdapter(
            database,
            'InitialTreatmentMonitor',
            (InitialTreatmentMonitor item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'staffContact': item.staffContact,
                  'mainActivity': item.mainActivity,
                  'activity': item.activity,
                  'monitoringDate': item.monitoringDate,
                  'noRehabAssistants': item.noRehabAssistants,
                  'areaCoveredHa': item.areaCoveredHa,
                  'remark': item.remark,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'currentFarmPic': item.currentFarmPic,
                  'ras': item.ras,
                  'status': item.status,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'cocoaSeedlingsAlive': item.cocoaSeedlingsAlive,
                  'plantainSeedlingsAlive': item.plantainSeedlingsAlive,
                  'nameOfChedTa': item.nameOfChedTa,
                  'contactOfChedTa': item.contactOfChedTa,
                  'community': item.community,
                  'operationalArea': item.operationalArea,
                  'contractorName': item.contractorName,
                  'numberOfPeopleInGroup': item.numberOfPeopleInGroup,
                  'groupWork': item.groupWork,
                  'completedByContractor': item.completedByContractor,
                  'areaCoveredRx': item.areaCoveredRx
                },
            changeListener),
        _initialTreatmentMonitorUpdateAdapter = UpdateAdapter(
            database,
            'InitialTreatmentMonitor',
            ['uid'],
            (InitialTreatmentMonitor item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'staffContact': item.staffContact,
                  'mainActivity': item.mainActivity,
                  'activity': item.activity,
                  'monitoringDate': item.monitoringDate,
                  'noRehabAssistants': item.noRehabAssistants,
                  'areaCoveredHa': item.areaCoveredHa,
                  'remark': item.remark,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'currentFarmPic': item.currentFarmPic,
                  'ras': item.ras,
                  'status': item.status,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'cocoaSeedlingsAlive': item.cocoaSeedlingsAlive,
                  'plantainSeedlingsAlive': item.plantainSeedlingsAlive,
                  'nameOfChedTa': item.nameOfChedTa,
                  'contactOfChedTa': item.contactOfChedTa,
                  'community': item.community,
                  'operationalArea': item.operationalArea,
                  'contractorName': item.contractorName,
                  'numberOfPeopleInGroup': item.numberOfPeopleInGroup,
                  'groupWork': item.groupWork,
                  'completedByContractor': item.completedByContractor,
                  'areaCoveredRx': item.areaCoveredRx
                },
            changeListener),
        _initialTreatmentMonitorDeletionAdapter = DeletionAdapter(
            database,
            'InitialTreatmentMonitor',
            ['uid'],
            (InitialTreatmentMonitor item) => <String, Object?>{
                  'uid': item.uid,
                  'agent': item.agent,
                  'staffContact': item.staffContact,
                  'mainActivity': item.mainActivity,
                  'activity': item.activity,
                  'monitoringDate': item.monitoringDate,
                  'noRehabAssistants': item.noRehabAssistants,
                  'areaCoveredHa': item.areaCoveredHa,
                  'remark': item.remark,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'currentFarmPic': item.currentFarmPic,
                  'ras': item.ras,
                  'status': item.status,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'cocoaSeedlingsAlive': item.cocoaSeedlingsAlive,
                  'plantainSeedlingsAlive': item.plantainSeedlingsAlive,
                  'nameOfChedTa': item.nameOfChedTa,
                  'contactOfChedTa': item.contactOfChedTa,
                  'community': item.community,
                  'operationalArea': item.operationalArea,
                  'contractorName': item.contractorName,
                  'numberOfPeopleInGroup': item.numberOfPeopleInGroup,
                  'groupWork': item.groupWork,
                  'completedByContractor': item.completedByContractor,
                  'areaCoveredRx': item.areaCoveredRx
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<InitialTreatmentMonitor>
      _initialTreatmentMonitorInsertionAdapter;

  final UpdateAdapter<InitialTreatmentMonitor>
      _initialTreatmentMonitorUpdateAdapter;

  final DeletionAdapter<InitialTreatmentMonitor>
      _initialTreatmentMonitorDeletionAdapter;

  @override
  Stream<List<InitialTreatmentMonitor>> findAllInitialTreatmentMonitorStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM InitialTreatmentMonitor',
        mapper: (Map<String, Object?> row) => InitialTreatmentMonitor(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            staffContact: row['staffContact'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: row['activity'] as int?,
            monitoringDate: row['monitoringDate'] as String?,
            noRehabAssistants: row['noRehabAssistants'] as int?,
            areaCoveredHa: row['areaCoveredHa'] as double?,
            remark: row['remark'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as Uint8List?,
            ras: row['ras'] as String?,
            status: row['status'] as int?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            cocoaSeedlingsAlive: row['cocoaSeedlingsAlive'] as int?,
            plantainSeedlingsAlive: row['plantainSeedlingsAlive'] as int?,
            nameOfChedTa: row['nameOfChedTa'] as String?,
            contactOfChedTa: row['contactOfChedTa'] as String?,
            community: row['community'] as int?,
            operationalArea: row['operationalArea'] as String?,
            contractorName: row['contractorName'] as String?,
            numberOfPeopleInGroup: row['numberOfPeopleInGroup'] as int?,
            groupWork: row['groupWork'] as String?,
            completedByContractor: row['completedByContractor'] as String?,
            areaCoveredRx: row['areaCoveredRx'] as String?),
        queryableName: 'InitialTreatmentMonitor',
        isView: false);
  }

  @override
  Future<List<InitialTreatmentMonitor>> findAllInitialTreatmentMonitor() async {
    return _queryAdapter.queryList('SELECT * FROM InitialTreatmentMonitor',
        mapper: (Map<String, Object?> row) => InitialTreatmentMonitor(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            staffContact: row['staffContact'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: row['activity'] as int?,
            monitoringDate: row['monitoringDate'] as String?,
            noRehabAssistants: row['noRehabAssistants'] as int?,
            areaCoveredHa: row['areaCoveredHa'] as double?,
            remark: row['remark'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as Uint8List?,
            ras: row['ras'] as String?,
            status: row['status'] as int?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            cocoaSeedlingsAlive: row['cocoaSeedlingsAlive'] as int?,
            plantainSeedlingsAlive: row['plantainSeedlingsAlive'] as int?,
            nameOfChedTa: row['nameOfChedTa'] as String?,
            contactOfChedTa: row['contactOfChedTa'] as String?,
            community: row['community'] as int?,
            operationalArea: row['operationalArea'] as String?,
            contractorName: row['contractorName'] as String?,
            numberOfPeopleInGroup: row['numberOfPeopleInGroup'] as int?,
            groupWork: row['groupWork'] as String?,
            completedByContractor: row['completedByContractor'] as String?,
            areaCoveredRx: row['areaCoveredRx'] as String?));
  }

  @override
  Stream<List<InitialTreatmentMonitor>>
      findInitialTreatmentMonitorByStatusStream(int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM InitialTreatmentMonitor WHERE status = ?1',
        mapper: (Map<String, Object?> row) => InitialTreatmentMonitor(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            staffContact: row['staffContact'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: row['activity'] as int?,
            monitoringDate: row['monitoringDate'] as String?,
            noRehabAssistants: row['noRehabAssistants'] as int?,
            areaCoveredHa: row['areaCoveredHa'] as double?,
            remark: row['remark'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as Uint8List?,
            ras: row['ras'] as String?,
            status: row['status'] as int?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            cocoaSeedlingsAlive: row['cocoaSeedlingsAlive'] as int?,
            plantainSeedlingsAlive: row['plantainSeedlingsAlive'] as int?,
            nameOfChedTa: row['nameOfChedTa'] as String?,
            contactOfChedTa: row['contactOfChedTa'] as String?,
            community: row['community'] as int?,
            operationalArea: row['operationalArea'] as String?,
            contractorName: row['contractorName'] as String?,
            numberOfPeopleInGroup: row['numberOfPeopleInGroup'] as int?,
            groupWork: row['groupWork'] as String?,
            completedByContractor: row['completedByContractor'] as String?,
            areaCoveredRx: row['areaCoveredRx'] as String?),
        arguments: [status],
        queryableName: 'InitialTreatmentMonitor',
        isView: false);
  }

  @override
  Future<List<InitialTreatmentMonitor>>
      findInitialTreatmentMonitorByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InitialTreatmentMonitor WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => InitialTreatmentMonitor(uid: row['uid'] as String?, agent: row['agent'] as String?, staffContact: row['staffContact'] as String?, mainActivity: row['mainActivity'] as int?, activity: row['activity'] as int?, monitoringDate: row['monitoringDate'] as String?, noRehabAssistants: row['noRehabAssistants'] as int?, areaCoveredHa: row['areaCoveredHa'] as double?, remark: row['remark'] as String?, lat: row['lat'] as double?, lng: row['lng'] as double?, accuracy: row['accuracy'] as double?, currentFarmPic: row['currentFarmPic'] as Uint8List?, ras: row['ras'] as String?, status: row['status'] as int?, farmRefNumber: row['farmRefNumber'] as String?, farmSizeHa: row['farmSizeHa'] as double?, cocoaSeedlingsAlive: row['cocoaSeedlingsAlive'] as int?, plantainSeedlingsAlive: row['plantainSeedlingsAlive'] as int?, nameOfChedTa: row['nameOfChedTa'] as String?, contactOfChedTa: row['contactOfChedTa'] as String?, community: row['community'] as int?, operationalArea: row['operationalArea'] as String?, contractorName: row['contractorName'] as String?, numberOfPeopleInGroup: row['numberOfPeopleInGroup'] as int?, groupWork: row['groupWork'] as String?, completedByContractor: row['completedByContractor'] as String?, areaCoveredRx: row['areaCoveredRx'] as String?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<InitialTreatmentMonitor>> findInitialTreatmentMonitorByStatus(
      int status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InitialTreatmentMonitor WHERE status = ?1',
        mapper: (Map<String, Object?> row) => InitialTreatmentMonitor(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            staffContact: row['staffContact'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: row['activity'] as int?,
            monitoringDate: row['monitoringDate'] as String?,
            noRehabAssistants: row['noRehabAssistants'] as int?,
            areaCoveredHa: row['areaCoveredHa'] as double?,
            remark: row['remark'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as Uint8List?,
            ras: row['ras'] as String?,
            status: row['status'] as int?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            cocoaSeedlingsAlive: row['cocoaSeedlingsAlive'] as int?,
            plantainSeedlingsAlive: row['plantainSeedlingsAlive'] as int?,
            nameOfChedTa: row['nameOfChedTa'] as String?,
            contactOfChedTa: row['contactOfChedTa'] as String?,
            community: row['community'] as int?,
            operationalArea: row['operationalArea'] as String?,
            contractorName: row['contractorName'] as String?,
            numberOfPeopleInGroup: row['numberOfPeopleInGroup'] as int?,
            groupWork: row['groupWork'] as String?,
            completedByContractor: row['completedByContractor'] as String?,
            areaCoveredRx: row['areaCoveredRx'] as String?),
        arguments: [status]);
  }

  @override
  Future<List<InitialTreatmentMonitor>> findInitialTreatmentMonitorByUID(
      String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InitialTreatmentMonitor WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => InitialTreatmentMonitor(
            uid: row['uid'] as String?,
            agent: row['agent'] as String?,
            staffContact: row['staffContact'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: row['activity'] as int?,
            monitoringDate: row['monitoringDate'] as String?,
            noRehabAssistants: row['noRehabAssistants'] as int?,
            areaCoveredHa: row['areaCoveredHa'] as double?,
            remark: row['remark'] as String?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as Uint8List?,
            ras: row['ras'] as String?,
            status: row['status'] as int?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            cocoaSeedlingsAlive: row['cocoaSeedlingsAlive'] as int?,
            plantainSeedlingsAlive: row['plantainSeedlingsAlive'] as int?,
            nameOfChedTa: row['nameOfChedTa'] as String?,
            contactOfChedTa: row['contactOfChedTa'] as String?,
            community: row['community'] as int?,
            operationalArea: row['operationalArea'] as String?,
            contractorName: row['contractorName'] as String?,
            numberOfPeopleInGroup: row['numberOfPeopleInGroup'] as int?,
            groupWork: row['groupWork'] as String?,
            completedByContractor: row['completedByContractor'] as String?,
            areaCoveredRx: row['areaCoveredRx'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteInitialTreatmentMonitorByUID(String id) async {
    return _queryAdapter.query(
        'DELETE FROM InitialTreatmentMonitor WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllInitialTreatmentMonitor() async {
    await _queryAdapter.queryNoReturn('DELETE FROM InitialTreatmentMonitor');
  }

  @override
  Future<int?> updateInitialTreatmentMonitorSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE InitialTreatmentMonitor SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertInitialTreatmentMonitor(
      InitialTreatmentMonitor monitor) async {
    await _initialTreatmentMonitorInsertionAdapter.insert(
        monitor, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertInitialTreatmentMonitor(
      List<InitialTreatmentMonitor> monitorList) {
    return _initialTreatmentMonitorInsertionAdapter.insertListAndReturnIds(
        monitorList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateInitialTreatmentMonitor(
      InitialTreatmentMonitor monitor) async {
    await _initialTreatmentMonitorUpdateAdapter.update(
        monitor, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteInitialTreatmentMonitor(InitialTreatmentMonitor monitor) {
    return _initialTreatmentMonitorDeletionAdapter
        .deleteAndReturnChangedRows(monitor);
  }
}

class _$ContractorCertificateDao extends ContractorCertificateDao {
  _$ContractorCertificateDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _contractorCertificateInsertionAdapter = InsertionAdapter(
            database,
            'ContractorCertificate',
            (ContractorCertificate item) => <String, Object?>{
                  'uid': item.uid,
                  'currentYear': item.currentYear,
                  'currentMonth': item.currentMonth,
                  'currrentWeek': item.currrentWeek,
                  'mainActivity': item.mainActivity,
                  'activity': _intListConverter.encode(item.activity),
                  'reportingDate': item.reportingDate,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'community': item.community,
                  'contractor': item.contractor,
                  'status': item.status,
                  'district': item.district,
                  'userId': item.userId
                },
            changeListener),
        _contractorCertificateUpdateAdapter = UpdateAdapter(
            database,
            'ContractorCertificate',
            ['uid'],
            (ContractorCertificate item) => <String, Object?>{
                  'uid': item.uid,
                  'currentYear': item.currentYear,
                  'currentMonth': item.currentMonth,
                  'currrentWeek': item.currrentWeek,
                  'mainActivity': item.mainActivity,
                  'activity': _intListConverter.encode(item.activity),
                  'reportingDate': item.reportingDate,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'community': item.community,
                  'contractor': item.contractor,
                  'status': item.status,
                  'district': item.district,
                  'userId': item.userId
                },
            changeListener),
        _contractorCertificateDeletionAdapter = DeletionAdapter(
            database,
            'ContractorCertificate',
            ['uid'],
            (ContractorCertificate item) => <String, Object?>{
                  'uid': item.uid,
                  'currentYear': item.currentYear,
                  'currentMonth': item.currentMonth,
                  'currrentWeek': item.currrentWeek,
                  'mainActivity': item.mainActivity,
                  'activity': _intListConverter.encode(item.activity),
                  'reportingDate': item.reportingDate,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'community': item.community,
                  'contractor': item.contractor,
                  'status': item.status,
                  'district': item.district,
                  'userId': item.userId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ContractorCertificate>
      _contractorCertificateInsertionAdapter;

  final UpdateAdapter<ContractorCertificate>
      _contractorCertificateUpdateAdapter;

  final DeletionAdapter<ContractorCertificate>
      _contractorCertificateDeletionAdapter;

  @override
  Stream<List<ContractorCertificate>> findAllContractorCertificateStream() {
    return _queryAdapter.queryListStream('SELECT * FROM ContractorCertificate',
        mapper: (Map<String, Object?> row) => ContractorCertificate(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            contractor: row['contractor'] as int?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?),
        queryableName: 'ContractorCertificate',
        isView: false);
  }

  @override
  Future<List<ContractorCertificate>> findAllContractorCertificate() async {
    return _queryAdapter.queryList('SELECT * FROM ContractorCertificate',
        mapper: (Map<String, Object?> row) => ContractorCertificate(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            contractor: row['contractor'] as int?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?));
  }

  @override
  Stream<List<ContractorCertificate>> findContractorCertificateByStatusStream(
      int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM ContractorCertificate WHERE status = ?1',
        mapper: (Map<String, Object?> row) => ContractorCertificate(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            contractor: row['contractor'] as int?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?),
        arguments: [status],
        queryableName: 'ContractorCertificate',
        isView: false);
  }

  @override
  Future<List<ContractorCertificate>>
      findContractorCertificateByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ContractorCertificate WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => ContractorCertificate(uid: row['uid'] as String?, currentYear: row['currentYear'] as String?, currentMonth: row['currentMonth'] as String?, currrentWeek: row['currrentWeek'] as String?, mainActivity: row['mainActivity'] as int?, activity: _intListConverter.decode(row['activity'] as String), reportingDate: row['reportingDate'] as String?, farmRefNumber: row['farmRefNumber'] as String?, farmSizeHa: row['farmSizeHa'] as double?, community: row['community'] as String?, contractor: row['contractor'] as int?, status: row['status'] as int?, district: row['district'] as int?, userId: row['userId'] as int?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<ContractorCertificate>> findContractorCertificateByStatus(
      int status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ContractorCertificate WHERE status = ?1',
        mapper: (Map<String, Object?> row) => ContractorCertificate(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            contractor: row['contractor'] as int?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?),
        arguments: [status]);
  }

  @override
  Future<List<ContractorCertificate>> findContractorCertificateByUID(
      String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ContractorCertificate WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => ContractorCertificate(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            contractor: row['contractor'] as int?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteContractorCertificateByUID(String id) async {
    return _queryAdapter.query(
        'DELETE FROM ContractorCertificate WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllContractorCertificate() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ContractorCertificate');
  }

  @override
  Future<int?> updateContractorCertificateSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE ContractorCertificate SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertContractorCertificate(
      ContractorCertificate contractorCertificate) async {
    await _contractorCertificateInsertionAdapter.insert(
        contractorCertificate, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertContractorCertificate(
      List<ContractorCertificate> contractorCertificateList) {
    return _contractorCertificateInsertionAdapter.insertListAndReturnIds(
        contractorCertificateList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateContractorCertificate(
      ContractorCertificate contractorCertificate) async {
    await _contractorCertificateUpdateAdapter.update(
        contractorCertificate, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteContractorCertificate(
      ContractorCertificate contractorCertificate) {
    return _contractorCertificateDeletionAdapter
        .deleteAndReturnChangedRows(contractorCertificate);
  }
}

class _$OutbreakFarmFromServerDao extends OutbreakFarmFromServerDao {
  _$OutbreakFarmFromServerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _outbreakFarmFromServerInsertionAdapter = InsertionAdapter(
            database,
            'OutbreakFarmFromServer',
            (OutbreakFarmFromServer item) => <String, Object?>{
                  'farmId': item.farmId,
                  'outbreaksId': item.outbreaksId,
                  'farmLocation': item.farmLocation,
                  'farmerName': item.farmerName,
                  'farmerAge': item.farmerAge,
                  'idType': item.idType,
                  'idNumber': item.idNumber,
                  'farmerContact': item.farmerContact,
                  'cocoaType': item.cocoaType,
                  'ageClass': item.ageClass,
                  'farmArea': item.farmArea,
                  'communitytbl': item.communitytbl,
                  'inspectionDate': item.inspectionDate,
                  'tempCode': item.tempCode
                },
            changeListener),
        _outbreakFarmFromServerDeletionAdapter = DeletionAdapter(
            database,
            'OutbreakFarmFromServer',
            ['farmId'],
            (OutbreakFarmFromServer item) => <String, Object?>{
                  'farmId': item.farmId,
                  'outbreaksId': item.outbreaksId,
                  'farmLocation': item.farmLocation,
                  'farmerName': item.farmerName,
                  'farmerAge': item.farmerAge,
                  'idType': item.idType,
                  'idNumber': item.idNumber,
                  'farmerContact': item.farmerContact,
                  'cocoaType': item.cocoaType,
                  'ageClass': item.ageClass,
                  'farmArea': item.farmArea,
                  'communitytbl': item.communitytbl,
                  'inspectionDate': item.inspectionDate,
                  'tempCode': item.tempCode
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OutbreakFarmFromServer>
      _outbreakFarmFromServerInsertionAdapter;

  final DeletionAdapter<OutbreakFarmFromServer>
      _outbreakFarmFromServerDeletionAdapter;

  @override
  Stream<List<OutbreakFarmFromServer>> findAllOutbreakFarmFromServerStream() {
    return _queryAdapter.queryListStream('SELECT * FROM OutbreakFarmFromServer',
        mapper: (Map<String, Object?> row) => OutbreakFarmFromServer(
            farmId: row['farmId'] as int?,
            outbreaksId: row['outbreaksId'] as String?,
            farmLocation: row['farmLocation'] as String?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytbl: row['communitytbl'] as String?,
            inspectionDate: row['inspectionDate'] as String?,
            tempCode: row['tempCode'] as String?),
        queryableName: 'OutbreakFarmFromServer',
        isView: false);
  }

  @override
  Future<List<OutbreakFarmFromServer>> findAllOutbreakFarmFromServer() async {
    return _queryAdapter.queryList('SELECT * FROM OutbreakFarmFromServer',
        mapper: (Map<String, Object?> row) => OutbreakFarmFromServer(
            farmId: row['farmId'] as int?,
            outbreaksId: row['outbreaksId'] as String?,
            farmLocation: row['farmLocation'] as String?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytbl: row['communitytbl'] as String?,
            inspectionDate: row['inspectionDate'] as String?,
            tempCode: row['tempCode'] as String?));
  }

  @override
  Future<List<OutbreakFarmFromServer>> findOutbreakFarmFromServerByFarmId(
      String farmId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM OutbreakFarmFromServer WHERE farmId = ?1',
        mapper: (Map<String, Object?> row) => OutbreakFarmFromServer(
            farmId: row['farmId'] as int?,
            outbreaksId: row['outbreaksId'] as String?,
            farmLocation: row['farmLocation'] as String?,
            farmerName: row['farmerName'] as String?,
            farmerAge: row['farmerAge'] as int?,
            idType: row['idType'] as String?,
            idNumber: row['idNumber'] as String?,
            farmerContact: row['farmerContact'] as String?,
            cocoaType: row['cocoaType'] as String?,
            ageClass: row['ageClass'] as String?,
            farmArea: row['farmArea'] as double?,
            communitytbl: row['communitytbl'] as String?,
            inspectionDate: row['inspectionDate'] as String?,
            tempCode: row['tempCode'] as String?),
        arguments: [farmId]);
  }

  @override
  Future<void> deleteAllOutbreakFarmFromServers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM OutbreakFarmFromServer');
  }

  @override
  Future<void> insertOutbreakFarmFromServer(OutbreakFarmFromServer farm) async {
    await _outbreakFarmFromServerInsertionAdapter.insert(
        farm, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertOutbreakFarmFromServer(
      List<OutbreakFarmFromServer> farmList) {
    return _outbreakFarmFromServerInsertionAdapter.insertListAndReturnIds(
        farmList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteOutbreakFarmFromServer(OutbreakFarmFromServer farm) {
    return _outbreakFarmFromServerDeletionAdapter
        .deleteAndReturnChangedRows(farm);
  }
}

class _$MaintenanceFuelDao extends MaintenanceFuelDao {
  _$MaintenanceFuelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _maintenanceFuelInsertionAdapter = InsertionAdapter(
            database,
            'MaintenanceFuel',
            (MaintenanceFuel item) => <String, Object?>{
                  'id': item.id,
                  'userid': item.userid,
                  'farmdetailstblForeignkey': item.farmdetailstblForeignkey,
                  'dateReceived': item.dateReceived,
                  'rehabassistantsTblForeignkey':
                      item.rehabassistantsTblForeignkey,
                  'fuelLtr': item.fuelLtr,
                  'remarks': item.remarks,
                  'uid': item.uid,
                  'status': item.status
                },
            changeListener),
        _maintenanceFuelUpdateAdapter = UpdateAdapter(
            database,
            'MaintenanceFuel',
            ['id'],
            (MaintenanceFuel item) => <String, Object?>{
                  'id': item.id,
                  'userid': item.userid,
                  'farmdetailstblForeignkey': item.farmdetailstblForeignkey,
                  'dateReceived': item.dateReceived,
                  'rehabassistantsTblForeignkey':
                      item.rehabassistantsTblForeignkey,
                  'fuelLtr': item.fuelLtr,
                  'remarks': item.remarks,
                  'uid': item.uid,
                  'status': item.status
                },
            changeListener),
        _maintenanceFuelDeletionAdapter = DeletionAdapter(
            database,
            'MaintenanceFuel',
            ['id'],
            (MaintenanceFuel item) => <String, Object?>{
                  'id': item.id,
                  'userid': item.userid,
                  'farmdetailstblForeignkey': item.farmdetailstblForeignkey,
                  'dateReceived': item.dateReceived,
                  'rehabassistantsTblForeignkey':
                      item.rehabassistantsTblForeignkey,
                  'fuelLtr': item.fuelLtr,
                  'remarks': item.remarks,
                  'uid': item.uid,
                  'status': item.status
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MaintenanceFuel> _maintenanceFuelInsertionAdapter;

  final UpdateAdapter<MaintenanceFuel> _maintenanceFuelUpdateAdapter;

  final DeletionAdapter<MaintenanceFuel> _maintenanceFuelDeletionAdapter;

  @override
  Stream<List<MaintenanceFuel>> findAllMaintenanceFuelStream() {
    return _queryAdapter.queryListStream('SELECT * FROM MaintenanceFuel',
        mapper: (Map<String, Object?> row) => MaintenanceFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        queryableName: 'MaintenanceFuel',
        isView: false);
  }

  @override
  Future<List<MaintenanceFuel>> findAllMaintenanceFuel() async {
    return _queryAdapter.queryList('SELECT * FROM MaintenanceFuel',
        mapper: (Map<String, Object?> row) => MaintenanceFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?));
  }

  @override
  Stream<List<MaintenanceFuel>> findMaintenanceFuelByStatusStream(int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM MaintenanceFuel WHERE status = ?1',
        mapper: (Map<String, Object?> row) => MaintenanceFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        arguments: [status],
        queryableName: 'MaintenanceFuel',
        isView: false);
  }

  @override
  Future<List<MaintenanceFuel>> findMaintenanceFuelByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MaintenanceFuel WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => MaintenanceFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<MaintenanceFuel>> findMaintenanceFuelByStatus(int status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MaintenanceFuel WHERE status = ?1',
        mapper: (Map<String, Object?> row) => MaintenanceFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        arguments: [status]);
  }

  @override
  Future<List<MaintenanceFuel>> findMaintenanceFuelByUID(String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MaintenanceFuel WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => MaintenanceFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteMaintenanceFuelByUID(String id) async {
    return _queryAdapter.query('DELETE FROM MaintenanceFuel WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllMaintenanceFuel() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MaintenanceFuel');
  }

  @override
  Future<int?> updateMaintenanceFuelSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE MaintenanceFuel SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertMaintenanceFuel(MaintenanceFuel maintenanceFuel) async {
    await _maintenanceFuelInsertionAdapter.insert(
        maintenanceFuel, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertMaintenanceFuel(
      List<MaintenanceFuel> maintenanceFuelList) {
    return _maintenanceFuelInsertionAdapter.insertListAndReturnIds(
        maintenanceFuelList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateMaintenanceFuel(MaintenanceFuel maintenanceFuel) async {
    await _maintenanceFuelUpdateAdapter.update(
        maintenanceFuel, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteMaintenanceFuel(MaintenanceFuel maintenanceFuel) {
    return _maintenanceFuelDeletionAdapter
        .deleteAndReturnChangedRows(maintenanceFuel);
  }
}

class _$InitialTreatmentFuelDao extends InitialTreatmentFuelDao {
  _$InitialTreatmentFuelDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _initialTreatmentFuelInsertionAdapter = InsertionAdapter(
            database,
            'InitialTreatmentFuel',
            (InitialTreatmentFuel item) => <String, Object?>{
                  'id': item.id,
                  'userid': item.userid,
                  'farmdetailstblForeignkey': item.farmdetailstblForeignkey,
                  'dateReceived': item.dateReceived,
                  'rehabassistantsTblForeignkey':
                      item.rehabassistantsTblForeignkey,
                  'fuelLtr': item.fuelLtr,
                  'remarks': item.remarks,
                  'uid': item.uid,
                  'status': item.status
                },
            changeListener),
        _initialTreatmentFuelUpdateAdapter = UpdateAdapter(
            database,
            'InitialTreatmentFuel',
            ['id'],
            (InitialTreatmentFuel item) => <String, Object?>{
                  'id': item.id,
                  'userid': item.userid,
                  'farmdetailstblForeignkey': item.farmdetailstblForeignkey,
                  'dateReceived': item.dateReceived,
                  'rehabassistantsTblForeignkey':
                      item.rehabassistantsTblForeignkey,
                  'fuelLtr': item.fuelLtr,
                  'remarks': item.remarks,
                  'uid': item.uid,
                  'status': item.status
                },
            changeListener),
        _initialTreatmentFuelDeletionAdapter = DeletionAdapter(
            database,
            'InitialTreatmentFuel',
            ['id'],
            (InitialTreatmentFuel item) => <String, Object?>{
                  'id': item.id,
                  'userid': item.userid,
                  'farmdetailstblForeignkey': item.farmdetailstblForeignkey,
                  'dateReceived': item.dateReceived,
                  'rehabassistantsTblForeignkey':
                      item.rehabassistantsTblForeignkey,
                  'fuelLtr': item.fuelLtr,
                  'remarks': item.remarks,
                  'uid': item.uid,
                  'status': item.status
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<InitialTreatmentFuel>
      _initialTreatmentFuelInsertionAdapter;

  final UpdateAdapter<InitialTreatmentFuel> _initialTreatmentFuelUpdateAdapter;

  final DeletionAdapter<InitialTreatmentFuel>
      _initialTreatmentFuelDeletionAdapter;

  @override
  Stream<List<InitialTreatmentFuel>> findAllInitialTreatmentFuelStream() {
    return _queryAdapter.queryListStream('SELECT * FROM InitialTreatmentFuel',
        mapper: (Map<String, Object?> row) => InitialTreatmentFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        queryableName: 'InitialTreatmentFuel',
        isView: false);
  }

  @override
  Future<List<InitialTreatmentFuel>> findAllInitialTreatmentFuel() async {
    return _queryAdapter.queryList('SELECT * FROM InitialTreatmentFuel',
        mapper: (Map<String, Object?> row) => InitialTreatmentFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?));
  }

  @override
  Stream<List<InitialTreatmentFuel>> findInitialTreatmentFuelByStatusStream(
      int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM InitialTreatmentFuel WHERE status = ?1',
        mapper: (Map<String, Object?> row) => InitialTreatmentFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        arguments: [status],
        queryableName: 'InitialTreatmentFuel',
        isView: false);
  }

  @override
  Future<List<InitialTreatmentFuel>> findInitialTreatmentFuelByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InitialTreatmentFuel WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => InitialTreatmentFuel(id: row['id'] as int?, userid: row['userid'] as int?, farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?, dateReceived: row['dateReceived'] as String?, rehabassistantsTblForeignkey: row['rehabassistantsTblForeignkey'] as int?, fuelLtr: row['fuelLtr'] as int?, remarks: row['remarks'] as String?, uid: row['uid'] as String?, status: row['status'] as int?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<InitialTreatmentFuel>> findInitialTreatmentFuelByStatus(
      int status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InitialTreatmentFuel WHERE status = ?1',
        mapper: (Map<String, Object?> row) => InitialTreatmentFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        arguments: [status]);
  }

  @override
  Future<List<InitialTreatmentFuel>> findInitialTreatmentFuelByUID(
      String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM InitialTreatmentFuel WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => InitialTreatmentFuel(
            id: row['id'] as int?,
            userid: row['userid'] as int?,
            farmdetailstblForeignkey: row['farmdetailstblForeignkey'] as int?,
            dateReceived: row['dateReceived'] as String?,
            rehabassistantsTblForeignkey:
                row['rehabassistantsTblForeignkey'] as int?,
            fuelLtr: row['fuelLtr'] as int?,
            remarks: row['remarks'] as String?,
            uid: row['uid'] as String?,
            status: row['status'] as int?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteInitialTreatmentFuelByUID(String id) async {
    return _queryAdapter.query(
        'DELETE FROM InitialTreatmentFuel WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllInitialTreatmentFuel() async {
    await _queryAdapter.queryNoReturn('DELETE FROM InitialTreatmentFuel');
  }

  @override
  Future<int?> updateInitialTreatmentFuelSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE InitialTreatmentFuel SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertInitialTreatmentFuel(
      InitialTreatmentFuel initialTreatmentFuel) async {
    await _initialTreatmentFuelInsertionAdapter.insert(
        initialTreatmentFuel, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertInitialTreatmentFuel(
      List<InitialTreatmentFuel> initialTreatmentFuelList) {
    return _initialTreatmentFuelInsertionAdapter.insertListAndReturnIds(
        initialTreatmentFuelList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateInitialTreatmentFuel(
      InitialTreatmentFuel initialTreatmentFuel) async {
    await _initialTreatmentFuelUpdateAdapter.update(
        initialTreatmentFuel, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteInitialTreatmentFuel(
      InitialTreatmentFuel initialTreatmentFuel) {
    return _initialTreatmentFuelDeletionAdapter
        .deleteAndReturnChangedRows(initialTreatmentFuel);
  }
}

class _$EquipmentDao extends EquipmentDao {
  _$EquipmentDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _equipmentInsertionAdapter = InsertionAdapter(
            database,
            'Equipment',
            (Equipment item) => <String, Object?>{
                  'id': item.id,
                  'equipmentCode': item.equipmentCode,
                  'dateOfCapturing':
                      _dateTimeConverter.encode(item.dateOfCapturing),
                  'equipment': item.equipment,
                  'status': item.status,
                  'serialNumber': item.serialNumber,
                  'manufacturer': item.manufacturer,
                  'picSerialNumber': item.picSerialNumber,
                  'picEquipment': item.picEquipment,
                  'staffName': item.staffName
                },
            changeListener),
        _equipmentDeletionAdapter = DeletionAdapter(
            database,
            'Equipment',
            ['id'],
            (Equipment item) => <String, Object?>{
                  'id': item.id,
                  'equipmentCode': item.equipmentCode,
                  'dateOfCapturing':
                      _dateTimeConverter.encode(item.dateOfCapturing),
                  'equipment': item.equipment,
                  'status': item.status,
                  'serialNumber': item.serialNumber,
                  'manufacturer': item.manufacturer,
                  'picSerialNumber': item.picSerialNumber,
                  'picEquipment': item.picEquipment,
                  'staffName': item.staffName
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Equipment> _equipmentInsertionAdapter;

  final DeletionAdapter<Equipment> _equipmentDeletionAdapter;

  @override
  Stream<List<Equipment>> findAllEquipmentStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Equipment',
        mapper: (Map<String, Object?> row) => Equipment(
            id: row['id'] as int?,
            equipmentCode: row['equipmentCode'] as String?,
            dateOfCapturing:
                _dateTimeConverter.decode(row['dateOfCapturing'] as int),
            equipment: row['equipment'] as String?,
            status: row['status'] as String?,
            serialNumber: row['serialNumber'] as String?,
            manufacturer: row['manufacturer'] as String?,
            picSerialNumber: row['picSerialNumber'] as String?,
            picEquipment: row['picEquipment'] as String?,
            staffName: row['staffName'] as String?),
        queryableName: 'Equipment',
        isView: false);
  }

  @override
  Stream<List<Equipment>> streamAllEquipmentWithNamesLike(String equipment) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Equipment WHERE LOWER(equipment) LIKE ?1 OR LOWER(equipmentCode) LIKE ?1',
        mapper: (Map<String, Object?> row) => Equipment(
            id: row['id'] as int?,
            equipmentCode: row['equipmentCode'] as String?,
            dateOfCapturing:
                _dateTimeConverter.decode(row['dateOfCapturing'] as int),
            equipment: row['equipment'] as String?,
            status: row['status'] as String?,
            serialNumber: row['serialNumber'] as String?,
            manufacturer: row['manufacturer'] as String?,
            picSerialNumber: row['picSerialNumber'] as String?,
            picEquipment: row['picEquipment'] as String?,
            staffName: row['staffName'] as String?),
        arguments: [equipment],
        queryableName: 'Equipment',
        isView: false);
  }

  @override
  Future<List<Equipment>> findAllEquipments() async {
    return _queryAdapter.queryList('SELECT * FROM Equipment',
        mapper: (Map<String, Object?> row) => Equipment(
            id: row['id'] as int?,
            equipmentCode: row['equipmentCode'] as String?,
            dateOfCapturing:
                _dateTimeConverter.decode(row['dateOfCapturing'] as int),
            equipment: row['equipment'] as String?,
            status: row['status'] as String?,
            serialNumber: row['serialNumber'] as String?,
            manufacturer: row['manufacturer'] as String?,
            picSerialNumber: row['picSerialNumber'] as String?,
            picEquipment: row['picEquipment'] as String?,
            staffName: row['staffName'] as String?));
  }

  @override
  Future<List<Equipment>> findEquipmentsWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList('SELECT * FROM Equipment LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => Equipment(
            id: row['id'] as int?,
            equipmentCode: row['equipmentCode'] as String?,
            dateOfCapturing:
                _dateTimeConverter.decode(row['dateOfCapturing'] as int),
            equipment: row['equipment'] as String?,
            status: row['status'] as String?,
            serialNumber: row['serialNumber'] as String?,
            manufacturer: row['manufacturer'] as String?,
            picSerialNumber: row['picSerialNumber'] as String?,
            picEquipment: row['picEquipment'] as String?,
            staffName: row['staffName'] as String?),
        arguments: [limit, offset]);
  }

  @override
  Future<List<Equipment>> findEquipmentsWithSearchAndLimit(
    String searchTerm,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Equipment WHERE LOWER(equipment) LIKE ?1 OR LOWER(equipmentCode) LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => Equipment(id: row['id'] as int?, equipmentCode: row['equipmentCode'] as String?, dateOfCapturing: _dateTimeConverter.decode(row['dateOfCapturing'] as int), equipment: row['equipment'] as String?, status: row['status'] as String?, serialNumber: row['serialNumber'] as String?, manufacturer: row['manufacturer'] as String?, picSerialNumber: row['picSerialNumber'] as String?, picEquipment: row['picEquipment'] as String?, staffName: row['staffName'] as String?),
        arguments: [searchTerm, limit, offset]);
  }

  @override
  Future<List<Equipment>> findEquipmentById(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Equipment WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Equipment(
            id: row['id'] as int?,
            equipmentCode: row['equipmentCode'] as String?,
            dateOfCapturing:
                _dateTimeConverter.decode(row['dateOfCapturing'] as int),
            equipment: row['equipment'] as String?,
            status: row['status'] as String?,
            serialNumber: row['serialNumber'] as String?,
            manufacturer: row['manufacturer'] as String?,
            picSerialNumber: row['picSerialNumber'] as String?,
            picEquipment: row['picEquipment'] as String?,
            staffName: row['staffName'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteEquipmentByRehabCode(String equipmentCode) async {
    return _queryAdapter.query('DELETE FROM Equipment WHERE equipmentCode = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [equipmentCode]);
  }

  @override
  Future<void> deleteAllEquipments() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Equipment');
  }

  @override
  Future<void> insertEquipment(Equipment equipment) async {
    await _equipmentInsertionAdapter.insert(
        equipment, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertEquipments(List<Equipment> equipmentList) {
    return _equipmentInsertionAdapter.insertListAndReturnIds(
        equipmentList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteEquipment(Equipment equipment) {
    return _equipmentDeletionAdapter.deleteAndReturnChangedRows(equipment);
  }
}

class _$ContractorCertificateVerificationDao
    extends ContractorCertificateVerificationDao {
  _$ContractorCertificateVerificationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _contractorCertificateVerificationInsertionAdapter = InsertionAdapter(
            database,
            'ContractorCertificateVerification',
            (ContractorCertificateVerification item) => <String, Object?>{
                  'uid': item.uid,
                  'currentYear': item.currentYear,
                  'currentMonth': item.currentMonth,
                  'currrentWeek': item.currrentWeek,
                  'mainActivity': item.mainActivity,
                  'activity': _intListConverter.encode(item.activity),
                  'reportingDate': item.reportingDate,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'community': item.community,
                  'status': item.status,
                  'district': item.district,
                  'userId': item.userId,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'currentFarmPic': item.currentFarmPic,
                  'contractor': item.contractor,
                  'completedBy': item.completedBy
                },
            changeListener),
        _contractorCertificateVerificationUpdateAdapter = UpdateAdapter(
            database,
            'ContractorCertificateVerification',
            ['uid'],
            (ContractorCertificateVerification item) => <String, Object?>{
                  'uid': item.uid,
                  'currentYear': item.currentYear,
                  'currentMonth': item.currentMonth,
                  'currrentWeek': item.currrentWeek,
                  'mainActivity': item.mainActivity,
                  'activity': _intListConverter.encode(item.activity),
                  'reportingDate': item.reportingDate,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'community': item.community,
                  'status': item.status,
                  'district': item.district,
                  'userId': item.userId,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'currentFarmPic': item.currentFarmPic,
                  'contractor': item.contractor,
                  'completedBy': item.completedBy
                },
            changeListener),
        _contractorCertificateVerificationDeletionAdapter = DeletionAdapter(
            database,
            'ContractorCertificateVerification',
            ['uid'],
            (ContractorCertificateVerification item) => <String, Object?>{
                  'uid': item.uid,
                  'currentYear': item.currentYear,
                  'currentMonth': item.currentMonth,
                  'currrentWeek': item.currrentWeek,
                  'mainActivity': item.mainActivity,
                  'activity': _intListConverter.encode(item.activity),
                  'reportingDate': item.reportingDate,
                  'farmRefNumber': item.farmRefNumber,
                  'farmSizeHa': item.farmSizeHa,
                  'community': item.community,
                  'status': item.status,
                  'district': item.district,
                  'userId': item.userId,
                  'lat': item.lat,
                  'lng': item.lng,
                  'accuracy': item.accuracy,
                  'currentFarmPic': item.currentFarmPic,
                  'contractor': item.contractor,
                  'completedBy': item.completedBy
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ContractorCertificateVerification>
      _contractorCertificateVerificationInsertionAdapter;

  final UpdateAdapter<ContractorCertificateVerification>
      _contractorCertificateVerificationUpdateAdapter;

  final DeletionAdapter<ContractorCertificateVerification>
      _contractorCertificateVerificationDeletionAdapter;

  @override
  Stream<List<ContractorCertificateVerification>>
      findAllContractorCertificateVerificationStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM ContractorCertificateVerification',
        mapper: (Map<String, Object?> row) => ContractorCertificateVerification(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as String?,
            contractor: row['contractor'] as int?,
            completedBy: row['completedBy'] as String?),
        queryableName: 'ContractorCertificateVerification',
        isView: false);
  }

  @override
  Future<List<ContractorCertificateVerification>>
      findAllContractorCertificateVerification() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ContractorCertificateVerification',
        mapper: (Map<String, Object?> row) => ContractorCertificateVerification(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as String?,
            contractor: row['contractor'] as int?,
            completedBy: row['completedBy'] as String?));
  }

  @override
  Stream<List<ContractorCertificateVerification>>
      findContractorCertificateVerificationByStatusStream(int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM ContractorCertificateVerification WHERE status = ?1',
        mapper: (Map<String, Object?> row) => ContractorCertificateVerification(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as String?,
            contractor: row['contractor'] as int?,
            completedBy: row['completedBy'] as String?),
        arguments: [status],
        queryableName: 'ContractorCertificateVerification',
        isView: false);
  }

  @override
  Future<List<ContractorCertificateVerification>>
      findContractorCertificateVerificationByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ContractorCertificateVerification WHERE status = ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => ContractorCertificateVerification(uid: row['uid'] as String?, currentYear: row['currentYear'] as String?, currentMonth: row['currentMonth'] as String?, currrentWeek: row['currrentWeek'] as String?, mainActivity: row['mainActivity'] as int?, activity: _intListConverter.decode(row['activity'] as String), reportingDate: row['reportingDate'] as String?, farmRefNumber: row['farmRefNumber'] as String?, farmSizeHa: row['farmSizeHa'] as double?, community: row['community'] as String?, status: row['status'] as int?, district: row['district'] as int?, userId: row['userId'] as int?, lat: row['lat'] as double?, lng: row['lng'] as double?, accuracy: row['accuracy'] as double?, currentFarmPic: row['currentFarmPic'] as String?, contractor: row['contractor'] as int?, completedBy: row['completedBy'] as String?),
        arguments: [status, limit, offset]);
  }

  @override
  Future<List<ContractorCertificateVerification>>
      findContractorCertificateVerificationByStatus(int status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ContractorCertificateVerification WHERE status = ?1',
        mapper: (Map<String, Object?> row) => ContractorCertificateVerification(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as String?,
            contractor: row['contractor'] as int?,
            completedBy: row['completedBy'] as String?),
        arguments: [status]);
  }

  @override
  Future<List<ContractorCertificateVerification>>
      findContractorCertificateVerificationByUID(String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ContractorCertificateVerification WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => ContractorCertificateVerification(
            uid: row['uid'] as String?,
            currentYear: row['currentYear'] as String?,
            currentMonth: row['currentMonth'] as String?,
            currrentWeek: row['currrentWeek'] as String?,
            mainActivity: row['mainActivity'] as int?,
            activity: _intListConverter.decode(row['activity'] as String),
            reportingDate: row['reportingDate'] as String?,
            farmRefNumber: row['farmRefNumber'] as String?,
            farmSizeHa: row['farmSizeHa'] as double?,
            community: row['community'] as String?,
            status: row['status'] as int?,
            district: row['district'] as int?,
            userId: row['userId'] as int?,
            lat: row['lat'] as double?,
            lng: row['lng'] as double?,
            accuracy: row['accuracy'] as double?,
            currentFarmPic: row['currentFarmPic'] as String?,
            contractor: row['contractor'] as int?,
            completedBy: row['completedBy'] as String?),
        arguments: [id]);
  }

  @override
  Future<int?> deleteContractorCertificateVerificationByUID(String id) async {
    return _queryAdapter.query(
        'DELETE FROM ContractorCertificateVerification WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllContractorCertificateVerification() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM ContractorCertificateVerification');
  }

  @override
  Future<int?> updateContractorCertificateVerificationSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query(
        'UPDATE ContractorCertificateVerification SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertContractorCertificateVerification(
      ContractorCertificateVerification
          contractorCertificateVerification) async {
    await _contractorCertificateVerificationInsertionAdapter.insert(
        contractorCertificateVerification, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertContractorCertificateVerification(
      List<ContractorCertificateVerification>
          contractorCertificateVerificationList) {
    return _contractorCertificateVerificationInsertionAdapter
        .insertListAndReturnIds(
            contractorCertificateVerificationList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateContractorCertificateVerification(
      ContractorCertificateVerification
          contractorCertificateVerification) async {
    await _contractorCertificateVerificationUpdateAdapter.update(
        contractorCertificateVerification, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteContractorCertificateVerification(
      ContractorCertificateVerification contractorCertificateVerification) {
    return _contractorCertificateVerificationDeletionAdapter
        .deleteAndReturnChangedRows(contractorCertificateVerification);
  }
}

class _$SocietyDao extends SocietyDao {
  _$SocietyDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _societyInsertionAdapter = InsertionAdapter(
            database,
            'Society',
            (Society item) => <String, Object?>{
                  'id': item.id,
                  'societyCode': item.societyCode,
                  'societyName': item.societyName
                }),
        _societyDeletionAdapter = DeletionAdapter(
            database,
            'Society',
            ['id'],
            (Society item) => <String, Object?>{
                  'id': item.id,
                  'societyCode': item.societyCode,
                  'societyName': item.societyName
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Society> _societyInsertionAdapter;

  final DeletionAdapter<Society> _societyDeletionAdapter;

  @override
  Future<List<Society>> findAllSociety() async {
    return _queryAdapter.queryList('SELECT * FROM Society',
        mapper: (Map<String, Object?> row) => Society(
            id: row['id'] as int?,
            societyCode: row['societyCode'] as int?,
            societyName: row['societyName'] as String?));
  }

  @override
  Future<List<Society>> findSocietyBySocietyName(String societyName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Society WHERE societyName = ?1',
        mapper: (Map<String, Object?> row) => Society(
            id: row['id'] as int?,
            societyCode: row['societyCode'] as int?,
            societyName: row['societyName'] as String?),
        arguments: [societyName]);
  }

  @override
  Future<List<Society>> findSocietyBySocietyCode(int societyCode) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Society WHERE societyCode = ?1',
        mapper: (Map<String, Object?> row) => Society(
            id: row['id'] as int?,
            societyCode: row['societyCode'] as int?,
            societyName: row['societyName'] as String?),
        arguments: [societyCode]);
  }

  @override
  Future<void> deleteAllSociety() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Society');
  }

  @override
  Future<void> insertSociety(Society society) async {
    await _societyInsertionAdapter.insert(society, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertSociety(List<Society> societyList) {
    return _societyInsertionAdapter.insertListAndReturnIds(
        societyList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteSociety(Society society) {
    return _societyDeletionAdapter.deleteAndReturnChangedRows(society);
  }
}

class _$FarmerFromServerDao extends FarmerFromServerDao {
  _$FarmerFromServerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _farmerFromServerInsertionAdapter = InsertionAdapter(
            database,
            'FarmerFromServer',
            (FarmerFromServer item) => <String, Object?>{
                  'id': item.id,
                  'farmerName': item.farmerName,
                  'farmerId': item.farmerId,
                  'farmerCode': item.farmerCode,
                  'phoneNumber': item.phoneNumber,
                  'societyName': item.societyName,
                  'nationalIdNumber': item.nationalIdNumber,
                  'numberOfCocoaFarms': item.numberOfCocoaFarms,
                  'numberOfCertifiedCrops': item.numberOfCertifiedCrops,
                  'cocoaBagsHarvestedPreviousYear':
                      item.cocoaBagsHarvestedPreviousYear,
                  'cocoaBagsSoldToGroup': item.cocoaBagsSoldToGroup,
                  'currentYearYieldEstimate': item.currentYearYieldEstimate
                },
            changeListener),
        _farmerFromServerDeletionAdapter = DeletionAdapter(
            database,
            'FarmerFromServer',
            ['id'],
            (FarmerFromServer item) => <String, Object?>{
                  'id': item.id,
                  'farmerName': item.farmerName,
                  'farmerId': item.farmerId,
                  'farmerCode': item.farmerCode,
                  'phoneNumber': item.phoneNumber,
                  'societyName': item.societyName,
                  'nationalIdNumber': item.nationalIdNumber,
                  'numberOfCocoaFarms': item.numberOfCocoaFarms,
                  'numberOfCertifiedCrops': item.numberOfCertifiedCrops,
                  'cocoaBagsHarvestedPreviousYear':
                      item.cocoaBagsHarvestedPreviousYear,
                  'cocoaBagsSoldToGroup': item.cocoaBagsSoldToGroup,
                  'currentYearYieldEstimate': item.currentYearYieldEstimate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FarmerFromServer> _farmerFromServerInsertionAdapter;

  final DeletionAdapter<FarmerFromServer> _farmerFromServerDeletionAdapter;

  @override
  Stream<List<FarmerFromServer>> findAllFarmersFromServerStream() {
    return _queryAdapter.queryListStream('SELECT * FROM FarmerFromServer',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        queryableName: 'FarmerFromServer',
        isView: false);
  }

  @override
  Stream<List<FarmerFromServer>> streamAllFarmersFromServerWithNamesLike(
      String farmerName) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM FarmerFromServer WHERE LOWER(farmerName) LIKE ?1 OR LOWER(farmerCode) LIKE ?1',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        arguments: [farmerName],
        queryableName: 'FarmerFromServer',
        isView: false);
  }

  @override
  Future<List<FarmerFromServer>> findAllFarmersFromServer() async {
    return _queryAdapter.queryList('SELECT * FROM FarmerFromServer',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?));
  }

  @override
  Future<List<FarmerFromServer>> findFarmersFromServerWithLimit(
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FarmerFromServer LIMIT ?1 OFFSET ?2',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        arguments: [limit, offset]);
  }

  @override
  Future<List<FarmerFromServer>> findFarmersFromServerWithSearchAndLimit(
    String searchTerm,
    int limit,
    int offset,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FarmerFromServer WHERE LOWER(farmerName) LIKE ?1 OR LOWER(farmerCode) LIKE ?1 LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => FarmerFromServer(id: row['id'] as int?, farmerName: row['farmerName'] as String?, farmerId: row['farmerId'] as int?, farmerCode: row['farmerCode'] as String?, phoneNumber: row['phoneNumber'] as String?, societyName: row['societyName'] as String?, nationalIdNumber: row['nationalIdNumber'] as String?, numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?, numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?, cocoaBagsHarvestedPreviousYear: row['cocoaBagsHarvestedPreviousYear'] as int?, cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?, currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        arguments: [searchTerm, limit, offset]);
  }

  @override
  Future<List<FarmerFromServer>> findFarmersFromServerInSociety(
      String societyName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FarmerFromServer WHERE societyName = ?1',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        arguments: [societyName]);
  }

  @override
  Future<List<FarmerFromServer>> findFarmerFromServerByFarmerId(
      int farmerId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FarmerFromServer WHERE farmerId = ?1',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        arguments: [farmerId]);
  }

  @override
  Future<List<FarmerFromServer>> findFarmersFromServerByFarmerCodes(
      List<int> farmerIds) async {
    const offset = 1;
    final _sqliteVariablesForFarmerIds =
        Iterable<String>.generate(farmerIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM FarmerFromServer WHERE farmerId IN (' +
            _sqliteVariablesForFarmerIds +
            ')',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        arguments: [...farmerIds]);
  }

  @override
  Future<List<FarmerFromServer>> findFarmersFromServerById(int farmerId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM FarmerFromServer WHERE farmerId = ?1',
        mapper: (Map<String, Object?> row) => FarmerFromServer(
            id: row['id'] as int?,
            farmerName: row['farmerName'] as String?,
            farmerId: row['farmerId'] as int?,
            farmerCode: row['farmerCode'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            societyName: row['societyName'] as String?,
            nationalIdNumber: row['nationalIdNumber'] as String?,
            numberOfCocoaFarms: row['numberOfCocoaFarms'] as int?,
            numberOfCertifiedCrops: row['numberOfCertifiedCrops'] as int?,
            cocoaBagsHarvestedPreviousYear:
                row['cocoaBagsHarvestedPreviousYear'] as int?,
            cocoaBagsSoldToGroup: row['cocoaBagsSoldToGroup'] as int?,
            currentYearYieldEstimate: row['currentYearYieldEstimate'] as int?),
        arguments: [farmerId]);
  }

  @override
  Future<int?> deleteFarmersFromServerByFarmerId(int farmerId) async {
    return _queryAdapter.query(
        'DELETE FROM FarmerFromServer WHERE farmerId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [farmerId]);
  }

  @override
  Future<void> deleteAllFarmersFromServer() async {
    await _queryAdapter.queryNoReturn('DELETE FROM FarmerFromServer');
  }

  @override
  Future<void> insertFarmerFromServer(FarmerFromServer farmerFromServer) async {
    await _farmerFromServerInsertionAdapter.insert(
        farmerFromServer, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertFarmersFromServer(
      List<FarmerFromServer> farmerFromServerList) {
    return _farmerFromServerInsertionAdapter.insertListAndReturnIds(
        farmerFromServerList, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteFarmerFromServer(FarmerFromServer farmerFromServer) {
    return _farmerFromServerDeletionAdapter
        .deleteAndReturnChangedRows(farmerFromServer);
  }
}

class _$MapFarmDao extends MapFarmDao {
  _$MapFarmDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _mapFarmInsertionAdapter = InsertionAdapter(
            database,
            'MapFarm',
            (MapFarm item) => <String, Object?>{
                  'uid': item.uid,
                  'userid': item.userid,
                  'farmboundary': item.farmboundary,
                  'farmerName': item.farmerName,
                  'farmerContact': item.farmerContact,
                  'farmSize': item.farmSize,
                  'location': item.district,
                  'region': item.region,
                  'farmReference': item.farmReference,
                  'status': item.status,
                },
            changeListener),
        _mapFarmUpdateAdapter = UpdateAdapter(
            database,
            'MapFarm',
            ['uid'],
            (MapFarm item) => <String, Object?>{
                  'uid': item.uid,
                  'userid': item.userid,
                  'farmboundary': item.farmboundary,
                  'farmerName': item.farmerName,
                  'farmerContact': item.farmerContact,
                  'farmSize': item.farmSize,
                  'location': item.district,
                  'region': item.region,
                  'farmReference': item.farmReference,
                  'status': item.status,
                },
            changeListener),
        _mapFarmDeletionAdapter = DeletionAdapter(
            database,
            'MapFarm',
            ['uid'],
            (MapFarm item) => <String, Object?>{
                  'uid': item.uid,
                  'userid': item.userid,
                  'farmboundary': item.farmboundary,
                  'farmerName': item.farmerName,
                  'farmerContact': item.farmerContact,
                  'farmSize': item.farmSize,
                  'location': item.district,
                  'region': item.region,
                  'farmReference': item.farmReference,
                  'status': item.status,
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MapFarm> _mapFarmInsertionAdapter;

  final UpdateAdapter<MapFarm> _mapFarmUpdateAdapter;

  final DeletionAdapter<MapFarm> _mapFarmDeletionAdapter;

  @override
  Stream<List<MapFarm>> findAllMapFarmStream() {
    return _queryAdapter.queryListStream('SELECT * FROM MapFarm',
        mapper: (Map<String, Object?> row) => MapFarm(
              uid: row['uid'] as String?,
              userid: row['userid'] as String?,
              farmboundary: row['farmboundary'] as Uint8List?,
              farmerName: row['farmerName'] as String?,
              farmerContact: row['farmerContact'] as String?,
              farmSize: row['farmSize'] as double?,
              district: row['location'] as String?,
              region: row['region'] as String?,
              farmReference: row['farmReference'] as String?,
              status: row['status'] as int?,
            ),
        queryableName: 'MapFarm',
        isView: false);
  }

  @override
  Future<List<MapFarm>> findAllMapFarm() async {
    return _queryAdapter.queryList('SELECT * FROM MapFarm',
        mapper: (Map<String, Object?> row) => MapFarm(
              uid: row['uid'] as String?,
              userid: row['userid'] as String?,
              farmboundary: row['farmboundary'] as Uint8List?,
              farmerName: row['farmerName'] as String?,
              farmerContact: row['farmerContact'] as String?,
              farmSize: row['farmSize'] as double?,
              district: row['location'] as String?,
              region: row['region'] as String?,
              farmReference: row['farmReference'] as String?,
              status: row['status'] as int?,
            ));
  }

  @override
  Stream<List<MapFarm>> findMapFarmByStatusStream(int status) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM MapFarm WHERE status = ?1',
        mapper: (Map<String, Object?> row) => MapFarm(
              uid: row['uid'] as String?,
              userid: row['userid'] as String?,
              farmboundary: row['farmboundary'] as Uint8List?,
              farmerName: row['farmerName'] as String?,
              farmerContact: row['farmerContact'] as String?,
              farmSize: row['farmSize'] as double?,
              district: row['location'] as String?,
              region: row['region'] as String?,
              farmReference: row['farmReference'] as String?,
              status: row['status'] as int?,
            ),
        arguments: [status],
        queryableName: 'MapFarm',
        isView: false);
  }

  @override
  Future<List<MapFarm>> findMapFarmByStatusWithLimit(
    int status,
    int limit,
    int offset,
  ) async {
    return _queryAdapter
        .queryList('SELECT * FROM MapFarm WHERE status = ?1 LIMIT ?2 OFFSET ?3',
            mapper: (Map<String, Object?> row) => MapFarm(
                  uid: row['uid'] as String?,
                  userid: row['userid'] as String?,
                  farmboundary: row['farmboundary'] as Uint8List?,
                  farmerName: row['farmerName'] as String?,
                  farmerContact: row['farmerContact'] as String?,
                  farmSize: row['farmSize'] as double?,
                  district: row['location'] as String?,
                  region: row['region'] as String?,
                  farmReference: row['farmReference'] as String?,
                  status: row['status'] as int?,
                ),
            arguments: [status, limit, offset]);
  }

  @override
  Future<List<MapFarm>> findMapFarmByStatus(int status) async {
    return _queryAdapter.queryList('SELECT * FROM MapFarm WHERE status = ?1',
        mapper: (Map<String, Object?> row) => MapFarm(
              uid: row['uid'] as String?,
              userid: row['userid'] as String?,
              farmboundary: row['farmboundary'] as Uint8List?,
              farmerName: row['farmerName'] as String?,
              farmerContact: row['farmerContact'] as String?,
              farmSize: row['farmSize'] as double?,
              district: row['location'] as String?,
              region: row['region'] as String?,
              farmReference: row['farmReference'] as String?,
              status: row['status'] as int?,
            ),
        arguments: [status]);
  }

  @override
  Future<List<MapFarm>> findMapFarmByUID(String id) async {
    return _queryAdapter.queryList('SELECT * FROM MapFarm WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => MapFarm(
              uid: row['uid'] as String?,
              userid: row['userid'] as String?,
              farmboundary: row['farmboundary'] as Uint8List?,
              farmerName: row['farmerName'] as String?,
              farmerContact: row['farmerContact'] as String?,
              farmSize: row['farmSize'] as double?,
              district: row['location'] as String?,
              region: row['region'] as String?,
              farmReference: row['farmReference'] as String?,
              status: row['status'] as int?,
            ),
        arguments: [id]);
  }

  @override
  Future<int?> deleteMapFarmByUID(String id) async {
    return _queryAdapter.query('DELETE FROM MapFarm WHERE uid = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> deleteAllMapFarm() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MapFarm');
  }

  @override
  Future<int?> updateMapFarmSubmissionStatusByUID(
    int status,
    String id,
  ) async {
    return _queryAdapter.query('UPDATE MapFarm SET status = ?1 WHERE uid = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [status, id]);
  }

  @override
  Future<void> insertMapFarm(MapFarm farm) async {
    await _mapFarmInsertionAdapter.insert(farm, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> bulkInsertMapFarm(List<MapFarm> farmList) {
    return _mapFarmInsertionAdapter.insertListAndReturnIds(
        farmList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateMapFarm(MapFarm farm) async {
    await _mapFarmUpdateAdapter.update(farm, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteMapFarm(MapFarm farm) {
    return _mapFarmDeletionAdapter.deleteAndReturnChangedRows(farm);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _intListConverter = IntListConverter();
