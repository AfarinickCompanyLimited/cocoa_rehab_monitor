// To parse this JSON data, do
//
//     final assignedFarms = assignedFarmsFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:floor/floor.dart';

AssignedFarm assignedFarmFromJson(String str) => AssignedFarm.fromJson(json.decode(str));

String assignedFarmToJson(AssignedFarm data) => json.encode(data.toJson());

@entity
class AssignedFarm {
  AssignedFarm({
    this.id,
    this.farmBoundary,
    this.farmername,
    this.location,
    this.farmReference,
    this.farmSize,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  Uint8List? farmBoundary;
  String? farmername;
  String? location;
  String? farmReference;
  String? farmSize;

  factory AssignedFarm.fromJson(Map<String, dynamic> json) => AssignedFarm(
    farmBoundary: Uint8List.fromList(utf8.encode(json["farm_boundary"])),
    farmername: json["farmername"],
    location: json["location"],
    farmReference: json["farm_reference"],
    farmSize: json["farm_size"],
  );

  Map<String, dynamic> toJson() => {
    // "farm_boundary": base64Encode(farmBoundary ?? []),
    "farm_boundary": const Utf8Decoder().convert(farmBoundary ?? []),
    "farmername": farmername,
    "location": location,
    "farm_reference": farmReference,
    "farm_size": farmSize,
  };
}
