import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_fuel.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InitialTreatmentFuelHistoryController extends GetxController{

  BuildContext? context;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  PersonnelAssignmentApiInterface personnelAssignmentApiInterface = PersonnelAssignmentApiInterface();

  TabController? tabController;
  var activeTabIndex = 0.obs;

  final PagingController<int, InitialTreatmentFuel> pendingRecordsController = PagingController(firstPageKey: 0);
  final PagingController<int, InitialTreatmentFuel> submittedRecordsController = PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  // INITIALISE

  Future<void> fetchData({required int status, required int pageKey, required PagingController controller}) async {
    try {
      final data = await globalController.database!.initialTreatmentFuelDao.findInitialTreatmentFuelByStatusWithLimit(
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
    

    }
  }


  confirmDelete(InitialTreatmentFuel initialTreatmentFuel) async {
    globals.primaryConfirmDialog(
        context: context,
        title: 'Delete Record',
        image: 'assets/images/cocoa_monitor/question.png',
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text("This action is irreversible. Are you sure you want to delete this record?",
              textAlign: TextAlign.center
          ),
        ),
        cancelTap: () {
          Get.back();
        },
        okayTap: () {
          Get.back();
          globalController.database!.initialTreatmentFuelDao.deleteInitialTreatmentFuelByUID(initialTreatmentFuel.uid!);
          // update();
          pendingRecordsController.itemList!.remove(initialTreatmentFuel);
          update(['pendingRecordsBuilder']);
        }
    );
  }


}

