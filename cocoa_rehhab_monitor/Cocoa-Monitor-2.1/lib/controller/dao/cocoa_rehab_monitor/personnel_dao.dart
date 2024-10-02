import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:floor/floor.dart';

@dao
abstract class PersonnelDao {
  @Query('SELECT * FROM Personnel')
  Stream<List<Personnel>> findAllPersonnelStream();

  @Query('SELECT * FROM Personnel')
  Future<List<Personnel>> findAllPersonnel();

  @Query('SELECT * FROM Personnel LIMIT :limit OFFSET :offset')
  Future<List<Personnel>> findPersonnelWithLimit(int limit, int offset);

  @Query('SELECT * FROM Personnel WHERE status = :status')
  Stream<List<Personnel>> findPersonnelByStatusStream(int status);

  @Query('SELECT * FROM Personnel WHERE status = :status')
  Future<List<Personnel>> findPersonnelByStatus(int status);

  @Query('SELECT * FROM Personnel WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<Personnel>> findPersonnelByStatusWithLimit(int status, int limit, int offset);

  @Query('SELECT * FROM Personnel WHERE uid = :id')
  Future<List<Personnel>> findPersonnelByUID(String id);

  @Query('DELETE FROM Personnel WHERE uid = :id')
  Future<int?> deletePersonnelByUID(String id);

  @delete
  Future<int?> deletePersonnel(Personnel personnel);

  @Query('DELETE FROM Personnel')
  Future<void> deleteAllPersonnel();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPersonnel(Personnel personnel);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertPersonnel(List<Personnel> personnelList);

  @Query('UPDATE Personnel SET status = :status WHERE uid = :id')
  Future<int?> updatePersonnelSubmissionStatusByUID(int status, String id);

  @update
  Future<void> updatePersonnel(Personnel personnel);

}


