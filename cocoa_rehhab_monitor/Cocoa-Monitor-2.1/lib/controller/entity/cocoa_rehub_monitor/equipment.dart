// To parse this JSON data, do
//
//     final equipment = equipmentFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

Equipment equipmentFromJson(String str) => Equipment.fromJson(json.decode(str));

String equipmentToJson(Equipment data) => json.encode(data.toJson());

@entity
class Equipment {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  String? equipmentCode;
  DateTime dateOfCapturing;
  String? equipment;
  String? status;
  String? serialNumber;
  String? manufacturer;
  String? picSerialNumber;
  String? picEquipment;
  String? staffName;

  Equipment({
    this.id,
    this.equipmentCode,
    required this.dateOfCapturing,
    this.equipment,
    this.status,
    this.serialNumber,
    this.manufacturer,
    this.picSerialNumber,
    this.picEquipment,
    this.staffName,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    equipmentCode: json["equipment_code"],
    dateOfCapturing: DateTime.parse(json["date_of_capturing"]),
    equipment: json["equipment"],
    status: json["status"],
    serialNumber: json["serial_number"],
    manufacturer: json["manufacturer"],
    picSerialNumber: json["pic_serial_number"],
    picEquipment: json["pic_equipment"],
    staffName: json["staff_name"],
  );

  Map<String, dynamic> toJson() => {
    "equipment_code": equipmentCode,
    "date_of_capturing": dateOfCapturing.toIso8601String(),
    "equipment": equipment,
    "status": status,
    "serial_number": serialNumber,
    "manufacturer": manufacturer,
    "pic_serial_number": picSerialNumber,
    "pic_equipment": picEquipment,
    "staff_name": staffName,
  };
}
