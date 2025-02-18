// To parse this JSON data, do
//
//     final outbreakFarm = outbreakFarmFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:floor/floor.dart';

MapFarm farmFromJson(String str) => MapFarm.fromJson(json.decode(str));

String farmToJson(MapFarm data) => json.encode(data.toJson());

@entity
class MapFarm {
  MapFarm({
    this.uid,
    this.userid,
    this.farmboundary,
    this.farmerName,
    this.farmSize,
    this.district,
    this.region,
    this.farmerContact,
    this.farmReference,
    this.status,
  });

  @primaryKey
  String? uid;
  String? userid;
  Uint8List? farmboundary;
  String? farmerName;
  double? farmSize;
  String? district;
  String? region;
  String? farmerContact;
  String? farmReference;
  int? status;

  factory MapFarm.fromJson(Map<String, dynamic> json) => MapFarm(
        uid: json["uid"],
        userid: json["userid"],
        farmboundary: Uint8List.fromList(utf8.encode(json["farmboundary"])),
        farmerName: json["farmer_name"],
        farmSize: json["farm_size"],
        district: json["district"],
        region: json["region"],
        farmerContact: json["contact"],
        farmReference: json["farm_reference"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userid": userid,
        "farmboundary":
            jsonDecode(const Utf8Decoder().convert(farmboundary ?? [])),
        "farmer_name": farmerName,
        "farm_size": farmSize,
        "location": district,
        "region": region,
        "contact": farmerContact,
        "farm_reference": farmReference,
        "status": status,
      };
}
