// To parse this JSON data, do
//
//     final contractor = rehabAssistantFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Contractor contractorFromJson(String str) =>
    Contractor.fromJson(json.decode(str));

String contractorToJson(Contractor data) => json.encode(data.toJson());

@entity
class Contractor {
  Contractor({
    this.id,
    
    this.contractorName,
    
    this.contractorId,
    
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

 
  String? contractorName;
 
  int? contractorId;
 

  factory Contractor.fromJson(Map<String, dynamic> json) => Contractor(
       
        contractorName: json["name"],
        contractorId: json["id"],
       
      );

  Map<String, dynamic> toJson() => {
      
        "name": contractorName,
        "id": contractorId,
       
      };
}

