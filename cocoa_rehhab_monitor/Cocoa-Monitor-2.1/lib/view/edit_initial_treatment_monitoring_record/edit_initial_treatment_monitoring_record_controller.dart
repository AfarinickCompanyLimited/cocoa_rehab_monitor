// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'dart:io' as io;
import 'dart:convert';
import 'dart:typed_data';
import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/outbreak_farm_apis.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/monitor.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/controller/model/picked_media.dart';
// import 'package:cocoa_monitor/view/utils/user_current_location.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:cocoa_monitor/view/widgets/_media_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';

import '../../controller/entity/cocoa_rehub_monitor/community.dart';
import 'components/initial_treatment_rehab_assistant_select.dart';

class EditInitialTreatmentMonitoringRecordController extends GetxController {
  late BuildContext editMonitoringRecordScreenContext;

  final editMonitoringRecordFormKey = GlobalKey<FormState>();

  InitialTreatmentMonitor? monitor;
  bool? isViewMode;
  RxBool isInitComplete = false.obs;

  HomeController homeController = Get.find();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

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
  TextEditingController? farmReferenceNumberTC = TextEditingController();

  TextEditingController? cocoaSeedlingsAliveTC = TextEditingController();

  TextEditingController? plantainSeedlingsAliveTC = TextEditingController();
  TextEditingController? cHEDTATC = TextEditingController();
  TextEditingController? cHEDTAContactTC = TextEditingController();

  TextEditingController? contractorNameTC = TextEditingController();

  TextEditingController? areaCoveredTC = TextEditingController();
  TextEditingController? remarksTC = TextEditingController();
  TextEditingController? numberOfRAAssignedTC = TextEditingController();
  TextEditingController? monitoringDateTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
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

  TextEditingController? numberInGroupTC = TextEditingController();
  // TextEditingController? communityNameTC = TextEditingController();

  var taskStatus;
  var isContractor = ''.obs;
  var isCompletedByGroup = ''.obs;
  PickedMedia? farmPhoto;
  OutbreakFarmFromServer farm = OutbreakFarmFromServer();
  Activity activity = Activity();
  Activity subActivity = Activity();

  List<InitialTreatmentRehabAssistantSelect> rehabAssistants =
      [InitialTreatmentRehabAssistantSelect(index: RxInt(1))].obs;

  void clearRehabAssistantsToDefault() {
    rehabAssistants.clear();
    rehabAssistants.add(InitialTreatmentRehabAssistantSelect(index: RxInt(1)));
  }

  void clearAllRehabAssistants() {
    rehabAssistants.clear();
  }

  RxString areaCoveredRx = ''.obs;

  updateAreaCovered() {
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
        areaCoveredRx.value = newAreaCovered.toString();
        // }
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
      // UserCurrentLocation? userCurrentLocation = UserCurrentLocation(context: editMonitoringRecordScreenContext);
      // userCurrentLocation.getUserLocation(
      //     forceEnableLocation: true,
      //     onLocationEnabled: (isEnabled, pos) {
      //       if (isEnabled == true){
      //         locationData = pos!;
      //         update();
      //       }
      //     }
      // );

      // FuelOil fuelOil = FuelOil.fromJson(jsonDecode(monitor!.fuelOil!));

      // farmID = monitor!.farmTblForeignkey;
      // farmSizeTC?.text =  monitor!.originalFarmSize.toString();
      areaCoveredTC?.text = monitor!.areaCoveredHa.toString();
      remarksTC?.text = monitor!.remark ?? '';
      numberOfRAAssignedTC?.text = monitor!.noRehabAssistants.toString();
      monitoringDateTC?.text = monitor!.monitoringDate ?? '';
      farmReferenceNumberTC?.text = monitor!.farmRefNumber ?? '';
      farmSizeTC?.text = monitor!.farmSizeHa.toString();
      cocoaSeedlingsAliveTC?.text = monitor!.cocoaSeedlingsAlive.toString();
      plantainSeedlingsAliveTC?.text =
          monitor!.plantainSeedlingsAlive.toString();
      cHEDTATC?.text = monitor!.nameOfChedTa ?? '';
      cHEDTAContactTC?.text = monitor!.contactOfChedTa ?? '';
      operationalAreaTC?.text = monitor!.operationalArea ?? '';
      contractorNameTC?.text = monitor!.contractorName ?? '';
      numberInGroupTC?.text = monitor!.numberOfPeopleInGroup.toString();
      isCompletedByGroup.value = monitor!.groupWork ?? '';
      isContractor.value = monitor!.completedByContractor ?? '';
      areaCoveredRx.value = monitor!.areaCoveredRx ?? '';

      // communityNameTC?.text = monitor!.community.toString();

      // fuelPurchasedDateTC?.text =  fuelOil.datePurchased ?? '';
      // fuelDateTC?.text =  fuelOil.date ?? '';
      // fuelQuantityPurchasedTC?.text =  fuelOil.qtyPurchased.toString();
      // fuelQuantityLtrTC?.text =  fuelOil.quantityLtr.toString();
      // fuelRedOilLtrTC?.text =  fuelOil.redOilLtr.toString();
      // fuelEngineOilLtrTC?.text =  fuelOil.engineOilLtr.toString();
      // fuelAreaTC?.text =  fuelOil.area.toString();
      // fuelReceivingOperatorTC?.text =  fuelOil.nameOperatorReceiving ?? '';
      // fuelRemarksTC?.text =  fuelOil.remarks ?? '';
      // taskStatus = monitor!.jobStatus;

      List? activityDataList = await globalController.database!.activityDao
          .findActivityByCode(monitor!.activity!);
      activity = activityDataList.first;

      List? subActivityDataList = await globalController.database!.activityDao
          .findActivityByCode(monitor!.activity!);
      subActivity = subActivityDataList.first;

      //  List? regionDistrictList = await globalController
      //     .database!.regionDistrictDao
      //     .findRegionDistrictByDistrictId(
      //         monitor!.regionDistrict!);
      // regionDistrict = regionDistrictList.first;
      // update();

      // Map<String, dynamic> decodedCommunity = jsonDecode(monitor!.community!);
      // int communityId = decodedCommunity['community_id'];

      // List? communityDataList = await globalController.database!.communityDao
      //     .findCommunityById(communityId);
      // community = communityDataList.first;

      List? communityDataList = await globalController.database!.communityDao
          .findCommunityById(monitor!.community!);
      community = communityDataList.first;

      List raList = jsonDecode(monitor!.ras!) as List;
      List<Ra> ras = raList.map((e) => Ra.fromJson(e)).toList();
      update();

      rehabAssistants.clear();
      int index = 1;
      await Future.forEach(ras, (Ra ra) async {
        List<RehabAssistant> dataList = await globalController
            .database!.rehabAssistantDao
            .findRehabAssistantByRehabCode(ra.rehabAsistant!);
        rehabAssistants.add(InitialTreatmentRehabAssistantSelect(
            index: RxInt(index),
            rehabAssistant: dataList.first,
            areaHa: ra.areaCoveredHa.toString(),
            isViewMode: isViewMode));
        index++;
      });
      isInitComplete.value = true;

      update();

      Future.delayed(const Duration(seconds: 3), () async {
        update();
      });
    });
  }

  // ==============================================================================
  // START ADD MONITORING RECORD
  // ==============================================================================
  handleAddMonitoringRecord() async {
    // if(farmPhoto == null){
    //   globals.showSnackBar(title: 'Alert', message: 'Kindly add a picture of the farm');
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
    } else {
      await Future.forEach(rehabAssistants,
          (InitialTreatmentRehabAssistantSelect item) async {
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

    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: editMonitoringRecordScreenContext);
    // isButtonDisabled.value = true;

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    //         isButtonDisabled.value = false;

    var pictureOfFarm = monitor!.currentFarmPic;
    if (farmPhoto?.file != null) {
      final bytes = await io.File(farmPhoto!.path!).readAsBytes();
      // pictureOfFarm = base64Encode(bytes);
      pictureOfFarm = bytes;
    } else {
      pictureOfFarm =
          Uint8List(0); // Assign empty Uint8List when pictureOfFarm is null
    }

    globals.startWait(editMonitoringRecordScreenContext);

    List<Ra> ras = rehabAssistants
        .map((InitialTreatmentRehabAssistantSelect e) => Ra(
            rehabAsistant: e.rehabAssistant?.rehabCode,
            areaCoveredHa: double.parse(e.areaCovered?.text ?? '0')))
        .toList();

    // FuelOil fuelOil = FuelOil(
    //   datePurchased: fuelPurchasedDateTC!.text,
    //   date: fuelDateTC!.text,
    //   nameOperatorReceiving: fuelReceivingOperatorTC!.text.trim(),
    //   quantityLtr: double.parse(fuelQuantityLtrTC!.text.isNotEmpty ? fuelQuantityLtrTC!.text.trim() : '0.0'),
    //   qtyPurchased: double.parse(fuelQuantityPurchasedTC!.text.isNotEmpty ? fuelQuantityPurchasedTC!.text.trim() : '0.0'),
    //   redOilLtr: double.parse(fuelRedOilLtrTC!.text.isNotEmpty ? fuelRedOilLtrTC!.text.trim() : '0.0'),
    //   engineOilLtr: double.parse(fuelEngineOilLtrTC!.text.isNotEmpty ? fuelEngineOilLtrTC!.text.trim() : '0.0'),
    //   area: double.parse(fuelAreaTC!.text.isNotEmpty ? fuelAreaTC!.text.trim() : '0.0'),
    //   remarks: fuelRemarksTC!.text.trim()
    // );

    InitialTreatmentMonitor monitorData = InitialTreatmentMonitor(
      uid: monitor?.uid,
      agent: globalController.userInfo.value.userId,
      monitoringDate: monitoringDateTC!.text,
      // lat: monitor!.lat,
      // lng: monitor!.lng,
      // accuracy: monitor?.accuracy,
      // staffContact: phoneTC!.text.trim(),
      // farmTblForeignkey: farm.farmId,
      mainActivity: activity.code,
      activity: subActivity.code,
      noRehabAssistants: rehabAssistants.length,
      // originalFarmSize: farm.farmArea,
      areaCoveredHa: areaCovered,
      // jobStatus: taskStatus,
      remark: remarksTC!.text,
      currentFarmPic: pictureOfFarm,
      status: SubmissionStatus.submitted,
      ras: jsonEncode(ras),
      // fuelOil: jsonEncode(fuelOil)
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.parse(farmSizeTC!.text),
      cocoaSeedlingsAlive: int.tryParse(cocoaSeedlingsAliveTC!.text),
      plantainSeedlingsAlive: int.tryParse(plantainSeedlingsAliveTC!.text),
      nameOfChedTa: cHEDTATC!.text,
      contactOfChedTa: cHEDTAContactTC!.text,
      // community: jsonEncode(community),
      community: community?.communityId,
      operationalArea: operationalAreaTC!.text,
      contractorName: contractorNameTC?.text ?? "",
      numberOfPeopleInGroup: int.tryParse(numberInGroupTC!.text.trim()),
      groupWork: isCompletedByGroup.value,
      completedByContractor: isContractor.value,
    );

    Map<String, dynamic> data = monitorData.toJson();
    data.remove('ras');
    data.remove('staff_contact');
    data.remove('main_activity');
    data.remove('submission_status');
    data.remove("areaCoveredRx");

    // data["rehab_assistants"] = jsonEncode(ras);
    data["rehab_assistants"] = ras.map((e) => e.toJson()).toList();
    // data["fuel_oil"] = jsonEncode(fuelOil);
    // data["fuel_oil"] = fuelOil.toJson();
    print('DATADATADATA ;;; $data');

    var postResult =
        await outbreakFarmApiInterface.updateMonitoring(monitorData, data);
    globals.endWait(editMonitoringRecordScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      // Get.back();
      Get.back(result: {'monitor': monitorData, 'submitted': true});
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
          context: editMonitoringRecordScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    } else {}
    // }
    //    else {
    //     isButtonDisabled.value = false;
    //     globals.showSnackBar(
    //         title: 'Alert',
    //         message:
    //             'Operation could not be completed. Turn on your location and try again');
    //   }
    // });
  }
  // ==============================================================================
  // END ADD MONITORING RECORD
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE MONITORING RECORD
  // ==============================================================================
  handleSaveOfflineMonitoringRecord() async {
    // if(farmPhoto == null){
    //   globals.showSnackBar(title: 'Alert', message: 'Kindly add a picture of the farm');
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
    } else {
      await Future.forEach(rehabAssistants,
          (InitialTreatmentRehabAssistantSelect item) async {
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

    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: editMonitoringRecordScreenContext);
    // isSaveButtonDisabled.value = true;

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    //         isSaveButtonDisabled.value = false;

    var pictureOfFarm = monitor!.currentFarmPic;
    if (farmPhoto?.file != null) {
      final bytes = await io.File(farmPhoto!.path!).readAsBytes();
      // pictureOfFarm = base64Encode(bytes);
      pictureOfFarm = bytes;
    }

    globals.startWait(editMonitoringRecordScreenContext);

    List<Ra> ras = rehabAssistants
        .map((InitialTreatmentRehabAssistantSelect e) => Ra(
            rehabAsistant: e.rehabAssistant?.rehabCode,
            areaCoveredHa: double.parse(e.areaCovered?.text ?? '0')))
        .toList();

    // FuelOil fuelOil = FuelOil(
    //     datePurchased: fuelPurchasedDateTC!.text,
    //     date: fuelDateTC!.text,
    //     nameOperatorReceiving: fuelReceivingOperatorTC!.text.trim(),
    //     quantityLtr: double.parse(fuelQuantityLtrTC!.text.isNotEmpty ? fuelQuantityLtrTC!.text.trim() : '0.0'),
    //     qtyPurchased: double.parse(fuelQuantityPurchasedTC!.text.isNotEmpty ? fuelQuantityPurchasedTC!.text.trim() : '0.0'),
    //     redOilLtr: double.parse(fuelRedOilLtrTC!.text.isNotEmpty ? fuelRedOilLtrTC!.text.trim() : '0.0'),
    //     engineOilLtr: double.parse(fuelEngineOilLtrTC!.text.isNotEmpty ? fuelEngineOilLtrTC!.text.trim() : '0.0'),
    //     area: double.parse(fuelAreaTC!.text.isNotEmpty ? fuelAreaTC!.text.trim() : '0.0'),
    //     remarks: fuelRemarksTC!.text.trim()
    // );

    InitialTreatmentMonitor monitorData = InitialTreatmentMonitor(
      uid: monitor?.uid,
      agent: globalController.userInfo.value.userId,
      monitoringDate: monitoringDateTC!.text,
      // lat: monitor!.lat,
      // lng: monitor!.lng,
      // accuracy: monitor?.accuracy,
      // staffContact: phoneTC!.text.trim(),
      // farmTblForeignkey: farm.farmId,
      mainActivity: activity.code,
      activity: subActivity.code,
      noRehabAssistants: rehabAssistants.length,
      // originalFarmSize: farm.farmArea,
      areaCoveredHa: areaCovered,
      // jobStatus: taskStatus,
      remark: remarksTC!.text,
      currentFarmPic: pictureOfFarm,
      status: SubmissionStatus.pending,
      ras: jsonEncode(ras),
      // fuelOil: jsonEncode(fuelOil)
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.parse(farmSizeTC!.text),
      cocoaSeedlingsAlive: int.tryParse(cocoaSeedlingsAliveTC!.text),
      plantainSeedlingsAlive: int.tryParse(plantainSeedlingsAliveTC!.text),
      nameOfChedTa: cHEDTATC!.text,
      contactOfChedTa: cHEDTAContactTC!.text,
      // community: jsonEncode(community),
      community: community?.communityId,
      operationalArea: operationalAreaTC!.text,
      contractorName: contractorNameTC!.text,
      numberOfPeopleInGroup: int.tryParse(numberInGroupTC!.text.trim()),
      groupWork: isCompletedByGroup.value,
      completedByContractor: isContractor.value,
      areaCoveredRx: areaCoveredRx.value,
    );

    Map<String, dynamic> data = monitorData.toJson();
    data.remove('ras');
    data.remove('staff_contact');
    data.remove('main_activity');
    // data["rehab_assistants"] = jsonEncode(ras);
    data["rehab_assistants"] = ras.map((e) => e.toJson()).toList();
    // data["fuel_oil"] = jsonEncode(fuelOil);
    // data["fuel_oil"] = fuelOil.toJson();

    print('THIS IS MONITOR DETAILS:::: $data');

    final initialTreatmentMonitorDao =
        globalController.database!.initialTreatmentMonitorDao;
    await initialTreatmentMonitorDao.updateInitialTreatmentMonitor(monitorData);

    globals.endWait(editMonitoringRecordScreenContext);

    // Get.back();
    Get.back(result: {'monitor': monitorData, 'submitted': false});
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
    //   else {
    //     isSaveButtonDisabled.value = false;
    //     globals.showSnackBar(
    //         title: 'Alert',
    //         message:
    //             'Operation could not be completed. Turn on your location and try again');
    //   }
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
    ).show(editMonitoringRecordScreenContext);
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

      farmPhoto = pickedMedia;
      update();
    } else {
      return null;
    }
  }
// ===========================================
// END PICK MEDIA
// ==========================================
}
