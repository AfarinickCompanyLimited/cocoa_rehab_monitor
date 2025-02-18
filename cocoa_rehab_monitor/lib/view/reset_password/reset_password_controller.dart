import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_rehab_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';


class ResetPasswordController extends GetxController {
  BuildContext? resetPasswordScreenContext;

  final newPasswordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  GlobalController indexController = Get.find();

  // final auth = FirebaseAuth.instance;
  Globals globals = Globals();
  UserInfoApiInterface userInfoApiInterface = UserInfoApiInterface();


  resetPassword() async {
    globals.startWait(resetPasswordScreenContext!);
    var resetStatus = await userInfoApiInterface.changePassword({
      'password': newPasswordTextController.text.trim(),
      'confirm_password': confirmPasswordTextController.text.trim(),
    });
    globals.endWait(resetPasswordScreenContext);

    if (resetStatus['connectionAvailable'] == true) {
      if (resetStatus['status'] == true) {
        var token = resetStatus['token'];
        globals.startWait(resetPasswordScreenContext!);
        var userData = await userInfoApiInterface.getUserInfo(token);
        globals.endWait(resetPasswordScreenContext);

        if (userData['status'] == true &&
            userData['connectionAvailable'] == true) {
          await userInfoApiInterface
              .saveUserDataToSharedPrefs(userData['userInfo']);
          indexController.userInfo.value =
          await userInfoApiInterface.retrieveUserInfoFromSharedPrefs();
          indexController.userIsLoggedIn.value = true;
          globals.showToast('Password reset successfully');

          // Navigator.of(registerScreenContext)
          //     .pushNamedAndRemoveUntil(route.trackMyTreeIndex, (Route<dynamic> route) => false);
          int count = 0;
          Navigator.of(resetPasswordScreenContext!).popUntil((_) => count++ >= 2);
        } else {
          globals.showToast('Password reset successful, login to continue');
        }
      } else {
        globals.showToast(resetStatus['message']);
      }
    } else {
      globals.showToast("Check your internet connection");
    }
  }
}