// To parse this JSON data, do
//
//     final activity = activityFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Activity activityFromJson(String str) => Activity.fromJson(json.decode(str));

String activityToJson(Activity data) => json.encode(data.toJson());

@entity
class Activity {
  Activity({
    this.code,
    this.mainActivity,
    this.subActivity,
    this.requiredEquipment,
  });

  @primaryKey
  int? code;
  String? mainActivity;
  String? subActivity;
  bool? requiredEquipment;

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    code: json["code"],
    mainActivity: json["main_activity"],
    subActivity: json["sub_activity"],
    requiredEquipment: json["required_equipment"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "main_activity": mainActivity,
    "sub_activity": subActivity,
    "required_equipment": requiredEquipment,
  };
}
