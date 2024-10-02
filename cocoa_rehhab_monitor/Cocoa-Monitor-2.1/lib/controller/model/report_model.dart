import 'dart:convert';

DetailedReport reportFromJson(String str) =>
    DetailedReport.fromJson(json.decode(str));

class DetailedReport {
  factory DetailedReport.fromJson(Map<String, dynamic> json) {
    return DetailedReport(
      raID: json['ra_id'],
      raName: json['ra_name'],
      district: json['district'],
      bankName: json['bank_name'],
      bankBranch: json['bank_branch'],
      snnitNumber: json['snnit_no'],
      salary: json['salary'],
      year: json['year'],
      poNumber: json['po_number'],
      month: json['month'],
      week: json['week'],
      paymentOption: json['payment_option'],
      momoAccount: json['momo_acc'],
    );
  }
  DetailedReport({
    required this.raID,
    required this.raName,
    required this.district,
    required this.bankName,
    required this.bankBranch,
    required this.snnitNumber,
    required this.salary,
    required this.year,
    required this.poNumber,
    required this.month,
    required this.week,
    required this.paymentOption,
    required this.momoAccount,
  });
  final String? raID;
  final String? raName;
  final String? district;
  final String? bankName;
  final String? bankBranch;
  final String? snnitNumber;
  final String? salary;
  final String? year;
  final String? poNumber;
  final String? month;
  final String? week;
  final String? paymentOption;
  final String? momoAccount;
}
