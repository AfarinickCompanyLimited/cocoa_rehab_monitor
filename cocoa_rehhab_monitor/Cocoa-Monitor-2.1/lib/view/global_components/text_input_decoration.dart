
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

var inputBorder =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 0, color: AppColor.lightText)
);

var inputBorderFocused =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: AppColor.primary)
);

var inputBorderError =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: AppColor.primary)
);
