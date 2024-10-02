import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

// var dioClient = (){
//   Dio? dio = Dio();
//   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//       (HttpClient dioClient) {
//     dioClient.badCertificateCallback =
//     ((X509Certificate cert, String host, int port) => true);
//     return dioClient;
//   };
// };

HttpClient dioClient() {
  Dio? dio = Dio();
  HttpClient httpClient = HttpClient();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient dioClient) {
    dioClient.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    httpClient = dioClient;
    return null;
  };
  return httpClient;
}
