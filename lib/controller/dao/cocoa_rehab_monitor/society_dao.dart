import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/society.dart';
import 'package:floor/floor.dart';

@dao
abstract class SocietyDao {
  @Query('SELECT * FROM Society')
  Future<List<Society>> findAllSociety();

  // @Query('SELECT DISTINCT regionId, regionName FROM RegionDistrict ORDER BY regionName ASC')
  // Future<List<Society>> findRegions();

  // @Query('SELECT DISTINCT regionName FROM Society ORDER BY regionName ASC')
  // Future<List<Society>> findRegions();

  // @Query('SELECT * FROM Society WHERE regionName = :regionName')
  // Future<List<Society>> findSocietyByRegionName(String regionName);

  @Query('SELECT * FROM Society WHERE societyName = :societyName')
  Future<List<Society>> findSocietyBySocietyName(String societyName);

  @Query('SELECT * FROM Society WHERE societyCode = :societyCode')
  Future<List<Society>> findSocietyBySocietyCode(int societyCode);

  @delete
  Future<int?> deleteSociety(Society society);

  @Query('DELETE FROM Society')
  Future<void> deleteAllSociety();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSociety(Society society);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertSociety(List<Society> societyList);
}
