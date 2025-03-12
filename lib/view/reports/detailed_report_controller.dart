// ignore_for_file: use_build_context_synchronously

// import 'dart:io';

import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';
// import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailedReportController extends GetxController {
  late BuildContext detailedReportScreenContext;

  final detailedReportFormKey = GlobalKey<FormState>();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  HomeController homeController = Get.find();

  PersonnelAssignmentApiInterface personnelAssignmentApiInterface =
      PersonnelAssignmentApiInterface();
  GeneralCocoaRehabApiInterface generalCocoaRehabApiInterface =
      GeneralCocoaRehabApiInterface();

  TextEditingController? startDateTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController? endDateTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  var isButtonDisabled = false.obs;

  // INITIALISE

  // ==============================================================================
  // START LOAD CSV
  // ==============================================================================
  handleLoadCSV() async {
    globals.startWait(detailedReportScreenContext);

    var postResult = await generalCocoaRehabApiInterface.loadOutbreakCSV({
      'userid': globalController.userInfo.value.userId,
      'start_date': startDateTC?.text,
      'end_date': endDateTC?.text
    });
    globals.endWait(detailedReportScreenContext);

    // print(postResult);

    if (postResult['status'] == true) {
      List<dynamic> dataList = postResult['data'];

      if (dataList.isNotEmpty) {
        globals.showConfirmDialog(
            context: homeController.homeScreenContext,
            content: Text(
              "${dataList.length + 1} records loaded successfully. Do you want to download a csv?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            yesButtonBackground: AppColor.primary,
            noButtonBackground: Colors.transparent,
            noChild: const Text(
              'No',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
            yesChild: const Text(
              'Yes',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            yesTap: () {
              Get.back();
              // downloadCSV(dataList);
            });
      } else {
        globals.showSecondaryDialog(
          context: homeController.homeScreenContext,
          content: const Text(
            'There are no records available for your selected date range',
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.success,
        );
      }
    } else if (postResult['status'] == false) {
      globals.showSecondaryDialog(
          context: detailedReportScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    } else {}
  }
  // ==============================================================================
  // END LOAD CSV
  // ==============================================================================

  // ==============================================================================
  // START DOWNLOAD CSV
  // ==============================================================================
  // downloadCSV(List dataArray) async {
  //   List<String> header = dataArray[0].keys.toList();

  //   List<List<dynamic>> rows = [];
  //   rows.add(header);

  //   for (var element in dataArray) {
  //     List<dynamic> dataRow = element.values.toList();
  //     rows.add(dataRow);
  //   }

  //   String csv = const ListToCsvConverter().convert(rows);

  //   File file = File('/storage/emulated/0/Download/Outbreak Farms ${startDateTC?.text} to ${endDateTC?.text}.csv');
  //   await file.writeAsString(csv);

  //   globals.showSecondaryDialog(
  //     context : homeController.homeScreenContext,
  //     content: Text('Successfully exported to /Download/Outbreak Farms ${startDateTC?.text} to ${endDateTC?.text}.csv',
  //       style: const TextStyle(fontSize: 13),
  //       textAlign: TextAlign.center,
  //     ),
  //     status: AlertDialogStatus.success,
  //   );

  // }
  // ==============================================================================
  // END DOWNLOAD CSV
  // ==============================================================================
}
