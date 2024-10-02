import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:floor/floor.dart';

@dao
abstract class OutbreakFarmFromServerDao {
  @Query('SELECT * FROM OutbreakFarmFromServer')
  Stream<List<OutbreakFarmFromServer>> findAllOutbreakFarmFromServerStream();

  @Query('SELECT * FROM OutbreakFarmFromServer')
  Future<List<OutbreakFarmFromServer>> findAllOutbreakFarmFromServer();

  @Query('SELECT * FROM OutbreakFarmFromServer WHERE farmId = :farmId')
  Future<List<OutbreakFarmFromServer>> findOutbreakFarmFromServerByFarmId(String farmId);

  @delete
  Future<int?> deleteOutbreakFarmFromServer(OutbreakFarmFromServer farm);

  @Query('DELETE FROM OutbreakFarmFromServer')
  Future<void> deleteAllOutbreakFarmFromServers();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOutbreakFarmFromServer(OutbreakFarmFromServer farm);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertOutbreakFarmFromServer(List<OutbreakFarmFromServer> farmList);

}
