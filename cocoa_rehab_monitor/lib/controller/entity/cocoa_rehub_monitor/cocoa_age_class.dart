import 'dart:convert';

import 'package:floor/floor.dart';

CocoaAgeClass cocoaAgeClassFromJson(String str) => CocoaAgeClass.fromJson(json.decode(str));

String cocoaAgeClassToJson(CocoaAgeClass data) => json.encode(data.toJson());

@entity
class CocoaAgeClass {
  CocoaAgeClass({
    this.id,
    this.name,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  String? name;

  factory CocoaAgeClass.fromJson(Map<String, dynamic> json) => CocoaAgeClass(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
