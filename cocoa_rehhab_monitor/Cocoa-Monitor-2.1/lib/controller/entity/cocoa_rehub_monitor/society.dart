// To parse this JSON data, do
//
//     final regionDistrict = regionDistrictFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Society socieryFromJson(String str) => Society.fromJson(json.decode(str));

String socieryToJson(Society data) => json.encode(data.toJson());

@entity
class Society {
  Society({
    this.id,
    this.societyCode,
    this.societyName,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int? societyCode;
  
  final String? societyName;

  factory Society.fromJson(Map<String, dynamic> json) => Society(
    societyCode: json["societ_code"],
    societyName: json["society"]
  );

  Map<String, dynamic> toJson() => {
    "societ_code": societyCode,
    "society": societyName,
  };
}
