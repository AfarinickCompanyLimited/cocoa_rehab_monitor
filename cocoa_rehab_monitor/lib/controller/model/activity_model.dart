// To parse this JSON data, do
//
//     final activity = activityFromJson(jsonString);

import 'dart:convert';

ActivityModel activityFromJsonM(String str) => ActivityModel.fromJson(json.decode(str));

String activityToJsonM(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  ActivityModel({
    this.code,
    this.mainActivity,
    this.subActivity,
    //this.requiredEquipment,
  });

  int? code;
  String? mainActivity;
  String? subActivity;
  //int? requiredEquipment;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    code: json["code"],
    mainActivity: json["main_activity"],
    subActivity: json["sub_activity"],
    // requiredEquipment: json["required_equipment"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "main_activity": mainActivity,
    "sub_activity": subActivity,
   // "required_equipment": requiredEquipment,
  };
}
