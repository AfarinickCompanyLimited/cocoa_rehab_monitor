import 'dart:convert';

DetailedReport reportFromJson(String str) =>
    DetailedReport.fromJson(json.decode(str));

class DetailedReport {
  factory DetailedReport.fromJson(Map<String, dynamic> json) {
    return DetailedReport(
      groupCode: json['group_code'],
      raID: json['ra_id'],
      raName: json['ra_name'],
      poName: json['po_name'],
      poNumber: json['po_number'],
      district: json['district'],
      farmHandsType: json['farmhands_type'],
      farmReference: json['farm_reference'],
      numberInAGroup: json['number_in_a_group'],
      activity: json['activity'],
      achievement: json['achievement'],
      amount: json['amount'],
      week: json['week'],
      month: json['month'],
      year: json['year'],
      issue: json['issue'],
    );
  }
  DetailedReport(
      {required this.groupCode,
      required this.raID,
      required this.raName,
      required this.poName,
      required this.poNumber,
      required this.district,
      required this.farmHandsType,
      required this.farmReference,
      required this.numberInAGroup,
      required this.activity,
      required this.achievement,
      required this.amount,
      required this.week,
      required this.month,
      required this.year,
      required this.issue});
  final String? groupCode;
  final String? raID;
  final String? raName;
  final String? poName;
  final String? poNumber;
  final String? district;
  final String? farmHandsType;
  final String? farmReference;
  final String? numberInAGroup;
  final String? activity;
  final double? achievement;
  final String? amount;
  final String? week;
  final String? month;
  final String? year;
  final String? issue;
}
