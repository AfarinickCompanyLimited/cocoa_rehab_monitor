import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:floor/floor.dart';

@dao
abstract class RegionDistrictDao {
  @Query('SELECT * FROM RegionDistrict')
  Future<List<RegionDistrict>> findAllRegionDistrict();

  @Query('SELECT DISTINCT regionId, regionName FROM RegionDistrict ORDER BY regionName ASC')
  Future<List<RegionDistrict>> findRegions();

  @Query('SELECT * FROM RegionDistrict WHERE regionName = :regionName')
  Future<List<RegionDistrict>> findRegionDistrictByRegionName(String regionName);

  @Query('SELECT * FROM RegionDistrict WHERE regionId = :regionId')
  Future<List<RegionDistrict>> findRegionDistrictByRegionId(String regionId);

  @Query('SELECT * FROM RegionDistrict WHERE districtId = :districtId')
  Future<List<RegionDistrict>> findRegionDistrictByDistrictId(int districtId);

  @Query('SELECT DISTINCT districtId, districtName FROM RegionDistrict WHERE regionName = :regionName ORDER BY districtName ASC')
  Future<List<RegionDistrict>> findDistrictsInRegion(String regionName);

  @Query('SELECT * FROM RegionDistrict WHERE districtName = :districtName')
  Future<List<RegionDistrict>> findRegionDistrictByDistrictName(String districtName);

  @delete
  Future<int?> deleteRegionDistrict(RegionDistrict regionDistrict);

  @Query('DELETE FROM RegionDistrict')
  Future<void> deleteAllRegionDistrict();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRegionDistrict(RegionDistrict regionDistrict);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertRegionDistrict(List<RegionDistrict> regionDistrictList);

}


