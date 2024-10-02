import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:floor/floor.dart';

@dao
abstract class RehabAssistantDao {
  @Query('SELECT * FROM RehabAssistant')
  Stream<List<RehabAssistant>> findAllRehabAssistantStream();

  // @Query('SELECT * FROM RehabAssistant WHERE LOWER(rehabName) LIKE :rehabName')
  @Query('SELECT * FROM RehabAssistant WHERE LOWER(rehabName) LIKE :rehabName OR LOWER(staffId) LIKE :rehabName')
  Stream<List<RehabAssistant>> streamAllRehabAssistantWithNamesLike(String rehabName);

  @Query('SELECT * FROM RehabAssistant')
  Future<List<RehabAssistant>> findAllRehabAssistants();

  @Query('SELECT * FROM RehabAssistant LIMIT :limit OFFSET :offset')
  Future<List<RehabAssistant>> findRehabAssistantsWithLimit(int limit, int offset);

  @Query('SELECT * FROM RehabAssistant WHERE LOWER(rehabName) LIKE :searchTerm OR LOWER(staffId) LIKE :searchTerm LIMIT :limit OFFSET :offset')
  Future<List<RehabAssistant>> findRehabAssistantsWithSearchAndLimit(String searchTerm, int limit, int offset);

  @Query('SELECT * FROM RehabAssistant WHERE districtName = :districtName')
  Future<List<RehabAssistant>> findRehabAssistantsInDistrict(String districtName);

  @Query('SELECT * FROM RehabAssistant WHERE regionName = :regionName')
  Future<List<RehabAssistant>> findRehabAssistantsInRegion(String regionName);

  @Query('SELECT * FROM RehabAssistant WHERE rehabCode = :rehabCode')
  Future<List<RehabAssistant>> findRehabAssistantByRehabCode(int rehabCode);

  @Query('SELECT * FROM RehabAssistant WHERE rehabCode IN (:rehabCodes)')
  Future<List<RehabAssistant>> findRehabAssistantsByRehabCodes(List<int> rehabCodes);

  @Query('SELECT * FROM RehabAssistant WHERE id = :id')
  Future<List<RehabAssistant>> findRehabAssistantById(int id);

  @Query('DELETE FROM RehabAssistant WHERE rehabCode = :rehabCode')
  Future<int?> deleteRehabAssistantByRehabCode(int rehabCode);

  @delete
  Future<int?> deleteRehabAssistant(RehabAssistant rehabAssistant);

  @Query('DELETE FROM RehabAssistant')
  Future<void> deleteAllRehabAssistants();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRehabAssistant(RehabAssistant rehabAssistant);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertRehabAssistants(List<RehabAssistant> rehabAssistantList);

}
