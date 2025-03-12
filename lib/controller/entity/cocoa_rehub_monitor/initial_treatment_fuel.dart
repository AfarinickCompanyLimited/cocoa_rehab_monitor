// To parse this JSON data, do
//
//     final initialTreatmentFuel = initialTreatmentFuelFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

InitialTreatmentFuel initialTreatmentFuelFromJson(String str) => InitialTreatmentFuel.fromJson(json.decode(str));

String initialTreatmentFuelToJson(InitialTreatmentFuel data) => json.encode(data.toJson());

@entity
class InitialTreatmentFuel {
  InitialTreatmentFuel({
    this.id,
    this.userid,
    this.farmdetailstblForeignkey,
    this.dateReceived,
    this.rehabassistantsTblForeignkey,
    this.fuelLtr,
    this.remarks,
    this.uid,
    this.status,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  int? userid;
  int? farmdetailstblForeignkey;
  String? dateReceived;
  int? rehabassistantsTblForeignkey;
  int? fuelLtr;
  String? remarks;
  String? uid;
  int? status;

  factory InitialTreatmentFuel.fromJson(Map<String, dynamic> json) => InitialTreatmentFuel(
    userid: json["userid"],
    farmdetailstblForeignkey: json["farmdetailstbl_foreignkey"],
    dateReceived: json["date_received"],
    rehabassistantsTblForeignkey: json["rehabassistantsTbl_foreignkey"],
    fuelLtr: json["fuel_ltr"],
    remarks: json["remarks"],
    uid: json["uid"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "farmdetailstbl_foreignkey": farmdetailstblForeignkey,
    "date_received": dateReceived,
    "rehabassistantsTbl_foreignkey": rehabassistantsTblForeignkey,
    "fuel_ltr": fuelLtr,
    "remarks": remarks,
    "uid": uid,
    "status": status,
  };
}

