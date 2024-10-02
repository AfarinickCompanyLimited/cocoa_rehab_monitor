// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cocoa_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_monitor/view/auth/login/login_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController{

  // LoginController loginController = Get.put(LoginController());
  // IndexController indexController = Get.put(IndexController());
  // TMTIndexController tmtIndexController = Get.put(TMTIndexController());
  LoginController loginController = Get.find();
  GlobalController indexController = Get.find();

  // final auth = FirebaseAuth.instance;
  Globals globals = Globals();
  UserInfoApiInterface userInfoApiInterface = UserInfoApiInterface();

  final registerFormKey = GlobalKey<FormState>();
  var nameTextController = TextEditingController(text: "");
  var emailTextController = TextEditingController(text: "");

  var otpVerificationID;

  var gender = Gender.none.obs;
  // bool _value = false;
  // int genderVal = -1.obs;

  var registerScreenContext;
  // var firstName, lastName, username, phoneNumber;

  /// ==============================================================================
  /// START REGISTER NEW USER ACCOUNT
  /// ==============================================================================
  registerUser() async{

    globals.startWait(registerScreenContext);
    var registrationStatus = await userInfoApiInterface.createAccount(
      {
        'name': nameTextController.text.trim(),
        'phone': loginController.phoneNumber,
        'email': emailTextController.text.trim(),
        'sex': gender.value,
        'country': loginController.country
      });
    globals.endWait(registerScreenContext);

    if(registrationStatus['connectionAvailable'] == true){
      if (registrationStatus['status'] == true){

        var token = registrationStatus['token'];
        globals.startWait(registerScreenContext);
        var userData = await userInfoApiInterface.getUserInfo(token);
        globals.endWait(registerScreenContext);

        if(userData['status'] == true && userData['connectionAvailable'] == true){
          await userInfoApiInterface.saveUserDataToSharedPrefs(userData['userInfo']);
          indexController.userInfo.value = await userInfoApiInterface.retrieveUserInfoFromSharedPrefs();
          indexController.userIsLoggedIn.value = true;
          globals.showToast('Account created successfully');


          // Navigator.of(registerScreenContext)
          //     .pushNamedAndRemoveUntil(route.trackMyTreeIndex, (Route<dynamic> route) => false);
          int count = 0;
          Navigator.of(registerScreenContext).popUntil((_) => count++ >= 2);

        }else{
          globals.showToast('Registration successful, login to continue');
        }

      }else{
        globals.showToast(registrationStatus['message']);
      }
    }else{
      globals.showToast("Check your internet connection");
    }
  }
// ==============================================================================
// END REGISTER NEW USER ACCOUNT
// ==============================================================================


}