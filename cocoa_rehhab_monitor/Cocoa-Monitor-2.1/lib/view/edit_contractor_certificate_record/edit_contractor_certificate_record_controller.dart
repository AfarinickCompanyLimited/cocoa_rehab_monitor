// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../controller/global_controller.dart';
import '../../controller/model/contractor_certificate_of_workdone_model.dart';
import '../../controller/model/job_order_farms_model.dart';
import '../../view/global_components/globals.dart';
import '../../view/home/home_controller.dart';
import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/db/activity_db.dart';
import '../../controller/db/contractor_certificate_of_workdone_db.dart';
import '../../controller/db/job_order_farms_db.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
import '../../controller/entity/cocoa_rehub_monitor/region_district.dart';
import '../../controller/model/activity_model.dart';
import '../../controller/constants.dart';
import '../utils/view_constants.dart';

class EditContractorCertificateRecordController extends GetxController {
  late BuildContext editContractorCertificateRecordScreenContext;
  final editContractorCertificateRecordFormKey = GlobalKey<FormState>();

  ContractorCertificateModel? contractorCertificate;
  bool? isViewMode;

  final HomeController homeController = Get.find();
  final Globals globals = Globals();
  final ContractorCertificateApiInterface contractorCertificateApiInterface =
  ContractorCertificateApiInterface();
  final GlobalController globalController = Get.find();
  final ImagePicker mediaPicker = ImagePicker();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  var isButtonDisabled = false.obs;

  LocationData? locationData;

  var region;
  var district;

  // Text controllers
  final TextEditingController operationalAreaTC = TextEditingController();
  final TextEditingController sectorTC = TextEditingController();
  final TextEditingController farmSizeTC = TextEditingController();
  final TextEditingController farmReferenceNumberTC = TextEditingController();
  final TextEditingController communityNameTC = TextEditingController();
  final TextEditingController farmerNameTC = TextEditingController();
  final TextEditingController communityTC = TextEditingController();

  Contractor? contractor;
  String? activity;
  List<ActivityModel> subActivity = [];

  final List<String> listOfWeeks = ['1', '2', '3', '4', '5'];
  final List<String> listOfMonths = [
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
  final List<String> listOfRoundsOfWeeding = ['1', '2'];

  var selectedWeek = ''.obs;
  var selectedMonth = ''.obs;
  var selectedYear = ''.obs;

  String? roundsOfWeeding;

  final ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
  final JobOrderFarmsDbFarmDatabaseHelper jobDb =
      JobOrderFarmsDbFarmDatabaseHelper.instance;

  JobOrderFarmModel? jobOrderFarmModel;

  final ContractorCertificateDatabaseHelper contractorCertificateDatabaseHelper =
      ContractorCertificateDatabaseHelper.instance;

  /// Assign values to UI fields
  assignValues() async {
    // Extracting community and sub-activity
    final List<String> comAndSub = contractorCertificate!.community!.split('-');
    final List<String> subActivityStrings = comAndSub
        .sublist(1, comAndSub.length - 1)
        .expand((sub) => sub.split(',').map((item) => item.trim()))
        .toList();

    List<Contractor>? contractorDataList = await globalController.database!
        .contractorDao
        .findContractorById(contractorCertificate!.contractor!);
    contractor = contractorDataList.first;

    roundsOfWeeding = contractorCertificate!.weedingRounds.toString();
    sectorTC.text = globalController.userInfo.value.sector ?? '';
    selectedWeek.value = contractorCertificate!.currrentWeek.toString();
    selectedMonth.value = contractorCertificate!.currentMonth ?? '';
    selectedYear.value = contractorCertificate!.currentYear ?? '';
    farmerNameTC.text = contractorCertificate!.farmerName ?? '';
    communityTC.text = comAndSub[0];
    communityNameTC.text = comAndSub[0];
    farmSizeTC.text = contractorCertificate!.farmSizeHa.toString();

    // Fetching sub-activities from the database
    List<ActivityModel> allActivities = await db.getAllData();
    subActivity = allActivities
        .where((activity) =>
        subActivityStrings.contains(activity.subActivity?.trim()))
        .toList();

    activity = comAndSub.last.trim();
    jobOrderFarmModel =
    await jobDb.getFarmByID(contractorCertificate!.farmRefNumber!);

    update();
  }

  /// Initialize the controller
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await assignValues();
      Future.delayed(const Duration(seconds: 3), update);
    });
  }

  /// Handle add monitoring record
  handleAddMonitoringRecord() async {
    String subActivityString = subActivity.map((e) => e.subActivity).join(', ');

    String communityData =
        "${communityTC.text}-$subActivityString-$activity-${contractor?.contractorName}";

    globals.startWait(editContractorCertificateRecordScreenContext);

    final contractorCert = ContractorCertificateModel(
      uid: const Uuid().v4(),
      currentYear: selectedYear.value,
      currentMonth: selectedMonth.value,
      currrentWeek: int.tryParse(selectedWeek.value),
      reportingDate: dateFormat.format(DateTime.now()),
      activity: subActivity.map((e) => e.code!).toList(),
      farmerName: farmerNameTC.text,
      farmRefNumber: farmReferenceNumberTC.text,
      farmSizeHa: double.parse(farmSizeTC.text),
      community: communityData,
      weedingRounds: int.tryParse(roundsOfWeeding!),
      sector: int.tryParse(sectorTC.text),
      contractor: contractor?.contractorId,
      district: globalController.userInfo.value.district,
      status: SubmissionStatus.submitted,
      userId: int.tryParse(globalController.userInfo.value.userId!),
    );

    final postResult = await contractorCertificateApiInterface
        .saveContractorCertificate(contractorCert, contractorCert.toJson());

    globals.endWait(editContractorCertificateRecordScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      final db = ContractorCertificateDatabaseHelper.instance;
      db.deleteData(contractorCertificate!.uid!);
      Get.back(result: {
        'contractorCertificate': contractorCert,
        'submitted': true
      });
      globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: Text(postResult['msg']),
        status: AlertDialogStatus.success,
        okayTap: () => Navigator.of(homeController.homeScreenContext).pop(),
      );
    } else {
      globals.showSecondaryDialog(
        context: editContractorCertificateRecordScreenContext,
        content: Text(postResult['msg']),
        status: AlertDialogStatus.error,
      );
    }
  }

  /// Handle save offline monitoring record
  handleSaveOfflineMonitoringRecord() async {
    String subActivityString = subActivity.map((e) => e.subActivity).join(', ');
    String communityData =
        "${communityTC.text}-$subActivityString-$activity-${contractor?.contractorName}";

    final contractorCert = ContractorCertificateModel(
      uid: const Uuid().v4(),
      currentYear: selectedYear.value,
      currentMonth: selectedMonth.value,
      currrentWeek: int.tryParse(selectedWeek.value),
      reportingDate: dateFormat.format(DateTime.now()),
      activity: subActivity.map((e) => e.code!).toList(),
      farmerName: farmerNameTC.text,
      farmRefNumber: farmReferenceNumberTC.text,
      farmSizeHa: double.parse(farmSizeTC.text),
      community: communityData,
      weedingRounds: int.tryParse(roundsOfWeeding!),
      sector: int.tryParse(sectorTC.text),
      contractor: contractor?.contractorId,
      district: globalController.userInfo.value.district,
      status: SubmissionStatus.pending,
      userId: int.tryParse(globalController.userInfo.value.userId!),
    );

    await contractorCertificateDatabaseHelper.deleteData(contractorCertificate!.uid!);
    await contractorCertificateDatabaseHelper.saveData(contractorCert);

    globals.endWait(editContractorCertificateRecordScreenContext);

    Get.back(result: {
      'contractorCertificate': contractorCert,
      'submitted': false,
    });
    globals.showSecondaryDialog(
      context: homeController.homeScreenContext,
      content: const Text('Certificate saved'),
      status: AlertDialogStatus.success,
    );
  }
}
