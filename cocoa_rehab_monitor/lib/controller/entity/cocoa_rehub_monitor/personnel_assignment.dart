// To parse this JSON data, do
//
//     final personnelAssignment = personnelAssignmentFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

PersonnelAssignment personnelAssignmentFromJson(String str) => PersonnelAssignment.fromJson(json.decode(str));

String personnelAssignmentToJson(PersonnelAssignment data) => json.encode(data.toJson());

@entity
class PersonnelAssignment {
  PersonnelAssignment({
    this.farmid,
    this.activity,
    this.rehabAssistants,
    this.rehabAssistantsObject,
    this.assignedDate,
    this.uid,
    this.blocks,
    this.agent,
    this.status
  });

  @primaryKey
  String? uid;
  String? farmid;
  int? activity;
  String? rehabAssistants;
  String? rehabAssistantsObject;
  String? assignedDate;
  String? blocks;
  int? agent;
  int? status;

  factory PersonnelAssignment.fromJson(Map<String, dynamic> json) => PersonnelAssignment(
    farmid: json["farmid"],
    activity: json["activity"],
    rehabAssistants: json["rehab_assistants"],
    rehabAssistantsObject: json["rehabAssistantsObject"],
    assignedDate: json["assigned_date"],
    uid: json["uid"],
    blocks: json["blocks"],
    agent: json["agent"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "farmid": farmid,
    "activity": activity,
    "rehab_assistants": rehabAssistants,
    "rehabAssistantsObject": rehabAssistantsObject,
    "assigned_date": assignedDate,
    "uid": uid,
    "blocks": blocks,
    "agent": agent,
    "status": status,
  };
}
