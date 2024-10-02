class Leave {
  String leaveType;
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
    'leave_type': leaveType,
    'number_of_days': numberOfDays,
    'leave_reason': leaveReason,
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