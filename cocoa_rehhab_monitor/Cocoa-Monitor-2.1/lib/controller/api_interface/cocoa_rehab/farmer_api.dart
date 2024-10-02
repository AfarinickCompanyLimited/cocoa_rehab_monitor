// // import 'dart:convert';
// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:dio/adapter.dart';
// import 'package:dio/dio.dart';
// import 'package:cocoa_master/controller/entity/farm.dart';
// import 'package:cocoa_master/controller/entity/farmer.dart';
// import 'package:cocoa_master/view/utils/constants.dart';
// import 'package:get/get.dart';
// // import 'package:get/get.dart';

// import '../../view/utils/connection_verify.dart';
// import '../global_controller.dart';

// class FarmerApiInterface {
//   GlobalController indexController = Get.find();

// // ===================================================================================
// // START ADD FARM
// // ===================================================================================
//   saveFarm(Farm farm, data) async {
//     final farmDao = indexController.database!.farmDao;
//     Dio? dio = Dio();
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient dioClient) {
//       dioClient.badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//       return dioClient;
//     };

//     if (await ConnectionVerify.connectionIsAvailable()) {
//       try {
//         var response =
//             await dio.post(URLs.baseUrl + URLs.saveFarm, data: data);
//         if (response.data['status'] == RequestStatus.True) {
//           farmDao.insertFarm(farm);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg']
//           };
//         } else if (response.data['status'] == RequestStatus.Exist) {
//           farmDao.updateFarmSubmissionStatusByUID(
//               SubmissionStatus.submitted, farm.uid!);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         } else {
//           // personnel.status = SubmissionStatus.pending;
//           // personnelDao.insertPersonnel(personnel);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         }
//       } catch (e) {
//         // personnel.status = SubmissionStatus.pending;
//         // personnelDao.insertPersonnel(personnel);
//         return {
//           'status': RequestStatus.False,
//           'connectionAvailable': true,
//           'msg':
//               'There was an error submitting your request. Kindly contact your supervisor',
//         };
//       }
//     } else {
//       farm.status = SubmissionStatus.pending;
//       farmDao.insertFarm(farm);
//       return {
//         'status': RequestStatus.NoInternet,
//         'connectionAvailable': false,
//         'msg': 'Data saved locally. Sync when you have internet connection',
//       };
//     }
//   }
// // ===================================================================================
// // END ADD FARM
// // ===================================================================================

// // ===================================================================================
// // START UPDATE FARM
// // ===================================================================================
//   updateFarm(Farm farm) async {
//     final farmDao = indexController.database!.farmDao;
//     Dio? dio = Dio();
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient dioClient) {
//       dioClient.badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//       return dioClient;
//     };

//     if (await ConnectionVerify.connectionIsAvailable()) {
//       try {
//         var response = await dio.post(URLs.baseUrl + URLs.saveFarm,
//             data: farm.toJson(),
//             options: Options(
//                 // headers: {
//                 //   "Connection": "Keep-Alive",
//                 //   "Keep-Alive": "timeout=5, max=1000"
//                 // }
//                 ));
//         if (response.data['status'] == RequestStatus.True) {
//           farmDao.updateFarm(farm);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg']
//           };
//         } else if (response.data['status'] == RequestStatus.Exist) {
//           farmDao.updateFarmSubmissionStatusByUID(
//               SubmissionStatus.submitted, farm.uid!);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         } else {
//           // personnel.status = SubmissionStatus.pending;
//           // personnelDao.insertPersonnel(personnel);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         }
//       } catch (e) {
//         // personnel.status = SubmissionStatus.pending;
//         // personnelDao.insertPersonnel(personnel);
//         return {
//           'status': RequestStatus.False,
//           'connectionAvailable': true,
//           'msg':
//               'There was an error submitting your request. Kindly contact your supervisor',
//         };
//       }
//     } else {
//       farm.status = SubmissionStatus.pending;
//       farmDao.updateFarm(farm);
//       return {
//         'status': RequestStatus.NoInternet,
//         'connectionAvailable': false,
//         'msg': 'Data saved locally. Sync when you have internet connection',
//       };
//     }
//   }
// // ===================================================================================
// // END UPDATE FARM
// // ===================================================================================

// // ===================================================================================
// // START SYNC FARM
// // ===================================================================================
//   syncFarm() async {
//     final farmDao = indexController.database!.farmDao;
//     List<Farm> records =
//         await farmDao.findFarmByStatus(SubmissionStatus.pending);
//     if (records.isNotEmpty) {
//       await Future.forEach(records, (Farm item) async {
//         item.status = SubmissionStatus.submitted;
//         // Map<String, dynamic> data = item.toJson();
//         // data.remove('ras');
//         // data.remove('staff_contact');
//         // data.remove('main_activity');
//         // data["rehab_assistants"] = jsonDecode(item.ras.toString());
//         // data["fuel_oil"] = jsonDecode(item.fuelOil.toString());
//         await updateFarm(item);
//       });
//     }
//   }
// // ===================================================================================
// // END SYNC FARM
// // ===================================================================================

// // ===================================================================================
// // START ADD FARMER
// // ===================================================================================
//   saveFarmer(Farmer farmer, data) async {
//     // print(data);
//     print('DATADATADATA ;;; $data');

//     final farmerDao = indexController.database!.farmerDao;
//     Dio? dio = Dio();
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient dioClient) {
//       dioClient.badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//       return dioClient;
//     };

//     if (await ConnectionVerify.connectionIsAvailable()) {
//       try {
//         var response =
//             await dio.post(URLs.baseUrl + URLs.saveFarmer, data: data);
//         if (response.data['status'] == RequestStatus.True) {
//           farmerDao.insertFarmer(farmer);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg']
//           };
//         } else if (response.data['status'] == RequestStatus.Exist) {
//           farmerDao.updateFarmerSubmissionStatusByUID(
//               SubmissionStatus.submitted, farmer.uid!);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         } else {
//           // personnel.status = SubmissionStatus.pending;
//           // personnelDao.insertPersonnel(personnel);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         }
//       } catch (e) {
//         print(e);
//         // personnel.status = SubmissionStatus.pending;
//         // personnelDao.insertPersonnel(personnel);
//         return {
//           'status': RequestStatus.False,
//           'connectionAvailable': true,
//           'msg':
//               'There was an error submitting your request. Kindly contact your supervisor',
//         };
//       }
//     } else {
//       farmer.status = SubmissionStatus.pending;
//       farmerDao.insertFarmer(farmer);
//       return {
//         'status': RequestStatus.NoInternet,
//         'connectionAvailable': false,
//         'msg': 'Data saved locally. Sync when you have internet connection',
//       };
//     }
//   }
// // ===================================================================================
// // END ADD FARMER
// // ===================================================================================

// // ===================================================================================
// // START UPDATE FARMER
// // ===================================================================================
//   updateFarmer(Farmer farmer) async {
//     final farmerDao = indexController.database!.farmerDao;

//     Dio? dio = Dio();
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient dioClient) {
//       dioClient.badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//       return dioClient;
//     };

//     if (await ConnectionVerify.connectionIsAvailable()) {
//       try {
//         var response = await dio.post(URLs.baseUrl + URLs.saveFarmer,
//             data: farmer.toJson(),
//             options: Options(
//                 // headers: {
//                 //   "Connection": "Keep-Alive",
//                 //   "Keep-Alive": "timeout=5, max=1000"
//                 // }
//                 ));
//         if (response.data['status'] == RequestStatus.True) {
//           farmerDao.insertFarmer(farmer);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg']
//           };
//         } else if (response.data['status'] == RequestStatus.Exist) {
//           farmerDao.updateFarmerSubmissionStatusByUID(
//               SubmissionStatus.submitted, farmer.uid!);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         } else {
//           // personnel.status = SubmissionStatus.pending;
//           // personnelDao.insertPersonnel(personnel);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         }
//       } catch (e) {
//         // personnel.status = SubmissionStatus.pending;
//         // personnelDao.insertPersonnel(personnel);
//         return {
//           'status': RequestStatus.False,
//           'connectionAvailable': true,
//           'msg':
//               'There was an error submitting your request. Kindly contact your supervisor',
//         };
//       }
//     } else {
//       farmer.status = SubmissionStatus.pending;
//       farmerDao.insertFarmer(farmer);
//       return {
//         'status': RequestStatus.NoInternet,
//         'connectionAvailable': false,
//         'msg': 'Data saved locally. Sync when you have internet connection',
//       };
//     }
//   }
// // ===================================================================================
// // END UPDATE FARMER
// // ===================================================================================

// // ===================================================================================
// // START SYNC FARMER
// // ===================================================================================
//   syncFarmer() async {
//     final farmerDao = indexController.database!.farmerDao;

//     List<Farmer> records =
//         await farmerDao.findFarmerByStatus(SubmissionStatus.pending);
//     if (records.isNotEmpty) {
//       await Future.forEach(records, (Farmer item) async {
//         item.status = SubmissionStatus.submitted;

//         await updateFarmer(item);
//       });
//     }
//   }
// // ===================================================================================
// // END SYNC FARMER
// // ===================================================================================
// }
