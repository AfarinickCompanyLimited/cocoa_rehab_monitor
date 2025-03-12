import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/community.dart';
import 'package:floor/floor.dart';

@dao
abstract class CommunityDao {
  @Query('SELECT * FROM Community')
  Future<List<Community>> findAllCommunity();

  @Query('SELECT * FROM Community WHERE communityId = :communityId')
  Future<List<Community>> findCommunityById(int communityId);

  @Query('SELECT DISTINCT regionId, regionName FROM Community ORDER BY regionName ASC')
  Future<List<Community>> findCommunityRegions();

  @Query('SELECT * FROM Community WHERE regionName = :regionName')
  Future<List<Community>> findCommunityByRegionName(String regionName);

  @Query('SELECT * FROM Community WHERE regionId = :regionId')
  Future<List<Community>> findCommunityByRegionId(String regionId);

  @Query('SELECT * FROM Community WHERE districtId = :districtId')
  Future<List<Community>> findCommunityByDistrictId(String districtId);

  @Query('SELECT * FROM Community WHERE districtName = :districtName')
  Future<List<Community>> findCommunityByDistrictName(String districtName);

  @Query('SELECT DISTINCT communityId, community FROM Community WHERE regionName = :regionName ORDER BY community ASC')
  Future<List<Community>> findCommunityInRegion(String regionName);

  @Query('SELECT DISTINCT communityId, community FROM Community WHERE districtName = :districtName ORDER BY community ASC')
  Future<List<Community>> findCommunityInDistrict(String districtName);

  @Query('SELECT * FROM Community WHERE community = :community')
  Future<List<Community>> findCommunityByCommunityName(String community);

  @delete
  Future<int?> deleteCommunity(Community community);

  @Query('DELETE FROM Community')
  Future<void> deleteAllCommunity();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCommunity(Community community);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertCommunity(List<Community> community);

}


