// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/constants.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import '../../controller/entity/cocoa_rehub_monitor/region_district.dart';
// import '../utils/user_current_location.dart';
import '../utils/view_constants.dart';

class EditContractorCertificateRecordController extends GetxController {
  late BuildContext editContractorCertificateRecordScreenContext;

  final editContractorCertificateRecordFormKey = GlobalKey<FormState>();

  ContractorCertificate? contractorCertificate;
  bool? isViewMode;

  HomeController homeController = Get.find();

  Globals globals = Globals();

  ContractorCertificateApiInterface contractorCertificateApiInterface =
      ContractorCertificateApiInterface();

  GlobalController globalController = Get.find();

  final ImagePicker mediaPicker = ImagePicker();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  var isButtonDisabled = false.obs;
  // var isSaveButtonDisabled = false.obs;

  LocationData? locationData;

  var region;
  var district;
  TextEditingController? operationalAreaTC = TextEditingController();

  // Community? community = Community();

  RegionDistrict? regionDistrict = RegionDistrict();

  TextEditingController? farmSizeTC = TextEditingController();
  TextEditingController? farmReferenceNumberTC = TextEditingController();
  TextEditingController? communityNameTC = TextEditingController();

  Contractor? contractor = Contractor();
  Activity activity = Activity();

  List<Activity> subActivity = [];

  List<String> listOfWeeks = ['1', '2', '3', '4', '5'];

  List<String> listOfMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  var selectedWeek = ''.obs;
  var selectedMonth = ''.obs;
  var selectedYear = ''.obs;

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
      //     context: editContractorCertificateRecordScreenContext);
      // userCurrentLocation.getUserLocation(
      //     forceEnableLocation: true,
      //     onLocationEnabled: (isEnabled, pos) {
      //       if (isEnabled == true) {
      //         locationData = pos!;
      //         update();
      //       }
      //     });

      selectedWeek.value = contractorCertificate!.currrentWeek ?? '';
      selectedMonth.value = contractorCertificate!.currentMonth ?? '';
      selectedYear.value = contractorCertificate!.currentYear ?? '';
      farmReferenceNumberTC?.text = contractorCertificate!.farmRefNumber ?? '';
      farmSizeTC?.text = contractorCertificate!.farmSizeHa.toString();
      communityNameTC?.text = contractorCertificate!.community.toString();

      List? activityDataList = await globalController.database!.activityDao
          .findActivityByCode(contractorCertificate!.activity[0]);
      activity = activityDataList.first;
      update();

      List<Activity>? subActivityDataList = await globalController
          .database!.activityDao
          .findAllActivityWithCodeList(contractorCertificate!.activity);
      subActivity = subActivityDataList;
      update();

      List? regionDistrictList = await globalController
          .database!.regionDistrictDao
          .findRegionDistrictByDistrictId(contractorCertificate!.district!);
      regionDistrict = regionDistrictList.first;
      update();

      // List? communityDataList = await globalController.database!.communityDao
      //     .findCommunityById(contractorCertificate!.community!);
      // community = communityDataList.first;
      // update();

      List? contractorDataList = await globalController.database!.contractorDao
          .findContractorById(contractorCertificate!.contractor!);
      contractor = contractorDataList.first;
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
    // isButtonDisabled.value = false;

    globals.startWait(editContractorCertificateRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
        subActivity.map((activity) => activity.code).cast<int>().toList();

    ContractorCertificate contractorCertificateData = ContractorCertificate(
        uid: contractorCertificate?.uid,
        currentYear: selectedYear.value,
        currentMonth: selectedMonth.value,
        currrentWeek: selectedWeek.value,
        reportingDate: formattedReportingDate,
        mainActivity: activity.code,
        activity: subActivityList,
        farmRefNumber: farmReferenceNumberTC!.text,
        farmSizeHa: double.parse(farmSizeTC!.text),
        community: communityNameTC!.text,
        contractor: contractor?.contractorId,
        district: regionDistrict?.districtId,
        status: SubmissionStatus.submitted,
        userId: int.tryParse(globalController.userInfo.value.userId!));

    Map<String, dynamic> data = contractorCertificateData.toJson();
    data.remove('main_activity');
    data.remove('submission_status');

    print('THIS IS Contractor Certificate DETAILS:::: $data');

    var postResult = await contractorCertificateApiInterface
        .saveContractorCertificate(contractorCertificateData, data);
    globals.endWait(editContractorCertificateRecordScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      Get.back(
          result: {'contractorCertificate': contractorCertificateData, 'submitted': true});

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
          context: editContractorCertificateRecordScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    }
  }

  // ==============================================================================
  // END ADD MONITORING RECORD
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE MONITORING RECORD
  // ==============================================================================
  handleSaveOfflineMonitoringRecord() async {
    globals.startWait(editContractorCertificateRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
        subActivity.map((activity) => activity.code).cast<int>().toList();

    ContractorCertificate contractorCertificateData = ContractorCertificate(
        uid: contractorCertificate?.uid,
        currentYear: selectedYear.value,
        currentMonth: selectedMonth.value,
        currrentWeek: selectedWeek.value,
        reportingDate: formattedReportingDate,
        mainActivity: activity.code,
        activity: subActivityList,
        status: SubmissionStatus.pending,
        farmRefNumber: farmReferenceNumberTC!.text,
        farmSizeHa: double.parse(farmSizeTC!.text),
        community: communityNameTC!.text,
        contractor: contractor?.contractorId,
        district: regionDistrict?.districtId,
        userId: int.tryParse(globalController.userInfo.value.userId!));

    Map<String, dynamic> data = contractorCertificateData.toJson();
    data.remove('main_activity');
    data.remove('submission_status');

    print('THIS IS Contractor Certificate DETAILS:::: $data');

    final contractorCertificateDao =
        globalController.database!.contractorCertificateDao;
    await contractorCertificateDao
        .updateContractorCertificate(contractorCertificateData);

    globals.endWait(editContractorCertificateRecordScreenContext);

    // Get.back();
    Get.back(result: {
      'contractorCertificate': contractorCertificateData,
      'submitted': false
    });
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Certificate record saved',
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        status: AlertDialogStatus.success,
        okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
  }

  // ==============================================================================
  // END OFFLINE SAVE MONITORING RECORD
  // ==============================================================================
}
