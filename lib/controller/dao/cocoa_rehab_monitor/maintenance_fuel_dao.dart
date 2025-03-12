import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/maintenance_fuel.dart';
import 'package:floor/floor.dart';

@dao
abstract class MaintenanceFuelDao {
  @Query('SELECT * FROM MaintenanceFuel')
  Stream<List<MaintenanceFuel>> findAllMaintenanceFuelStream();

  @Query('SELECT * FROM MaintenanceFuel')
  Future<List<MaintenanceFuel>> findAllMaintenanceFuel();

  @Query('SELECT * FROM MaintenanceFuel WHERE status = :status')
  Stream<List<MaintenanceFuel>> findMaintenanceFuelByStatusStream(int status);

  @Query('SELECT * FROM MaintenanceFuel WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<MaintenanceFuel>> findMaintenanceFuelByStatusWithLimit(int status, int limit, int offset);

  @Query('SELECT * FROM MaintenanceFuel WHERE status = :status')
  Future<List<MaintenanceFuel>> findMaintenanceFuelByStatus(int status);

  @Query('SELECT * FROM MaintenanceFuel WHERE uid = :id')
  Future<List<MaintenanceFuel>> findMaintenanceFuelByUID(String id);

  @Query('DELETE FROM MaintenanceFuel WHERE uid = :id')
  Future<int?> deleteMaintenanceFuelByUID(String id);

  @delete
  Future<int?> deleteMaintenanceFuel(MaintenanceFuel maintenanceFuel);

  @Query('DELETE FROM MaintenanceFuel')
  Future<void> deleteAllMaintenanceFuel();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMaintenanceFuel(MaintenanceFuel maintenanceFuel);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertMaintenanceFuel(List<MaintenanceFuel> maintenanceFuelList);

  @Query('UPDATE MaintenanceFuel SET status = :status WHERE uid = :id')
  Future<int?> updateMaintenanceFuelSubmissionStatusByUID(int status, String id);

  @update
  Future<void> updateMaintenanceFuel(MaintenanceFuel maintenanceFuel);

}


