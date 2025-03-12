import '../global_controller.dart';
import 'package:get/get.dart';

class Leave {
  final globalController = Get.put(GlobalController());
  int leaveType;
  String numberOfDays;
  String leaveReason;
  String startDate;
  String endDate;

  Leave({required this.leaveType,
      required this.numberOfDays,
      required this.leaveReason,
      required this.startDate,
      required this.endDate});

  Map<String, dynamic> toJson() => {
    'employee': globalController.userInfo.value.staffId,
    'leave_type': leaveType,
    'description': leaveReason,
    'start_date': startDate,
    'end_date': endDate
  };

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
    leaveType: json['leave_type'],
    numberOfDays: json['number_of_days'],
    leaveReason: json['leave_reason'],
    startDate: json['start_date'],
    endDate: json['end_date'],
  );
}