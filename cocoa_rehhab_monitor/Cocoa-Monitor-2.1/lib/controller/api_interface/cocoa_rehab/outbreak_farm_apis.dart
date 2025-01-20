// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/db/initail_activity_db.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_fuel.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm.dart';
import 'package:cocoa_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OutbreakFarmApiInterface {
  GlobalController indexController = Get.find();

// ===================================================================================
// START ADD OUTBREAK FARM
// ===================================================================================
  saveOutbreakFarm(OutbreakFarm outbreakFarm) async {
    final outbreakFarmDao = indexController.database!.outbreakFarmDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.saveOutbreakFarm,
            data: outbreakFarm.toJson());
        if (response.data['status'] == RequestStatus.True) {
          outbreakFarmDao.insertOutbreakFarm(outbreakFarm);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          outbreakFarmDao.updateOutbreakFarmSubmissionStatusByUID(
              SubmissionStatus.submitted, outbreakFarm.uid!);
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
      } catch (e, stackTrace) {

    FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('saveOutbreakFarm');


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
      outbreakFarm.status = SubmissionStatus.pending;
      outbreakFarmDao.insertOutbreakFarm(outbreakFarm);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END ADD OUTBREAK FARM
// ===================================================================================

// ===================================================================================
// START UPDATE OUTBREAK FARM
// ===================================================================================
  updateOutbreakFarm(OutbreakFarm outbreakFarm) async {
    final outbreakFarmDao = indexController.database!.outbreakFarmDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.saveOutbreakFarm,
            data: outbreakFarm.toJson(),
            options: Options(
                // headers: {
                //   "Connection": "Keep-Alive",
                //   "Keep-Alive": "timeout=5, max=1000"
                // }
                ));
        if (response.data['status'] == RequestStatus.True) {
          outbreakFarmDao.updateOutbreakFarm(outbreakFarm);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          outbreakFarmDao.updateOutbreakFarmSubmissionStatusByUID(
              SubmissionStatus.submitted, outbreakFarm.uid!);
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
      } catch (e, stackTrace) {

    FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('updateOutbreakFarm');


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
      outbreakFarm.status = SubmissionStatus.pending;
      outbreakFarmDao.updateOutbreakFarm(outbreakFarm);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE OUTBREAK FARM
// ===================================================================================

// ===================================================================================
// START SYNC OUTBREAK FARM
// ===================================================================================
  syncOutbreakFarm() async {
    final outbreakFarmDao = indexController.database!.outbreakFarmDao;
    List<OutbreakFarm> records = await outbreakFarmDao
        .findOutbreakFarmByStatus(SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records, (OutbreakFarm item) async {
        item.status = SubmissionStatus.submitted;
        // Map<String, dynamic> data = item.toJson();
        // data.remove('ras');
        // data.remove('staff_contact');
        // data.remove('main_activity');
        // data["rehab_assistants"] = jsonDecode(item.ras.toString());
        // data["fuel_oil"] = jsonDecode(item.fuelOil.toString());
        await updateOutbreakFarm(item);
      });
    }
  }
// ===================================================================================
// END SYNC OUTBREAK FARM
// ===================================================================================

  // =========================================================================================================================
  // ========================================================================================================================

// ===================================================================================
// START ADD MONITORING
// ===================================================================================

  Future<Map<String, dynamic>> saveMonitoring(
      Map<String, dynamic> d, Map<String, dynamic> data, bool edit) async {
    final db = InitialTreatmentMonitorDatabaseHelper.instance;

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        final uri = Uri.parse(URLs.baseUrl + URLs.saveAllMonitorings);

        final response = await http.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(data),
        );


        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          //print("THE RESPONSE DATA: ${responseData}");
          if (responseData.first['status'] == RequestStatus.True) {

              await db.saveData(d);

            return {
              'status': responseData.first['status'],
              'connectionAvailable': true,
              'msg': responseData.first['msg']
            };
          } else if (responseData.first['status'] == RequestStatus.Exist) {
            return {
              'status': responseData.first['status'],
              'connectionAvailable': true,
              'msg': responseData.first['msg'],
            };
          } else {
            // print('ERROR ON1 ${responseData['status']}');
            // print('ERROR ON1B ${responseData['msg']}');

            return {
              'status': responseData.first['status'],
              'connectionAvailable': true,
              'msg': responseData.first['msg'],
            };
          }
        } else {
          final responseData = jsonDecode(response.body);
          print('HTTP ERROR: ${response.body}');
          //print('HTTP ERROR MESSAGE : ${responseData.first['msg']}');
          return {
            'status': RequestStatus.False,
            'connectionAvailable': true,
            'msg': responseData.first['msg'],
          };
        }
      } catch (e, stackTrace) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('saveMonitoring');

        print('ERROR ON SAVE INITIAL TREATMENT: $e');
        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
          'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      d["submission_status"] = SubmissionStatus.pending;
      await db.saveData(d);

      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have an internet connection',
      };
    }
  }

//   saveMonitoring(InitialTreatmentMonitorModel monitor, data) async {
// final db = InitialTreatmentMonitorDatabaseHelper.instance;
//     Dio? dio = Dio();
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient dioClient) {
//       dioClient.badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//       return dioClient;
//     };
//     if (await ConnectionVerify.connectionIsAvailable()) {
//       try {
//         // var response = await dio.post('https://dcbf-154-160-21-151.eu.ngrok.io' + URLs.saveObMonitoring, data: data);
//         var response =
//             await dio.post(URLs.baseUrl + URLs.saveAllMonitorings, data: data);
//         if (response.data['status'] == RequestStatus.True) {
//           db.saveData(monitor);
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg']
//           };
//         } else if (response.data['status'] == RequestStatus.Exist) {
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         } else {
//           // personnel.status = SubmissionStatus.pending;
//           // personnelDao.insertPersonnel(personnel);
//
//           print('ERROR ON1 ${response.data['status']}');
//           print('ERROR ON1B ${response.data['msg']}');
//
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         }
//       } catch (e, stackTrace) {
//
//     FirebaseCrashlytics.instance.recordError(e, stackTrace);
//         FirebaseCrashlytics.instance.log('saveMonitoring');
//
//
//         print('ERROR ON SAVE INITIAL TREATMENT$e');
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
//       monitor.status = SubmissionStatus.pending;
//       db.saveData(monitor);
//       return {
//         'status': RequestStatus.NoInternet,
//         'connectionAvailable': false,
//         'msg': 'Data saved locally. Sync when you have internet connection',
//       };
//     }
//   }
// ===================================================================================
// END ADD MONITORING
// ===================================================================================

// ===================================================================================
// START UPDATE MONITORING
// ===================================================================================
  updateMonitoring(InitialTreatmentMonitor monitor, data) async {
    final initialTreatmentMonitorDao =
        indexController.database!.initialTreatmentMonitorDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        // var response = await dio.post('https://dcbf-154-160-21-151.eu.ngrok.io' + URLs.saveObMonitoring, data: data,options: Options(
        var response = await dio.post(URLs.baseUrl + URLs.saveAllMonitorings,
            data: data,
            options: Options(
                // headers: {
                //   "Connection": "Keep-Alive",
                //   "Keep-Alive": "timeout=5, max=1000"
                // }
                ));
        if (response.data['status'] == RequestStatus.True) {
          initialTreatmentMonitorDao.updateInitialTreatmentMonitor(monitor);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          initialTreatmentMonitorDao
              .updateInitialTreatmentMonitorSubmissionStatusByUID(
                  SubmissionStatus.submitted, monitor.uid!);
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
      } catch (e, stackTrace) {
        print('ERROR ON UPDATE INITIAL TREATMENT ONLINE $e');

    FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('updateMonitoring');



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
      monitor.status = SubmissionStatus.pending;
      initialTreatmentMonitorDao.updateInitialTreatmentMonitor(monitor);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE MONITORING
// ===================================================================================

// ===================================================================================
// START SYNC MONITORING
// ===================================================================================

  syncMonitoring() async {
    final initialTreatmentMonitorDao =
        indexController.database!.initialTreatmentMonitorDao;
    int offset = 0;
    int limit = 20;
    bool endOfRecords = false;

    while (!endOfRecords) {
      List<InitialTreatmentMonitor> records = await initialTreatmentMonitorDao
          .findInitialTreatmentMonitorByStatusWithLimit(
              SubmissionStatus.pending, limit, offset);
      if (records.isNotEmpty) {
        await Future.forEach(records, (InitialTreatmentMonitor item) async {
          item.status = SubmissionStatus.submitted;
          Map<String, dynamic> data = item.toJson();
          data.remove('ras');
          data.remove('staff_contact');
          data.remove('main_activity');
          data.remove('submission_status');
          data["rehab_assistants"] = jsonDecode(item.ras.toString());
          // data["fuel_oil"] = jsonDecode(item.fuelOil.toString());
          await updateMonitoring(item, data);
        });
        offset += limit;
      } else {
        endOfRecords = true;
      }
    }
  }
  /*syncMonitoring() async{
    final initialTreatmentMonitorDao = indexController.database!.initialTreatmentMonitorDao;
    List<InitialTreatmentMonitor> records = await initialTreatmentMonitorDao.findInitialTreatmentMonitorByStatus(SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records, (InitialTreatmentMonitor item) async {
        item.status = SubmissionStatus.submitted;
        Map<String, dynamic> data = item.toJson();
        data.remove('ras');
        data.remove('staff_contact');
        data.remove('main_activity');
        data.remove('submission_status');
        data["rehab_assistants"] = jsonDecode(item.ras.toString());
        data["fuel_oil"] = jsonDecode(item.fuelOil.toString());
        await updateMonitoring(item, data);
      });
    }
  }*/
// ===================================================================================
// END SYNC MONITORING
// ===================================================================================

  /// ******************************************************************************************************************************
  ///******************************************************************************************************************************

// ===================================================================================
// START ADD FUEL
// ===================================================================================
  saveFuel(InitialTreatmentFuel initialTreatmentFuel) async {
    final initialTreatmentFuelDao =
        indexController.database!.initialTreatmentFuelDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        // var response = await dio.post('https://dcbf-154-160-21-151.eu.ngrok.io' + URLs.saveInitialTreatmentFuel, data: initialTreatmentFuel.toJson());
        var response = await dio.post(
            URLs.baseUrl + URLs.saveInitialTreatmentFuel,
            data: initialTreatmentFuel.toJson());
        if (response.data['status'] == RequestStatus.True) {
          initialTreatmentFuelDao
              .insertInitialTreatmentFuel(initialTreatmentFuel);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          initialTreatmentFuelDao
              .updateInitialTreatmentFuelSubmissionStatusByUID(
                  SubmissionStatus.submitted, initialTreatmentFuel.uid!);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        } else {
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        }
      } catch (e) {
        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      initialTreatmentFuel.status = SubmissionStatus.pending;
      initialTreatmentFuelDao.insertInitialTreatmentFuel(initialTreatmentFuel);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END ADD FUEL
// ===================================================================================

// ===================================================================================
// START UPDATE FUEL
// ===================================================================================
  updateFuel(InitialTreatmentFuel initialTreatmentFuel) async {
    final initialTreatmentFuelDao =
        indexController.database!.initialTreatmentFuelDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        // var response = await dio.post('https://dcbf-154-160-21-151.eu.ngrok.io' + URLs.saveInitialTreatmentFuel, data: initialTreatmentFuel.toJson(),
        var response =
            await dio.post(URLs.baseUrl + URLs.saveInitialTreatmentFuel,
                data: initialTreatmentFuel.toJson(),
                options: Options(
                    // headers: {
                    //   "Connection": "Keep-Alive",
                    //   "Keep-Alive": "timeout=5, max=1000"
                    // }
                    ));
        if (response.data['status'] == RequestStatus.True) {
          initialTreatmentFuelDao
              .updateInitialTreatmentFuel(initialTreatmentFuel);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          initialTreatmentFuelDao
              .updateInitialTreatmentFuelSubmissionStatusByUID(
                  SubmissionStatus.submitted, initialTreatmentFuel.uid!);
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
      initialTreatmentFuel.status = SubmissionStatus.pending;
      initialTreatmentFuelDao.updateInitialTreatmentFuel(initialTreatmentFuel);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE FUEL
// ===================================================================================

// ===================================================================================
// START SYNC FUEL
// ===================================================================================

  syncFuel() async {
    final initialTreatmentFuelDao =
        indexController.database!.initialTreatmentFuelDao;
    int offset = 0;
    int limit = 20;
    bool endOfRecords = false;

    while (!endOfRecords) {
      List<InitialTreatmentFuel> records = await initialTreatmentFuelDao
          .findInitialTreatmentFuelByStatusWithLimit(
              SubmissionStatus.pending, limit, offset);
      if (records.isNotEmpty) {
        await Future.forEach(records, (InitialTreatmentFuel item) async {
          item.status = SubmissionStatus.submitted;
          await updateFuel(item);
        });
        offset += limit;
      } else {
        endOfRecords = true;
      }
    }
  }

  /*syncFuel() async{
    final initialTreatmentFuelDao = indexController.database!.initialTreatmentFuelDao;
    List<InitialTreatmentFuel> records = await initialTreatmentFuelDao.findInitialTreatmentFuelByStatus(SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records, (InitialTreatmentFuel item) async {
        item.status = SubmissionStatus.submitted;
        await updateFuel(item);
      });
    }
  }*/
// ===================================================================================
// END SYNC FUEL
// ===================================================================================
}
