import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/cocoa_type.dart';
import 'package:floor/floor.dart';

@dao
abstract class CocoaTypeDao {
  @Query('SELECT * FROM CocoaType')
  Stream<List<CocoaType>> findAllCocoaTypeStream();

  @Query('SELECT * FROM CocoaType')
  Future<List<CocoaType>> findAllCocoaType();

  // @Query('SELECT * FROM Activity WHERE code = :code')
  // Future<List<CocoaType>> findActivityByCode(int code);

  @delete
  Future<int?> deleteCocoaType(CocoaType cocoaType);

  @Query('DELETE FROM CocoaType')
  Future<void> deleteAllCocoaType();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCocoaType(CocoaType cocoaType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertCocoaType(List<CocoaType> cocoaTypeList);

}
