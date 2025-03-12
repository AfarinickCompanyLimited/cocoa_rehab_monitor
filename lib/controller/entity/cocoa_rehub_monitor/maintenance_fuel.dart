// To parse this JSON data, do
//
//     final maintenanceFuel = maintenanceFuelFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

MaintenanceFuel maintenanceFuelFromJson(String str) => MaintenanceFuel.fromJson(json.decode(str));

String maintenanceFuelToJson(MaintenanceFuel data) => json.encode(data.toJson());

@entity
class MaintenanceFuel {
  MaintenanceFuel({
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

  factory MaintenanceFuel.fromJson(Map<String, dynamic> json) => MaintenanceFuel(
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
