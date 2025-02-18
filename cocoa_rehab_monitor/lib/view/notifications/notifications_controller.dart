import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/notification_data.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/notification_view.dart';

class NotificationsController extends GetxController{

  BuildContext? notificationsScreenContext;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  PersonnelAssignmentApiInterface personnelAssignmentApiInterface = PersonnelAssignmentApiInterface();

  // INITIALISE


  void openAddBeneficiaryBottomSheet(NotificationData notificationData) async{

    final notificationDao = globalController.database!.notificationDao;
    await notificationDao.setNotificationRead(true, notificationData.id);
    update();
    homeController.update();

    showModalBottomSheet<void>(
      elevation: 5,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      context: notificationsScreenContext!,
      builder: (context) {
        return NotificationView(notificationData: notificationData);
      },
    );
  }


}

