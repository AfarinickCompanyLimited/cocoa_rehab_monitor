import 'dart:convert';

ContractorCertificateVerificationModel contractorCertificateVerificationFromJson(
    String str) =>
    ContractorCertificateVerificationModel.fromJson(json.decode(str));

String contractorCertificateVerificationToJson(
    ContractorCertificateVerificationModel data) =>
    json.encode(data.toJson());


class ContractorCertificateVerificationModel {
  ContractorCertificateVerificationModel({
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
    this.sub_activity_string
  });

  String? uid;
  String? currentYear;
  String? currentMonth;
  String? currrentWeek;
  String? sub_activity_string;
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
  String? currentFarmPic;
  int? contractor;
  String? completedBy;

  factory ContractorCertificateVerificationModel.fromJson(
      Map<String, dynamic> json) =>
      ContractorCertificateVerificationModel(
        uid: json["uid"],
        currentYear: json["current_year"],
        currentMonth: json["current_month"],
        currrentWeek: json["currrent_week"],
        mainActivity: json["main_activity"],
        sub_activity_string: json["sub_activity_string"],
        activity:
        json["activity"],
        reportingDate: json["reporting_date"],
        farmRefNumber: json["farm_ref_number"],
        farmSizeHa: json["farm_size_ha"],
        community: json["community"],
        status: json["status"],
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
    "sub_activity_string": sub_activity_string,
    "current_year": currentYear,
    "current_month": currentMonth,
    "currrent_week": currrentWeek,
    "main_activity": mainActivity,
    "activity": activity,
    "reporting_date": reportingDate,
    "farm_ref_number": farmRefNumber,
    "farm_size_ha": farmSizeHa,
    "community": community,
    "status": status,
    "district": district,
    "userid": userId,
    "lat": lat,
    "lng": lng,
    "accuracy": accuracy,
    "contractor": contractor,
    "completed_by": completedBy,
    "current_farm_pic": currentFarmPic,
  };
}
