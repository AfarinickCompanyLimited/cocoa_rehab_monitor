
// ignore_for_file: use_build_context_synchronously

import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/outbreak_farm_apis.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_fuel.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditInitialTreatmentFuelController extends GetxController{

  late BuildContext context;

  final assignRAFormKey = GlobalKey<FormState>();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  HomeController homeController = Get.find();

  InitialTreatmentFuel? initialTreatmentFuel;
  bool? isViewMode;

  OutbreakFarmApiInterface outbreakFarmApiInterface = OutbreakFarmApiInterface();

  TextEditingController? remarksTC = TextEditingController();
  TextEditingController? quantityTC = TextEditingController();
  TextEditingController? dateReceivedTC = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  OutbreakFarmFromServer? farm;
  RehabAssistant? rehabAssistant = RehabAssistant();

  var isButtonDisabled = false.obs;

  // INITIALISE
  @override
  void onInit() async {

    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      dateReceivedTC?.text =  initialTreatmentFuel!.dateReceived!;
      remarksTC?.text =  initialTreatmentFuel!.remarks!;
      quantityTC?.text =  initialTreatmentFuel!.fuelLtr.toString();

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
  handleSubmit() async{

    globals.startWait(context);

    InitialTreatmentFuel initialTreatmentFuelData = InitialTreatmentFuel(
      uid: initialTreatmentFuel?.uid,
      userid: int.parse(globalController.userInfo.value.userId!),
      farmdetailstblForeignkey: int.parse(farm!.farmId.toString()),
      dateReceived: dateReceivedTC?.text,
      rehabassistantsTblForeignkey: rehabAssistant?.rehabCode,
      remarks: remarksTC?.text.trim(),
      fuelLtr: int.parse(quantityTC!.text.trim()),
      status: SubmissionStatus.submitted,
    );

    var postResult = await outbreakFarmApiInterface.updateFuel(initialTreatmentFuelData);
    globals.endWait(context);

    if (postResult['status'] == RequestStatus.True || postResult['status'] == RequestStatus.Exist || postResult['status'] == RequestStatus.NoInternet){
      Get.back(result: {'initialTreatmentFuel': initialTreatmentFuelData, 'submitted': true});
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
          context : context,
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
  // END MAINTENANCE FUEL
  // ==============================================================================



  // ==============================================================================
  // START OFFLINE MAINTENANCE FUEL
  // ==============================================================================
  handleOfflineSave() async{

    globals.startWait(context);

    InitialTreatmentFuel initialTreatmentFuelData = InitialTreatmentFuel(
      id: initialTreatmentFuel?.id,
      uid: initialTreatmentFuel?.uid,
      userid: int.parse(globalController.userInfo.value.userId!),
      farmdetailstblForeignkey: int.parse(farm!.farmId.toString()),
      dateReceived: dateReceivedTC?.text,
      rehabassistantsTblForeignkey: rehabAssistant?.rehabCode,
      remarks: remarksTC?.text.trim(),
      fuelLtr: int.parse(quantityTC!.text.trim()),
      status: SubmissionStatus.pending,
    );

    final initialTreatmentFuelDao = globalController.database!.initialTreatmentFuelDao;
    initialTreatmentFuelDao.updateInitialTreatmentFuel(initialTreatmentFuelData);

    globals.endWait(context);

    Get.back(result: {'initialTreatmentFuel': initialTreatmentFuelData, 'submitted': false});
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
// END OFFLINE MAINTENANCE FUEL
// ==============================================================================


}

