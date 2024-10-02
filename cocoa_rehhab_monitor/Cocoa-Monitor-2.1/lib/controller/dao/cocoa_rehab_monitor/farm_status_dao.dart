import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm_status.dart';
import 'package:floor/floor.dart';

@dao
abstract class FarmStatusDao {
  @Query('SELECT * FROM FarmStatus')
  Stream<List<FarmStatus>> findAllFarmStatusStream();

  @Query('SELECT * FROM FarmStatus WHERE LOWER(farmerName) LIKE :farmerName OR LOWER(farmid) LIKE :farmerName')
  Stream<List<FarmStatus>> streamAllFarmStatusWithNamesLike(String farmerName);

  @Query('SELECT * FROM FarmStatus LIMIT :limit OFFSET :offset')
  Future<List<FarmStatus>> findFarmStatusWithLimit(int limit, int offset);

  @Query('SELECT * FROM FarmStatus WHERE LOWER(farmerName) LIKE :searchTerm OR LOWER(farmid) LIKE :searchTerm LIMIT :limit OFFSET :offset')
  Future<List<FarmStatus>> findFarmStatusWithSearchAndLimit(String searchTerm, int limit, int offset);

  @Query('SELECT * FROM FarmStatus')
  Future<List<FarmStatus>> findAllFarmStatus();

  @Query('SELECT * FROM FarmStatus WHERE farmid = :farmId')
  Future<List<FarmStatus>> findFarmStatusByFarmId(String farmId);

  @delete
  Future<int?> deleteFarmStatus(FarmStatus farmStatus);

  @Query('DELETE FROM FarmStatus')
  Future<void> deleteAllFarmStatus();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFarmStatus(FarmStatus farmStatus);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertFarmStatus(List<FarmStatus> farmStatusList);

}
