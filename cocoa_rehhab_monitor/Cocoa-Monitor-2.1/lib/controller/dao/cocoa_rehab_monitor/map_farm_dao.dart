import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/map_farm.dart';
import 'package:floor/floor.dart';

@dao
abstract class MapFarmDao {
  @Query('SELECT * FROM MapFarm')
  Stream<List<MapFarm>> findAllMapFarmStream();

  @Query('SELECT * FROM MapFarm')
  Future<List<MapFarm>> findAllMapFarm();

  @Query('SELECT * FROM MapFarm WHERE status = :status')
  Stream<List<MapFarm>> findMapFarmByStatusStream(int status);

  @Query(
      'SELECT * FROM MapFarm WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<MapFarm>> findMapFarmByStatusWithLimit(
      int status, int limit, int offset);

  @Query('SELECT * FROM MapFarm WHERE status = :status')
  Future<List<MapFarm>> findMapFarmByStatus(int status);

  @Query('SELECT * FROM MapFarm WHERE uid = :id')
  Future<List<MapFarm>> findMapFarmByUID(String id);

  @Query('DELETE FROM MapFarm WHERE uid = :id')
  Future<int?> deleteMapFarmByUID(String id);

  @delete
  Future<int?> deleteMapFarm(MapFarm MapFarm);

  @Query('DELETE FROM MapFarm')
  Future<void> deleteAllMapFarm();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMapFarm(MapFarm MapFarm);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertMapFarm(List<MapFarm> MapFarmList);

  @Query('UPDATE MapFarm SET status = :status WHERE uid = :id')
  Future<int?> updateMapFarmSubmissionStatusByUID(int status, String id);

  @update
  Future<void> updateMapFarm(MapFarm MapFarm);
}
