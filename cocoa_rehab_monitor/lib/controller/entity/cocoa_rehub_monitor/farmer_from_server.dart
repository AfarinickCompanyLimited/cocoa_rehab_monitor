// To parse this JSON data, do
//
//     final rehabAssistant = rehabAssistantFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

FarmerFromServer farmerFromServerFromJson(String str) =>
    FarmerFromServer.fromJson(json.decode(str));

String farmerFromServerToJson(FarmerFromServer data) =>
    json.encode(data.toJson());

@entity
class FarmerFromServer {
  FarmerFromServer({
    this.id,
    this.farmerName,
    this.farmerId,
    this.farmerCode,
    this.phoneNumber,
    this.societyName,
    this.nationalIdNumber,
    this.numberOfCocoaFarms,
    this.numberOfCertifiedCrops,
    this.cocoaBagsHarvestedPreviousYear,
    this.cocoaBagsSoldToGroup,
    this.currentYearYieldEstimate,
  });

  @PrimaryKey(autoGenerate: true)
  final int? id;

  String? farmerName;
  int? farmerId;
  String? farmerCode;
  String? phoneNumber;

  String? societyName;
  String? nationalIdNumber;
  int? numberOfCocoaFarms;
  int? numberOfCertifiedCrops;
  int? cocoaBagsHarvestedPreviousYear;
  int? cocoaBagsSoldToGroup;
  int? currentYearYieldEstimate;

  // String? idType;
  // String? idNumber;
  // String? districtName;

  factory FarmerFromServer.fromJson(Map<String, dynamic> json) =>
      FarmerFromServer(
        farmerName: json["farmer_name"],
        farmerId: json["farmerid"],
        farmerCode: json["farmer_code"],
        phoneNumber: json["phone_number"],
        societyName: json["society_name"],
        nationalIdNumber: json["national_id_no"],
        numberOfCocoaFarms: json["no_of_cocoa_farms"],
        numberOfCertifiedCrops: json["no_of_certified_crop"],
        cocoaBagsHarvestedPreviousYear:
            json["total_cocoa_bags_harvested_previous_year"],
        cocoaBagsSoldToGroup: json["total_cocoa_bags_sold_group_previous_year"],
        currentYearYieldEstimate: json["current_year_yeild_estimate"],
      );

  Map<String, dynamic> toJson() => {
        "farmer_name": farmerName,
        "farmerid": farmerId,
        "farmer_code": farmerCode,
        "phone_number": phoneNumber,
        "society_name": societyName,
        "national_id_no": nationalIdNumber,
        "no_of_cocoa_farms": numberOfCocoaFarms,
        "no_of_certified_crop": numberOfCertifiedCrops,
        "total_cocoa_bags_harvested_previous_year":
            cocoaBagsHarvestedPreviousYear,
        "total_cocoa_bags_sold_group_previous_year": cocoaBagsSoldToGroup,
        "current_year_yeild_estimate": currentYearYieldEstimate,
      };
}
