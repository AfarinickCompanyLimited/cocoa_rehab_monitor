// To parse this JSON data, do
//
//     final cmUser = cmUserFromJson(jsonString);

import 'dart:convert';

CmUser cmUserFromJson(String str) => CmUser.fromJson(json.decode(str));

String cmUserToJson(CmUser data) => json.encode(data.toJson());

class CmUser {
  CmUser({
    this.firstName,
    this.lastName,
    this.userId,
    this.group,
    this.staffId,
    this.sector,
    this.district
  });

  String? firstName;
  String? lastName;
  String? userId;
  String? group;
  String? staffId;
  String? sector;
  int? district;


  factory CmUser.fromJson(Map<String, dynamic> json) => CmUser(
    firstName: json["first_name"],
    lastName: json["last_name"],
    userId: json["user_id"],
    group: json["group"],
    staffId: json["staff_id"],
    sector: json["sector"],
    district: json["district"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "user_id": userId,
    "group": group,
    "staff_id": staffId,
    "sector": sector,
    "district": district,
  };
}
