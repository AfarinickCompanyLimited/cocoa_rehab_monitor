// import 'dart:convert';
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/map_farm.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/controller/utils/connection_verify.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';

class MapFarmsApiInterface {
  GlobalController indexController = Get.find();

// ===================================================================================
// START MAP FARM
// ===================================================================================
  mapFarm(MapFarm farm, data) async {
    final mapFarmDao = indexController.database!.mapFarmDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.mapFarm, data: data);
        if (response.data['status'] == RequestStatus.True) {
          mapFarmDao.insertMapFarm(farm);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          mapFarmDao.updateMapFarmSubmissionStatusByUID(
              SubmissionStatus.submitted, farm.uid!);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        } else {
          // personnel.status = SubmissionStatus.pending;
          // personnelDao.insertPersonnel(personnel);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        }
      } catch (e) {
        // personnel.status = SubmissionStatus.pending;
        // personnelDao.insertPersonnel(personnel);

        debugPrint('Error here ${e.toString()}');

        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      farm.status = SubmissionStatus.pending;
      mapFarmDao.insertMapFarm(farm);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END MAP FARM
// ===================================================================================

// ===================================================================================
// START UPDATE FARM
// ===================================================================================
  updateFarm(MapFarm farm) async {
    final mapFarmDao = indexController.database!.mapFarmDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.mapFarm,
            data: farm.toJson(),
            options: Options(
                // headers: {
                //   "Connection": "Keep-Alive",
                //   "Keep-Alive": "timeout=5, max=1000"
                // }
                ));
        if (response.data['status'] == RequestStatus.True) {
          mapFarmDao.updateMapFarm(farm);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          mapFarmDao.updateMapFarmSubmissionStatusByUID(
              SubmissionStatus.submitted, farm.uid!);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        } else {
          // personnel.status = SubmissionStatus.pending;
          // personnelDao.insertPersonnel(personnel);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        }
      } catch (e) {
        // personnel.status = SubmissionStatus.pending;
        // personnelDao.insertPersonnel(personnel);
        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      farm.status = SubmissionStatus.pending;
      mapFarmDao.updateMapFarm(farm);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE FARM
// ===================================================================================

// ===================================================================================
// START SYNC FARM
// ===================================================================================
  syncFarm() async {
    final mapFarmDao = indexController.database!.mapFarmDao;
    List<MapFarm> records =
        await mapFarmDao.findMapFarmByStatus(SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records, (MapFarm item) async {
        item.status = SubmissionStatus.submitted;
        // Map<String, dynamic> data = item.toJson();
        // data.remove('ras');
        // data.remove('staff_contact');
        // data.remove('main_activity');
        // data["rehab_assistants"] = jsonDecode(item.ras.toString());
        // data["fuel_oil"] = jsonDecode(item.fuelOil.toString());
        await updateFarm(item);
      });
    }
  }
// ===================================================================================
// END SYNC FARM
// ===================================================================================

// // ===================================================================================
// // START MAP FARMER
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
// // END MAP FARMER
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
// ===================================================================================
// END SYNC FARMER
// ===================================================================================
}
