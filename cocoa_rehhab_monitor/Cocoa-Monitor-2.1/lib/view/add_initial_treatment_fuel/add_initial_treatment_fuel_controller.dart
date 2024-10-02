
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
import 'package:uuid/uuid.dart';

class AddInitialTreatmentFuelController extends GetxController{

  late BuildContext context;

  final assignRAFormKey = GlobalKey<FormState>();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  HomeController homeController = Get.find();

  OutbreakFarmApiInterface outbreakFarmApiInterface = OutbreakFarmApiInterface();

  TextEditingController? remarksTC = TextEditingController();
  TextEditingController? quantityTC = TextEditingController();
  TextEditingController? dateReceivedTC = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  OutbreakFarmFromServer? farm;
  RehabAssistant? rehabAssistant = RehabAssistant();

  var isButtonDisabled = false.obs;

  // INITIALISE



  // ==============================================================================
  // START FUEL SUBMISSION
  // ==============================================================================
  handleSubmit() async{

    globals.startWait(context);

    InitialTreatmentFuel initialTreatmentFuel = InitialTreatmentFuel(
      uid: const Uuid().v4(),
      userid: int.parse(globalController.userInfo.value.userId!),
      farmdetailstblForeignkey: int.parse(farm!.farmId.toString()),
      dateReceived: dateReceivedTC?.text,
      rehabassistantsTblForeignkey: rehabAssistant?.rehabCode,
      remarks: remarksTC?.text.trim(),
      fuelLtr: int.parse(quantityTC!.text.trim()),
      status: SubmissionStatus.submitted,
    );
    var postResult = await outbreakFarmApiInterface.saveFuel(initialTreatmentFuel);
    globals.endWait(context);

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
  // END FUEL SUBMISSION
  // ==============================================================================



  // ==============================================================================
  // START OFFLINE FUEL SUBMISSION
  // ==============================================================================
  handleOfflineSave() async{

    globals.startWait(context);

    InitialTreatmentFuel initialTreatmentFuel = InitialTreatmentFuel(
      uid: const Uuid().v4(),
      userid: int.parse(globalController.userInfo.value.userId!),
      farmdetailstblForeignkey: int.parse(farm!.farmId.toString()),
      dateReceived: dateReceivedTC?.text,
      rehabassistantsTblForeignkey: rehabAssistant?.rehabCode,
      remarks: remarksTC?.text.trim(),
      fuelLtr: int.parse(quantityTC!.text.trim()),
      status: SubmissionStatus.pending,
    );
    final initialTreatmentFuelDao = globalController.database!.initialTreatmentFuelDao;
    await initialTreatmentFuelDao.insertInitialTreatmentFuel(initialTreatmentFuel);

    globals.endWait(context);

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
// END OFFLINE FUEL SUBMISSION
// ==============================================================================




}

