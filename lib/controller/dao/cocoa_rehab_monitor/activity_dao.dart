import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ActivityDao {
  @Query('SELECT * FROM Activity')
  Stream<List<Activity>> findAllActivityStream();

  @Query('SELECT * FROM Activity')
  Future<List<Activity>> findAllActivity();

  @Query('SELECT DISTINCT mainActivity FROM Activity ORDER BY mainActivity ASC')
  Future<List<Activity>> findAllMainActivity();

  @Query('SELECT DISTINCT subActivity FROM Activity ORDER BY subActivity ASC')
  Future<List<Activity>> findAllSubActivity();

  @Query('SELECT * FROM Activity WHERE code IN (:ids)')
  Future<List<Activity>> findAllActivityWithIdList(List<int> ids);

  @Query('SELECT * FROM Activity WHERE code IN (:code)')
  Future<List<Activity>> findAllActivityWithCodeList(List<int> code);

  @Query(
      'SELECT DISTINCT subActivity FROM Activity WHERE subActivity IN (:code)')
  Future<List<Activity>> findAllActivityWithCodeList2(List<int> code);

  @Query(
      'SELECT DISTINCT mainActivity FROM Activity WHERE mainActivity IN (:mainActivityList)')
  Future<List<Activity>> findAllActivityWithMainActivityList(
      List<String> mainActivityList);

  @Query(
      'SELECT DISTINCT mainActivity FROM Activity WHERE mainActivity IN (:mainActivityList)')
  Future<List<Activity>> nfindAllActivityWithMainActivityList(
      List<int> mainActivityList);    

  @Query('SELECT * FROM Activity WHERE mainActivity = :mainActivity')
  Future<List<Activity>> findSubActivities(String mainActivity);

  @Query('SELECT * FROM Activity WHERE code = :code')
  Future<List<Activity>> findActivityByCode(int code);

  @Query('DELETE FROM Activity WHERE code = :code')
  Future<int?> deleteActivityByCode(String code);

  @delete
  Future<int?> deleteActivities(Activity activity);

  @Query('DELETE FROM Activity')
  Future<void> deleteAllActivity();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertActivity(Activity activity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertActivity(List<Activity> activityList);
}
