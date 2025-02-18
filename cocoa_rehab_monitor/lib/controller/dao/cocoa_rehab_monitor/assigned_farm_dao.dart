import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import 'package:floor/floor.dart';

@dao
abstract class AssignedFarmDao {
  @Query('SELECT * FROM AssignedFarm')
  Stream<List<AssignedFarm>> findAllAssignedFarmsStream();

  @Query('SELECT * FROM AssignedFarm')
  Future<List<AssignedFarm>> findAllAssignedFarms();

  @Query('SELECT * FROM AssignedFarm LIMIT :limit OFFSET :offset')
  Future<List<AssignedFarm>> findAssignedFarmWithLimit(int limit, int offset);

  @Query('SELECT * FROM AssignedFarm WHERE farmReference = :ref')
  Future<List<AssignedFarm>> findAssignedFarmsByFarmRef(String ref);

  @delete
  Future<int?> deleteAssignedFarms(AssignedFarm assignedFarm);

  @Query('DELETE FROM AssignedFarm')
  Future<void> deleteAllAssignedFarms();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAssignedFarms(AssignedFarm assignedFarm);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertAssignedFarms(List<AssignedFarm> assignedFarmList);

}
