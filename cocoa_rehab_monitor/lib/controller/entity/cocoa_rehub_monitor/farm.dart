// To parse this JSON data, do
//
//     final farm = farmFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Farm farmFromJson(String str) => Farm.fromJson(json.decode(str));

String farmToJson(Farm data) => json.encode(data.toJson());

@entity
class Farm {
  Farm({
    this.id,
    this.farmCode,
    this.farmId,
    this.farmerNam,
    this.districtId,
    this.districtName,
    this.regionId,
    this.regionName,
    this.farmSize,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  int? farmCode;
  String? farmId;
  String? farmerNam;
  int? districtId;
  String? districtName;
  String? regionId;
  String? regionName;
  double? farmSize;

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
    farmCode: json["farm_code"],
    farmId: json["farm_id"],
    farmerNam: json["farmer_nam"],
    districtId: json["district_id"],
    districtName: json["district_name"],
    regionId: json["region_id"],
    regionName: json["region_name"],
    farmSize: json["farm_size"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "farm_code": farmCode,
    "farm_id": farmId,
    "farmer_nam": farmerNam,
    "district_id": districtId,
    "district_name": districtName,
    "region_id": regionId,
    "region_name": regionName,
    "farm_size": farmSize,
  };
}
