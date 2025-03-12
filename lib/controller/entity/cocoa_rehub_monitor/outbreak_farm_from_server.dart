// To parse this JSON data, do
//
//     final outbreakFarmFromServer = outbreakFarmFromServerFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

OutbreakFarmFromServer outbreakFarmFromServerFromJson(String str) => OutbreakFarmFromServer.fromJson(json.decode(str));

String outbreakFarmFromServerToJson(OutbreakFarmFromServer data) => json.encode(data.toJson());

@entity
class OutbreakFarmFromServer {
  OutbreakFarmFromServer({
    this.farmId,
    this.outbreaksId,
    this.farmLocation,
    this.farmerName,
    this.farmerAge,
    this.idType,
    this.idNumber,
    this.farmerContact,
    this.cocoaType,
    this.ageClass,
    this.farmArea,
    this.communitytbl,
    this.inspectionDate,
    this.tempCode,
  });

  @primaryKey
  int? farmId;
  String? outbreaksId;
  String? farmLocation;
  String? farmerName;
  int? farmerAge;
  String? idType;
  String? idNumber;
  String? farmerContact;
  String? cocoaType;
  String? ageClass;
  double? farmArea;
  String? communitytbl;
  String? inspectionDate;
  String? tempCode;

  factory OutbreakFarmFromServer.fromJson(Map<String, dynamic> json) => OutbreakFarmFromServer(
    farmId: json["farm_id"],
    outbreaksId: json["outbreaks_id"],
    farmLocation: json["farm_location"],
    farmerName: json["farmer_name"],
    farmerAge: json["farmer_age"],
    idType: json["id_type"],
    idNumber: json["id_number"],
    farmerContact: json["farmer_contact"],
    cocoaType: json["cocoa_type"],
    ageClass: json["age_class"],
    farmArea: json["farm_area"]?.toDouble(),
    communitytbl: json["communitytbl"],
    inspectionDate: json["inspection_date"],
    tempCode: json["temp_code"],
  );

  Map<String, dynamic> toJson() => {
    "farm_id": farmId,
    "outbreaks_id": outbreaksId,
    "farm_location": farmLocation,
    "farmer_name": farmerName,
    "farmer_age": farmerAge,
    "id_type": idType,
    "id_number": idNumber,
    "farmer_contact": farmerContact,
    "cocoa_type": cocoaType,
    "age_class": ageClass,
    "farm_area": farmArea,
    "communitytbl": communitytbl,
    "inspection_date": inspectionDate,
    "temp_code": tempCode,
  };
}
