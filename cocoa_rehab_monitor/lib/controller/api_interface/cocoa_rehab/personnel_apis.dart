// ignore_for_file: avoid_print, unnecessary_string_interpolations

import 'dart:io';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_rehab_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef OnOperationCompletedCallback = Function();

class PersonnelApiInterface {
  GlobalController globalController = Get.find();

// ===================================================================================
// START ADD PERSONNEL
// ===================================================================================
  addPersonnel(Personnel personnel) async {
    final personnelDao = globalController.database!.personnelDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        debugPrint("Error here and there ${personnel}");

        var response = await dio.post(URLs.baseUrl + URLs.addPersonnel,
            data: personnel.toJson());

        if (response.data['status'] == RequestStatus.True) {
          personnelDao.insertPersonnel(personnel);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          personnelDao.updatePersonnelSubmissionStatusByUID(
              SubmissionStatus.submitted, personnel.uid!);
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
        // personnel.status = SubmissionStatus.pending;
        // personnelDao.insertPersonnel(personnel);
        print(e);
        print("Stack trace ${stackTrace.toString()}");
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('addPersonnel');

        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      personnel.status = SubmissionStatus.pending;
      personnelDao.insertPersonnel(personnel);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END ADD PERSONNEL
// ===================================================================================

// ===================================================================================
// START UPDATE PERSONNEL
// ===================================================================================
  updatePersonnel(Personnel personnel) async {
    final personnelDao = globalController.database!.personnelDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.addPersonnel,
            data: personnel.toJson());
        if (response.data['status'] == RequestStatus.True) {
          personnelDao.updatePersonnel(personnel);
          print(
              'RESPONSE DATA STATUS IN METHOD UPDATE PERSONNEL FOR REQUESTSTATUS OF ONE::: ${response.data['status']}');
          print(
              'RESPONSE DATA MESSAGE IN METHOD UPDATE PERSONNEL FOR REQUESTSTATUS OF ONE::: ${response.data['msg']}');

          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          personnelDao.updatePersonnelSubmissionStatusByUID(
              SubmissionStatus.submitted, personnel.uid!);
          print(
              'RESPONSE DATA STATUS IN METHOD UPDATE PERSONNEL FOR REQUESTSTATUS OF EXISTS::: ${response.data['status']}');

          print(
              'RESPONSE DATA MESSAGE IN METHOD UPDATE PERSONNEL FOR REQUESTSTATUS OF EXISTS::: ${response.data['msg']}');

          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        } else {
          print(
              'RESPONSE DATA STATUS IN METHOD UPDATE PERSONNEL FOR ELSE STATEMENT OF REQUESTSTATUS OF EXISTS::: ${response.data['status']}');

          print(
              'RESPONSE DATA MESSAGE IN METHOD UPDATE PERSONNEL FOR ELSE STATEMENT OF REQUESTSTATUS OF EXISTS::: ${response.data['msg']}');
          // personnel.status = SubmissionStatus.pending;
          // personnelDao.insertPersonnel(personnel);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        }
      } catch (e, stackTrace) {
        // personnel.status = SubmissionStatus.pending;
        // personnelDao.insertPersonnel(personnel);

        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('updatePersonnel');

        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      print('NO NETWORK IN UPDATE PERSONNEL:::');

      personnel.status = SubmissionStatus.pending;
      personnelDao.updatePersonnel(personnel);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE PERSONNEL
// ===================================================================================

// ===================================================================================
// START SYNC PERSONNEL
// ===================================================================================
  syncPersonnel() async {
    print('SYNCING ON LINE 176 ');

    final personnelDao = globalController.database!.personnelDao;
    int offset = 0;
    int limit = 50;
    bool endOfRecords = false;

    while (!endOfRecords) {
      List<Personnel> records =
          await personnelDao.findPersonnelByStatusWithLimit(
              SubmissionStatus.pending, limit, offset);
      print(
          'THIS IS THE NUMBER OF PENDING RAS TO BE SYNCED:: ${records.length}');
      print('RECORDS IS EMPTY?::: ${records.isEmpty}');

      if (records.isNotEmpty) {
        await Future.forEach(records, (Personnel item) async {
          item.status = SubmissionStatus.submitted;
          print(
              'THIS IS THE NAME OF THE ITEM BEING SYNCED TO THE DATABASE AT PERSONNEL API INTERFACE:::  ${item.name}');
          await updatePersonnel(item);
        });
        offset += limit;
      } else {
        endOfRecords = true;
      }
    }
  }
  /* syncPersonnel() async{
    final personnelDao = globalController.database!.personnelDao;
    List<Personnel> records = await personnelDao.findPersonnelByStatus(SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records, (Personnel item) async {
        item.status = SubmissionStatus.submitted;
        await updatePersonnel(item);
      });
    }
  }*/
// ===================================================================================
// END SYNC PERSONNEL
// ===================================================================================
}
