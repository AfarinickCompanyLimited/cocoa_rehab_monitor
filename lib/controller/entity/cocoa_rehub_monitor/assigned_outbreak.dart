// To parse this JSON data, do
//
//     final assignedOutbreak = assignedOutbreakFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:floor/floor.dart';

AssignedOutbreak assignedOutbreakFromJson(String str) => AssignedOutbreak.fromJson(json.decode(str));

String assignedOutbreakToJson(AssignedOutbreak data) => json.encode(data.toJson());

@entity
class AssignedOutbreak {
  AssignedOutbreak({
    this.obId,
    this.obCode,
    this.obSize,
    this.districtId,
    this.districtName,
    this.regionId,
    this.regionName,
    this.obBoundary
  });

  @primaryKey
  int? obId;
  String? obCode;
  String? obSize;
  int? districtId;
  String? districtName;
  String? regionId;
  String? regionName;
  Uint8List? obBoundary;

  factory AssignedOutbreak.fromJson(Map<String, dynamic> json) => AssignedOutbreak(
    obId: json["ob_id"],
    obCode: json["ob_code"],
    obSize: json["ob_size"],
    districtId: json["district_id"],
    districtName: json["district_name"],
    regionId: json["region_id"],
    regionName: json["region_name"],
    obBoundary: Uint8List.fromList(utf8.encode(json["ob_boundary"])),
  );

  Map<String, dynamic> toJson() => {
    "ob_id": obId,
    "ob_code": obCode,
    "ob_size": obSize,
    "district_id": districtId,
    "district_name": districtName,
    "region_id": regionId,
    "region_name": regionName,
    "ob_boundary": const Utf8Decoder().convert(obBoundary ?? []),
  };
}
