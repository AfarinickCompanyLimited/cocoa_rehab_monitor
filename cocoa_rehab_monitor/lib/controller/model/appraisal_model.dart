

import 'dart:convert';

AppraisalModel appraisalFromJson(String str) => AppraisalModel.fromJson(json.decode(str));

String appraisalToJson(AppraisalModel data) => json.encode(data.toJson());


class AppraisalModel {
  int? id;
  String? employeeID;
  List<Map<String, dynamic>>? competency=[];
  String? areas_for_improvement;
  String? comment;

  AppraisalModel({
    this.id,
    this.employeeID,
    this.competency,
    this.areas_for_improvement,
    this.comment
  });


  factory AppraisalModel.fromJson(Map<String, dynamic> json) {
    return AppraisalModel(
      id: json['id'],
      employeeID: json['employee_id'],
      competency: json['competency'],
      areas_for_improvement: json['areas_for_improvement'],
      comment: json['comment']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeID,
      'competency': competency,
      'areas_for_improvement': areas_for_improvement,
      'comment': comment
    };
  }
}