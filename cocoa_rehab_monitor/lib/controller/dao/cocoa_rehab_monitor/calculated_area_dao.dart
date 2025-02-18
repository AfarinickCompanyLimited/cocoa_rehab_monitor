import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/calculated_area.dart';
import 'package:floor/floor.dart';

@dao
abstract class CalculatedAreaDao {
  @Query('SELECT * FROM CalculatedArea ORDER BY date')
  Stream<List<CalculatedArea>> findAllCalculatedAreaStream();

  @Query('SELECT * FROM CalculatedArea ORDER BY date')
  Future<List<CalculatedArea>> findAllCalculatedArea();

  @delete
  Future<int?> deleteCalculatedArea(CalculatedArea calculatedArea);

  @Query('DELETE FROM CalculatedArea')
  Future<void> deleteAllCalculatedArea();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCalculatedArea(CalculatedArea calculatedArea);

}
