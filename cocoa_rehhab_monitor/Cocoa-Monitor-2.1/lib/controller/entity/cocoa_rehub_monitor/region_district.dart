// To parse this JSON data, do
//
//     final regionDistrict = regionDistrictFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

RegionDistrict regionDistrictFromJson(String str) => RegionDistrict.fromJson(json.decode(str));

String regionDistrictToJson(RegionDistrict data) => json.encode(data.toJson());

@entity
class RegionDistrict {
  RegionDistrict({
    this.id,
    this.districtId,
    this.districtName,
    this.regionId,
    this.regionName,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int? districtId;
  final String? districtName;
  final String? regionId;
  final String? regionName;

  factory RegionDistrict.fromJson(Map<String, dynamic> json) => RegionDistrict(
    districtId: json["district_id"],
    districtName: json["district_name"],
    regionId: json["region_id"],
    regionName: json["region_name"],
  );

  Map<String, dynamic> toJson() => {
    "district_id": districtId,
    "district_name": districtName,
    "region_id": regionId,
    "region_name": regionName,
  };
}
