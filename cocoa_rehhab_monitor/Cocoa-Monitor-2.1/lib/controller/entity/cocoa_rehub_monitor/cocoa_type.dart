import 'dart:convert';

import 'package:floor/floor.dart';

CocoaType cocoaTypeFromJson(String str) => CocoaType.fromJson(json.decode(str));

String cocoaTypeToJson(CocoaType data) => json.encode(data.toJson());

@entity
class CocoaType {
  CocoaType({
    this.id,
    this.name,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;
  String? name;

  factory CocoaType.fromJson(Map<String, dynamic> json) => CocoaType(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
