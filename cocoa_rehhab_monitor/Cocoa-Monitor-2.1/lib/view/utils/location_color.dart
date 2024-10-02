import 'package:flutter/material.dart';

Color locationAccuracyColor(double? accuracy) {
    if (accuracy == null) {
      return Colors.red;
    } else if (accuracy <= 10) {
      return Colors.green;
    } else if (accuracy <= 15) {
      return Colors.amber;
    } else if (accuracy > 15) {
      return Colors.red;
    }
    return Colors.grey;
  }