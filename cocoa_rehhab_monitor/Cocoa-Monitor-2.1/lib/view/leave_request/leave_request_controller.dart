import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_monitor/controller/model/leave.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../controller/global_controller.dart';

class LeaveRequestController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  final globals = Globals();
  final _api = GeneralCocoaRehabApiInterface();

  var selectedLeave = ''.obs;

  TextEditingController numberOfDays = TextEditingController();
  TextEditingController leaveReason = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  calculateDays() {
    DateTime start = DateTime.parse(startDate.text);
    DateTime end = DateTime.parse(endDate.text);
    int days = end.difference(start).inDays + 1;
    numberOfDays.text = days.toString();
  }

  validate() {
    if (selectedLeave.value.isEmpty) {}
  }

  List<String> leaveList = [
    'Sick',
    'Annual',
    'Maternity',
    'Paternity',
    'LOP',
    'Hospitalisation',
  ];

  submitLeaveRequest() async {
    Leave leave = Leave(
        leaveType: selectedLeave.value,
        numberOfDays: numberOfDays.text,
        leaveReason: leaveReason.text,
        startDate: startDate.text,
        endDate: endDate.text);
    Map<String, dynamic> leaveMap = leave.toJson();

    int response = await _api.submitLeave(leaveMap);

    if (response == 1) {
      globals.showSnackBar(
          title: 'Success', message: 'Leave request submitted successfully');
    } else if (response == 2) {
      globals.showSnackBar(
          title: 'Error', message: 'Error submitting leave request');
    } else {
      globals.showSnackBar(
          title: 'No internet',
          message: 'Please check your internet connection, and try again');
    }
  }

  saveLeaveRequest() {}
}
