import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm.dart';
import 'package:floor/floor.dart';

@dao
abstract class OutbreakFarmDao {
  @Query('SELECT * FROM OutbreakFarm')
  Stream<List<OutbreakFarm>> findAllOutbreakFarmStream();

  @Query('SELECT * FROM OutbreakFarm')
  Future<List<OutbreakFarm>> findAllOutbreakFarm();

  @Query('SELECT * FROM OutbreakFarm WHERE status = :status')
  Stream<List<OutbreakFarm>> findOutbreakFarmByStatusStream(int status);

  @Query('SELECT * FROM OutbreakFarm WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<OutbreakFarm>> findOutbreakFarmByStatusWithLimit(int status, int limit, int offset);

  @Query('SELECT * FROM OutbreakFarm WHERE status = :status')
  Future<List<OutbreakFarm>> findOutbreakFarmByStatus(int status);

  @Query('SELECT * FROM OutbreakFarm WHERE uid = :id')
  Future<List<OutbreakFarm>> findOutbreakFarmByUID(String id);

  @Query('DELETE FROM OutbreakFarm WHERE uid = :id')
  Future<int?> deleteOutbreakFarmByUID(String id);

  @delete
  Future<int?> deleteOutbreakFarm(OutbreakFarm outbreakFarm);

  @Query('DELETE FROM OutbreakFarm')
  Future<void> deleteAllOutbreakFarm();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOutbreakFarm(OutbreakFarm outbreakFarm);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertOutbreakFarm(List<OutbreakFarm> outbreakFarmList);

  @Query('UPDATE OutbreakFarm SET status = :status WHERE uid = :id')
  Future<int?> updateOutbreakFarmSubmissionStatusByUID(int status, String id);

  @update
  Future<void> updateOutbreakFarm(OutbreakFarm outbreakFarm);

}


