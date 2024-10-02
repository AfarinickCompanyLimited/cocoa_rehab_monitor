import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonnelAssignmentHistoryController extends GetxController{

  BuildContext? personnelAssignmentHistoryScreenContext;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  PersonnelAssignmentApiInterface personnelAssignmentApiInterface = PersonnelAssignmentApiInterface();

  TabController? tabController;
  var activeTabIndex = 0.obs;

  // INITIALISE


  confirmDeletePersonnelAssignment(PersonnelAssignment personnelAssignment) async {
    globals.primaryConfirmDialog(
        context: personnelAssignmentHistoryScreenContext,
        title: 'Delete Assignment Record',
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
          globalController.database!.personnelAssignmentDao.deletePersonnelAssignmentByUID(personnelAssignment.uid!);
          update();
        }
    );
  }


}

