import 'dart:convert';
import 'dart:io';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/db/contractor_certificate_of_workdone_db.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/contractor_certificate_verification.dart';
import 'package:cocoa_rehab_monitor/controller/model/contractor_certificate_of_workdone_verification_model.dart';
import 'package:cocoa_rehab_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_rehab_monitor/controller/db/contractor_certificate_of_workdone_verification_db.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import 'package:cocoa_rehab_monitor/controller/model/contractor_certificate_of_workdone_model.dart';


class ContractorCertificateApiInterface {
  GlobalController indexController = Get.find();

// ===================================================================================
// START ADD WORK DONE BY CONTRACTOR CERTIFICATE
// ===================================================================================
//   saveContractorCertificate(
//       ContractorCertificateModel contractorCertificate, data) async {
//     ContractorCertificateDatabaseHelper db =
//         ContractorCertificateDatabaseHelper.instance;
//
//     Dio? dio = Dio();
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient dioClient) {
//       dioClient.badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//       return dioClient;
//     };
//     if (await ConnectionVerify.connectionIsAvailable()) {
//       print("THE DATA IS HERE HERE HERE HERE HERE: $data");
//       try {
//         // var response = await dio.post('https://dcbf-154-160-21-151.eu.ngrok.io' + URLs.saveObMonitoring, data: data);
//         var response = await dio
//             .post(URLs.baseUrl + URLs.saveContractorCertificate, data: data);
//         // print("THE RESPONSE IS HERE: " + response.data);
//         if (response.data['status'] == RequestStatus.True) {
//           db.saveData(contractorCertificate);
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
//           return {
//             'status': response.data['status'],
//             'connectionAvailable': true,
//             'msg': response.data['msg'],
//           };
//         }
//       } catch (e, stackTrace) {
//         debugPrint(e.toString());
//         FirebaseCrashlytics.instance.recordError(e, stackTrace);
//         FirebaseCrashlytics.instance.log('saveContractorCertificate');
//         print("THE ERROR IS HERE: " + e.toString());
//
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
//       contractorCertificate.status = SubmissionStatus.pending;
//       db.saveData(contractorCertificate);
//       return {
//         'status': RequestStatus.NoInternet,
//         'connectionAvailable': false,
//         'msg': 'Data saved locally. Sync when you have internet connection',
//       };
//     }
//   }




  saveContractorCertificate(
      ContractorCertificateModel contractorCertificate, Map<String, dynamic> data) async {
    ContractorCertificateDatabaseHelper db =
        ContractorCertificateDatabaseHelper.instance;

    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        final response = await dio.post(
          URLs.baseUrl + URLs.saveContractorCertificate,
          data: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.data);
          if (responseData['status'] == RequestStatus.True) {

            db.saveData(contractorCertificate);
            return {
              'status': responseData['status'],
              'connectionAvailable': true,
              'msg': responseData['msg'],
            };
          } else if (responseData['status'] == RequestStatus.Exist) {
            return {
              'status': responseData['status'],
              'connectionAvailable': true,
              'msg': responseData['msg'],
            };
          } else {
            return {
              'status': responseData['status'],
              'connectionAvailable': true,
              'msg': responseData['msg'],
            };
          }
        } else {
          print("Response failed with status code: ${response.statusCode}");
          return {
            'status': RequestStatus.False,
            'connectionAvailable': true,
            'msg':
            'There was an error submitting your request. Kindly contact your supervisor',
          };
        }
      } catch (e, stackTrace) {
        debugPrint(e.toString());
        // FirebaseCrashlytics.instance.recordError(e, stackTrace);
        // FirebaseCrashlytics.instance.log('saveContractorCertificate');
        print("THE ERROR IS HERE: $e");

        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
          'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      contractorCertificate.status = SubmissionStatus.pending;
      db.saveData(contractorCertificate);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }

// ===================================================================================
// END ADD  WORK DONE BY CONTRACTOR CERTIFICATE
// ===================================================================================

// ===================================================================================
// START UPDATE WORK DONE BY CONTRACTOR CERTIFICATE
// ===================================================================================
  updateContractorCertificate(
      ContractorCertificate contractorCertificate) async {
    final contractorCertificateDao =
        indexController.database!.contractorCertificateDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response =
            await dio.post(URLs.baseUrl + URLs.saveContractorCertificate,
                data: contractorCertificate.toJson(),
                options: Options(
                    // headers: {
                    //   "Connection": "Keep-Alive",
                    //   "Keep-Alive": "timeout=5, max=1000"
                    // }
                    ));
        if (response.data['status'] == RequestStatus.True) {
          contractorCertificateDao
              .updateContractorCertificate(contractorCertificate);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          contractorCertificateDao
              .updateContractorCertificateSubmissionStatusByUID(
                  SubmissionStatus.submitted, contractorCertificate.uid!);
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
        print(e);
        // FirebaseCrashlytics.instance.recordError(e, stackTrace);
        // FirebaseCrashlytics.instance.log('updateContractorCertificate');

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
      contractorCertificate.status = SubmissionStatus.pending;
      contractorCertificateDao
          .updateContractorCertificate(contractorCertificate);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE WORK DONE BY CONTRACTOR CERTIFICATE
// ===================================================================================

// ===================================================================================
// START SYNC WORK DONE BY CONTRACTOR CERTIFICATE
// ===================================================================================
  syncContractorCertificate() async {
    final contractorCertificateDao =
        indexController.database!.contractorCertificateDao;
    List<ContractorCertificate> records = await contractorCertificateDao
        .findContractorCertificateByStatus(SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records, (ContractorCertificate item) async {
        item.status = SubmissionStatus.submitted;

        await updateContractorCertificate(item);
      });
    }
  }
// ===================================================================================
// END SYNC WORK DONE BY CONTRACTOR CERTIFICATE
// ===================================================================================

// ===================================================================================
// START ADD WORK DONE BY CONTRACTOR CERTIFICATE VERIFICATION
// ===================================================================================
  saveContractorCertificateVerification(
      ContractorCertificateVerificationModel contractorCertificateVerification,
      data) async {
    final contractorCertificateVerificationDao =
        indexController.database!.contractorCertificateVerificationDao;

    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(
            URLs.baseUrl + URLs.saveContractorCertificateVerification,
            data: data);
        print('JJKJJK:::::${response.data['status']}');

        if (response.data['status'] == RequestStatus.True) {
          // /// initialise the database
          // ContractorCertificateDatabaseHelper dbHelper = ContractorCertificateDatabaseHelper.instance;
          //
          // /// save the data offline
          // await dbHelper.saveData(contractorCertificateVerification);

          // contractorCertificateVerificationDao
          //     .insertContractorCertificateVerification(
          //         contractorCertificateVerification);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          contractorCertificateVerificationDao
              .updateContractorCertificateVerificationSubmissionStatusByUID(
                  SubmissionStatus.submitted,
                  contractorCertificateVerification.uid!);
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
        print('ERROR REPORT $e');
        // FirebaseCrashlytics.instance.recordError(e, stackTrace);
        // FirebaseCrashlytics.instance
          //  .log('saveContractorCertificateVerification');

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
      contractorCertificateVerification.status = SubmissionStatus.pending;

      /// initialise the database
      ContractorCertificateVerificationDatabaseHelper dbHelper =
          ContractorCertificateVerificationDatabaseHelper.instance;

      /// save the data offline
      await dbHelper.saveData(contractorCertificateVerification);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END ADD  WORK DONE BY CONTRACTOR CERTIFICATE VERIFICATION
// ===================================================================================

// ===================================================================================
// START UPDATE WORK DONE BY CONTRACTOR CERTIFICATE VERIFICATION
// ===================================================================================
  updateContractorCertificateVerification(
      ContractorCertificateVerification
          contractorCertificateVerification) async {
    final contractorCertificateVerificationDao =
        indexController.database!.contractorCertificateVerificationDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(
            URLs.baseUrl + URLs.saveContractorCertificateVerification,
            data: contractorCertificateVerification.toJson(),
            options: Options(
                // headers: {
                //   "Connection": "Keep-Alive",
                //   "Keep-Alive": "timeout=5, max=1000"
                // }
                ));
        if (response.data['status'] == RequestStatus.True) {
          contractorCertificateVerificationDao
              .updateContractorCertificateVerification(
                  contractorCertificateVerification);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          contractorCertificateVerificationDao
              .updateContractorCertificateVerificationSubmissionStatusByUID(
                  SubmissionStatus.submitted,
                  contractorCertificateVerification.uid!);
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
        // FirebaseCrashlytics.instance.recordError(e, stackTrace);
        // FirebaseCrashlytics.instance
        //     .log('updateContractorCertificateVerification');

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
      contractorCertificateVerification.status = SubmissionStatus.pending;
      contractorCertificateVerificationDao
          .updateContractorCertificateVerification(
              contractorCertificateVerification);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE WORK DONE BY CONTRACTOR CERTIFICATE VERIFICATION
// ===================================================================================

// ===================================================================================
// START SYNC WORK DONE BY CONTRACTOR CERTIFICATE VERIFICATION
// ===================================================================================
  syncContractorCertificateVerification() async {
    final contractorCertificateVerificationDao =
        indexController.database!.contractorCertificateVerificationDao;
    List<ContractorCertificateVerification> records =
        await contractorCertificateVerificationDao
            .findContractorCertificateVerificationByStatus(
                SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records,
          (ContractorCertificateVerification item) async {
        item.status = SubmissionStatus.submitted;

        await updateContractorCertificateVerification(item);
      });
    }
  }
// ===================================================================================
// END SYNC WORK DONE BY CONTRACTOR CERTIFICATE VERIFICATION
// ===================================================================================
}
