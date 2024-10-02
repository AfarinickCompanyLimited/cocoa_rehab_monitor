// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      print('PERMISSION NOT YET GRANTED');
      await Permission.storage.request();
    }
    print('PERMISSION SEEMS TO HAVE BEEN GRANTED');

    Directory newDirectory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      newDirectory = Directory("/storage/emulated/0/Download");
    } else {
      newDirectory = await getApplicationDocumentsDirectory();
    }

    final exPath = newDirectory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> saveExcelFile(List<int> bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsBytes(bytes);
  }
}
