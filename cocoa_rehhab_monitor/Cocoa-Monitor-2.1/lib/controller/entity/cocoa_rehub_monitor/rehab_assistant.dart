// To parse this JSON data, do
//
//     final rehabAssistant = rehabAssistantFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

RehabAssistant rehabAssistantFromJson(String str) =>
    RehabAssistant.fromJson(json.decode(str));

String rehabAssistantToJson(RehabAssistant data) => json.encode(data.toJson());

@entity
class RehabAssistant {
  RehabAssistant({
    this.id,
    this.rehabName,
    this.rehabCode,
    this.phoneNumber,
    this.salaryBankName,
    this.bankAccountNumber,
    this.gender,
    this.ssnitNumber,
    this.momoNumber,
    this.momoAccountName,
    this.dob,
    this.poFirstName,
    this.poLastName,
    this.districtName,
    this.districtId,
    this.image,
    this.paymentOption,
    this.designation,
    this.regionId,
    this.regionName,
    this.staffId,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  String? rehabName;
  int? rehabCode;
  String? phoneNumber;
  String? salaryBankName;
  String? bankAccountNumber;
  String? gender;
  String? ssnitNumber;
  String? momoNumber;
  String? momoAccountName;
  String? dob;
  String? poFirstName;
  String? poLastName;
  String? districtName;
  int? districtId;
  String? image;
  String? paymentOption;
  String? designation;
  String? regionId;
  String? regionName;
  String? staffId;

  factory RehabAssistant.fromJson(Map<String, dynamic> json) => RehabAssistant(
        rehabName: json["name"],
        staffId: json["staff_code"],
        phoneNumber: json["phone_number"],
        salaryBankName: json["bank_branch"],
        bankAccountNumber: json["bank_account_number"],
        gender: json['gender'],
        ssnitNumber: json["ssnit_number"],
        momoNumber: json["momo_number"],
        momoAccountName: json["momo_account_name"],
        dob: json["dob"],
        poFirstName: json["po_first_name"],
        poLastName: json["po_last_name"],
        districtName: json["district"],
        districtId: json["district_id"],
        image: json["photo_staff"] ?? "",
        paymentOption: json["payment_option"],
        designation: json["designation"],
        regionId: json["region_id"],
        regionName: json["region_name"],
        rehabCode: json["rehab_code"],
      );

  Map<String, dynamic> toJson() => {
        "name": rehabName,
        "staff_code": staffId,
        "phone_number": phoneNumber,
        "bank_branch": salaryBankName,
        "bank_account_number": bankAccountNumber,
        "gender": gender,
        "ssnit_number": ssnitNumber,
        "momo_number": momoNumber,
        "momo_account_name": momoAccountName,
        "dob": dob,
        "po_first_name": poFirstName,
        "po_last_name": poLastName,
        "district": districtName,
        "district_id": districtId,
        "photo_staff": image,
        "payment_option": paymentOption,
        "designation": designation,
        "region_id": regionId,
        "region_name": regionName,
        "rehab_code": rehabCode,
      };
}
