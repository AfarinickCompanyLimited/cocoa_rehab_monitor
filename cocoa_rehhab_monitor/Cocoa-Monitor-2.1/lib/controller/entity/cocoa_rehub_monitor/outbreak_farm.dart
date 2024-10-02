// To parse this JSON data, do
//
//     final outbreakFarm = outbreakFarmFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:floor/floor.dart';

OutbreakFarm outbreakFarmFromJson(String str) => OutbreakFarm.fromJson(json.decode(str));

String outbreakFarmToJson(OutbreakFarm data) => json.encode(data.toJson());

@entity
class OutbreakFarm {
  OutbreakFarm({
    this.uid,
    this.agent,
    this.inspectionDate,
    this.outbreaksForeignkey,
    this.farmboundary,
    /*this.farmLocation,*/
    this.farmerName,
    this.farmerAge,
    this.idType,
    this.idNumber,
    this.farmerContact,
    this.cocoaType,
    this.ageClass,
    this.farmArea,
    this.communitytblForeignkey,
    this.status
  });

  @primaryKey
  String? uid;
  int? agent;
  String? inspectionDate;
  int? outbreaksForeignkey;
  Uint8List? farmboundary;
  /*String? farmLocation;*/
  String? farmerName;
  int? farmerAge;
  String? idType;
  String? idNumber;
  String? farmerContact;
  String? cocoaType;
  String? ageClass;
  double? farmArea;
  int? communitytblForeignkey;
  int? status;

  factory OutbreakFarm.fromJson(Map<String, dynamic> json) => OutbreakFarm(
    uid: json["uid"],
    agent: json["agent"],
    inspectionDate: json["inspection_date"],
    outbreaksForeignkey: json["outbreaks_foreignkey"],
    farmboundary: Uint8List.fromList(utf8.encode(json["farmboundary"])),
    /*farmLocation: json["farm_location"],*/
    farmerName: json["farmer_name"],
    farmerAge: json["farmer_age"],
    idType: json["id_type"],
    idNumber: json["id_number"],
    farmerContact: json["farmer_contact"],
    cocoaType: json["cocoa_type"],
    ageClass: json["age_class"],
    farmArea: json["farm_area"],
    communitytblForeignkey: json["communitytbl_foreignkey"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "agent": agent,
    "inspection_date": inspectionDate,
    "outbreaks_foreignkey": outbreaksForeignkey,
    "farmboundary": jsonDecode(const Utf8Decoder().convert(farmboundary ?? [])),
    /*"farm_location": farmLocation,*/
    "farmer_name": farmerName,
    "farmer_age": farmerAge,
    "id_type": idType,
    "id_number": idNumber,
    "farmer_contact": farmerContact,
    "cocoa_type": cocoaType,
    "age_class": ageClass,
    "farm_area": farmArea,
    "communitytbl_foreignkey": communitytblForeignkey,
    "status": status,
  };
}
