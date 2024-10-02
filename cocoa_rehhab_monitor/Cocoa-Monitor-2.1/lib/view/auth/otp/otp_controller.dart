import 'package:cocoa_monitor/view/auth/login/login_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_monitor/view/routes.dart' as route;

class OTPController extends GetxController {
  late BuildContext otpScreenContext;
  final auth = FirebaseAuth.instance;
  Globals globals = Globals();

  bool? loginIsSuccessful;

  // TMTIndexController tmtIndexController = Get.find();

  // ============================================================================
  // START VERIFY OTP  ====================================================
  // ============================================================================
  Future verifyOTPCode(smsCode) async {
    globals.startWait(otpScreenContext);
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: Get.find<LoginController>().otpVerificationID,
      smsCode: smsCode,
    );
    // ADD AWAIT HERE
    auth.signInWithCredential(credential).then((user) async {
      globals.endWait(otpScreenContext);
      globals.showToast('Verification successful');

      if (loginIsSuccessful! == true) {
        // Get.offAll(() => Index(), transition: Transition.fadeIn);
        Get.offAll(() => const Home(), transition: Transition.fadeIn);
        // tmtIndexController.loadInitialData();
        // int count = 0;
        // Navigator.of(otpScreenContext).popUntil((_) => count++ >= 2);
      } else {
        Navigator.pushReplacementNamed(otpScreenContext, route.registerScreen);
      }

      // if (registrationIsSuccessful != false){
      //   if (registrationIsSuccessful["status"] == true){
      //     await saveToSharedPrefs(registrationIsSuccessful["data"]);
      //     Navigator.of(otpScreenContext).pushAndRemoveUntil<void>(
      //       MaterialPageRoute<void>(builder: (BuildContext context) => ChooseAccountType(userId: registrationIsSuccessful["data"],)
      //       ),
      //       ModalRoute.withName(route.chooseAccountType),
      //     );
      //   }else{
      //     globals.showToast(registrationIsSuccessful["msg"]);
      //   }
      // }else{
      //   globals.showToast('Something went wrong, retry');
      // }
    }).catchError((e) {
      globals.endWait(otpScreenContext);
      globals.showSnackBar(
          title: 'Error', message: 'Invalid verification code');
      // globals.showToast('Invalid verification code');
    });
  }
  // ============================================================================
  // END VERIFY OTP  ====================================================
  // ============================================================================
}
