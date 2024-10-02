import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/notification_data.dart';
import 'package:floor/floor.dart';

@dao
abstract class NotificationDao {
  @Query('SELECT * FROM NotificationData ORDER BY date DESC')
  Stream<List<NotificationData>> findAllNotificationsStream();

  @Query('SELECT * FROM NotificationData ORDER BY date DESC')
  Future<List<NotificationData>> findAllNotifications();

  @Query('SELECT * FROM NotificationData WHERE read = :read')
  Stream<List<NotificationData>> findNotificationByReadStream(bool read);

  @Query('SELECT * FROM NotificationData WHERE read = :read')
  Future<List<NotificationData>> findNotificationByRead(bool read);

  @delete
  Future<int?> deleteNotification(NotificationData notification);

  @Query('DELETE FROM NotificationData')
  Future<void> deleteAllNotifications();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotificationData(NotificationData notification);

  @Query('UPDATE NotificationData SET read = :read WHERE id = :id')
  Future<int?> setNotificationRead(bool read, String id);

  @Query('UPDATE NotificationData SET read = :read')
  Future<int?> setAllNotificationRead(bool read);

}
