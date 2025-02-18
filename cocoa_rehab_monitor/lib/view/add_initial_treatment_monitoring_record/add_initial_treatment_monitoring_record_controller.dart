// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'dart:io' as io;
import 'dart:convert';
import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/outbreak_farm_apis.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/db/initail_activity_db.dart';
import 'package:cocoa_rehab_monitor/controller/db/job_order_farms_db.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/controller/model/activity_model.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/controller/model/picked_media.dart';
import 'package:cocoa_rehab_monitor/view/utils/bytes_to_size.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';
import 'package:cocoa_rehab_monitor/view/widgets/_media_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uuid/uuid.dart';
import 'package:cocoa_rehab_monitor/controller/db/activity_db.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/community.dart';
import 'package:cocoa_rehab_monitor/controller/model/activity_data_model.dart';
import 'components/initial_treatment_rehab_assistant_select.dart';

class AddInitialTreatmentMonitoringRecordController extends GetxController {
  late BuildContext addMonitoringRecordScreenContext;

  final addMonitoringRecordFormKey = GlobalKey<FormState>();

  HomeController homeController = Get.find();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;

  JobOrderFarmsDbFarmDatabaseHelper jobOrderDb =
      JobOrderFarmsDbFarmDatabaseHelper.instance;

  OutbreakFarmApiInterface outbreakFarmApiInterface =
      OutbreakFarmApiInterface();

  final ImagePicker mediaPicker = ImagePicker();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // var isButtonDisabled = false.obs;
  // var isSaveButtonDisabled = false.obs;

  LocationData? locationData;

  TextEditingController? blocksTC = TextEditingController();
  var assignmentDate;
  // TextEditingController? phoneTC = TextEditingController();
  var region;
  var district;
  TextEditingController? operationalAreaTC = TextEditingController();
  var farmID;
  Community? community = Community();

  // RegionDistrict? regionDistrict = RegionDistrict();

  TextEditingController? farmSizeTC = TextEditingController();
  TextEditingController? communityTC = TextEditingController();
  TextEditingController? farmLocationTC = TextEditingController();
  TextEditingController? cocoaSeedlingsAliveTC = TextEditingController();
  TextEditingController? plantainSeedlingsAliveTC = TextEditingController();

  TextEditingController? farmReferenceNumberTC = TextEditingController();

  TextEditingController? areaCoveredTC = TextEditingController();
  TextEditingController? remarksTC = TextEditingController();
  TextEditingController? numberOfPeopleInGroup = TextEditingController();
  TextEditingController? numberOfRAAssignedTC = TextEditingController();
  TextEditingController? cHEDTATC = TextEditingController();
  TextEditingController? contractorNameTC = TextEditingController();
  TextEditingController? numberInGroupTC = TextEditingController();

  TextEditingController? cHEDTAContactTC = TextEditingController();

  // farmerContactTC

  TextEditingController? monitoringDateTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  TextEditingController? reportingDateTC = TextEditingController();

  TextEditingController? fuelPurchasedDateTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController? fuelDateTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController? fuelQuantityPurchasedTC = TextEditingController();
  TextEditingController? fuelQuantityLtrTC = TextEditingController();
  TextEditingController? fuelRedOilLtrTC = TextEditingController();
  TextEditingController? fuelEngineOilLtrTC = TextEditingController();
  TextEditingController? fuelAreaTC = TextEditingController();
  TextEditingController? fuelReceivingOperatorTC = TextEditingController();
  TextEditingController? fuelRemarksTC = TextEditingController();
  // TextEditingController? communityNameTC = TextEditingController();
  var taskStatus;
  var isContractor = ''.obs;
  var isCompletedByGroup = ''.obs;
  var isDoneEqually = ''.obs;

  InitialTreatmentMonitorDatabaseHelper initDb = InitialTreatmentMonitorDatabaseHelper.instance;

  PickedMedia? farmPhoto;
  OutbreakFarmFromServer farm = OutbreakFarmFromServer();
  // Activity activity = Activity();
  //ActivityModel subActivity = ActivityModel();
  List<ActivityModel> subActivityList = [];
  String? activity;

  List<InitialTreatmentRehabAssistantSelection> rehabAssistants =
      [InitialTreatmentRehabAssistantSelection(index: RxInt(1))].obs;

  void clearRehabAssistantsToDefault() {
    rehabAssistants.clear();
    rehabAssistants.add(InitialTreatmentRehabAssistantSelection(
      index: RxInt(rehabAssistants.length + 1),
      // areaCovered: TextEditingController(text: '0.0'),
      // rehabAssistant: RehabAssistant(),
    ));
  }

  void clearAllRehabAssistants() {
    rehabAssistants.clear();
  }

  RxString areaCoveredRx = ''.obs;

  // updateAreaCovered() {
  //   print('CALCULATING');
  //   final areaCoveredValue = areaCoveredTC?.text;
  //   final numberInGroupValue = numberInGroupTC?.text;

  //   if (areaCoveredValue != null && numberInGroupValue != null) {
  //     final areaCoveredDouble = double.tryParse(areaCoveredValue) ?? 0;
  //     final numberInGroupInt = int.tryParse(numberInGroupValue) ?? 0;

  //     if (numberInGroupInt != 0) {
  //       final newAreaCovered = areaCoveredDouble / numberInGroupInt;
  //       // for (var element in rehabAssistants) {
  //       // element.areaCoveredRx.value = newAreaCovered.toString();
  //       areaCoveredRx.value = newAreaCovered.toString();
  //       // }
  //       print(areaCoveredRx.value);
  //     }
  //   }
  // }

  updateAreaCovered() {
    print('CALCULATING');
    final areaCoveredValue = areaCoveredTC?.text;
    final numberInGroupValue = numberInGroupTC?.text;

    if (areaCoveredValue!.isNotEmpty && numberInGroupValue!.isNotEmpty) {
      final areaCoveredDouble = double.tryParse(areaCoveredValue) ?? 0;
      final numberInGroupInt = int.tryParse(numberInGroupValue) ?? 0;

      if (numberInGroupInt != 0) {
        final newAreaCovered = areaCoveredDouble / numberInGroupInt;
        // for (var element in rehabAssistants) {
        // element.areaCoveredRx.value = newAreaCovered.toString();
        double roundedValue = double.parse(newAreaCovered.toStringAsFixed(3));
        areaCoveredRx.value = roundedValue.toString();
        // }
        print(areaCoveredRx.value);
      }
    }
  }

  final List<String> taskStatusItems = [
    TaskStatus.pending,
    TaskStatus.ongoing,
    TaskStatus.completed,
  ];

  final List<String> yesNoItems = [
    YesNo.yes,
    YesNo.no,
  ];

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // UserCurrentLocation? userCurrentLocation =
      //     UserCurrentLocation(context: addMonitoringRecordScreenContext);
      // userCurrentLocation.getUserLocation(
      //     forceEnableLocation: true,
      //     onLocationEnabled: (isEnabled, pos) {
      //       if (isEnabled == true) {
      //         locationData = pos!;
      //         update();
      //       }
      //     });
    });
  }

  // ==============================================================================
  // START ADD MONITORING RECORD
  // ==============================================================================
  handleAddMonitoringRecord() async {

    var areaCovered = 0.0;

    if (rehabAssistants.isEmpty) {
      areaCovered = double.parse(areaCoveredTC!.text);
      if (areaCovered > double.parse(farmSizeTC?.text ?? '0')) {
        globals.showSnackBar(
            title: 'Alert',
            message:
                'Area covered by rehab assistants cannot be bigger than farm size',
            duration: 5);
        return;
      }

      for(int i = 0; i < rehabAssistants.length; i++){
        for(int j = i+1; j < rehabAssistants.length; j++){
          if(rehabAssistants[i].rehabAssistant!.rehabName == rehabAssistants[j].rehabAssistant!.rehabName){
            globals.showSnackBar(
                title: 'Alert',
                message:
                'Rehab assistants cannot be the same',
                duration: 5);
            return;
          }
        }
      }

      // for(int i = 0; i < rehabAssistants.length; i++){
      //   if(rehabAssistants[i].rehabAssistant!.rehabName == rehabAssistants[i+1].rehabAssistant!.rehabName){
      //
      //   }
      // }
    } else {
      await Future.forEach(rehabAssistants,
          (InitialTreatmentRehabAssistantSelection item) async {
        areaCovered += double.parse(item.areaCovered?.text ?? '0');
      });
      if (areaCovered > double.parse(farmSizeTC?.text ?? '0')) {
        globals.showSnackBar(
            title: 'Alert',
            message:
                'Area covered by rehab assistants cannot be bigger than farm size',
            duration: 5);
        return;
      }
    }
    var com = "";
    com += communityTC!.text;
    com += ",";
    com += activity!;
    com += ",";
    List<int> codes = [];

    var subActivityString = "";

    subActivityList.forEach((element) {
      codes.add(element.code!);
      subActivityString += element.code.toString();
      subActivityString += ",";
      com += element.subActivity!;
      com += "#";
    });


   //
   //  Uint8List? pictureOfFarm;
   //  if (farmPhoto?.file != null) {
   //    final bytes = await io.File(farmPhoto!.path!).readAsBytes();
   //    // pictureOfFarm = base64Encode(bytes);
   //    pictureOfFarm = bytes;
   //  } else {
   //    pictureOfFarm =
   //        Uint8List(0); // Assign empty Uint8List when pictureOfFarm is null
   //  }
   //


    //com += subActivity.subActivity!;
    com += "-";

   globals.startWait(addMonitoringRecordScreenContext);

    /// Fetch the activity using the main activity
    List<ActivityModel> act = await db.getSubActivityByMainActivity(activity!);

    List<Ra> ras = [];
    for(InitialTreatmentRehabAssistantSelection r in rehabAssistants){
      ras.add(Ra(
          rehabAsistant: r.rehabAssistant?.rehabCode,
          areaCoveredHa: double.parse(r.areaCovered?.text ?? '0')));
      com += "{${r.rehabAssistant!.rehabName} & ${r.rehabAssistant!.rehabCode} & ${r.areaCovered!.text}}%";
    }

    InitialTreatmentMonitorModel monitor = InitialTreatmentMonitorModel(
      uid: const Uuid().v4(),
      agent: globalController.userInfo.value.userId,
      completionDate: monitoringDateTC!.text,
      reportingDate: reportingDateTC!.text,
      mainActivity: act.first.code,
        activity: subActivityString,
      noRehabAssistants: rehabAssistants.length,
      areaCoveredHa: areaCovered,
      remark: remarksTC!.text,
      status: SubmissionStatus.submitted,
      ras: jsonEncode(ras),
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.parse(farmSizeTC!.text),
      community: com,
      numberOfPeopleInGroup: int.tryParse(numberInGroupTC!.text.trim()),
      groupWork: isCompletedByGroup.value,
      sector: int.tryParse(globalController.userInfo.value.sector!)
    );

    Map<String, dynamic> data = monitor.toJsonOnline();
    Map<String, dynamic> dataOffline = monitor.toJson();
    data.remove('ras');
    //data.remove('staff_contact');
    data.remove('main_activity');
    data.remove('submission_status');
    data["community"] = communityTC!.text;
    dataOffline["activity"] = subActivityString;
    data["activity"] = codes;
    //data.remove("areaCoveredRx");
    // data["rehab_assistants"] = jsonEncode(ras);
    data["rehab_assistants"] = ras.map((e) => e.toJson()).toList();
    print("Rehab-type::::::::: ${data["rehab_assistants"].runtimeType}");
    // data["fuel_oil"] = jsonEncode(fuelOil);
    // data["fuel_oil"] = fuelOil.toJson();
    // data["staff_contact"] = "0248823823";
    print('DATA-DATA-DATA ;;; $data');
    print('DATADATADATA---OFFLINE ;;; $data');

    var postResult =
         await outbreakFarmApiInterface.saveMonitoring(dataOffline, data, true);
    globals.endWait(addMonitoringRecordScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      Get.back();
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
          context: addMonitoringRecordScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    } else {}

  }
  // ==============================================================================
  // END ADD MONITORING RECORD
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE MONITORING RECORD
  // ==============================================================================
  handleSaveOfflineMonitoringRecord() async {
    // if (farmPhoto == null) {
    //   globals.showSnackBar(
    //       title: 'Alert', message: 'Kindly add a picture of the farm');
    //   return;
    // }

    var areaCovered = 0.0;

    if (rehabAssistants.isEmpty) {
      areaCovered = double.parse(areaCoveredTC!.text);
      if (areaCovered > double.parse(farmSizeTC?.text ?? '0')) {
        globals.showSnackBar(
            title: 'Alert',
            message:
                'Area covered by rehab assistants cannot be bigger than farm size',
            duration: 5);
        return;
      }


      for(int i = 0; i < rehabAssistants.length; i++){
        for(int j = i+1; j < rehabAssistants.length; j++){
          if(rehabAssistants[i].rehabAssistant!.rehabName == rehabAssistants[j].rehabAssistant!.rehabName){
            globals.showSnackBar(
                title: 'Alert',
                message:
                'Rehab assistants cannot be the same',
                duration: 5);
            return;
          }
        }
      }

    } else {
      await Future.forEach(rehabAssistants,
          (InitialTreatmentRehabAssistantSelection item) async {
        areaCovered += double.parse(item.areaCovered?.text ?? '0');
      });
      if (areaCovered > double.parse(farmSizeTC?.text ?? '0')) {
        globals.showSnackBar(
            title: 'Alert',
            message:
                'Area covered by rehab assistants cannot be bigger than farm size',
            duration: 5);
        return;
      }
    }

    var com = "";
    com += communityTC!.text;
    com += ",";
    com += activity!;
    com += ",";
    List<int> codes = [];

    var subActivityString = "";

    int index = 0;
    subActivityList.forEach((element) {
      codes.add(element.code!);
      print("CODE ::::: ${element.code}");
      subActivityString += codes[index].toString();
      subActivityString += ",";
      com += element.subActivity!;
      com += "#";

      index++;
    });
    com += "-";

    print("SUB ACTIVITY :::::: $subActivityList");

   globals.startWait(addMonitoringRecordScreenContext);

    /// Fetch the activity using the main activity
    List<ActivityModel> act = await db.getSubActivityByMainActivity(activity!);

    List<Ra> ras = [];
    for(InitialTreatmentRehabAssistantSelection r in rehabAssistants){
      ras.add(Ra(
          rehabAsistant: r.rehabAssistant?.rehabCode,
          areaCoveredHa: double.parse(r.areaCovered?.text ?? '0')));
      com += "{${r.rehabAssistant!.rehabName} & ${r.rehabAssistant!.rehabCode} & ${r.areaCovered!.text}}%";
    }

    InitialTreatmentMonitorModel monitor = InitialTreatmentMonitorModel(
      uid: const Uuid().v4(),
      agent: globalController.userInfo.value.userId,
      completionDate: monitoringDateTC!.text,
      reportingDate: reportingDateTC!.text,
      mainActivity: act.first.code,
      activity: subActivityString,
      noRehabAssistants: rehabAssistants.length,
      areaCoveredHa: areaCovered,
      remark: remarksTC!.text,
      status: SubmissionStatus.pending,
      ras: jsonEncode(ras),
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.parse(farmSizeTC!.text),
      community: com,
      numberOfPeopleInGroup: int.tryParse(numberInGroupTC!.text.trim()),
      groupWork: isCompletedByGroup.value,
      sector: int.tryParse(globalController.userInfo.value.sector!),
    );

    Map<String, dynamic> data = monitor.toJson();
    Map<String, dynamic> dataOffline = monitor.toJson();
    //data.remove('ras');
    data.remove('staff_contact');
    data.remove('main_activity');
    data["group_work"] = isCompletedByGroup.value;
    //data.remove('submission_status');
    // data["rehab_assistants"] = jsonEncode(ras);
    //data["rehab_assistants"] = ras.map((e) => e.toJson()).toList();
    // data["fuel_oil"] = jsonEncode(fuelOil);
    // data["fuel_oil"] = fuelOil.toJson();

    print('THIS IS MONITOR DETAILS:::: $data');
    //
    await initDb.saveData(dataOffline);
    //
    globals.endWait(addMonitoringRecordScreenContext);
    //
    Get.back();
    globals.showSecondaryDialog(
         context: homeController.homeScreenContext,
        content: const Text(
           'Monitoring record saved',
          style: TextStyle(fontSize: 13),
           textAlign: TextAlign.center,
         ),
         status: AlertDialogStatus.success,
        okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
    // }
    //  else {
    //   isSaveButtonDisabled.value = false;
    //   globals.showSnackBar(
    //       title: 'Alert',
    //       message:
    //           'Your location accuracy is too low. It must not be greater than ${MaxLocationAccuracy.max} meters');
    //   locationData = position;
    //   update();
    // }
    // }
    // else {
    //   isSaveButtonDisabled.value = false;
    //   globals.showSnackBar(
    //       title: 'Alert',
    //       message:
    //           'Operation could not be completed. Turn on your location and try again');
    // }
    // });
  }
  // ==============================================================================
  // END OFFLINE SAVE MONITORING RECORD
  // ==============================================================================

// ===========================================
// START SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================
  chooseMediaSource() {
    AlertDialog(
      scrollable: true,
      // insetPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(10.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      content: MediaSourceDialog(
        mediaType: FileType.image,
        onCameraSourceTap: (source, mediaType) => pickMedia(source: source),
        onGallerySourceTap: (source, mediaType) => pickMedia(source: source),
      ),
    ).show(addMonitoringRecordScreenContext);
  }
// ===========================================
// END SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================

// ===========================================
// START PICK MEDIA
// ==========================================
  pickMedia({int? source}) async {
    final XFile? mediaFile;
    var fileType = FileType.image;
    if (source == 0) {
      mediaFile = await mediaPicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
    } else {
      mediaFile = await mediaPicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);
    }

    if (mediaFile != null) {
      var fileSize = await mediaFile.length();
      PickedMedia pickedMedia = PickedMedia(
        name: mediaFile.name,
        path: mediaFile.path,
        type: fileType,
        size: fileSize,
        file: io.File(mediaFile.path),
      );
      // print('haaaaaaaaaaaaaaaa');
      // print(bytesToSize(fileSize));
      farmPhoto = pickedMedia;
      update();
      print(bytesToSize(fileSize));
    } else {
      return null;
    }
  }
// ===========================================
// END PICK MEDIA
// ==========================================
}
