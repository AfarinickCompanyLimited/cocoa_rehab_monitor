// // ignore_for_file: avoid_print
//
// import 'dart:math';
//
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/notification_data.dart';
// import 'package:cocoa_monitor/view/notifications/notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import 'package:get/get.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import '../database/database.dart';
//
// class FirebaseNotificationHandler {
//   Future<void> handleRemoteMessage(RemoteMessage message) async {
//     AndroidNotificationChannel channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'Cocoa Rehab Monitor', // title
//       description:
//           'This channel is used for important notifications.', // description
//       importance: Importance.high,
//       playSound: true,
//     );
//
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     print('HANDLING REMOTE NOTIFICATION IN THE BACKGROUND');
//     // GlobalController globalController = Get.put(GlobalController());
//     // final notificationDao = globalController.database!.notificationDao;
//     final database =
//         await $FloorAppDatabase.databaseBuilder('app_database.db').build();
//     final notificationDao = database.notificationDao;
//
//     await notificationDao.insertNotificationData(NotificationData(
//         message.messageId!,
//         message.notification!.title,
//         message.notification!.body,
//         DateTime.now(),
//         false));
//
//     NotificationService notificationService = NotificationService();
//     notificationService.handleRemoteMessage(message);
//   }
//
//   static requestNotificationPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//       //initializeNotifications();
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//       //initializeNotifications();
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
// }
//
// class NotificationService {
//   // Singleton pattern
//   static final NotificationService _notificationService =
//       NotificationService._internal();
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal();
//
//   static const channelId = "default_notification_channel_id";
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static const AndroidNotificationDetails _androidNotificationDetails =
//       AndroidNotificationDetails(
//     channelId,
//     "Alert",
//     channelDescription:
//         "This channel is responsible for all the local notifications",
//     playSound: true,
//     priority: Priority.high,
//     importance: Importance.high,
//   );
//
//   static const DarwinNotificationDetails _iOSNotificationDetails =
//       DarwinNotificationDetails();
//
//   final NotificationDetails notificationDetails = const NotificationDetails(
//     android: _androidNotificationDetails,
//     iOS: _iOSNotificationDetails,
//   );
//
//   Future<void> init() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     // AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: false,
//       requestAlertPermission: true,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     // final IOSInitializationSettings iOSInitializationSettings =
//     // IOSInitializationSettings(
//     //   defaultPresentAlert: false,
//     //   defaultPresentBadge: false,
//     //   defaultPresentSound: false,
//     // );
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: initializationSettingsDarwin,
//     );
//
//     // *** Initialize timezone here ***
//     // tz.initializeTimeZones();
//
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveNotificationResponse,
//     );
//   }
//
//   // Future<void> requestIOSPermissions() async {
//   //   await flutterLocalNotificationsPlugin
//   //       .resolvePlatformSpecificImplementation<
//   //       IOSFlutterLocalNotificationsPlugin>()
//   //       ?.requestPermissions(
//   //     alert: true,
//   //     badge: true,
//   //     sound: true,
//   //   );
//   // }
//
//   Future<void> showNotification(
//       int id, String title, String body, String payload) async {
//     await flutterLocalNotificationsPlugin.show(
//       id,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
//
//   // Future<void> scheduleNotification(int id, String title, String body,
//   //     DateTime eventDate, TimeOfDay eventTime, String payload,
//   //     [DateTimeComponents? dateTimeComponents]) async {
//   //   final scheduledTime = eventDate.add(Duration(
//   //     hours: eventTime.hour,
//   //     minutes: eventTime.minute,
//   //   ));
//   //   await flutterLocalNotificationsPlugin.zonedSchedule(
//   //     id,
//   //     title,
//   //     body,
//   //     tz.TZDateTime.from(scheduledTime, tz.local),
//   //     notificationDetails,
//   //     uiLocalNotificationDateInterpretation:
//   //     UILocalNotificationDateInterpretation.absoluteTime,
//   //     androidAllowWhileIdle: true,
//   //     payload: payload,
//   //     matchDateTimeComponents: dateTimeComponents,
//   //   );
//   // }
//
//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }
//
//   handleRemoteMessage(RemoteMessage remoteMessage) async {
//     var data = remoteMessage.data;
//     await showNotification(
//       Random().nextInt(1000),
//       remoteMessage.notification!.title!,
//       remoteMessage.notification!.body!,
//       jsonEncode(data),
//     );
//     // await showNotification(
//     //   Random().nextInt(1000),
//     //   data["title"],
//     //   data["body"],
//     //   jsonEncode(data),
//     // );
//   }
// }
//
// void onDidReceiveNotificationResponse(
//     NotificationResponse notificationResponse) async {
//   // final String? payload = notificationResponse.payload;
//
//   Get.to(() => const Notifications(), transition: Transition.fadeIn);
// }
//
// void onDidReceiveLocalNotification(
//     int id, String? title, String? body, String? payload) async {
//   print('ONDIDRECEIVELOCALNOTIFICATION FNX');
//   Get.to(() => const Notifications(), transition: Transition.fadeIn);
//
//   // // display a dialog with the notification details, tap ok to go to another page
//   // showDialog(
//   //   context: context,
//   //   builder: (BuildContext context) => CupertinoAlertDialog(
//   //     title: Text(title!),
//   //     content: Text(body!),
//   //     actions: [
//   //       CupertinoDialogAction(
//   //         isDefaultAction: true,
//   //         child: const Text('Ok'),
//   //         onPressed: () async {
//   //           Get.to(() => const Notifications(), transition: Transition.fadeIn);
//   //         },
//   //       )
//   //     ],
//   //   ),
//   // );
// }
