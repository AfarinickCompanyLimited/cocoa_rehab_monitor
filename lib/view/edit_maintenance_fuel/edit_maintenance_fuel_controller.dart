// ignore_for_file: use_build_context_synchronously

import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/maintenance_fuel.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditMaintenanceFuelController extends GetxController {
  late BuildContext context;

  final assignRAFormKey = GlobalKey<FormState>();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  HomeController homeController = Get.find();

  MaintenanceFuel? maintenanceFuel;
  bool? isViewMode;

  // MaintenanceMonitoringApiInterface monitoringApiInterface =
  //     MaintenanceMonitoringApiInterface();

  TextEditingController? remarksTC = TextEditingController();
  TextEditingController? quantityTC = TextEditingController();
  TextEditingController? dateReceivedTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  Farm? farm;
  RehabAssistant? rehabAssistant = RehabAssistant();

  var isButtonDisabled = false.obs;

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dateReceivedTC?.text = maintenanceFuel!.dateReceived!;
      remarksTC?.text = maintenanceFuel!.remarks!;
      quantityTC?.text = maintenanceFuel!.fuelLtr.toString();

      /*List? activityDataList = await globalController.database!.activityDao.findActivityByCode(personnelAssignment!.activity!);
      activity = activityDataList.first;*/

      update();

      Future.delayed(const Duration(seconds: 3), () async {
        update();
      });
    });
  }

  // ==============================================================================
  // START MAINTENANCE FUEL
  // ==============================================================================
  /*handleSubmit() async {
    globals.startWait(context);

    MaintenanceFuel maintenanceFuelData = MaintenanceFuel(
      id: maintenanceFuel?.id,
      uid: maintenanceFuel?.uid,
      userid: int.parse(globalController.userInfo.value.userId!),
      farmdetailstblForeignkey: int.parse(farm!.farmCode.toString()),
      dateReceived: dateReceivedTC?.text,
      rehabassistantsTblForeignkey: rehabAssistant?.rehabCode,
      remarks: remarksTC?.text.trim(),
      fuelLtr: int.parse(quantityTC!.text.trim()),
      status: SubmissionStatus.submitted,
    );

    var postResult = 
        await monitoringApiInterface.updateFuel(maintenanceFuelData);
    globals.endWait(context);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      Get.back(result: {'maintenanceFuel': maintenanceFuel, 'submitted': true});
      globals.showSecondaryDialog(
          context: homeController.homeScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.success,
          okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
    } else if (postResult['status'] == RequestStatus.False) {
      globals.showSecondaryDialog(
          context: context,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    } else {}
  }*/
  // ==============================================================================
  // END MAINTENANCE FUEL
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE MAINTENANCE FUEL
  // ==============================================================================
  handleOfflineSave() async {
    globals.startWait(context);

    MaintenanceFuel maintenanceFuelData = MaintenanceFuel(
      id: maintenanceFuel?.id,
      uid: maintenanceFuel?.uid,
      userid: int.parse(globalController.userInfo.value.userId!),
      farmdetailstblForeignkey: int.parse(farm!.farmCode.toString()),
      dateReceived: dateReceivedTC?.text,
      rehabassistantsTblForeignkey: rehabAssistant?.rehabCode,
      remarks: remarksTC?.text.trim(),
      fuelLtr: int.parse(quantityTC!.text.trim()),
      status: SubmissionStatus.pending,
    );

    final maintenanceFuelDao = globalController.database!.maintenanceFuelDao;
    maintenanceFuelDao.updateMaintenanceFuel(maintenanceFuelData);

    globals.endWait(context);

    Get.back(result: {'maintenanceFuel': maintenanceFuel, 'submitted': false});
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Record saved',
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        status: AlertDialogStatus.success,
        okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
  }
// ==============================================================================
// END OFFLINE MAINTENANCE FUEL
// ==============================================================================
}
