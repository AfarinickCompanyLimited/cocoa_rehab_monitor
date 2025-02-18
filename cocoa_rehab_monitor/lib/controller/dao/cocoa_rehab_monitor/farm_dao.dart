import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:floor/floor.dart';

@dao
abstract class FarmDao {
  @Query('SELECT * FROM Farm')
  Stream<List<Farm>> findAllFarmStream();

  @Query('SELECT * FROM Farm')
  Future<List<Farm>> findAllFarm();

  @Query('SELECT * FROM Farm WHERE districtName = :districtName')
  Future<List<Farm>> findFarmsInDistrict(String districtName);

  @Query('SELECT * FROM Farm WHERE regionName = :regionName')
  Future<List<Farm>> findFarmsInRegion(String regionName);

  @Query('SELECT * FROM Farm WHERE farmId = :farmId')
  Future<List<Farm>> findFarmByFarmId(String farmId);

  @Query('SELECT * FROM Farm WHERE farmCode = :farmCode')
  Future<List<Farm>> findFarmByFarmCode(int farmCode);

  @Query('DELETE FROM Farm WHERE farmCode = :farmCode')
  Future<int?> deleteFarmByCode(String farmCode);

  @delete
  Future<int?> deleteFarm(Farm farm);

  @Query('DELETE FROM Farm')
  Future<void> deleteAllFarms();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFarm(Farm farm);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertFarm(List<Farm> farmList);

}
