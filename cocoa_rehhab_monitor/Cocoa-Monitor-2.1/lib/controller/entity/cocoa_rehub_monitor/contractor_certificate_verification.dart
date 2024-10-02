import 'dart:convert';
// import 'dart:typed_data';

import 'package:floor/floor.dart';

ContractorCertificateVerification contractorCertificateVerificationFromJson(
        String str) =>
    ContractorCertificateVerification.fromJson(json.decode(str));

String contractorCertificateVerificationToJson(
        ContractorCertificateVerification data) =>
    json.encode(data.toJson());

@entity
class ContractorCertificateVerification {
  ContractorCertificateVerification({
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
    this.status,
    this.district,
    this.userId,
    this.lat,
    this.lng,
    this.accuracy,
    this.currentFarmPic,
    this.contractor,
    this.completedBy,
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
  int? status;
  int? district;
  int? userId;
  double? lat;
  double? lng;
  double? accuracy;
  // Uint8List? currentFarmPic;
  String? currentFarmPic;
  int? contractor;
  String? completedBy;

  factory ContractorCertificateVerification.fromJson(
          Map<String, dynamic> json) =>
      ContractorCertificateVerification(
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
        status: json["submission_status"],
        district: json["district"],
        userId: json["userid"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        accuracy: json["accuracy"],
        currentFarmPic: json["current_farm_pic"],
        contractor: json["contractor"],
        completedBy: json["completed_by"],
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
        "submission_status": status,
        "district": district,
        "userid": userId,
        "lat": lat,
        "lng": lng,
        "accuracy": accuracy,
        // "current_farm_pic": base64Encode(currentFarmPic ?? []),
        "current_farm_pic": currentFarmPic,
        "contractor": contractor,
        "completed_by": completedBy,
      };
}
