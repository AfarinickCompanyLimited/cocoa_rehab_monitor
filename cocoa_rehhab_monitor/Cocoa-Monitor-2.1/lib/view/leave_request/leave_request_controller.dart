import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_monitor/controller/model/leave.dart';
import 'package:cocoa_monitor/controller/utils/dio_singleton_instance.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LeaveRequestController extends GetxController {

  BuildContext? LeaveRequestScreenContext;

  @override
  void onInit() async {
    super.onInit();
    await fetchLeaveTypes();
  }

  final globals = Globals();
  final _api = GeneralCocoaRehabApiInterface();

  var selectedLeave = ''.obs;

  TextEditingController numberOfDays = TextEditingController();
  TextEditingController leaveReason = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  RxList leaveList = RxList(); // Using RxList to track changes

  calculateDays() {
    DateTime start = DateTime.parse(startDate.text);
    DateTime end = DateTime.parse(endDate.text);
    int days = end.difference(start).inDays + 1;
    numberOfDays.text = days.toString();
  }

  validate() {
    if (selectedLeave.value.isEmpty) {}
  }

  RxInt maxDays = 0.obs;

  List leaveTypesResponse = [];


  getMaximumLeaveDays() {
    leaveTypesResponse.forEach((element) {
      if(element['name'] == selectedLeave.value) {
        maxDays.value = element['max_duration'];
        return;
      }
    });
  }

  submitLeaveRequest() async {

    var lt = 0;
    leaveTypesResponse.forEach((element) {
      if(element['name'] == selectedLeave.value) {
        lt = element['id'];
      }
    });
    if(lt == 0) {
      globals.showSnackBar(
          title: 'Error', message: 'Please select a leave type');
      return;
    }

    Leave leave = Leave(
        leaveType: lt,
        numberOfDays: numberOfDays.text,
        leaveReason: leaveReason.text,
        startDate: startDate.text,
        endDate: endDate.text);
    Map<String, dynamic> leaveMap = leave.toJson();
    // print("THE DATA FOR SUBMISSION IS ${leaveMap}");

    globals.startWait(LeaveRequestScreenContext!);
    int response = await _api.submitLeave(leaveMap);
    globals.endWait(LeaveRequestScreenContext);

    if (response == 1) {
      Get.back();
      globals.showSnackBar(
          title: 'Success', message: 'Leave request submitted successfully');
    } else if (response == 2) {
      print("THE RESPONSE IS ${response}");
      globals.showSnackBar(
          title: 'Error', message: 'Cannot submit leave request, contact your supervisor for assistance');
    } else {
      globals.showSnackBar(
          title: 'An unknown error occurred',
          message: 'Try again or contact support for assistance');
    }
  }

  // calculate the number of working days between two dates without saturday and sunday
  int calculateWorkingDays(DateTime startDate, DateTime endDate) {
    int workingDays = 0;
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      if (currentDate.weekday != DateTime.saturday && currentDate.weekday != DateTime.sunday) {
        workingDays++;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return workingDays;
  }


  saveLeaveRequest() {}


  fetchLeaveTypes() async {
    try {
      var response = await DioSingleton.instance.get("http://18.171.87.243/api/v1/leavetypes");
      if(response.data['data'] != null) {
        leaveTypesResponse = response.data['data'].map((e) => e).toList();
        leaveList.addAll(leaveTypesResponse.map((e) => e['name'])); // Updating leaveList
        update(); // Notifying listeners
      }else {
        leaveTypesResponse = [];
        leaveList.clear(); // Clearing leaveList
        update(); // Notifying listeners
      }
    } catch (e) {
      // todo ::: remove print
      print(e);
    }
  }
}