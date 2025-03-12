// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class EditAssignRAController extends GetxController{

  late BuildContext editAssignRAScreenContext;

  final assignRAFormKey = GlobalKey<FormState>();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  HomeController homeController = Get.find();

  PersonnelAssignment? personnelAssignment;
  bool? isViewMode;

  PersonnelAssignmentApiInterface personnelAssignmentApiInterface = PersonnelAssignmentApiInterface();

  LocationData? locationData;
  TextEditingController? blocksTC = TextEditingController();
  TextEditingController? assignmentDateTC = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  Farm? farm;
  Activity activity = Activity();
  Activity subActivity = Activity();
  List<RehabAssistant> selectedRehabAssistants = [];

  var isButtonDisabled = false.obs;

  // INITIALISE
  @override
  void onInit() async {

    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      assignmentDateTC?.text =  personnelAssignment!.assignedDate!;

      List? activityDataList = await globalController.database!.activityDao.findActivityByCode(personnelAssignment!.activity!);
      activity = activityDataList.first;

      List? subActivityDataList = await  globalController.database!.activityDao.findActivityByCode(personnelAssignment!.activity!);
      subActivity = subActivityDataList.first;

      update();

      Future.delayed(const Duration(seconds: 3), () async {
        update();
      });

    });

  }



  // ==============================================================================
  // START ASSIGN RA
  // ==============================================================================
  handleAssignRA() async{

    globals.startWait(editAssignRAScreenContext);
    // List<Activity> activities = await globalController.database!.activityDao.findSubActivities(activity!.mainActivity!);

    PersonnelAssignment personnelAssignmentData = PersonnelAssignment(
      uid: personnelAssignment?.uid,
      agent: int.parse(globalController.userInfo.value.userId!),
      farmid: farm?.farmCode.toString(),
      activity: subActivity.code,
      assignedDate: assignmentDateTC?.text,
      blocks: blocksTC?.text.trim(),
      rehabAssistants: selectedRehabAssistants.map((e) => e.rehabCode).toList().toString(),
      rehabAssistantsObject: jsonEncode(selectedRehabAssistants),
      status: SubmissionStatus.submitted,
    );
    var postResult = await personnelAssignmentApiInterface.updatePersonnelAssignment(personnelAssignmentData);
    globals.endWait(editAssignRAScreenContext);

    if (postResult['status'] == RequestStatus.True || postResult['status'] == RequestStatus.Exist || postResult['status'] == RequestStatus.NoInternet){
      Get.back();
      globals.showSecondaryDialog(
          context : homeController.homeScreenContext,
          content: Text(postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.success,
          okayTap: () => Navigator.of(homeController.homeScreenContext).pop()
      );
    }else if(postResult['status'] == RequestStatus.False){
      globals.showSecondaryDialog(
          context : editAssignRAScreenContext,
          content: Text(postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error
      );
    }else{

    }

  }
  // ==============================================================================
  // END ASSIGN RA
  // ==============================================================================



  // ==============================================================================
  // START OFFLINE ASSIGN RA
  // ==============================================================================
  handleOfflineAssignRA() async{

    globals.startWait(editAssignRAScreenContext);
    // List<Activity> activities = await globalController.database!.activityDao.findSubActivities(activity!.mainActivity!);

    PersonnelAssignment personnelAssignmentData = PersonnelAssignment(
      uid: personnelAssignment?.uid,
      agent: int.parse(globalController.userInfo.value.userId!),
      farmid: farm?.farmCode.toString(),
      activity: subActivity.code,
      assignedDate: assignmentDateTC?.text,
      blocks: blocksTC?.text.trim(),
      rehabAssistants: selectedRehabAssistants.map((e) => e.rehabCode).toList().toString(),
      rehabAssistantsObject: jsonEncode(selectedRehabAssistants),
      status: SubmissionStatus.pending,
    );
    final personnelAssignmentDao = globalController.database!.personnelAssignmentDao;
    personnelAssignmentDao.updatePersonnelAssignment(personnelAssignmentData);

    globals.endWait(editAssignRAScreenContext);

    Get.back();
    globals.showSecondaryDialog(
        context : homeController.homeScreenContext,
        content: const Text('Record saved',
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        status: AlertDialogStatus.success,
        okayTap: () => Navigator.of(homeController.homeScreenContext).pop()
    );

  }
// ==============================================================================
// END OFFLINE ASSIGN RA
// ==============================================================================


}

