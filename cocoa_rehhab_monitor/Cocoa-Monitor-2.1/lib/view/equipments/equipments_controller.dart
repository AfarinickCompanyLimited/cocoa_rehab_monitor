import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/equipment.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class EquipmentsController extends GetxController{

  BuildContext? context;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  PersonnelAssignmentApiInterface personnelAssignmentApiInterface = PersonnelAssignmentApiInterface();

  TextEditingController? searchTC = TextEditingController();

  // TabController? tabController;
  // var activeTabIndex = 0.obs;
  final PagingController<int, Equipment> pagingController = PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  // INITIALISE

  Future<void> fetchData({required int pageKey, required PagingController controller}) async {
    try {
      final data = searchTC!.text.isEmpty ?
                  await globalController.database!.equipmentDao.findEquipmentsWithLimit(_pageSize, pageKey * _pageSize)
                : await globalController.database!.equipmentDao.findEquipmentsWithSearchAndLimit("%${searchTC!.text.trim()}%", _pageSize, pageKey * _pageSize);
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
        FirebaseCrashlytics.instance.log('equpments. fetchData');


    }
  }

}

