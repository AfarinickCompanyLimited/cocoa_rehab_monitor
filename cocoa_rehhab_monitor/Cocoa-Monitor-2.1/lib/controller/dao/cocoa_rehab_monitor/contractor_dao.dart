import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor.dart';
import 'package:floor/floor.dart';

@dao
abstract class ContractorDao {
  @Query('SELECT * FROM Contractor')
  Stream<List<Contractor>> findAllContractorStream();

  // @Query('SELECT * FROM Contractor WHERE LOWER(contractorName) LIKE :contractorName')
  @Query(
      'SELECT * FROM Contractor WHERE LOWER(contractorName) LIKE :contractorName OR LOWER(contractorId) LIKE :contractorName')
  Stream<List<Contractor>> streamAllContractorWithNamesLike(
      String contractorName);

  @Query('SELECT * FROM Contractor')
  Future<List<Contractor>> findAllContractors();

  @Query('SELECT * FROM Contractor LIMIT :limit OFFSET :offset')
  Future<List<Contractor>> findContractorsWithLimit(int limit, int offset);

  @Query(
      'SELECT * FROM Contractor WHERE LOWER(contractorName) LIKE :searchTerm OR LOWER(staffId) LIKE :searchTerm LIMIT :limit OFFSET :offset')
  Future<List<Contractor>> findContractorsWithSearchAndLimit(
      String searchTerm, int limit, int offset);

  @Query('SELECT * FROM Contractor WHERE districtName = :districtName')
  Future<List<Contractor>> findContractorsInDistrict(String districtName);

  @Query('SELECT * FROM Contractor WHERE regionName = :regionName')
  Future<List<Contractor>> findContractorsInRegion(String regionName);

  @Query('SELECT * FROM Contractor WHERE contractorId = :contractorId')
  Future<List<Contractor>> findContractorById(int contractorId);

  @delete
  Future<int?> deleteContractor(Contractor contractor);

  @Query('DELETE FROM Contractor')
  Future<void> deleteAllContractors();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertContractor(Contractor contractor);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertContractors(List<Contractor> contractorList);
}
