// To parse this JSON data, do
//
//     final calculatedArea = calculatedAreaFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

CalculatedArea calculatedAreaFromJson(String str) => CalculatedArea.fromJson(json.decode(str));

String calculatedAreaToJson(CalculatedArea data) => json.encode(data.toJson());

@entity
class CalculatedArea {
  CalculatedArea({
    this.id,
    required this.date,
    required this.title,
    required this.value,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  DateTime date;
  String title;
  String value;

  factory CalculatedArea.fromJson(Map<String, dynamic> json) => CalculatedArea(
    date: json["date"],
    title: json["title"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "title": title,
    "value": value,
  };
}
