import 'package:cocoa_monitor/controller/db/initail_activity_db.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/controller/model/activity_data_model.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/api_interface/cocoa_rehab/outbreak_farm_apis.dart';

class InitialTreatmentMonitoringHistoryController extends GetxController {
  BuildContext? monitoringHistoryScreenContext;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  OutbreakFarmApiInterface outbreakFarmApiInterface =
      OutbreakFarmApiInterface();
  TabController? tabController;
  var activeTabIndex = 0.obs;

  final PagingController<int, InitialTreatmentMonitor>
      pendingRecordsController = PagingController(firstPageKey: 0);
  final PagingController<int, InitialTreatmentMonitor>
      submittedRecordsController = PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  InitialTreatmentMonitorDatabaseHelper db = InitialTreatmentMonitorDatabaseHelper.instance;

  // INITIALISE

  Future<void> fetchData() async {
    var d = await db.getAllData();
    print("THE REHAB DATA === $d");
  }







}
