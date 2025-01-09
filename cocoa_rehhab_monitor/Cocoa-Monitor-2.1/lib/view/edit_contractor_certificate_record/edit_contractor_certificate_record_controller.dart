// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/controller/model/contractor_certificate_of_workdone_model.dart';
import 'package:cocoa_monitor/controller/model/job_order_farms_model.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/constants.dart';
import '../../controller/db/activity_db.dart';
import '../../controller/db/contractor_certificate_of_workdone_db.dart';
import '../../controller/db/job_order_farms_db.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import '../../controller/entity/cocoa_rehub_monitor/region_district.dart';
// import '../utils/user_current_location.dart';
import '../../controller/model/activity_model.dart';
import '../utils/view_constants.dart';

class EditContractorCertificateRecordController extends GetxController {
  late BuildContext editContractorCertificateRecordScreenContext;

  final editContractorCertificateRecordFormKey = GlobalKey<FormState>();

  ContractorCertificateModel? contractorCertificate;
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

  TextEditingController? sectorTC = TextEditingController();

  TextEditingController? farmSizeTC = TextEditingController();
  TextEditingController? farmReferenceNumberTC = TextEditingController();
  TextEditingController? communityNameTC = TextEditingController();

  Contractor? contractor = Contractor();
  String? activity;

  List<ActivityModel> subActivity = [];

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
  String? roundsOfWeeding;

  ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;

  JobOrderFarmsDbFarmDatabaseHelper jobDb =
      JobOrderFarmsDbFarmDatabaseHelper.instance;

  TextEditingController? farmerNameTC = TextEditingController();

  TextEditingController? communityTC = TextEditingController();

  List<String> listOfRoundsOfWeeding = [
    '1',
    '2',
  ];

  List<String> sectorData = ['1', '2', '3', '4'];

  JobOrderFarmModel? jobOrderFarmModel;

  ContractorCertificateDatabaseHelper contractorCertificateDatabaseHelper =
      ContractorCertificateDatabaseHelper.instance;

  assignValues() async {
    var sub_activity_strings = [];
    var comAndSub = contractorCertificate!.community!.split('-');

    for (int i = 1; i < comAndSub.length; i++) {
      sub_activity_strings.add(comAndSub[i].trim());
    }

    List? contractorDataList = await globalController.database!.contractorDao
        .findContractorById(contractorCertificate!.contractor!);
    contractor = contractorDataList.first;
    update();

    roundsOfWeeding = contractorCertificate!.roundsOfWeeding.toString();
    sectorTC?.text = globalController.userInfo.value.sector ?? '';
    selectedWeek.value = contractorCertificate!.currrentWeek.toString();
    selectedMonth.value = contractorCertificate!.currentMonth ?? '';
    selectedYear.value = contractorCertificate!.currentYear ?? '';
    farmerNameTC?.text = contractorCertificate!.farmerName ?? '';
    communityTC?.text = comAndSub[0];
    //farmReferenceNumberTC?.text = contractorCertificate!.farmRefNumber ?? '';
    farmSizeTC?.text = contractorCertificate!.farmSizeHa.toString();
    communityNameTC?.text = comAndSub[0];

    for (var s in sub_activity_strings) {
      var subActivities = await db.getActivityBySubActivity(s);
      print("subActivities $subActivities");

      subActivities.forEach((act) {
        subActivity.add(act);
        update();
        // if (!subActivities.contains(act)) {
        //   subActivity.add(act);
        // }
      });

    }
    activity = comAndSub[2];
    print("subActivities $subActivity");

    jobOrderFarmModel =
        await jobDb.getFarmByID(contractorCertificate!.farmRefNumber!);

    update();
  }

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // List? communityDataList = await globalController.database!.communityDao
      //     .findCommunityById(contractorCertificate!.community!);
      // community = communityDataList.first;
      // update();
      assignValues();

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

    var code = await db.getActivityCodeByMainActivity(activity!);

    ContractorCertificate contractorCertificateData = ContractorCertificate(
        uid: contractorCertificate?.uid,
        currentYear: selectedYear.value,
        currentMonth: selectedMonth.value,
        currrentWeek: selectedWeek.value,
        reportingDate: formattedReportingDate,
        mainActivity: code,
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

    // var postResult = await contractorCertificateApiInterface
    //     .saveContractorCertificate(contractorCertificateData, data);
    //
    // globals.endWait(editContractorCertificateRecordScreenContext);
    //
    // if (postResult['status'] == RequestStatus.True ||
    //     postResult['status'] == RequestStatus.Exist ||
    //     postResult['status'] == RequestStatus.NoInternet) {
    //   Get.back(
    //       result: {'contractorCertificate': contractorCertificateData, 'submitted': true});
    //
    //   globals.showSecondaryDialog(
    //       context: homeController.homeScreenContext,
    //       content: Text(
    //         postResult['msg'],
    //         style: const TextStyle(fontSize: 13),
    //         textAlign: TextAlign.center,
    //       ),
    //       status: AlertDialogStatus.success,
    //       okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
    // } else if (postResult['status'] == RequestStatus.False) {
    //   globals.showSecondaryDialog(
    //       context: editContractorCertificateRecordScreenContext,
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
//   handleSaveOfflineMonitoringRecord() async {
// //    globals.startWait(editContractorCertificateRecordScreenContext);
//     DateTime now = DateTime.now();
//     String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);
//
//     List<int> subActivityList =
//         subActivity.map((activity) => activity.code).cast<int>().toList();
//
//     var code = await db.getActivityCodeByMainActivity(activity!);
//
//     ContractorCertificate contractorCertificateData = ContractorCertificate(
//         uid: contractorCertificate?.uid,
//         currentYear: selectedYear.value,
//         currentMonth: selectedMonth.value,
//         currrentWeek: selectedWeek.value,
//         reportingDate: formattedReportingDate,
//         mainActivity: code,
//         activity: subActivityList,
//         status: SubmissionStatus.pending,
//         farmRefNumber: farmReferenceNumberTC!.text,
//         farmSizeHa: double.parse(farmSizeTC!.text),
//         community: communityNameTC!.text,
//         contractor: contractor?.contractorId,
//         district: regionDistrict?.districtId,
//         userId: int.tryParse(globalController.userInfo.value.userId!));
//
//     Map<String, dynamic> data = contractorCertificateData.toJson();
//     data.remove('main_activity');
//     data.remove('submission_status');
//
//     print('THIS IS Contractor Certificate DETAILS:::: $data');
//
//     final contractorCertificateDao =
//         globalController.database!.contractorCertificateDao;
//     await contractorCertificateDao
//         .updateContractorCertificate(contractorCertificateData);
//
//     globals.endWait(editContractorCertificateRecordScreenContext);
//
//     // Get.back();
//     Get.back(result: {
//       'contractorCertificate': contractorCertificateData,
//       'submitted': false
//     });
//     globals.showSecondaryDialog(
//         context: homeController.homeScreenContext,
//         content: const Text(
//           'Certificate record saved',
//           style: TextStyle(fontSize: 13),
//           textAlign: TextAlign.center,
//         ),
//         status: AlertDialogStatus.success,
//         okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
//   }

  handleSaveOfflineMonitoringRecord() async {
    // isSaveButtonDisabled.value = false;

    globals.startWait(editContractorCertificateRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    String subActivityString = '';

    for (int i = 0; i < subActivity.length; i++) {
      subActivityString += subActivity[i].subActivity!;
      if (i < subActivity.length - 1) {
        subActivityString += ', ';
      }
    }

    var com = '';
    com += communityTC!.text;
    com += '-';
    com += subActivityString;
    com += '- ';
    com += activity!;
    com += '- ';
    com += contractor!.contractorName!;

    List<int> subActivityList =
    subActivity.map((newActivity) => newActivity.code).cast<int>().toList();

    ContractorCertificateModel contractorCertificate =
    ContractorCertificateModel(
        uid: const Uuid().v4(),
        currentYear: selectedYear.value,
        currentMonth: selectedMonth.value,
        currrentWeek: int.tryParse(selectedWeek.value),
        reportingDate: formattedReportingDate,
        activity: subActivityList,
        farmerName: farmerNameTC!.text,
        farmRefNumber: farmReferenceNumberTC!.text,
        farmSizeHa: double.parse(farmSizeTC!.text),
        community: com,
        roundsOfWeeding: int.tryParse(roundsOfWeeding!),
        sector: int.tryParse(sectorTC!.text),
        contractor: contractor?.contractorId,
        district: regionDistrict?.districtId,
        status: SubmissionStatus.pending,
        userId: int.tryParse(
          globalController.userInfo.value.userId!,
        ));

    Map<String, dynamic> data = contractorCertificate.toJson();
    print('THIS IS Contractor Certificate DATA DETAILS:::: $data');

    // data.remove('main_activity');
    // data.remove('submission_status');

    // final contractorCertificateDao =
    //     globalController.database!.contractorCertificateDao;
    // await contractorCertificateDao
    //     .insertContractorCertificate(contractorCertificate);

    await contractorCertificateDatabaseHelper.saveData(contractorCertificate);

    globals.endWait(editContractorCertificateRecordScreenContext);

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
