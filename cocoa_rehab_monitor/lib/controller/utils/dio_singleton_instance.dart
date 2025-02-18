import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioSingleton {
  static Dio? _instance;

  // Private constructor to prevent external instantiation
  DioSingleton._();

  static Dio get instance {
    if (_instance == null) {
      _instance = Dio();
      (_instance!.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient dioClient) {
        dioClient.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };
    }
    return _instance!;
  }
}
