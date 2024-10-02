import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farmer_from_server.dart';
import 'package:floor/floor.dart';

@dao
abstract class FarmerFromServerDao {
  @Query('SELECT * FROM FarmerFromServer')
  Stream<List<FarmerFromServer>> findAllFarmersFromServerStream();

  @Query(
      'SELECT * FROM FarmerFromServer WHERE LOWER(farmerName) LIKE :farmerName OR LOWER(farmerCode) LIKE :farmerName')
  Stream<List<FarmerFromServer>> streamAllFarmersFromServerWithNamesLike(
      String farmerName);

  @Query('SELECT * FROM FarmerFromServer')
  Future<List<FarmerFromServer>> findAllFarmersFromServer();

  @Query('SELECT * FROM FarmerFromServer LIMIT :limit OFFSET :offset')
  Future<List<FarmerFromServer>> findFarmersFromServerWithLimit(
      int limit, int offset);

  @Query(
      'SELECT * FROM FarmerFromServer WHERE LOWER(farmerName) LIKE :searchTerm OR LOWER(farmerCode) LIKE :searchTerm LIMIT :limit OFFSET :offset')
  Future<List<FarmerFromServer>> findFarmersFromServerWithSearchAndLimit(
      String searchTerm, int limit, int offset);

  @Query('SELECT * FROM FarmerFromServer WHERE societyName = :societyName')
  Future<List<FarmerFromServer>> findFarmersFromServerInSociety(
      String societyName);

  @Query('SELECT * FROM FarmerFromServer WHERE farmerId = :farmerId')
  Future<List<FarmerFromServer>> findFarmerFromServerByFarmerId(int farmerId);

  @Query('SELECT * FROM FarmerFromServer WHERE farmerId IN (:farmerIds)')
  Future<List<FarmerFromServer>> findFarmersFromServerByFarmerCodes(
      List<int> farmerIds);

  @Query('SELECT * FROM FarmerFromServer WHERE farmerId = :farmerId')
  Future<List<FarmerFromServer>> findFarmersFromServerById(int farmerId);

  @Query('DELETE FROM FarmerFromServer WHERE farmerId = :farmerId')
  Future<int?> deleteFarmersFromServerByFarmerId(int farmerId);

  @delete
  Future<int?> deleteFarmerFromServer(FarmerFromServer farmerFromServer);

  @Query('DELETE FROM FarmerFromServer')
  Future<void> deleteAllFarmersFromServer();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFarmerFromServer(FarmerFromServer farmerFromServer);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertFarmersFromServer(
      List<FarmerFromServer> farmerFromServerList);
}
