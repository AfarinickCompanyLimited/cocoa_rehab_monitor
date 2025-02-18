// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
import 'package:cocoa_rehab_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';

class PersonnelAssignmentApiInterface {
  GlobalController globalController = Get.find();

// ===================================================================================
// START ADD PERSONNEL ASSIGNMENT
// ===================================================================================
  addPersonnelAssignment(PersonnelAssignment personnelAssignment) async {
    final personnelAssignmentDao =
        globalController.database!.personnelAssignmentDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.assignPersonnel,
            data: personnelAssignment.toJson());
        if (response.data['status'] == RequestStatus.True) {
          personnelAssignmentDao.insertPersonnelAssignment(personnelAssignment);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          personnelAssignmentDao.updatePersonnelAssignmentSubmissionStatusByUID(
              SubmissionStatus.submitted, personnelAssignment.uid!);
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
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('addPersonnelAssignment');


        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      personnelAssignment.status = SubmissionStatus.pending;
      personnelAssignmentDao.insertPersonnelAssignment(personnelAssignment);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END ADD PERSONNEL ASSIGNMENT
// ===================================================================================

// ===================================================================================
// START UPDATE PERSONNEL ASSIGNMENT
// ===================================================================================
  updatePersonnelAssignment(PersonnelAssignment personnelAssignment) async {
    final personnelAssignmentDao =
        globalController.database!.personnelAssignmentDao;
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.assignPersonnel,
            data: personnelAssignment.toJson());
        if (response.data['status'] == RequestStatus.True) {
          personnelAssignmentDao.updatePersonnelAssignment(personnelAssignment);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else if (response.data['status'] == RequestStatus.Exist) {
          personnelAssignmentDao.updatePersonnelAssignmentSubmissionStatusByUID(
              SubmissionStatus.submitted, personnelAssignment.uid!);
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
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('updatePersonnelAssignment');


        
        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      personnelAssignment.status = SubmissionStatus.pending;
      personnelAssignmentDao.updatePersonnelAssignment(personnelAssignment);
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'Data saved locally. Sync when you have internet connection',
      };
    }
  }
// ===================================================================================
// END UPDATE PERSONNEL ASSIGNMENT
// ===================================================================================

// ===================================================================================
// START SYNC PERSONNEL ASSIGNMENT
// ===================================================================================

  syncPersonnelAssignment() async {
    final personnelAssignmentDao =
        globalController.database!.personnelAssignmentDao;
    int offset = 0;
    int limit = 20;
    bool endOfRecords = false;

    while (!endOfRecords) {
      List<PersonnelAssignment> records =
          await personnelAssignmentDao.findPersonnelAssignmentByStatusWithLimit(
              SubmissionStatus.pending, limit, offset);
      if (records.isNotEmpty) {
        await Future.forEach(records, (PersonnelAssignment item) async {
          item.status = SubmissionStatus.submitted;
          await updatePersonnelAssignment(item);
        });
        offset += limit;
      } else {
        endOfRecords = true;
      }
    }
  }
  /* syncPersonnelAssignment() async{
    final personnelAssignmentDao = globalController.database!.personnelAssignmentDao;
    List<PersonnelAssignment> records = await personnelAssignmentDao.findPersonnelAssignmentByStatus(SubmissionStatus.pending);
    if (records.isNotEmpty) {
      await Future.forEach(records, (PersonnelAssignment item) async {
        item.status = SubmissionStatus.submitted;
        await updatePersonnelAssignment(item);
      });
    }
  }*/
// ===================================================================================
// END SYNC PERSONNEL ASSIGNMENT
// ===================================================================================
}
