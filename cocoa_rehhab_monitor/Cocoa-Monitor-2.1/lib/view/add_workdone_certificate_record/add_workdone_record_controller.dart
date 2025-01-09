// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/db/activity_db.dart';
import 'package:cocoa_monitor/controller/db/contractor_certificate_of_workdone_db.dart';
import 'package:cocoa_monitor/controller/db/job_order_farms_db.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import '../../controller/model/activity_model.dart';
import '../../controller/model/contractor_certificate_of_workdone_model.dart';

class AddContractorCertificateRecordController extends GetxController {
  late BuildContext addContractorCertificateRecordScreenContext;

  final addContractorCertificateRecordFormKey = GlobalKey<FormState>();

  HomeController homeController = Get.find();

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

  TextEditingController? sectorTC = TextEditingController();
  TextEditingController? districtTC = TextEditingController();

  Contractor? contractor = Contractor();

  TextEditingController? farmSizeTC = TextEditingController();
  TextEditingController? farmerNameTC = TextEditingController();

  TextEditingController? farmReferenceNumberTC = TextEditingController();
  TextEditingController? communityTC = TextEditingController();

  ActivityModel? activit;
  String? activity;

  ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;

  JobOrderFarmsDbFarmDatabaseHelper jobDb =
      JobOrderFarmsDbFarmDatabaseHelper.instance;

  List<ActivityModel> subActivity = [];

  List<ActivityModel> activities = [];

  List<AssignedFarm> farmRefs = [];

  List<String> act = [];

  List<String> fr = [];

  // getDistinctActivity() {
  //   activities.forEach((activity) {
  //     if(!act.contains(activity.mainActivity)){
  //       act.add(activity.mainActivity!);
  //     }
  //   });
  //   print("THE ACTIVITY STRINGS ::::::::: ${act}");
  // }
  //
  // getDistinctFarmRefs(){
  //   farmRefs.forEach((f){
  //     fr.add(f.farmReference!);
  //   });
  // }
  //
  // getFarmRefs()async{
  //   farmRefs = await globalController.database!.assignedFarmDao.findAllAssignedFarms();
  // }
  //
  // getActivity() async {
  //   activities = await db.getAllActivityWithMainActivityList([
  //     MainActivities.Maintenance,
  //     MainActivities.Establishment,
  //     MainActivities.InitialTreatment,
  //   ]);
  //   print("THE ACTIVITY ::::::::: ${activities[0].mainActivity}");
  // }

  String? roundsOfWeeding;

  List<String> listOfWeeks = ['1', '2', '3', '4', '5'];

  List<String> listOfRoundsOfWeeding = [
    '1',
    '2',
  ];

  List<String> sectorData = ['1', '2', '3', '4'];

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

  ContractorCertificateDatabaseHelper contractorCertificateDatabaseHelper =
      ContractorCertificateDatabaseHelper.instance;

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


     globals.startWait(addContractorCertificateRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
        subActivity.map((activity) => activity.code).cast<int>().toList();

    ContractorCertificateModel contractorCertificate =
        ContractorCertificateModel(
            uid: const Uuid().v4(),
            currentYear: selectedYear,
            currentMonth: selectedMonth,
            currrentWeek: int.tryParse(selectedWeek),
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
            status: SubmissionStatus.submitted,
            userId: int.tryParse(
              globalController.userInfo.value.userId!,
            ));

    Map<String, dynamic> data = contractorCertificate.toJson();
    data.remove('main_activity');
    data.remove('submission_status');

    data["community"] = communityTC!.text;
    data["district"] = 0;

    print('THIS IS Contractor Certificate DETAILS:::: $data');

    var postResult = await contractorCertificateApiInterface
        .saveContractorCertificate(contractorCertificate, data);
    globals.endWait(addContractorCertificateRecordScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      Get.back(result: {
        'contractorCertificate': contractorCertificate,
        'submitted': true
      });
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
          context: addContractorCertificateRecordScreenContext,
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
    // isSaveButtonDisabled.value = false;

    globals.startWait(addContractorCertificateRecordScreenContext);
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
            currentYear: selectedYear,
            currentMonth: selectedMonth,
            currrentWeek: int.tryParse(selectedWeek),
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
    ///Delete the data
    await contractorCertificateDatabaseHelper.deleteData(contractorCertificate.uid!);
    /// insert the new data
    await contractorCertificateDatabaseHelper.saveData(contractorCertificate);

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
