// To parse this JSON data, do
//
//     final notificationData = notificationDataFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

NotificationData notificationDataFromJson(String str) => NotificationData.fromJson(json.decode(str));

String notificationDataToJson(NotificationData data) => json.encode(data.toJson());

@entity
class NotificationData {
  NotificationData(
      this.id,
    this.title,
    this.message,
    this.date,
    this.read,
  );

  @primaryKey
  String id;
  String? title;
  String? message;
  final DateTime date;
  bool? read;

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    json["id"],
    json["title"],
    json["message"],
    json["date"],
    json["read"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "message": message,
    "date": date,
    "read": read,
  };
}
