import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
import 'package:floor/floor.dart';

@dao
abstract class PersonnelAssignmentDao {
  @Query('SELECT * FROM PersonnelAssignment')
  Stream<List<PersonnelAssignment>> findAllPersonnelAssignmentStream();

  @Query('SELECT * FROM PersonnelAssignment')
  Future<List<PersonnelAssignment>> findAllPersonnelAssignment();

  @Query('SELECT * FROM PersonnelAssignment WHERE status = :status')
  Stream<List<PersonnelAssignment>> findPersonnelAssignmentByStatusStream(int status);

  @Query('SELECT * FROM PersonnelAssignment WHERE status = :status')
  Future<List<PersonnelAssignment>> findPersonnelAssignmentByStatus(int status);

  @Query('SELECT * FROM PersonnelAssignment WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<PersonnelAssignment>> findPersonnelAssignmentByStatusWithLimit(int status, int limit, int offset);

  @Query('SELECT * FROM PersonnelAssignment WHERE uid = :id')
  Future<List<PersonnelAssignment>> findPersonnelAssignmentByUID(String id);

  @Query('DELETE FROM PersonnelAssignment WHERE uid = :id')
  Future<int?> deletePersonnelAssignmentByUID(String id);

  @delete
  Future<int?> deletePersonnelAssignment(PersonnelAssignment personnelAssignment);

  @Query('DELETE FROM PersonnelAssignment')
  Future<void> deleteAllPersonnelAssignment();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPersonnelAssignment(PersonnelAssignment personnelAssignment);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertPersonnelAssignment(List<PersonnelAssignment> personnelAssignmentList);

  @Query('UPDATE PersonnelAssignment SET status = :status WHERE uid = :id')
  Future<int?> updatePersonnelAssignmentSubmissionStatusByUID(int status, String id);

  @update
  Future<void> updatePersonnelAssignment(PersonnelAssignment personnelAssignment);

}


