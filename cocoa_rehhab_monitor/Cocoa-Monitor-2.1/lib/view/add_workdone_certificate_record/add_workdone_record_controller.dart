// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/constants.dart';
import '../../controller/entity/cocoa_rehub_monitor/activity.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import '../../controller/entity/cocoa_rehub_monitor/region_district.dart';
import '../../controller/global_controller.dart';
import '../global_components/globals.dart';
import '../home/home_controller.dart';
import '../utils/view_constants.dart';

class AddContractorCertificateRecordController extends GetxController {
  late BuildContext addContractorCertificateRecordScreenContext;

  final addContractorCertificateRecordFormKey = GlobalKey<FormState>();

  HomeController homeController = Get.find();


  var activityCheck = false.obs;
  var subActivityCheck = false.obs;

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  ContractorCertificateApiInterface contractorCertificateApiInterface =
  ContractorCertificateApiInterface();

  final ImagePicker mediaPicker = ImagePicker();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // var isButtonDisabled = false.obs;
  // var isSaveButtonDisabled = false.obs;

  LocationData? locationData;

  // Community? community = Community();

  RegionDistrict? regionDistrict = RegionDistrict();

  Contractor? contractor = Contractor();

  TextEditingController? farmSizeTC = TextEditingController();
  TextEditingController? farmerNameTC = TextEditingController();

  TextEditingController? farmReferenceNumberTC = TextEditingController();
  TextEditingController? communityTC = TextEditingController();

  Activity activity = Activity();

  List<Activity> subActivity = [];

  List<String> listOfWeeks = ['1', '2', '3', '4', '5'];
  List<String> listOfRoundsOfWeeding = ['1', '2'];

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

  var selectedWeek;
  var selectedMonth;
  var selectedYear;
  var roundsOfWeeding;

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
      //     context: addContractorCertificateRecordScreenContext);
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
    // isButtonDisabled.value = false;

    globals.startWait(addContractorCertificateRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
    subActivity.map((activity) => activity.code).cast<int>().toList();

    ContractorCertificate contractorCertificate = ContractorCertificate(
        uid: const Uuid().v4(),
        currentYear: selectedYear,
        currentMonth: selectedMonth,
        currrentWeek: selectedWeek,
        farmerName: farmerNameTC!.text,
        roundsOfWeeding: int.tryParse(roundsOfWeeding),
        reportingDate: formattedReportingDate,
        mainActivity: activity.code,
        activity: subActivityList,
        farmRefNumber: farmReferenceNumberTC!.text,
        farmSizeHa: double.tryParse(farmSizeTC!.text),
        community: communityTC!.text,
        contractor: contractor?.contractorId,
        district: regionDistrict?.districtId,
        status: SubmissionStatus.submitted,
        userId: int.tryParse(
          globalController.userInfo.value.userId!,
        ));

    Map<String, dynamic> data = contractorCertificate.toJson();
    data.remove('main_activity');
    data.remove('submission_status');

    print('THIS IS Contractor Certificate DETAILS:::: $data');

    // var postResult = await contractorCertificateApiInterface
    //     .saveContractorCertificate(contractorCertificate, data);
    globals.endWait(addContractorCertificateRecordScreenContext);
    //
    // if (postResult['status'] == RequestStatus.True ||
    //     postResult['status'] == RequestStatus.Exist ||
    //     postResult['status'] == RequestStatus.NoInternet) {
    //   Get.back(result: {
    //     'contractorCertificate': contractorCertificate,
    //     'submitted': true
    //   });
    //   globals.showSecondaryDialog(
    //      context: homeController.homeScreenContext,
    //       content: Text(
    //         postResult['msg'],
    //         style: const TextStyle(fontSize: 13),
    //         textAlign: TextAlign.center,
    //       ),
    //       status: AlertDialogStatus.success,
    //       okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
    // }
    // else if (postResult['status'] == RequestStatus.False) {
    //   globals.showSecondaryDialog(
    //       context: addContractorCertificateRecordScreenContext,
    //       content: Text(
    //         postResult['msg'],
    //         style: const TextStyle(fontSize: 13),
    //         textAlign: TextAlign.center,
    //       ),
    //       status: AlertDialogStatus.error);
    // }
  }

  // ==============================================================================
  // END ADD MONITORING RECORD
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE MONITORING RECORD
  // ==============================================================================
  handleSaveOfflineMonitoringRecord() async {
    // isSaveButtonDisabled.value = false;

    globals.startWait(addContractorCertificateRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
    subActivity.map((newActivity) => newActivity.code).cast<int>().toList();

    ContractorCertificate contractorCertificate = ContractorCertificate(
        uid: const Uuid().v4(),
        currentYear: selectedYear,
        currentMonth: selectedMonth,
        farmerName: farmerNameTC!.text,
        roundsOfWeeding: roundsOfWeeding!.text,
        currrentWeek: selectedWeek,
        reportingDate: formattedReportingDate,
        mainActivity: activity.code,
        activity: subActivityList,
        status: SubmissionStatus.pending,
        farmRefNumber: farmReferenceNumberTC!.text,
        farmSizeHa: double.parse(farmSizeTC!.text),
        community: communityTC?.text,
        contractor: contractor?.contractorId,
        district: regionDistrict?.districtId,
        userId: int.tryParse(globalController.userInfo.value.userId!));

    Map<String, dynamic> data = contractorCertificate.toJson();
    print('THIS IS Contractor Certificate DATA DETAILS:::: $data');

    data.remove('main_activity');
    data.remove('submission_status');

    final contractorCertificateDao =
        globalController.database!.contractorCertificateDao;
    await contractorCertificateDao
        .insertContractorCertificate(contractorCertificate);

    globals.endWait(addContractorCertificateRecordScreenContext);

    Get.back(result: {
      'contractorCertificate': contractorCertificate,
      'submitted': false
    });
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Certificate saved',
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
