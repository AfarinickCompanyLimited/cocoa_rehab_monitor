import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/db/activity_db.dart';
import 'package:cocoa_rehab_monitor/controller/db/contractor_certificate_of_workdone_db.dart';
import 'package:cocoa_rehab_monitor/controller/db/job_order_farms_db.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/contractor.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import 'package:cocoa_rehab_monitor/controller/model/activity_model.dart';
import 'package:cocoa_rehab_monitor/controller/model/contractor_certificate_of_workdone_model.dart';

import '../utils/view_constants.dart';

class AddContractorCertificateRecordController extends GetxController {
  // Dependencies
  final HomeController homeController = Get.find();
  final Globals globals = Globals();
  final GlobalController globalController = Get.find();
  final ContractorCertificateApiInterface contractorCertificateApiInterface =
  ContractorCertificateApiInterface();
  final ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
  final JobOrderFarmsDbFarmDatabaseHelper jobDb =
      JobOrderFarmsDbFarmDatabaseHelper.instance;
  final ContractorCertificateDatabaseHelper contractorCertificateDatabaseHelper =
      ContractorCertificateDatabaseHelper.instance;
  final ImagePicker mediaPicker = ImagePicker();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // Screen context
  late BuildContext addContractorCertificateRecordScreenContext;

  // Form key
  final GlobalKey<FormState> addContractorCertificateRecordFormKey =
  GlobalKey<FormState>();

  // Form controllers
  final TextEditingController sectorTC = TextEditingController();
  final TextEditingController districtTC = TextEditingController();
  final TextEditingController farmSizeTC = TextEditingController();
  final TextEditingController farmerNameTC = TextEditingController();
  final TextEditingController farmReferenceNumberTC = TextEditingController();
  final TextEditingController communityTC = TextEditingController();

  // Dropdown data
  final List<String> listOfWeeks = ['1', '2', '3', '4', '5'];
  final List<String> listOfRoundsOfWeeding = ['1', '2'];
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

  // Selected values
  String? selectedWeek;
  String? selectedMonth;
  String? selectedYear;
  String? activity;
  String? roundsOfWeeding;
  RegionDistrict? regionDistrict = RegionDistrict();
  Contractor? contractor;
  List<ActivityModel> subActivity = [];

  // Location data
  LocationData? locationData;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    sectorTC.text = globalController.userInfo.value.sector.toString();
  }

  // ===========================================================================
  // FORM SUBMISSION HANDLERS
  // ===========================================================================

  Future<void> handleAddMonitoringRecord() async {
    if (!_validateForm()) return;

    globals.startWait(addContractorCertificateRecordScreenContext);

    try {
      final contractorCertificate = _createContractorCertificateModel(
        status: SubmissionStatus.submitted,
      );

      final data = _prepareSubmissionData(contractorCertificate);
      final postResult = await contractorCertificateApiInterface
          .saveContractorCertificate(contractorCertificate, data);

      _handleSubmissionResponse(postResult, contractorCertificate);
    } catch (e) {
      globals.endWait(addContractorCertificateRecordScreenContext);
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  Future<void> handleSaveOfflineMonitoringRecord() async {
    if (!_validateForm()) return;

    globals.startWait(addContractorCertificateRecordScreenContext);

    try {
      final contractorCertificate = _createContractorCertificateModel(
        status: SubmissionStatus.pending,
      );

      await contractorCertificateDatabaseHelper.saveData(contractorCertificate);

      _handleOfflineSaveSuccess(contractorCertificate);
    } catch (e) {
      globals.endWait(addContractorCertificateRecordScreenContext);
      _showErrorDialog('Failed to save offline: ${e.toString()}');
    }
  }

  // ===========================================================================
  // PRIVATE HELPER METHODS
  // ===========================================================================

  bool _validateForm() {
    if (!addContractorCertificateRecordFormKey.currentState!.validate()) {
      globals.showSnackBar(
        title: 'Alert',
        message: 'Kindly provide all required information',
      );
      return false;
    }
    return true;
  }

  ContractorCertificateModel _createContractorCertificateModel({
    required int status,
  }) {
    final now = DateTime.now();
    final formattedReportingDate = dateFormat.format(now);

    return ContractorCertificateModel(
      uid: const Uuid().v4(),
      currentYear: selectedYear,
      currentMonth: selectedMonth,
      currrentWeek: int.tryParse(selectedWeek ?? ''),
      reportingDate: formattedReportingDate,
      activity: subActivity.map((a) => a.code!).toList(),
      farmerName: farmerNameTC.text,
      farmRefNumber: farmReferenceNumberTC.text,
      farmSizeHa: double.tryParse(farmSizeTC.text) ?? 0.0,
      community: _buildCommunityString(),
      weedingRounds: int.tryParse(roundsOfWeeding ?? ''),
      sector: int.tryParse(sectorTC.text),
      contractor: contractor?.contractorId,
      district: globalController.userInfo.value.district,
      status: status,
      userId: int.tryParse(globalController.userInfo.value.userId ?? ''),
    );
  }

  String _buildCommunityString() {
    final subActivities = subActivity.map((a) => a.subActivity).join(', ');
    return '${communityTC.text}-$subActivities- $activity- ${contractor?.contractorName}';
  }

  Map<String, dynamic> _prepareSubmissionData(
      ContractorCertificateModel certificate) {
    final data = certificate.toJson();
    data['community'] = communityTC.text;
    return data;
  }

  void _handleSubmissionResponse(
      Map<String, dynamic> response, ContractorCertificateModel certificate) {
    globals.endWait(addContractorCertificateRecordScreenContext);

    if (response['status'] == RequestStatus.True ||
        response['status'] == RequestStatus.Exist ||
        response['status'] == RequestStatus.NoInternet) {
      Get.back(result: {
        'contractorCertificate': certificate,
        'submitted': true
      });
      _showSuccessDialog(response['msg']);
    } else {
      _showErrorDialog(response['msg']);
    }
  }

  void _handleOfflineSaveSuccess(ContractorCertificateModel certificate) {
    globals.endWait(addContractorCertificateRecordScreenContext);
    Get.back(result: {
      'contractorCertificate': certificate,
      'submitted': false
    });
    _showSuccessDialog('Certificate saved');
  }

  void _showSuccessDialog(String message) {
    globals.showSecondaryDialog(
      context: homeController.homeScreenContext,
      content: Text(
        message,
        style: const TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      ),
      status: AlertDialogStatus.success,
      okayTap: () => Navigator.of(homeController.homeScreenContext).pop(),
    );
  }

  void _showErrorDialog(String message) {
    globals.showSecondaryDialog(
      context: addContractorCertificateRecordScreenContext,
      content: Text(
        message,
        style: const TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      ),
      status: AlertDialogStatus.error,
    );
  }
}