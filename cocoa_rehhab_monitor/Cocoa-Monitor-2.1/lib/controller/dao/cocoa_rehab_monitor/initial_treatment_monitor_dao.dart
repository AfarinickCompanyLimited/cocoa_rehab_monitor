import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:floor/floor.dart';


@dao
abstract class InitialTreatmentMonitorDao {
  @Query('SELECT * FROM InitialTreatmentMonitor')
  Stream<List<InitialTreatmentMonitor>> findAllInitialTreatmentMonitorStream();

  @Query('SELECT * FROM InitialTreatmentMonitor')
  Future<List<InitialTreatmentMonitor>> findAllInitialTreatmentMonitor();

  @Query('SELECT * FROM InitialTreatmentMonitor WHERE status = :status')
  Stream<List<InitialTreatmentMonitor>> findInitialTreatmentMonitorByStatusStream(int status);

  @Query('SELECT * FROM InitialTreatmentMonitor WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<InitialTreatmentMonitor>> findInitialTreatmentMonitorByStatusWithLimit(int status, int limit, int offset);

  @Query('SELECT * FROM InitialTreatmentMonitor WHERE status = :status')
  Future<List<InitialTreatmentMonitor>> findInitialTreatmentMonitorByStatus(int status);

  @Query('SELECT * FROM InitialTreatmentMonitor WHERE uid = :id')
  Future<List<InitialTreatmentMonitor>> findInitialTreatmentMonitorByUID(String id);

  @Query('DELETE FROM InitialTreatmentMonitor WHERE uid = :id')
  Future<int?> deleteInitialTreatmentMonitorByUID(String id);

  @delete
  Future<int?> deleteInitialTreatmentMonitor(InitialTreatmentMonitor monitor);

  @Query('DELETE FROM InitialTreatmentMonitor')
  Future<void> deleteAllInitialTreatmentMonitor();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertInitialTreatmentMonitor(InitialTreatmentMonitor monitor);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertInitialTreatmentMonitor(List<InitialTreatmentMonitor> monitorList);

  @Query('UPDATE InitialTreatmentMonitor SET status = :status WHERE uid = :id')
  Future<int?> updateInitialTreatmentMonitorSubmissionStatusByUID(int status, String id);

  @update
  Future<void> updateInitialTreatmentMonitor(InitialTreatmentMonitor monitor);

}


