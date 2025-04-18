import 'package:cocoa_rehab_monitor/view/utils/double_value_trimmer.dart';

String bytesToSize(int bytes) {
  late String size;
  if (bytes >= 1000000000) {
    size = "${(bytes / (1024*1024*1024)).truncateToDecimalPlaces(2).toString()} GB";
  }else if (bytes >= 1000000){
    size = "${(bytes / (1024*1024)).truncateToDecimalPlaces(2).toString()} MB";
    // return "${(bytes / 1000).toString()} MB";
  }else if (bytes < 1000000){
    size = "${(bytes / (1024)).truncateToDecimalPlaces(2).toString()} KB";
  }

  return size;

}
