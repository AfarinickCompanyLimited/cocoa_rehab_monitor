import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_outbreak.dart';
import 'package:floor/floor.dart';

@dao
abstract class AssignedOutbreakDao {
  @Query('SELECT * FROM AssignedOutbreak')
  Stream<List<AssignedOutbreak>> findAllAssignedOutbreakStream();

  @Query('SELECT * FROM AssignedOutbreak')
  Future<List<AssignedOutbreak>> findAllAssignedOutbreaks();

  @Query('SELECT * FROM AssignedOutbreak LIMIT :limit OFFSET :offset')
  Future<List<AssignedOutbreak>> findAssignedOutbreakWithLimit(int limit, int offset);

  @Query('SELECT * FROM AssignedOutbreak WHERE obId = :obId')
  Future<List<AssignedOutbreak>> findAssignedOutbreakById(int obId);

  @Query('SELECT * FROM AssignedOutbreak WHERE obCode = :obCode')
  Future<List<AssignedOutbreak>> findAssignedOutbreakByCode(String obCode);

  @delete
  Future<int?> deleteAssignedOutbreak(AssignedOutbreak assignedOutbreak);

  @Query('DELETE FROM AssignedOutbreak')
  Future<void> deleteAllAssignedOutbreaks();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAssignedOutbreak(AssignedOutbreak assignedOutbreak);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertAssignedOutbreak(List<AssignedOutbreak> assignedOutbreakList);

}
