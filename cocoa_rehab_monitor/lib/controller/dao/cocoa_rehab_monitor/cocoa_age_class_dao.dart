import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/cocoa_age_class.dart';
import 'package:floor/floor.dart';

@dao
abstract class CocoaAgeClassDao {
  @Query('SELECT * FROM CocoaAgeClass')
  Stream<List<CocoaAgeClass>> findAllCocoaAgeClassStream();

  @Query('SELECT * FROM CocoaAgeClass')
  Future<List<CocoaAgeClass>> findAllCocoaAgeClass();

  @delete
  Future<int?> deleteCocoaAgeClass(CocoaAgeClass cocoaAgeClass);

  @Query('DELETE FROM CocoaAgeClass')
  Future<void> deleteAllCocoaAgeClass();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCocoaAgeClass(CocoaAgeClass cocoaAgeClass);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertCocoaAgeClass(List<CocoaAgeClass> cocoaAgeClassList);

}
