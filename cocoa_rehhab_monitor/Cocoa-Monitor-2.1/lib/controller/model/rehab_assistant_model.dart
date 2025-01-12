import 'dart:convert';

class RehabAssistantModel {
  RehabAssistantModel({
    this.rehabCode,
    this.rehabName,
    this.districtId,
    this.districtName,
    this.regionId,
    this.regionName,
    this.designation,
    this.image,
    this.staffId,
    this.phoneNumber,
    this.salaryBankName,
    this.bankAccountNumber,
    this.ssnitNumber,
    this.momoAccountName,
    this.momoNumber,
    this.paymentOption,
    this.po,
  });

  final int? rehabCode;
  final String? rehabName;
  final int? districtId;
  final String? districtName;
  final String? regionId;
  final String? regionName;
  final String? designation;
  final String? image;
  final String? staffId;
  final String? phoneNumber;
  final String? salaryBankName;
  final String? bankAccountNumber;
  final String? ssnitNumber;
  final String? momoAccountName;
  final String? momoNumber;
  final String? paymentOption;
  final String? po;

  // From JSON
  factory RehabAssistantModel.fromJson(Map<String, dynamic> json) =>
      RehabAssistantModel(
        rehabCode: json["rehab_code"],
        rehabName: json["rehab_name"],
        districtId: json["district_id"],
        districtName: json["district_name"],
        regionId: json["region_id"],
        regionName: json["region_name"],
        designation: json["designation"],
        image: json["image"],
        staffId: json["staff_id"],
        phoneNumber: json["phone_number"],
        salaryBankName: json["salary_bank_name"],
        bankAccountNumber: json["bank_account_number"],
        ssnitNumber: json["ssnit_number"],
        momoAccountName: json["momo_account_name"],
        momoNumber: json["momo_number"],
        paymentOption: json["payment_option"],
        po: json["po"],
      );

  // To JSON
  Map<String, dynamic> toJson() => {
    "rehab_code": rehabCode,
    "rehab_name": rehabName,
    "district_id": districtId,
    "district_name": districtName,
    "region_id": regionId,
    "region_name": regionName,
    "designation": designation,
    "image": image,
    "staff_id": staffId,
    "phone_number": phoneNumber,
    "salary_bank_name": salaryBankName,
    "bank_account_number": bankAccountNumber,
    "ssnit_number": ssnitNumber,
    "momo_account_name": momoAccountName,
    "momo_number": momoNumber,
    "payment_option": paymentOption,
    "po": po,
  };

  static List<RehabAssistantModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => RehabAssistantModel.fromJson(json)).toList();
}
