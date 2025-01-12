import 'dart:convert';

InitialTreatmentMonitorModel monitorRecordFromJson(String str) =>
    InitialTreatmentMonitorModel.fromJson(json.decode(str));

String monitorRecordToJson(InitialTreatmentMonitorModel data) =>
    json.encode(data.toJson());

class InitialTreatmentMonitorModel {
  InitialTreatmentMonitorModel({
    this.uid,
    this.agent,
    this.activity,
    this.mainActivity,
    this.completionDate,
    this.reportingDate,
    this.noRehabAssistants,
    this.areaCoveredHa,
    this.remark,
    this.ras,
    this.status,
    this.farmRefNumber,
    this.farmSizeHa,
    this.community,
    this.numberOfPeopleInGroup,
    this.groupWork,
    this.sector,
  });

  String? uid;
  String? agent;
  int? activity;
  int? mainActivity;
  String? completionDate;
  String? reportingDate;
  int? noRehabAssistants;
  double? areaCoveredHa;
  String? remark;
  String? ras;
  int? status;
  String? farmRefNumber;
  double? farmSizeHa;
  String? community;
  int? numberOfPeopleInGroup;
  String? groupWork;
  int? sector;

  factory InitialTreatmentMonitorModel.fromJson(Map<String, dynamic> json) =>
      InitialTreatmentMonitorModel(
        uid: json["uid"],
        agent: json["agent"],
        activity: json["activity"],
        completionDate: json["monitoring_date"],
        reportingDate: json["reporting_date"],
        noRehabAssistants: json["no_rehab_assistants"],
        areaCoveredHa: json["area_covered_ha"].toDouble(),
        remark: json["remark"],
        ras: jsonEncode(List<Ra>.from(json["ras"].map((x) => Ra.fromJson(x)))),
        status: json["submission_status"],
        farmRefNumber: json["farm_ref_number"],
        farmSizeHa: json["farm_size_ha"],
        community: json["community"],
        numberOfPeopleInGroup: json["number_of_people_in_group"],
        groupWork: json["groupWork"],
        sector: json["sector"],
      );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "agent": agent,
    "main_activity": activity,
    "monitoring_date": completionDate,
    "reporting_date": reportingDate,
    "no_rehab_assistants": noRehabAssistants,
    "area_covered_ha": areaCoveredHa,
    "remark": remark,
    "ras": ras,
    "submission_status": status,
    "farm_ref_number": farmRefNumber,
    "farm_size_ha": farmSizeHa,
    "community": community,
    "number_of_people_in_group": numberOfPeopleInGroup,
    "groupWork": groupWork,
    "sector": sector,

  };

}

class Ra {
  Ra({
    this.rehabAsistant,
    this.areaCoveredHa,
  });

  int? rehabAsistant;
  double? areaCoveredHa;

  factory Ra.fromJson(Map<String, dynamic> json) => Ra(
    rehabAsistant: json["rehab_asistant"],
    areaCoveredHa: json["area_covered_ha"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "rehab_asistant": rehabAsistant,
    "area_covered_ha": areaCoveredHa,
  };
}
