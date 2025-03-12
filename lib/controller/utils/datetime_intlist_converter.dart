import 'dart:convert';

import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

// Custom type converter for List<int>
class IntListConverter extends TypeConverter<List<int>, String> {
  @override
  List<int> decode(String databaseValue) {
    if (databaseValue.isEmpty) return [];
    final List<dynamic> jsonList = json.decode(databaseValue);
    return jsonList.cast<int>();
  }

  @override
  String encode(List<int> value) {
    return json.encode(value);
  }
}