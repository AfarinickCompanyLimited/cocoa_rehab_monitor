import 'dart:convert';

import 'package:floor/floor.dart';

ContractorCertificate contractorCertificateFromJson(String str) =>
    ContractorCertificate.fromJson(json.decode(str));

String contractorCertificateToJson(ContractorCertificate data) =>
    json.encode(data.toJson());



@entity
class ContractorCertificate {
  ContractorCertificate({
    this.uid,
    this.currentYear,
    this.currentMonth,
    this.currrentWeek,
    this.mainActivity,
    required this.activity,
    this.reportingDate,
    this.farmRefNumber,
    this.farmSizeHa,
    this.community,
    this.contractor,
    this.status,
    this.district,
    this.userId,
    this.farmerName,
    this.roundsOfWeeding,
  });

  @primaryKey
  String? uid;
  String? currentYear;
  String? currentMonth;
  String? currrentWeek;
  int? mainActivity;
  final List<int> activity;
  String? reportingDate;
  String? farmRefNumber;
  double? farmSizeHa;
  String? community;
  int? contractor;
  int? status;
  int? district;
  int? userId;
  String? farmerName;
  int? roundsOfWeeding;

  factory ContractorCertificate.fromJson(Map<String, dynamic> json) =>
      ContractorCertificate(
        uid: json["uid"],
        currentYear: json["current_year"],
        currentMonth: json["current_month"],
        currrentWeek: json["current_week"],
        mainActivity: json["main_activity"],
        activity:
            json["activity"] != null ? List<int>.from(json["activity"]) : [],
        reportingDate: json["reporting_date"],
        farmRefNumber: json["farm_ref_number"],
        farmSizeHa: json["farm_size_ha"],
        community: json["community"],
        contractor: json["contractor"],
        status: json["submission_status"],
        district: json["district"],
        userId: json["userid"],
        farmerName: json["farmer_name"],
        roundsOfWeeding: json["rounds_of_weeding"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "current_year": currentYear,
        "current_month": currentMonth,
        "currrent_week": currrentWeek,
        "main_activity": mainActivity,
        "activity": activity,
        "reporting_date": reportingDate,
        "farm_ref_number": farmRefNumber,
        "farm_size_ha": farmSizeHa,
        "community": community,
        "contractor": contractor,
        "submission_status": status,
        "district": district,
        "userid": userId,
        "farmer_name": farmerName,
        "rounds_of_weeding": roundsOfWeeding,
      };
}
