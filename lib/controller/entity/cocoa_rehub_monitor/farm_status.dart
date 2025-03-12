// To parse this JSON data, do
//
//     final farmStatus = farmStatusFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

FarmStatus farmStatusFromJson(String str) => FarmStatus.fromJson(json.decode(str));

String farmStatusToJson(FarmStatus data) => json.encode(data.toJson());

@entity
class FarmStatus {
  FarmStatus({
    this.id,
    this.farmid,
    this.location,
    this.activity,
    this.area,
    this.areaCovered,
    this.farmerName,
    this.status,
    this.month,
    this.year,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  String? farmid;
  String? location;
  String? activity;
  double? area;
  double? areaCovered;
  String? farmerName;
  String? status;
  String? month;
  int? year;

  factory FarmStatus.fromJson(Map<String, dynamic> json) => FarmStatus(
    farmid: json["farmid"],
    location: json["location"],
    activity: json["activity"],
    area: json["area"].toDouble(),
    areaCovered: json["area_covered"],
    farmerName: json["farmer_name"],
    status: json["status"],
    month: json["month"],
    year: json["year"],
  );

  Map<String, dynamic> toJson() => {
    "farmid": farmid,
    "location": location,
    "activity": activity,
    "area": area,
    "area_covered": areaCovered,
    "farmer_name": farmerName,
    "status": status,
    "month": month,
    "year": year,
  };
}
