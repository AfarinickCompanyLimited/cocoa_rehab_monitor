// To parse this JSON data, do
//
//     final poLocation = poLocationFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

PoLocation poLocationFromJson(String str) => PoLocation.fromJson(json.decode(str));

String poLocationToJson(PoLocation data) => json.encode(data.toJson());

@entity
class PoLocation {
  PoLocation({
    this.id,
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.uid,
    required this.userid,
    required this.inspectionDate,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  double lat;
  double lng;
  int accuracy;
  String uid;
  int userid;
  DateTime inspectionDate;

  factory PoLocation.fromJson(Map<String, dynamic> json) => PoLocation(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
    accuracy: json["accuracy"],
    uid: json["uid"],
    userid: json["userid"],
    inspectionDate: json["inspection_date"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
    "accuracy": accuracy,
    "uid": uid,
    "userid": userid,
    "inspection_date": inspectionDate,
  };
}
