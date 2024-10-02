import 'dart:convert';

LoadedIssue reportFromJson(String str) =>
    LoadedIssue.fromJson(json.decode(str));

class LoadedIssue {
  factory LoadedIssue.fromJson(Map<String, dynamic> json) {
    return LoadedIssue(
      title: json['title'],
      feedback: json['feedback'],
      sentDate: json['sent_date'],
      uid: json['uid'],
      status: json['Status'],
      raID: json['ra_id'],
      farmReference: json['farm_reference'],
      activity: json['activity'],
      week: json['week'],
      month: json['month'],
    );
  }
  LoadedIssue({
    required this.title,
    required this.feedback,
    required this.sentDate,
    required this.uid,
    required this.status,
    required this.raID,
    required this.farmReference,
    required this.activity,
    required this.week,
    required this.month,
  });
  final String? title;
  final String? raID;
  final String? feedback;
  final String? sentDate;
  final String? uid;

  final String? farmReference;

  final String? activity;
  final String? status;

  final String? week;
  final String? month;
}
