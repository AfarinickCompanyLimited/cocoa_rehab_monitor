import 'package:cocoa_monitor/controller/db/contractor_certificate_of_workdone_verification_db.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/model/contractor_certificate_of_workdone_verification_model.dart';

class CertificateVerificationHistoryController extends GetxController {
  BuildContext? certificateVerificationHistoryScreenContext;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  ContractorCertificateApiInterface contractorCertificateApiInterface =
      ContractorCertificateApiInterface();
  ContractorCertificateVerificationDatabaseHelper db = ContractorCertificateVerificationDatabaseHelper.instance;
  TabController? tabController;
  var activeTabIndex = 0.obs;

  final PagingController<int, ContractorCertificateVerificationModel> pendingRecordsController =
      PagingController(firstPageKey: 0);
  final PagingController<int, ContractorCertificateVerificationModel>
      submittedRecordsController = PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  // INITIALISE

  Future<void> fetchData(
      {required int status,
      required int pageKey,
      required PagingController controller}) async {
    try {

      final data  = await db.getAllDataWithLimitAndStatus(_pageSize, status);
      // print("THE DATA ============================= ${data[0].toJson()}");
      // final data = await globalController.database!.contractorCertificateVerificationDao
      //     .findContractorCertificateVerificationByStatusWithLimit(
      //         status, _pageSize, pageKey * _pageSize);

      final isLastPage = data.length < _pageSize;
      if (isLastPage) {
        controller.appendLastPage(data);
      } else {
        final nextPageKey = pageKey + 1;
        controller.appendPage(data, nextPageKey);
      }
    } catch (error, stackTrace) {
      controller.error = error;
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
        FirebaseCrashlytics.instance.log('cert verif history.. fetchData');


    }
  }
}
