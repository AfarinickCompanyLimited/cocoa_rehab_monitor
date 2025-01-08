import 'dart:convert';

import 'package:floor/floor.dart';

ContractorCertificateModel contractorCertificateFromJson(String str) =>
    ContractorCertificateModel.fromJson(json.decode(str));

String contractorCertificateToJson(ContractorCertificateModel data) =>
    json.encode(data.toJson());



@entity
class ContractorCertificateModel {
  ContractorCertificateModel( {
    this.uid,
    this.currentYear,
    this.currentMonth,
    this.currrentWeek,
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
    this.weedingRounds, this.sector,
  });

  @primaryKey
  final String? uid;
  final String? currentYear;
  final String? currentMonth;
  final int? currrentWeek;
  final List<int>? activity;
  final String? reportingDate;
  final String? farmRefNumber;
  final double? farmSizeHa;
  final String? community;
  final int? contractor;
  final int? userId;
  final int? district;
  final int? weedingRounds;
  final String? farmerName;
  final int? sector;
  int? roundsOfWeeding;
  int? status;

  factory ContractorCertificateModel.fromJson(Map<String, dynamic> json) =>
      ContractorCertificateModel(
        uid: json["uid"],
        currentYear: json["current_year"],
        currentMonth: json["current_month"],
        currrentWeek: json["currrent_week"],
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

  Map<String, dynamic> toJsonOffline() => {
    "uid": uid,
    "current_year": currentYear,
    "current_month": currentMonth,
    "current_week": currrentWeek,
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
