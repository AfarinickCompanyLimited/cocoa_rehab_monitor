
import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/personnel_apis.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:cocoa_rehab_monitor/controller/constants.dart';

class PersonnelHistoryController extends GetxController{

  BuildContext? personnelHistoryScreenContext;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  PersonnelApiInterface personnelApiInterface = PersonnelApiInterface();
  final pendingPersonnelRepository = PersonnelRepository(SubmissionStatus.pending);
  final submittedPersonnelRepository = PersonnelRepository(SubmissionStatus.submitted);

  TabController? tabController;
  var activeTabIndex = 0.obs;

  final PagingController<int, Personnel> pendingRecordsController = PagingController(firstPageKey: 0);
  final PagingController<int, Personnel> submittedRecordsController = PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  // INITIALISE


  Future<void> fetchPersonnel({required int status, required int pageKey, required PagingController controller}) async {
    try {
      final personnelData = await globalController.database!.personnelDao.findPersonnelByStatusWithLimit(
          status, _pageSize, pageKey * _pageSize);
      final isLastPage = personnelData.length < _pageSize;
      if (isLastPage) {
        controller.appendLastPage(personnelData);
      } else {
        final nextPageKey = pageKey + 1;
        controller.appendPage(personnelData, nextPageKey);
      }
    } catch (error) {
      controller.error = error;
    }
  }

  deletePersonnel(Personnel personnel) async {

  }


  confirmDeletePersonnel(Personnel personnel) async {
    globals.primaryConfirmDialog(
        context: personnelHistoryScreenContext,
        title: 'Delete Personnel',
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
          globalController.database!.personnelDao.deletePersonnelByUID(personnel.uid!);
        }
    );
  }

}


class PersonnelRepository {
  int status;
  PersonnelRepository(this.status);

  GlobalController globalController = Get.find();
  final _personnelList = RxList<Personnel>();

  List<Personnel> get personnelList => _personnelList;

  Future<void> initializeData() async {
    final personnelData =
    await globalController.database!.personnelDao.findPersonnelByStatus(status);
    _personnelList.addAll(personnelData);
  }
}

