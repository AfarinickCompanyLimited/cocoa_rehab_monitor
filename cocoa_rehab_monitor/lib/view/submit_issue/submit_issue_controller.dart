import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';

class SubmitIssueController extends GetxController {
  late BuildContext context;

  final formKey = GlobalKey<FormState>();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  HomeController homeController = Get.find();

  GeneralCocoaRehabApiInterface generalCocoaRehabApiInterface =
      GeneralCocoaRehabApiInterface();

  TextEditingController? raIDTC = TextEditingController();

  TextEditingController? titleTC = TextEditingController();

  TextEditingController? messageTC = TextEditingController();
  TextEditingController? farmReferenceNumberTC = TextEditingController();

  TextEditingController? dateReceivedTC = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  OutbreakFarmFromServer? farm;
  Activity activity = Activity();
  Activity subActivity = Activity();

  RehabAssistant? rehabAssistant = RehabAssistant();
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

  String? selectedWeek;
  String? selectedMonth;

  var isButtonDisabled = false.obs;

  // INITIALISE

  // ==============================================================================
  // START FUEL SUBMISSION
  // ==============================================================================
  handleSubmit() async {
    globals.startWait(context);

    var postResult = await generalCocoaRehabApiInterface.submitIssue({
      "uid": const Uuid().v4(),
      "userid": globalController.userInfo.value.userId,
      "title": titleTC?.text.trim(),
      "feedback": messageTC?.text.trim(),
      "week": selectedWeek,
      "month": selectedMonth,
      "farm_reference": farmReferenceNumberTC?.text.trim(),
      "activity": subActivity.subActivity,
      "ra_id": raIDTC?.text.trim(),
    });
    //if (context.mounted) {
      globals.endWait(context);
    //}

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      Get.back();
      // if (context.mounted) {
        globals.showSecondaryDialog(
            context: homeController.homeScreenContext,
            content: Text(
              postResult['msg'],
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success,
            okayTap: () =>
                Navigator.of(homeController.homeScreenContext).pop());
     // }
    } else if (postResult['status'] == RequestStatus.False) {
      //if (context.mounted) {
        globals.showSecondaryDialog(
            context: context,
            content: Text(
              postResult['msg'],
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.error);
      //}
    } else {}
  }
  // ==============================================================================
  // END FUEL SUBMISSION
  // ==============================================================================
}
