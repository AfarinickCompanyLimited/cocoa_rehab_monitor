import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
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

  // INITIALISE

  Future<void> fetchData(
      {required int status,
      required int pageKey,
      required PagingController controller,
      }) async {
    try {
      final data = await globalController.database!.initialTreatmentMonitorDao
          .findInitialTreatmentMonitorByStatusWithLimit(
              status, _pageSize, pageKey * _pageSize);
      final isLastPage = data.length < _pageSize;
      if (isLastPage) {
        controller.appendLastPage(data);
      } else {
        final nextPageKey = pageKey + 1;
        controller.appendPage(data, nextPageKey);
      }
    } catch (error, stackTrace) {
      controller.error = error;
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
        FirebaseCrashlytics.instance.log('init treatment. fetchData');


    }
  }

  confirmDeleteMonitoring(InitialTreatmentMonitor monitor) async {
    globals.primaryConfirmDialog(
        context: monitoringHistoryScreenContext,
        title: 'Delete Record',
        image: 'assets/images/cocoa_monitor/question.png',
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
              "This action is irreversible. Are you sure you want to delete this record?",
              textAlign: TextAlign.center),
        ),
        cancelTap: () {
          Get.back();
        },
        okayTap: () {
          Get.back();
          globalController.database!.initialTreatmentMonitorDao
              .deleteInitialTreatmentMonitorByUID(monitor.uid!);
          // update();
          pendingRecordsController.itemList!.remove(monitor);
          update(['pendingRecordsBuilder']);
        });
  }
}
