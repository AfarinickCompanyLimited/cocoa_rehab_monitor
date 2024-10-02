// To parse this JSON data, do
//
//     final community = communityFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Community communityFromJson(String str) => Community.fromJson(json.decode(str));

String communityToJson(Community data) => json.encode(data.toJson());

@entity
class Community {
  Community({
    this.operationalArea,
    this.communityId,
    this.community,
    this.districtId,
    this.districtName,
    this.regionId,
    this.regionName,
  });

  @primaryKey
  int? communityId;
  String? operationalArea;
  String? community;
  int? districtId;
  String? districtName;
  String? regionId;
  String? regionName;

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    operationalArea: json["operational_area"],
    communityId: json["community_id"],
    community: json["community"],
    districtId: json["district_id"],
    districtName: json["district_name"],
    regionId: json["region_id"],
    regionName: json["region_name"],
  );

  Map<String, dynamic> toJson() => {
    "operational_area": operationalArea,
    "community_id": communityId,
    "community": community,
    "district_id": districtId,
    "district_name": districtName,
    "region_id": regionId,
    "region_name": regionName,
  };
}
