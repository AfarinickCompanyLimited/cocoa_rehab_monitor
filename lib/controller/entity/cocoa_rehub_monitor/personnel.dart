// To parse this JSON data, do
//
//     final personnel = personnelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:floor/floor.dart';

Personnel personnelFromJson(String str) => Personnel.fromJson(json.decode(str));

String personnelToJson(Personnel data) => json.encode(data.toJson());

@entity
class Personnel {
  Personnel({
    this.uid,
    this.agent,
    this.submissionDate,
    this.lat,
    this.lng,
    this.accuracy,
    // this.email,
    this.designation,
    this.name,
    // this.lastName,
    // this.middleName,
    this.gender,
    this.dob,
    this.contact,
    this.region,
    this.district,
    // this.operationalArea,
    // this.nationalIdType,
    // this.nationalIdNumber,
    this.ssnitNumber,
    this.salaryBankName,
    this.bankBranch,
    this.bankAccountNumber,
    // this.bankAccountName,
    // this.maritalStatus,
    // this.highestLevelEducation,
    this.paymentOption,
    // this.momoNumber,
    // this.cocoaBoardFarmHand,
    // this.communityRespondent,
    // this.activity,
    this.photoStaff,
    // this.photoId,
    // this.photoSsnitCard,
    this.status,
    this.isOwnerOfMomo,
    this.momoAccountName,
    this.momoNumber,
  });

  @primaryKey
  String? uid;
  String? agent;
  String? submissionDate;
  double? lat;
  double? lng;
  double? accuracy;
  // String? email;
  String? designation;
  String? name;
  // String? lastName;
  // String? middleName;
  String? gender;
  String? dob;
  String? contact;
  String? region;
  int? district;
  // String? operationalArea;
  // String? nationalIdType;
  // String? nationalIdNumber;
  String? ssnitNumber;
  String? salaryBankName;
  String? bankBranch;
  String? bankAccountNumber;
  // String? bankAccountName;
  // String? maritalStatus;
  // String? highestLevelEducation;
  String? paymentOption;
  // String? momoNumber;
  // String? cocoaBoardFarmHand;
  // String? communityRespondent;
  // String? activity;
  // String? photoStaff;
  // String? photoId;
  // String? photoSsnitCard;
  Uint8List? photoStaff;
  // Uint8List? photoId;
  // Uint8List? photoSsnitCard;
  int? status;
  String? isOwnerOfMomo;
  String? momoAccountName;
  String? momoNumber;

  factory Personnel.fromJson(Map<String, dynamic> json) => Personnel(
        uid: json["uid"],
        agent: json["agent"],
        submissionDate: json["submission_date"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        accuracy: json["accuracy"].toDouble(),
        // email: json["email"],
        designation: json["designation"],
        name: json["name"],
        // lastName: json["last_name"],
        // middleName: json["middle_name"],
        gender: json["gender"],
        dob: json["dob"],
        contact: json["contact"],
        region: json["region"],
        district: json["district"],
        // operationalArea: json["operational_area"],
        // nationalIdType: json["national_id_type"],
        // nationalIdNumber: json["national_id_number"],
        ssnitNumber: json["ssnit_number"],
        salaryBankName: json["salary_bank_name"],
        bankBranch: json["bank_branch"],
        bankAccountNumber: json["bank_account_number"],
        // bankAccountName: json["bank_account_name"],
        // maritalStatus: json["marital_status"],
        // highestLevelEducation: json["highest_level_education"],
        paymentOption: json["payment_option"],
        // momoNumber: json["momo_number"],
        // cocoaBoardFarmHand: json["cocoa_board_farm_hand"],
        // communityRespondent: json["community_respondent"],
        // activity: json["activity"],
        photoStaff: json["photo_staff"],
        // photoId: json["photo_id"],
        // photoSsnitCard: json["photo_ssnit_card"],
        status: json["status"],
        isOwnerOfMomo: json["owner_momo"],
        momoAccountName: json["momo_account_name"],
        momoNumber: json["momo_number"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "agent": agent,
        //"submission_date": submissionDate,
        // "lat": lat,
        // "lng": lng,
        // "accuracy": accuracy,
        // "email": email,
        "designation": designation,
        "name": name,
        // "last_name": lastName,
        // "middle_name": middleName,
        "gender": gender,
        "dob": dob,
        "contact": contact,
        // "region": region,
        "district": district,
        // "operational_area": operationalArea,
        // "national_id_type": nationalIdType,
        // "national_id_number": nationalIdNumber,
        "ssnit_number": ssnitNumber,
        "salary_bank_name": salaryBankName,
        "bank_branch": bankBranch,
        "bank_account_number": bankAccountNumber,
        // "bank_account_name": bankAccountName,
        // "marital_status": maritalStatus,
        // "highest_level_education": highestLevelEducation,
        //"payment_option": paymentOption,
        // "momo_number": momoNumber,
        // "cocoa_board_farm_hand": cocoaBoardFarmHand,
        // "community_respondent": communityRespondent,
        // "activity": activity,
        // "photo_staff": photoStaff,
        "photo_staff": base64Encode(photoStaff ?? []),
        // "photo_id": photoId,
        // "photo_id": base64Encode(photoId ?? []),
        // "photo_ssnit_card": photoSsnitCard,
        // "photo_ssnit_card": base64Encode(photoSsnitCard ?? []),
        "status": status,
        // "owner_momo": isOwnerOfMomo,
        // "momo_account_name": momoAccountName,
        // "momo_number": momoNumber,
      };
}
