// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/db/activity_db.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_outbreak.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/cocoa_age_class.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/cocoa_type.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/community.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/equipment.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm_status.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/po_location.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_monitor/controller/model/activity_model.dart';
import 'package:cocoa_monitor/controller/model/job_order_farms_model.dart';
import 'package:cocoa_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
// import 'package:dio/adapter.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view/global_components/globals.dart';
import '../../db/job_order_farms_db.dart';
import '../../utils/dio_singleton_instance.dart';

typedef OnOperationCompletedCallback = Function();

class GeneralCocoaRehabApiInterface {
  GlobalController indexController = Get.find();
  Globals globals = Globals();

  // ==============================================================================
  // =========================== START GET APP VERSION  ========================
  // ==============================================================================

  /* Future checkVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  bool? ultimatumSet =  prefs.getBool(SharedPref.ultimatumActivated);
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.versionCheck,
            data: {'version': Build.buildNumber});

        if (response.data['status'] == 1) {
          //version is the right versio
         // await prefs.setString(SharedPref.activationTimestamp,
            //  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
            //  await prefs.setString(SharedPref.appVersionFromServer, value)

          return true;
        } else {
          //version is wrong needs update
          
          return false;
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }*/

  // ==============================================================================
  // =========================== End GET APP VERSION  ========================
  // ==============================================================================

  // ==============================================================================
  // =========================== START GET Contractors  ===============================
  // ==============================================================================

  Future loadRegionContractors() async {
    final contractorDao = indexController.database!.contractorDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    // if (await ConnectionVerify.connectionIsAvailable()) {
    try {
      var response =
          await DioSingleton.instance.post(URLs.baseUrl + URLs.loadContractors);
      if (response.data['status'] == 1 && response.data['data'] != null) {
        List resultList = response.data['data'];
        List<Contractor> listOfContractors =
            resultList.map((e) => contractorFromJson(jsonEncode(e))).toList();
        await contractorDao.deleteAllContractors();
        await contractorDao.bulkInsertContractors(listOfContractors);
        debugPrint(
            'LOADING CONTRACTORS TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

        return true;
      } else {
        debugPrint(
            'RESPONSE DATA FAILED IN LOAD CONTRACTORS ::: ${response.data?['status']}');

        // return false;
      }
    } catch (e, stackTrace) {
      print(' LOADING CONTRACTORS TO LOCAL DB ERROR ${e.toString()}');
      print('Stack trace:\n$stackTrace');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      FirebaseCrashlytics.instance.log('loadRegionContractors');
    }
    // }
  }

// ==============================================================================
// ============================  END GET Contractors  ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET Region District  ===============================
  // ==============================================================================

  Future loadRegionDistricts() async {
    final regionDistrictDao = indexController.database!.regionDistrictDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    // if (await ConnectionVerify.connectionIsAvailable()) {
    try {
      var response = await DioSingleton.instance.post(
          URLs.baseUrl + URLs.loadRegionDistricts,
          data: {"userid": indexController.userInfo.value.userId});
      if (response.data['status'] == true && response.data['data'] != null) {
        List resultList = response.data['data'];
        List<RegionDistrict> listOfRD = resultList
            .map((e) => regionDistrictFromJson(jsonEncode(e)))
            .toList();
        await regionDistrictDao.deleteAllRegionDistrict();
        await regionDistrictDao.bulkInsertRegionDistrict(listOfRD);
        debugPrint(
            'LOADING REGION DISTRICTS TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

        return true;
      } else {
        debugPrint(
            'RESPONSE DATA FAILED IN LOAD REGION DISTRICTS ::: ${response.data?['status']}');

        // return false;
      }
    } catch (e, stackTrace) {
      print(' LOAD REGION DISTRICTS TO LOCAL DB ERROR ${e.toString()}');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      FirebaseCrashlytics.instance.log('loadRegionDistricts');
    }
    // }
  }

// ==============================================================================
// ============================  END GET Region District  ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET ACTIVITIES  ===============================
  // ==============================================================================

  Future loadActivities() async {
    // final activityDao = indexController.database!.activityDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    // if (await ConnectionVerify.connectionIsAvailable()) {
    try {
      var response =
          await DioSingleton.instance.get(URLs.baseUrl + URLs.loadActivities);
      if (response.data['status'] == true && response.data['data'] != null) {

        List resultList = response.data['data'];

        // debugPrint(
        //   "ALL THE ACTIVITY DATA ::::::::: ${response.data['data'].runtimeType}",
        // );
        //
        // print("THE ACTIVITY DATA ::::::::: ${resultList[0].runtimeType}");

        List<ActivityModel> listOfActivity =
            resultList.map((e){
              return activityFromJsonM(jsonEncode(e));
            }).toList();

        /// initialize the database
        ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
        /// delete existing records
        await db.deleteAll();
        /// bulk insert the data
        await db.bulkInsertData(listOfActivity);

        // await activityDao.deleteAllActivity();
        // await activityDao.bulkInsertActivity(listOfActivity);
        debugPrint(
            'LOADING ACTIVITIES TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');
        return true;
      } else {
        // return false;
        debugPrint(
            'RESPONSE DATA FAILED IN LOAD ACTIVITIES ::: ${response.data?['status']}');
      }
    } catch (e, stackTrace) {
      print(' LOAD ACTIVITY TO LOCAL DB ERROR ${e.toString()}');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      FirebaseCrashlytics.instance.log('loadActivities');
    }
    // }
  }

// ==============================================================================
// ============================  END GET ACTIVITIES  ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET FARMS  ===============================
  // ==============================================================================

  Future loadFarms() async {
    final farmDao = indexController.database!.farmDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance
            .post(URLs.baseUrl + URLs.loadFarms, data:
                // kDebugMode
                // ? {'userid': 12622}
                // ? {'userid': 12863}
                // :
                {'userid': indexController.userInfo.value.userId});
        // print(response.data);
        // print(response.data);
        // print(response.data);
        // print(response.data);
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<Farm> farmList =
              resultList.map((e) => farmFromJson(jsonEncode(e))).toList();
          await farmDao.deleteAllFarms();
          await farmDao.bulkInsertFarm(farmList);
          debugPrint(
              'LOADING FARMS TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD FARMS ::: ${response.data?['status']}');

          return false;
        }
      } catch (e, stackTrace) {
        print(' LOAD FARMS TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadFarms');
      }
    }
  }

// ==============================================================================
// ============================  END GET FARMS  ===============================
// ==============================================================================

  Future loadJobOrderFarms() async {
    JobOrderFarmsDbFarmDatabaseHelper db = JobOrderFarmsDbFarmDatabaseHelper.instance;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance
            .post(URLs.baseUrl + URLs.loadJobOrderFarms, data:
        // kDebugMode
        // ? {'userid': 12622}
        // ? {'userid': 12863}
        // :
        {'userid': indexController.userInfo.value.userId});
        // print(response.data);
        // print(response.data);
        // print(response.data);
        // print(response.data);
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<JobOrderFarmModel> farmList =
          resultList.map((e) => jobOrderFarmFromJson(jsonEncode(e))).toList();
          await db.deleteAll();
          await db.bulkInsertData(farmList);
          debugPrint(
              'LOADING JOB ORDER FARMS TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD JOB ORDER FARMS ::: ${response.data?['status']}');

          return false;
        }
      } catch (e, stackTrace) {
        print(' LOAD JOB ORDER FARMS TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadFarms');
      }
    }
  }

  // ==============================================================================
  // =========================== START GET REHAB ASSISTANTS  ===============================
  // ==============================================================================

  Future loadRehabAssistants() async {
    final rehabAssistantDao = indexController.database!.rehabAssistantDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance.post(
            URLs.baseUrl + URLs.loadRehabAssistants,
            data: {'userid': indexController.userInfo.value.userId});

        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];

          List<RehabAssistant> farmList = resultList.map((e) {
            return rehabAssistantFromJson(jsonEncode(e));
          }).toList();
          await rehabAssistantDao.deleteAllRehabAssistants();
          await rehabAssistantDao.bulkInsertRehabAssistants(farmList);
          debugPrint(
              'LOADING REHAB ASSISTANTS TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          // return false;
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD REHAB ASSISTANTS ::: ${response.data?['status']}');
        }
      } catch (e, stackTrace) {
        print(' LOAD REHAB ASSISTANTS TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadRehabAssistants');
      }
    }
  }

/*
  Future loadPaginatedRehabAssistants() async {
    final rehabAssistantDao = indexController.database!.rehabAssistantDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    // if (await ConnectionVerify.connectionIsAvailable()) {
    //const pageSize = 100;
    var page = 1;
    var userId = indexController.userInfo.value.userId;
    bool hasMorePages = true;

    List<RehabAssistant> allRehabAssistants = [];

    while (hasMorePages) {
      print('LOADING PAGINATED RA\'S');
      print(userId);
      final response = await DioSingleton.instance.get(
          'https://cocoarehabmonitor.com/rehabassistantslist_drf/?page=$page&userid=$userId');

      if (response.data['results'] != null) {
        List resultList = response.data['results'];

        List<RehabAssistant> farmList = resultList.map((e) {
          return rehabAssistantFromJson(jsonEncode(e));
        }).toList();


        allRehabAssistants.addAll(farmList);
        print('THIS IS THE LENGTH OF PAGE$page::: ${farmList.length}');
      } else {
        debugPrint(
            'RESPONSE DATA FAILED IN LOAD REHAB ASSISTANTS ::: ${response.data?['status']}');
        break;
      }
      hasMorePages = response.data['next'] != null;

      page++;
    }
    // Performing batch insert
    await rehabAssistantDao.deleteAllRehabAssistants();

    await rehabAssistantDao.bulkInsertRehabAssistants(allRehabAssistants);
    print('TOTAL LENGTH OF RA::: ${allRehabAssistants.length}');
    // }
  }*/

// ==============================================================================
// ============================  END GET REHAB ASSISTANTS  ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET FARM STATUS  ===============================
  // ==============================================================================

  Future loadFarmStatus() async {
    final farmStatusDao = indexController.database!.farmStatusDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance.post(
            URLs.baseUrl + URLs.loadFarmStatus,
            data: {'userid': indexController.userInfo.value.userId});
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<FarmStatus> farmList =
              resultList.map((e) => farmStatusFromJson(jsonEncode(e))).toList();
          await farmStatusDao.deleteAllFarmStatus();
          await farmStatusDao.bulkInsertFarmStatus(farmList);
          debugPrint(
              'LOADING FARM STATUS TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD FARM STATUS ::: ${response.data?['status']}');

          // return false;
        }
      } catch (e, stackTrace) {
        print(' LOAD FARM STATUS TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadFarmStatus');
      }
    }
  }

// ==============================================================================
// ============================  END GET FARM STATUS ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET ASSIGNED FARMS  ========================
  // ==============================================================================

  Future loadAssignedFarms() async {
    final assignedFarmDao = indexController.database!.assignedFarmDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance.post(
            URLs.baseUrl + URLs.loadAssignedFarms,
            data: {'userid': indexController.userInfo.value.userId});
        debugPrint(
            'LOADING SAMMYS ID ::: ${indexController.userInfo.value.userId}');
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<AssignedFarm> farmList = resultList
              .map((e) => assignedFarmFromJson(jsonEncode(e)))
              .toList();
          await assignedFarmDao.deleteAllAssignedFarms();
          await assignedFarmDao.bulkInsertAssignedFarms(farmList);
          debugPrint(
              'LOADING ASSIGNED FARM  TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD ASSIGNED FARM::: ${response.data?['status']}');

          // return false;
        }
      } catch (e, stackTrace) {
        print(' LOAD ASSIGNED FARM TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadAssignedFarms');
      }
    }
  }

// ==============================================================================
// ============================  END GET ASSIGNED FARMS ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET COCOA TYPES  ========================
  // ==============================================================================

  Future loadCocoaTypes() async {
    final cocoaTypeDao = indexController.database!.cocoaTypeDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance.post(
            URLs.baseUrl + URLs.loadCocoaTypes,
            data: {'userid': indexController.userInfo.value.userId});
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<CocoaType> cocoaTypeList =
              resultList.map((e) => cocoaTypeFromJson(jsonEncode(e))).toList();
          await cocoaTypeDao.deleteAllCocoaType();
          await cocoaTypeDao.bulkInsertCocoaType(cocoaTypeList);
          debugPrint(
              'LOADING ASSIGNED FARM  TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD ASSIGNED FARM::: ${response.data?['status']}');

          // return false;
        }
      } catch (e, stackTrace) {
        print(' LOAD COCOA TYPE TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadCocoaTypes');
      }
    }
  }

// ==============================================================================
// ============================  END GET COCOA TYPES ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET COCOA AGE CLASS  ========================
  // ==============================================================================

  Future loadCocoaAgeClass() async {
    final cocoaAgeClassDao = indexController.database!.cocoaAgeClassDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance.post(
            URLs.baseUrl + URLs.loadCocoaAgeClass,
            data: {'userid': indexController.userInfo.value.userId});
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<CocoaAgeClass> cocoaAgeClassList = resultList
              .map((e) => cocoaAgeClassFromJson(jsonEncode(e)))
              .toList();
          await cocoaAgeClassDao.deleteAllCocoaAgeClass();
          await cocoaAgeClassDao.bulkInsertCocoaAgeClass(cocoaAgeClassList);
          debugPrint(
              'LOADING COCOA AGE CLASS   TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN COCOA AGE CLASS ::: ${response.data?['status']}');

          // return false;
        }
      } catch (e, stackTrace) {
        print(' LOAD COCOA AGE CLASS TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadCocoaAgeClass');
      }
    }
  }

// ==============================================================================
// ============================  END GET COCOA AGE CLASS ===============================
// ==============================================================================

// ==============================================================================
  // =========================== START GET COMMUNITY  ========================
  // ==============================================================================

  Future loadCommunities() async {
    final communityDao = indexController.database!.communityDao;
    print("THE USER ID IS :::::::::::::: ${indexController.userInfo.value.userId}");
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    // if (await ConnectionVerify.connectionIsAvailable()) {
    try {
      var response = await DioSingleton.instance
          .post(URLs.baseUrl + URLs.loadCommunities, data:
              // kDebugMode
              // ? {'userid': 12863}
              // ? {'userid': 12863}
              // :
              {'userid': indexController.userInfo.value.userId});
      if (response.data['status'] == true && response.data['data'] != null) {
        List resultList = response.data['data'];
        List<Community> communityList =
            resultList.map((e) => communityFromJson(jsonEncode(e))).toList();
        await communityDao.deleteAllCommunity();
        await communityDao.bulkInsertCommunity(communityList);
        debugPrint(
            'LOADING COMMUNITY TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

        return true;
      } else {
        debugPrint(
            'RESPONSE DATA FAILED IN LOAD COMMUNITY ::: ${response.data?['status']}');

        // return false;
      }
    } catch (e, stackTrace) {
      print(' LOAD COMMUNITY TO LOCAL DB ERROR ${e.toString()}');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      FirebaseCrashlytics.instance.log('loadCommunities');
    }
    // }
  }

// ==============================================================================
// ============================  END GET COMMUNITY ===============================
// ==============================================================================

// ==============================================================================
  // =========================== START GET ASSIGNED OUTBREAKS  ========================
  // ==============================================================================

  Future loadAssignedOutbreaks() async {
    final assignedOutbreakDao = indexController.database!.assignedOutbreakDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance
            .post(URLs.baseUrl + URLs.loadAssignedOutbreaks, data:
                // kDebugMode
                // ? {'userid': 12863}
                // ? {'userid': 12863}
                // :
                {'userid': indexController.userInfo.value.userId});
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<AssignedOutbreak> assignedOutbreakList = resultList
              .map((e) => assignedOutbreakFromJson(jsonEncode(e)))
              .toList();
          await assignedOutbreakDao.deleteAllAssignedOutbreaks();
          await assignedOutbreakDao
              .bulkInsertAssignedOutbreak(assignedOutbreakList);
          debugPrint(
              'LOADING ASSIGNED OUTBREAKS  TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD ASSIGNED OUTBREAKS::: ${response.data?['status']}');

          // return false;
        }
      } catch (e, stackTrace) {
        print(' LOAD ASSIGNED OUTBREAKS TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadAssignedOutbreaks');
      }
    }
  }

// ==============================================================================
// ============================  END GET ASSIGNED OUTBREAKS ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET OUTBREAK CSV  ========================
  // ==============================================================================

  Future loadOutbreakCSV(data) async {
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance
            .post(URLs.baseUrl + URLs.loadOutbreakCSV, data: data);
        if (response.data['status'] == true && response.data['data'] != null) {
          List<dynamic> resultList = response.data['data'];
          // print(response.data['data']);
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'] ?? 'Data loaded successfully',
            'data': resultList
          };
        } else {
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'] ?? 'Unable to load outbreak csv'
          };
        }
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadOutbreakCSV');

        return {
          'status': false,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      return {
        'status': false,
        'connectionAvailable': false,
        'msg': 'No internet connection',
      };
    }
  }

// ==============================================================================
// ============================  END GET OUTBREAK CSV ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET OUTBREAK FARMS FROM SERVER  ========================
  // ==============================================================================

  Future loadOutbreakFarmsFromServer() async {
    final outbreakFarmFromServerDao =
        indexController.database!.outbreakFarmFromServerDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance.post(
            URLs.baseUrl + URLs.loadInitialTreatmentFarms,
            data: {'userid': indexController.userInfo.value.userId});
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<OutbreakFarmFromServer> farmList = resultList
              .map((e) => outbreakFarmFromServerFromJson(jsonEncode(e)))
              .toList();
          await outbreakFarmFromServerDao.deleteAllOutbreakFarmFromServers();
          await outbreakFarmFromServerDao
              .bulkInsertOutbreakFarmFromServer(farmList);
          debugPrint(
              'LOADING OUTBREAK FARMS FROM SERVER  TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

          return true;
        } else {
          debugPrint(
              'RESPONSE DATA FAILED IN LOAD OUTBREAK FARMS FROM SERVER::: ${response.data?['status']}');

          // return false;
        }
      } catch (e, stackTrace) {
        print(
            ' LOAD OUTBREAK FARMS FROM SERVER TO LOCAL DB ERROR ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadOutbreakFarmsFromServer');
      }
    }
  }

// ==============================================================================
// ============================  END GET OUTBREAK FARMS FROM SERVER ===============================
// ==============================================================================

  // ==============================================================================
  // =========================== START GET EQUIPMENTS  ========================
  // ==============================================================================

  Future loadEquipments() async {
    final equipmentDao = indexController.database!.equipmentDao;
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    // if (await ConnectionVerify.connectionIsAvailable()) {
    try {
      var response = await DioSingleton.instance.post(
          URLs.baseUrl + URLs.loadEquipments,
          data: {'userid': indexController.userInfo.value.userId});
      if (response.data['status'] == true && response.data['data'] != null) {
        List resultList = response.data['data'];
        List<Equipment> equipmentList =
            resultList.map((e) => equipmentFromJson(jsonEncode(e))).toList();
        await equipmentDao.deleteAllEquipments();
        await equipmentDao.bulkInsertEquipments(equipmentList);
        debugPrint(
            'LOADING EQUIPMENTS TO LOCAL DB SHOULD BE SUCCESSFUL ::: ${response.data?['status']}');

        return true;
      } else {
        debugPrint(
            'RESPONSE DATA FAILED IN LOAD EQUIPMENTS::: ${response.data?['status']}');

        // return false;
      }
    } catch (e, stackTrace) {
      print(' LOAD EQUIPMENTS TO LOCAL DB ERROR ${e.toString()}');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      FirebaseCrashlytics.instance.log('loadEquipments');
    }
    // }
  }

// ==============================================================================
// ============================  END GET EQUIPMENTS ===============================
// ==============================================================================

// ===================================================================================
// START SYNC USER LOCATION
// ===================================================================================
  syncUserLocation() async {
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    final poLocationDao = indexController.database!.poLocationDao;
    int offset = 0;
    int limit = 20; // set the batch size here
    bool endOfRecords = false;

    while (!endOfRecords) {
      List<PoLocation> records =
          await poLocationDao.findPoLocationWithLimit(limit, offset);
      if (records.isNotEmpty) {
        await Future.forEach(records, (PoLocation item) async {
          if (await ConnectionVerify.connectionIsAvailable()) {
            try {
              var itemData = {
                "lat": item.lat,
                "lng": item.lng,
                "accuracy": item.accuracy,
                "uid": item.uid,
                "userid": item.userid,
                "inspection_date": item.inspectionDate.toString()
              };

              debugPrint("Limit is  ${item.inspectionDate.toString()}");

              debugPrint(' "lat": ${item.lat},\n "lng": ${item.lng},\n '
                  '"accuracy": ${item.accuracy},\n "uid": ${item.uid},\n '
                  '"userid": ${item.userid},\n '
                  '"inspection_date": ${item.inspectionDate.toString()}\n');

              var response = await DioSingleton.instance
                  .post(URLs.baseUrl + URLs.savePOLocation, data: itemData);

              print(response.data);

              if (response.data['status'] == RequestStatus.True ||
                  response.data['status'] == RequestStatus.Exist) {
                await poLocationDao.deletePOLocation(item);
              }
            } catch (e, stackTrace) {
              print(' SYNC USER LOCATION TO SERVER ERROR ${e.toString()}');
              FirebaseCrashlytics.instance.recordError(e, stackTrace);
              FirebaseCrashlytics.instance.log('syncUserLocation');
            }
          } else {
            debugPrint("Limit is off ${item.inspectionDate.toString()}");
            // print("we dont have internet");
            await poLocationDao.insertPOLocation(item);
          }
        });
        offset += limit;
      } else {
        endOfRecords = true;
      }
    }
  }

  /*syncUserLocation() async{

    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    final poLocationDao = indexController.database!.poLocationDao;
    List<PoLocation> records = await poLocationDao.findAllPOLocations();
    if (records.isNotEmpty) {
      await Future.forEach(records, (PoLocation item) async {
        if (await ConnectionVerify.connectionIsAvailable()){
          try {

            var itemData = {
              "lat": item.lat,
              "lng": item.lng,
              "accuracy":item.accuracy,
              "uid": item.uid,
              "userid" : item.userid,
              "inspection_date":item.inspectionDate.toString()
            };

            var response = await dio.post(URLs.baseUrl + URLs.savePOLocation, data: itemData);
            // print(response.data);
            if (response.data['status'] == RequestStatus.True || response.data['status'] == RequestStatus.Exist){
              await poLocationDao.deletePOLocation(item);
            }
          } catch (e) {
            print(e);
          }
        }else{
          // print("we dont have internet");
        }

      }
      );
    }
  }*/
// ===================================================================================
// END SYNC USER LOCATION
// ===================================================================================

// ===================================================================================
// START SEND FEEDBACK
// ===================================================================================
  submitIssue(data) async {
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await DioSingleton.instance
            .post(URLs.baseUrl + URLs.sendIssue, data: data);
        if (response.data['status'] == RequestStatus.True) {
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else {
          return {
            'status': response.data['status'],
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        }
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('submitIssue');

        return {
          'status': RequestStatus.False,
          'connectionAvailable': true,
          'msg':
              'There was an error submitting your request. Kindly contact your supervisor',
        };
      }
    } else {
      return {
        'status': RequestStatus.NoInternet,
        'connectionAvailable': false,
        'msg': 'You do not have an active internet connection',
      };
    }
  }
// ===================================================================================
// END SEND FEEDBACK
// ===================================================================================

// ==============================================================================
  // =========================== START GET FINANCIAL REPORTS  ===============================
  // ==============================================================================

  // Future loadFinacialReport() async {
  //   Dio? dio = Dio();
  //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (HttpClient dioClient) {
  //     dioClient.badCertificateCallback =
  //         ((X509Certificate cert, String host, int port) => true);
  //     return dioClient;
  //   };

  //   if (await ConnectionVerify.connectionIsAvailable()) {
  //     try {
  //       var response = await dio.post(URLs.baseUrl + URLs.loadPayments,
  //           data: {'userid': indexController.userInfo.value.userId,
  //           'month' : 'May',
  //           'week' : '3',
  //           'year' : '2023'
  //           });
  //       if (response.data['status'] == true && response.data['data'] != null) {
  //         // var decodedData =
  //         //     json.decode(response.data).cast<Map<String, dynamic>>();
  //         // List resultList = response.data['data'];
  //         // return true;
  //       } else {
  //         // return false;
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

// ==============================================================================
// ============================  END GET FINANCIAL REPORTS  ===============================
// ==============================================================================

  Future submitLeave(data) async {
    String? staffID = indexController.userInfo.value.staffId;
    String? baseURL = "http://hradmin.cocoarehabmonitor.com/";
    if (await ConnectionVerify.connectionIsAvailable()) {
    try {
      var response =
      //todo: change the baseurl to the actual after backend hosting
      await DioSingleton.instance.post("${baseURL}api/v1/leaves/${staffID}/", data: data);
      if (response.data['status'] == 201) {

        return 1;
      } else {
        // return false;
        debugPrint(
            'RESPONSE DATA FAILED IN SUBMIT LEAVE ::: ${response.data?['status']}');
      }
      return 2;
    } catch (e, stackTrace) {
      debugPrint(
          "AN UNKNOWN ERROR OCCURRED IN SUBMIT LEAVE ${stackTrace}");
    }
    return 3;
    // }
  }
    else{
      return 3;
    }
  }
}
