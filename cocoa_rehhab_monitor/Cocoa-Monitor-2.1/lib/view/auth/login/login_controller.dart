// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:cocoa_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_monitor/view/auth/otp/otp.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  GlobalController indexController = Get.find();

  final auth = FirebaseAuth.instance;
  Globals globals = Globals();
  UserInfoApiInterface userInfoApiInterface = UserInfoApiInterface();

  final loginFormKey = GlobalKey<FormState>();
  var phoneTextController = TextEditingController();
  var usernameTextController = TextEditingController();
  var passwordTextController = TextEditingController();
  // var phoneNumberWithCountryCode;

  var otpVerificationID;

  var loginScreenContext;
  // var firstName, lastName, username, phoneNumber;
  var phoneNumber, username, password, country;

  // var selectedCountry = "";

  var selectedCountry = {
    "phoneCode": "233",
    "countryCode": "GH",
    "name": "Ghana",
  };

  // ==============================================================================
  // START CHECK IF PHONE NUMBER IS REGISTERED
  // ==============================================================================
  ///This function will check if the entered phone number is registered
  ///If yes, the user details will be retrieved. if no, OTP will be done
  lookupPhoneNumber() async {
    // phoneNumber = "+${selectedCountry["phoneCode"]}${phoneTextController.text.trim()}";
    phoneNumber = phoneTextController.text.trim();
    print('THIS IS LOGIN CONTROLLER PHONE NUMBER :::: $phoneNumber');

    country = selectedCountry["name"];

    globals.startWait(loginScreenContext);
    var phoneNumberStatus =
        await userInfoApiInterface.accountLookup(phoneNumber);
    globals.endWait(loginScreenContext);
    if (phoneNumberStatus['status'] == true) {
      indexController.userInfo.value =
          await userInfoApiInterface.retrieveUserInfoFromSharedPrefs();
      indexController.userIsLoggedIn.value = true;

      // TrueKing changed
      // uncomment line below if verification needed
      // sendOTP(loginIsSuccessful: true);

      // comment this line if the above is true
      Get.offAll(() => const Home(), transition: Transition.fadeIn);

      // var token = phoneNumberStatus['token'];
      // globals.startWait(loginScreenContext);
      // var userData = await userInfoApiInterface.getUserInfo(token);
      // globals.endWait(loginScreenContext);
      //
      // if(userData['status'] == true && userData['connectionAvailable'] == true){
      //   await userInfoApiInterface.saveUserDataToSharedPrefs(userData['userInfo']);
      //   indexController.userInfo.value = await userInfoApiInterface.retrieveUserInfoFromSharedPrefs();
      //   indexController.userIsLoggedIn.value = true;
      //
      //   // Navigator.of(loginScreenContext).pop();
      //   sendOTP(loginIsSuccessful: true);
      //
      // }else if(userData['status'] == false && userData['connectionAvailable'] == true){
      //   globals.showToast(userData['message']);
      // }else{
      //   globals.showToast('Check your internet connection');
      // }
    } else if (phoneNumberStatus['status'] == false &&
        phoneNumberStatus['connectionAvailable'] == true) {
      // Phone number is not registered ::: Do OTP
      // sendOTP(loginIsSuccessful: false);
      // globals.showToast(phoneNumberStatus['message']);
      globals.showSnackBar(
          title: 'Error', message: phoneNumberStatus['message']);
    } else {
      globals.showToast("Check your internet connection");
    }
  }
  // ==============================================================================
  // END CHECK IF PHONE NUMBER IS REGISTERED
  // ==============================================================================

  // ==============================================================================
  // START SEND OTP
  // ==============================================================================
  sendOTP({required bool loginIsSuccessful}) async {
    print('LOGIN SUCCESFUL BOOLEAN = ${loginIsSuccessful.toString()}');
    // var userPhoneNumber = "+${selectedCountry["phoneCode"]}${phoneTextController.text.trim()}";
    var userPhoneNumber = "+233${phoneTextController.text.trim()}";
    print('USERPHONENUMBER = $userPhoneNumber');

    // var userPhoneNumber = "+233248823823";

    try {
      print('STARTING OTP VERIFICATION');

      globals.startWait(loginScreenContext);
      await auth.verifyPhoneNumber(
          phoneNumber: userPhoneNumber,
          // timeout: const Duration(seconds: 30),
          verificationCompleted: (phoneAuthCredential) async {
            // await auth.signInWithCredential(phoneAuthCredential);

            // print('completed');
          },
          verificationFailed: (verificationFailed) {
            print('FIREBASEAUTHEXCEPTION::::: $verificationFailed');
            // print('false');
            // print(verificationFailed.message);
            globals.endWait(loginScreenContext);
            // globals.showToast('Verification failed. Please try again');
            globals.showSnackBar(
                title: 'Verification failed', message: 'Please try again');
          },
          codeSent: (verificationId, resendToken) {
            globals.endWait(loginScreenContext);
            otpVerificationID = verificationId;
            Get.to(() => OTP(
                phone: userPhoneNumber, loginIsSuccessful: loginIsSuccessful));
          },
          codeAutoRetrievalTimeout: (verificationId) {
            // globals.showToast('Verification timeout. Please try again');
          });
    } on FirebaseAuthException catch (e, stackTrace) {
      print('FIREBASEAUTHEXEPTION:::: ${e.toString()}');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      FirebaseCrashlytics.instance.log('sendOTP');
    }
  }
// ==============================================================================
// END SEND OTP
// ==============================================================================



  // ==============================================================================
  // START CHECK IF USERNAME AND PASSWORD ARE REGISTERED
  // ==============================================================================
  lookupUsernamePassword() async {
    username = usernameTextController.text.trim();
    password = passwordTextController.text.trim();

    globals.startWait(loginScreenContext);
    var userLoginStatus =
        await userInfoApiInterface.accountLookupUsername(username, password);
    globals.endWait(loginScreenContext);

    if (userLoginStatus['status']) {
      indexController.userInfo.value =
          await userInfoApiInterface.retrieveUserInfoFromSharedPrefs();
      indexController.userIsLoggedIn.value = true;

      Get.offAll(() => const Home(), transition: Transition.fadeIn);
    } else if (userLoginStatus['status'] == false &&
        userLoginStatus['connectionAvailable'] == true) {
      // Phone number is not registered ::: Do OTP
      // sendOTP(loginIsSuccessful: false);
      // globals.showToast(phoneNumberStatus['message']);
      globals.showSnackBar(title: 'Error', message: userLoginStatus['message']);
    } else {
      globals.showToast("Check your internet connection");
    }
  }
  // ==============================================================================
  // END CHECK IF USERNAME AND PASSWORD ARE REGISTERED
  // ==============================================================================
}
