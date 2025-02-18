
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cocoa_rehab_monitor/view/routes.dart' as route;
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'dart:math';
import 'dart:ui';
import 'controller/constants.dart';
import 'controller/entity/cocoa_rehub_monitor/notification_data.dart';
import 'controller/global_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';


// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', 'Cocoa Rehab Monitor',
//     description: "This channel is used for important notifications",
//     importance: Importance.max,
//     playSound: true);
//
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   FirebaseNotificationHandler firebaseNotificationHandler =
//       FirebaseNotificationHandler();
//   await firebaseNotificationHandler.handleRemoteMessage(message);
// }
//
// const AndroidNotificationDetails _androidNotificationDetails =
//     AndroidNotificationDetails(
//   'default_notification_channel_id',
//   "Alert",
//   channelDescription:
//       "This channel is responsible for all the local notifications",
//   playSound: true,
//   priority: Priority.high,
//   importance: Importance.high,
//   // icon: '@mipmap/launcher_icon',
// );
//
// const DarwinNotificationDetails _iOSNotificationDetails =
//     DarwinNotificationDetails();
//
// const NotificationDetails notificationDetails = NotificationDetails(
//   android: _androidNotificationDetails,
//   iOS: _iOSNotificationDetails,
// );

// GeneralCocoaRehabApiInterface generalCocoaRehabApiInterface =
//     GeneralCocoaRehabApiInterface();

/*void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    generalCocoaRehabApiInterface.loadPaginatedRehabAssistants();
    //DTA FETCHING COMES HERE
    //homeController.syncData
    return Future.value(true);
  });
}

void schedulePeriodicTask() {
  Workmanager().registerPeriodicTask('uniqueName', 'taskName',
      frequency: Duration(hours: 12));
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Workmanager().initialize(callbackDispatcher);
  // await Firebase.initializeApp();
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 //  Pass all uncaught "fatal" errors from the framework to Crashlytics
 // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
 //
 //  Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
 //    PlatformDispatcher.instance.onError = (error, stack) {
 //      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
 //      return true;
 //    };

  GlobalController indexController = Get.put(GlobalController());
  await indexController.buildAppDB();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  ShareP.preferences = sharedPreferences;

  await indexController.loadUserInfo();
  await indexController.clearSavedTimestamp();

  // FirebaseMessaging.instance.subscribeToTopic('Dom');

  //NotificationService notificationService = NotificationService();
  //await notificationService.init();

  //FirebaseNotificationHandler.requestNotificationPermission();
  //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // This section handles message when app is in foreground
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //   final notificationDao = indexController.database!.notificationDao;
  //   await notificationDao.insertNotificationData(NotificationData(
  //       message.messageId!,
  //       message.notification!.title,
  //       message.notification!.body,
  //       DateTime.now(),
  //       false));
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     Random().nextInt(1000),
  //     message.notification!.title,
  //     message.notification!.body,
  //     notificationDetails,
  //   );
  // });

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //   final notificationDao = indexController.database!.notificationDao;
  //   await notificationDao.insertNotificationData(NotificationData(
  //       message.messageId!,
  //       message.notification!.title,
  //       message.notification!.body,
  //       DateTime.now(),
  //       false));
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     Random().nextInt(1000),
  //     message.notification!.title,
  //     message.notification!.body,
  //     notificationDetails,
  //   );
  // });

  // FirebaseMessaging.instance
  //     .getInitialMessage()
  //     .then((RemoteMessage? message) async {
  //   if (message != null) {
  //     final notificationDao = indexController.database!.notificationDao;
  //     await notificationDao.insertNotificationData(NotificationData(
  //         message.messageId!,
  //         message.notification!.title,
  //         message.notification!.body,
  //         DateTime.now(),
  //         false));
  //
  //     await flutterLocalNotificationsPlugin.show(
  //       Random().nextInt(1000),
  //       message.notification!.title,
  //       message.notification!.body,
  //       notificationDetails,
  //     );
  //   }
  // });

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: appColorPrimary,
      fontFamily: 'Poppins',
      // splashColor: Colors.transparent,
      // highlightColor: Colors.transparent,
    ),
    initialRoute: route.splashScreen,
    // initialRoute: route.registerScreen,
    onGenerateRoute: route.controller,
    // routes: {
    //   // '/splash': (context) => Splash(),
    //   '/home': (context) => Home(),
    // },
  ));
}
