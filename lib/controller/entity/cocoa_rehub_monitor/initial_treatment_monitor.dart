// To parse this JSON data, do
//
//     final monitorRecord = monitorRecordFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';
// import 'dart:typed_data';

import 'package:floor/floor.dart';

InitialTreatmentMonitor monitorRecordFromJson(String str) =>
    InitialTreatmentMonitor.fromJson(json.decode(str));

String monitorRecordToJson(InitialTreatmentMonitor data) =>
    json.encode(data.toJson());

@entity
class InitialTreatmentMonitor {
  InitialTreatmentMonitor({
    this.uid,
    this.agent,
    this.staffContact,
    // this.farmTblForeignkey,
    this.mainActivity,
    this.activity,
    this.monitoringDate,
    this.noRehabAssistants,
    // this.originalFarmSize,
    this.areaCoveredHa,
    this.remark,
    // this.jobStatus,
    this.lat,
    this.lng,
    this.accuracy,
    this.currentFarmPic,
    this.ras,
    // this.fuelOil,
    this.status,
    this.farmRefNumber,
    this.farmSizeHa,
    this.cocoaSeedlingsAlive,
    this.plantainSeedlingsAlive,
    this.nameOfChedTa,
    this.contactOfChedTa,
    this.community,
    this.operationalArea,
    this.contractorName,
    this.numberOfPeopleInGroup,
    this.groupWork,
    this.completedByContractor,
    this.areaCoveredRx,
  });

  @primaryKey
  String? uid;
  String? agent;
  String? staffContact;
  // int? farmTblForeignkey;
  int? mainActivity;
  int? activity;
  String? monitoringDate;
  int? noRehabAssistants;
  // double? originalFarmSize;
  double? areaCoveredHa;
  String? remark;
  // String? jobStatus;
  double? lat;
  double? lng;
  double? accuracy;
  // String? currentFarmPic;
  Uint8List? currentFarmPic;
  String? ras;
  // String? fuelOil;
  int? status;
  String? farmRefNumber;
  double? farmSizeHa;
  int? cocoaSeedlingsAlive;
  int? plantainSeedlingsAlive;
  String? nameOfChedTa;
  String? contactOfChedTa;
  int? community;
  // String? community;
  String? operationalArea;
  String? contractorName;
  int? numberOfPeopleInGroup;
  String? groupWork;
  String? completedByContractor;
  String? areaCoveredRx;

  factory InitialTreatmentMonitor.fromJson(Map<String, dynamic> json) =>
      InitialTreatmentMonitor(
        uid: json["uid"],
        agent: json["agent"],
        staffContact: json["staff_contact"],
        // farmTblForeignkey: json["farmTbl_foreignkey"],
        mainActivity: json["main_activity"],
        activity: json["activity"],
        monitoringDate: json["monitoring_date"],
        noRehabAssistants: json["no_rehab_assistants"],
        // originalFarmSize: json["original_farm_size"],
        areaCoveredHa: json["area_covered_ha"].toDouble(),
        remark: json["remark"],
        // jobStatus: json["status"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        accuracy: json["accuracy"],
        currentFarmPic: json["current_farm_pic"],
       // ras: jsonEncode(List<Ra>.from(json["ras"].map((x) => Ra.fromJson(x)))),
        // fuelOil: jsonEncode(FuelOil.fromJson(json["fuel_oil"])),
        status: json["submission_status"],
        farmRefNumber: json["farm_ref_number"],
        farmSizeHa: json["farm_size_ha"],
        cocoaSeedlingsAlive: json["cocoa_seedlings_alive"],
        plantainSeedlingsAlive: json["plantain_seedlings_alive"],
        nameOfChedTa: json["name_of_ched_ta"],
        contactOfChedTa: json["ched_ta_contact"],
        community: json["community"],
        operationalArea: json["operational_area"],
        contractorName: json["contractor_name"],
        numberOfPeopleInGroup: json["number_of_people_in_group"],
        groupWork: json["groupWork"],
        completedByContractor: json["completedByContractor"],
        areaCoveredRx: json["areaCoveredRx"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "agent": agent,
        "staff_contact": staffContact,
        // "farmTbl_foreignkey": farmTblForeignkey,
        "main_activity": mainActivity,
        "activity": activity,
        "monitoring_date": monitoringDate,
        "no_rehab_assistants": noRehabAssistants,
        // "original_farm_size": originalFarmSize,
        "area_covered_ha": areaCoveredHa,
        "remark": remark,
        // "status": jobStatus,
        "lat": lat,
        "lng": lng,
        "accuracy": accuracy,
        "current_farm_pic": base64Encode(currentFarmPic ?? []),
        "ras": ras,
        // "fuel_oil": fuelOil,
        "submission_status": status,
        "farm_ref_number": farmRefNumber,
        "farm_size_ha": farmSizeHa,
        "cocoa_seedlings_alive": cocoaSeedlingsAlive,
        "plantain_seedlings_alive": plantainSeedlingsAlive,
        "name_of_ched_ta": nameOfChedTa,
        "ched_ta_contact": contactOfChedTa,
        "community": community,
        "operational_area": operationalArea,
        "contractor_name": contractorName,
        "number_of_people_in_group": numberOfPeopleInGroup,
        "groupWork": groupWork,
        "completedByContractor": completedByContractor,
        "areaCoveredRx": areaCoveredRx,
      };
}

// class FuelOil {
//   FuelOil({
//     this.datePurchased,
//     this.date,
//     this.qtyPurchased,
//     this.nameOperatorReceiving,
//     this.quantityLtr,
//     this.redOilLtr,
//     this.engineOilLtr,
//     this.area,
//     this.remarks,
//   });

//   String? datePurchased;
//   String? date;
//   double? qtyPurchased;
//   String? nameOperatorReceiving;
//   double? quantityLtr;
//   double? redOilLtr;
//   double? engineOilLtr;
//   double? area;
//   String? remarks;

// factory FuelOil.fromJson(Map<String, dynamic> json) => FuelOil(
//       datePurchased: json["date_purchased"],
//       date: json["date"],
//       qtyPurchased: json["qty_purchased"],
//       nameOperatorReceiving: json["name_operator_receiving"],
//       quantityLtr: json["quantity_ltr"].toDouble(),
//       redOilLtr: json["red_oil_ltr"],
//       engineOilLtr: json["engine_oil_ltr"],
//       area: json["area"],
//       remarks: json["remarks"],
//     );

// Map<String, dynamic> toJson() => {
//       "date_purchased": datePurchased,
//       "date": date,
//       "qty_purchased": qtyPurchased,
//       "name_operator_receiving": nameOperatorReceiving,
//       "quantity_ltr": quantityLtr,
//       "red_oil_ltr": redOilLtr,
//       "engine_oil_ltr": engineOilLtr,
//       "area": area,
//       "remarks": remarks,
//     };
// }

// class Ra {
//   Ra({
//     this.rehabAsistant,
//     this.areaCoveredHa,
//   });
//
//   int? rehabAsistant;
//   double? areaCoveredHa;
//
//   factory Ra.fromJson(Map<String, dynamic> json) => Ra(
//         rehabAsistant: json["rehab_asistant"],
//         areaCoveredHa: json["area_covered_ha"].toDouble(),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "rehab_asistant": rehabAsistant,
//         "area_covered_ha": areaCoveredHa,
//       };
// }
