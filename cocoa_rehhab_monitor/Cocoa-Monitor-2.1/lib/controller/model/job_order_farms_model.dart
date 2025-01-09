import 'dart:convert';

JobOrderFarmModel jobOrderFarmFromJson(String str) => JobOrderFarmModel.fromJson(json.decode(str));

String jobOrderFarmToJson(JobOrderFarmModel data) => json.encode(data.toJson());

class JobOrderFarmModel {
  final int? farmCode;
  final String? farmId;
  final String? farmerName;
  final int? districtId;
  final String? districtName;
  final String? regionId;
  final String? regionName;
  final String? location;
  final double? farmSize;
  final int? sector;
  final int? e1;
  final int? e2;
  final int? e3;
  final int? e4;
  final int? e6;
  final int? e7;
  final int? m3;
  final int? r1;
  final int? r2;
  final int? r4;
  final int? t1;
  final int? t2;
  final int? t5;
  final int? t7;

  JobOrderFarmModel({
    this.location, this.farmSize,
    this.farmCode,
    this.farmId,
    this.farmerName,
    this.districtId,
    this.districtName,
    this.regionId,
    this.regionName,
    this.sector,
    this.e1,
    this.e2,
    this.e3,
    this.e4,
    this.e6,
    this.e7,
    this.m3,
    this.r1,
    this.r2,
    this.r4,
    this.t1,
    this.t2,
    this.t5,
    this.t7,
  });

  // Factory method to create a Farm object from JSON
  factory JobOrderFarmModel.fromJson(Map<String, dynamic> json) {
    return JobOrderFarmModel(
      farmCode: json['farm_code'],
      farmId: json['farm_id'],
      farmerName: json['farmer_nam'],
      districtId: json['district_id'],
      districtName: json['district_name'],
      regionId: json['region_id'],
      regionName: json['region_name'],
      location: json['location'],
      farmSize: json['farm_size'],
      sector: json['sector'],
      e1: json['E1'],
      e2: json['E2'],
      e3: json['E3'],
      e4: json['E4'],
      e6: json['E6'],
      e7: json['E7'],
      m3: json['M3'],
      r1: json['R1'],
      r2: json['R2'],
      r4: json['R4'],
      t1: json['T1'],
      t2: json['T2'],
      t5: json['T5'],
      t7: json['T7'],
    );
  }

  // Method to convert a Farm object to JSON
  Map<String, dynamic> toJson() {
    return {
      'farm_code': farmCode,
      'farm_id': farmId,
      'farmer_nam': farmerName,
      'district_id': districtId,
      'district_name': districtName,
      'region_id': regionId,
      'region_name': regionName,
      'sector': sector,
      'location': location,
      'farm_size': farmSize,
      'E1': e1,
      'E2': e2,
      'E3': e3,
      'E4': e4,
      'E6': e6,
      'E7': e7,
      'M3': m3,
      'R1': r1,
      'R2': r2,
      'R4': r4,
      'T1': t1,
      'T2': t2,
      'T5': t5,
      'T7': t7,
    };
  }
}


