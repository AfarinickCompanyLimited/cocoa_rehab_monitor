import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/equipment.dart';
import 'package:floor/floor.dart';

@dao
abstract class EquipmentDao {
  @Query('SELECT * FROM Equipment')
  Stream<List<Equipment>> findAllEquipmentStream();

  @Query('SELECT * FROM Equipment WHERE LOWER(equipment) LIKE :equipment OR LOWER(equipmentCode) LIKE :equipment')
  Stream<List<Equipment>> streamAllEquipmentWithNamesLike(String equipment);

  @Query('SELECT * FROM Equipment')
  Future<List<Equipment>> findAllEquipments();

  @Query('SELECT * FROM Equipment LIMIT :limit OFFSET :offset')
  Future<List<Equipment>> findEquipmentsWithLimit(int limit, int offset);

  @Query('SELECT * FROM Equipment WHERE LOWER(equipment) LIKE :searchTerm OR LOWER(equipmentCode) LIKE :searchTerm LIMIT :limit OFFSET :offset')
  Future<List<Equipment>> findEquipmentsWithSearchAndLimit(String searchTerm, int limit, int offset);

  @Query('SELECT * FROM Equipment WHERE id = :id')
  Future<List<Equipment>> findEquipmentById(int id);

  @Query('DELETE FROM Equipment WHERE equipmentCode = :equipmentCode')
  Future<int?> deleteEquipmentByRehabCode(String equipmentCode);

  @delete
  Future<int?> deleteEquipment(Equipment equipment);

  @Query('DELETE FROM Equipment')
  Future<void> deleteAllEquipments();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEquipment(Equipment equipment);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertEquipments(List<Equipment> equipmentList);

}
