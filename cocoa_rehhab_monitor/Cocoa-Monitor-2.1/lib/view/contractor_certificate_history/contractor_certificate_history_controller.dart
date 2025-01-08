import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/db/contractor_certificate_of_workdone_db.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import '../../controller/model/contractor_certificate_of_workdone_model.dart';

class ContractorCertificateHistoryController extends GetxController {
  BuildContext? contractorCertificateHistoryScreenContext;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  ContractorCertificateApiInterface contractorCertificateApiInterface =
      ContractorCertificateApiInterface();

  ContractorCertificateDatabaseHelper db = ContractorCertificateDatabaseHelper.instance;

  TabController? tabController;
  var activeTabIndex = 0.obs;

  final PagingController<int, ContractorCertificate>
      pendingRecordsController = PagingController(firstPageKey: 0);
  final PagingController<int, ContractorCertificate>
      submittedRecordsController = PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  Future<void> fetchData(
      {required int status,
      required int pageKey,
      required PagingController controller}) async {
    try {
      final data = await globalController.database!.contractorCertificateDao.findContractorCertificateByStatusWithLimit(status, _pageSize, pageKey * _pageSize);
         
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
        FirebaseCrashlytics.instance.log('contractor cert. fetchData');

      
    }
  }

  confirmDeleteMonitoring(ContractorCertificate contractorCertificate) async {
    globals.primaryConfirmDialog(
        context: contractorCertificateHistoryScreenContext,
        title: 'Delete Record',
        image: 'assets/images/cocoa_monitor/question.png',
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
              "This action is irreversible. Are you sure you want to delete this record?",
              textAlign: TextAlign.center),
        ),
        cancelTap: () {
          Get.back();
        },
        okayTap: () {
          Get.back();
          globalController.database!.contractorCertificateDao.deleteContractorCertificateByUID(contractorCertificate.uid!);
          // update();
          pendingRecordsController.itemList!.remove(contractorCertificate);
          update(['pendingRecordsBuilder']);
        });
  }
}
