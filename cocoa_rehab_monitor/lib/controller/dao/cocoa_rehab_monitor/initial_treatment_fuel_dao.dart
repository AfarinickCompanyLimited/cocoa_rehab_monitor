import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_fuel.dart';
import 'package:floor/floor.dart';

@dao
abstract class InitialTreatmentFuelDao {
  @Query('SELECT * FROM InitialTreatmentFuel')
  Stream<List<InitialTreatmentFuel>> findAllInitialTreatmentFuelStream();

  @Query('SELECT * FROM InitialTreatmentFuel')
  Future<List<InitialTreatmentFuel>> findAllInitialTreatmentFuel();

  @Query('SELECT * FROM InitialTreatmentFuel WHERE status = :status')
  Stream<List<InitialTreatmentFuel>> findInitialTreatmentFuelByStatusStream(int status);

  @Query('SELECT * FROM InitialTreatmentFuel WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<InitialTreatmentFuel>> findInitialTreatmentFuelByStatusWithLimit(int status, int limit, int offset);

  @Query('SELECT * FROM InitialTreatmentFuel WHERE status = :status')
  Future<List<InitialTreatmentFuel>> findInitialTreatmentFuelByStatus(int status);

  @Query('SELECT * FROM InitialTreatmentFuel WHERE uid = :id')
  Future<List<InitialTreatmentFuel>> findInitialTreatmentFuelByUID(String id);

  @Query('DELETE FROM InitialTreatmentFuel WHERE uid = :id')
  Future<int?> deleteInitialTreatmentFuelByUID(String id);

  @delete
  Future<int?> deleteInitialTreatmentFuel(InitialTreatmentFuel initialTreatmentFuel);

  @Query('DELETE FROM InitialTreatmentFuel')
  Future<void> deleteAllInitialTreatmentFuel();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertInitialTreatmentFuel(InitialTreatmentFuel initialTreatmentFuel);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertInitialTreatmentFuel(List<InitialTreatmentFuel> initialTreatmentFuelList);

  @Query('UPDATE InitialTreatmentFuel SET status = :status WHERE uid = :id')
  Future<int?> updateInitialTreatmentFuelSubmissionStatusByUID(int status, String id);

  @update
  Future<void> updateInitialTreatmentFuel(InitialTreatmentFuel initialTreatmentFuel);

}


