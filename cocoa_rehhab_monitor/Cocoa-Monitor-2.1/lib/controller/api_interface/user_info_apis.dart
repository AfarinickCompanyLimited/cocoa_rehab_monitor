// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:cocoa_monitor/controller/api_interface/parse_image.dart';
import 'package:cocoa_monitor/controller/model/cm_user.dart';
import 'package:cocoa_monitor/controller/model/user_info.dart';
import 'package:cocoa_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/auth/login/login.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../utils/dio_singleton_instance.dart';

class UserInfoApiInterface {
  ///Check if phone number is registered
  accountLookup(phone) async {
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.lookupUserAccount,
            data: {'telephone': phone});
        print('THE LOGIN RESPONSE::: $response');
        print('THE LOGIN RESPONSE STATUS::: ${response.data['status']}');

        if (response.data['status'] == RequestStatus.True) {
          var data = response.data['data'];
          print('THE LOGIN RESPONSE DATA::: $data');

          CmUser userInfo = CmUser(
              userId: data['user_id'],
              firstName: data['first_name'],
              lastName: data["last_name"],
              group: data["group"],
              staffId: data["staff_id"]);

          GlobalController indexController = Get.find();
          await saveUserDataToSharedPrefs(userInfo);
          indexController.userInfo.value =
              await retrieveUserInfoFromSharedPrefs();

          return {
            'status': true,
            'connectionAvailable': true,
            'userInfo': userInfo
          };
        } else {
          print('THE LOGIN RESPONSE NOT TRUE::: $response');

          return {
            'status': false,
            'message': response.data['msg'],
            'connectionAvailable': true
          };
        }
        // if (response.data['status'] == true){
        //   String token = response.data['token'];
        //   return {
        //     'status': true,
        //     'connectionAvailable': true,
        //     'token': token
        //   };
        // }else{
        //   return {
        //     'status': false,
        //     'connectionAvailable': true
        //   };
        // }
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('accountLookup');
      }
    } else {
      print('CONECTION IS NOT AVAILABLE');
      return {'status': false, 'connectionAvailable': false};
    }
  }
// ===================================================================================
// End Check if phone number is registered
// ===================================================================================

// check if user is registered
  accountLookupUsername(username, password) async {
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.lookupUserAccount,
            data: {'username': username, "password": password});
        print('THE LOGIN RESPONSE::: $response');
        print('THE LOGIN RESPONSE STATUS::: ${response.data['status']}');

        if (response.data['status'] == RequestStatus.True) {
          var data = response.data['data'];
          print('THE LOGIN RESPONSE DATA::: $data');

          CmUser userInfo = CmUser(
              userId: data['user_id'],
              firstName: data['first_name'],
              lastName: data["last_name"],
              group: data["group"],
              staffId: data["staff_id"]);

          GlobalController indexController = Get.find();
          await saveUserDataToSharedPrefs(userInfo);
          indexController.userInfo.value =
              await retrieveUserInfoFromSharedPrefs();

          return {
            'status': true,
            'connectionAvailable': true,
            'userInfo': userInfo
          };
        } else {
          print('THE LOGIN RESPONSE NOT TRUE::: $response');

          return {
            'status': false,
            'message': response.data['msg'],
            'connectionAvailable': true
          };
        }
        // if (response.data['status'] == true){
        //   String token = response.data['token'];
        //   return {
        //     'status': true,
        //     'connectionAvailable': true,
        //     'token': token
        //   };
        // }else{
        //   return {
        //     'status': false,
        //     'connectionAvailable': true
        //   };
        // }
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('accountLookup');
      }
    } else {
      print('CONECTION IS NOT AVAILABLE');
      return {'status': false, 'connectionAvailable': false};
    }
  }
// ===================================================================================
// End Check if user is registered
// ===================================================================================

  ///Create a new user account
  createAccount(userData) async {
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
            await dio.post(URLs.baseUrl + URLs.createAccount, data: userData);
        var data = response.data;
        return {
          'status': data['status'],
          'connectionAvailable': true,
          'message': data['msg'],
          'token': data['token']
        };
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('createAccount');
      }
    } else {
      return {'status': false, 'connectionAvailable': false};
    }
  }
// ===================================================================================
// End create new user account
// ===================================================================================

  /// Change account password
  changePassword(userData) async {
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
            await dio.post(URLs.baseUrl + URLs.changePassword, data: userData);
        var data = response.data;
        return {
          'status': data['status'],
          'connectionAvailable': true,
          'message': data['msg'],
          'token': data['token']
        };
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('resetPassword');
      }
    } else {
      return {'status': false, 'connectionAvailable': false};
    }
  }
// ===================================================================================
// End change account password
// ===================================================================================

  ///Retrieve user account information from server
  getUserInfo(token) async {
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio
            .post(URLs.baseUrl + URLs.getUserInfo, data: {'token': token});
        if (response.data['status'] == true) {
          var data = response.data['data'];

          UserInfo userInfo = UserInfo(
            id: data['id'],
            token: token,
            name: data["name"],
            phone: data["phone"],
            image: parseImage(data["image"]),
            email: data["email"],
            country: data["country"],
            sex: data["sex"],
            loginId: data["Login.id"],
            loginUname: data["Login.uname"],
            loginRole: data["Login.role"],
            loginLastLogin: data["Login.last_login"],
            loginStatus: data["Login.status"],
            loginNotificationToken: data["Login.notification_token"],
          );

          GlobalController indexController = Get.find();
          await saveUserDataToSharedPrefs(userInfo);
          indexController.userInfo.value =
              await retrieveUserInfoFromSharedPrefs();

          return {
            'status': true,
            'connectionAvailable': true,
            'userInfo': userInfo
          };
        } else {
          return {
            'status': false,
            'message': response.data['msg'],
            'connectionAvailable': true
          };
        }
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('getUserInfo');
      }
    } else {
      return {'status': false, 'connectionAvailable': false};
    }
  }
// ===================================================================================
// End retrieve user account information
// ===================================================================================

  // ===================================================================================
// START UPDATE PROFILE PHOTO
// ===================================================================================
  updateProfilePhoto(data, token) async {
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    GlobalController indexController = Get.find();

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response =
            await dio.post(URLs.baseUrl + URLs.updateProfilePhoto, data: data);
        if (response.data['status'] == true) {
          var userData = await getUserInfo(token);

          saveUserDataToSharedPrefs(userData['userInfo']);
          indexController.userInfo.value =
              await retrieveUserInfoFromSharedPrefs();

          return {
            'status': true,
            'connectionAvailable': true,
            'msg': response.data['msg']
          };
        } else {
          return {
            'status': false,
            'connectionAvailable': true,
            'msg': response.data['msg'],
          };
        }
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('updateProfilePhoto');
      }
    } else {
      return {
        'status': false,
        'connectionAvailable': false,
      };
    }
  }
// ===================================================================================
// END UPDATE PROFILE PHOTO
// ===================================================================================

// ===================================================================================
  ///Update account details
// ===================================================================================
  updateAccountDetails(userData, token) async {
    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    GlobalController indexController = Get.find();

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.updateAccountDetails,
            data: userData);
        var data = response.data;

        var profileInfo = await getUserInfo(token);
        await saveUserDataToSharedPrefs(profileInfo['userInfo']);
        indexController.userInfo.value =
            await retrieveUserInfoFromSharedPrefs();

        return {
          'status': data['status'],
          'connectionAvailable': true,
          'message': data['msg'],
          'token': data['token']
        };
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('updateAccountDetails');
      }
    } else {
      return {'status': false, 'connectionAvailable': false};
    }
  }
// ===================================================================================
// End Update Account Details
// ===================================================================================

  /// Save user details in shared prefs
  Future saveUserDataToSharedPrefs(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPref.loggedIn, true);
    await prefs.setString(SharedPref.user, jsonEncode(user));
  }
// ===================================================================================
// End Save user details in shared prefs
// ===================================================================================

  /// Retrieve user info from shared prefs
  Future retrieveUserInfoFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString(SharedPref.user);
    CmUser userInfo = CmUser.fromJson(json.decode(user!));
    return userInfo;
  }
// ===================================================================================
// End Retrieve user info from shared prefs
// ===================================================================================

  /// Retrieve user login status from shared prefs
  Future<bool?> userIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loginStatus = prefs.getBool(SharedPref.loggedIn);
    return loginStatus;
  }
// ===================================================================================
// End Retrieve user login status from shared prefs
// ===================================================================================

  /// Remove shared Preferences app update activation timestamp
  Future clearTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedBuildNumber = prefs.getInt(SharedPref.buildNumber);
    int? currentVersion = Build.buildNumber;

    if (storedBuildNumber != null) {
      if (currentVersion > storedBuildNumber) {
        prefs.remove(SharedPref.activationTimestamp);
        prefs.setInt(SharedPref.buildNumber, Build.buildNumber);
      }
    }
    prefs.setInt(SharedPref.buildNumber, Build.buildNumber);
  }

// ===================================================================================
// End Retrieve user login status from shared prefs
// ===================================================================================

// ========================================================
// START SET USER FIREBASE NOTIFICATION TOKEN
// ========================================================
  Future setUserFirebaseNotificationToken() async {
    GlobalController indexController = Get.find();

    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('addedFirebaseNotificationToken') == false){
    if (indexController.userIsLoggedIn.value == true) {
      // if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        String? token = await messaging.getToken();

        var response = await DioSingleton.instance
            .post(URLs.baseUrl + URLs.updateFirebaseToken, data: {
          'token': token,
          'userid': indexController.userInfo.value.userId
        });
        if (response.data['status'] == true) {
          await prefs.setBool('addedFirebaseNotificationToken', true);
        }
      } catch (e, stackTrace) {
        print('SETUSERFIREBASENOTIFICATIONTOKEN ERROR ::: ${e.toString()}');
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('setUserFirebaseNotificationToken');
      }
      // }
    }
    // }
  }
// ========================================================
// END SET USER FIREBASE NOTIFICATION TOKEN
// ========================================================

  /// ===================================================================================
// START LOGOUT
// ===================================================================================
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => const Login(), transition: Transition.zoom);
  }
// ===================================================================================
// END LOGOUT
  /// ===================================================================================

  Future setServerURL({required bool isDefault, String? url}) async {
    Get.find<GlobalController>().serverUrl =
        isDefault ? 'https://cocoarehabmonitor.com' : url!;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString(SharedPref.serverURL, isDefault ? 'http://cocoarehabmonitor.com' : url!);
  }
}
