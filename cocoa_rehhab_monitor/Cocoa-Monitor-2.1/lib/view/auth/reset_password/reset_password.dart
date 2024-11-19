import 'dart:ui';

import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../global_components/text_input_decoration.dart';
import 'reset_password_controller.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResetPasswordController resetPasswordController =
        Get.put(ResetPasswordController());
    resetPasswordController.resetScreenContext = context;
    // Size size = MediaQuery.of(context).size;

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColor.lightBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: AppColor.lightBackground,
            // height: size.height,
            // height: size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Container(
                //   width: double.infinity,
                //   height: size.height,
                //   decoration: BoxDecoration(
                //       image: DecorationImage(
                //         // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken),
                //         image: AssetImage('assets/images/track_my_tree/forest1.png'),
                //         fit: BoxFit.cover
                //       )
                //   ),
                // ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/cocoa_monitor/cacao_beans.jpg',
                            ),
                            fit: BoxFit.cover)),
                  ),
                ),

                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      alignment: Alignment.center,
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: appMainHorizontalPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "Cocoa Rehab Monitor",
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 25),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                const Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        // color: AppColor.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                // Text('Phone Number',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // SizedBox(height: 5,),
                                Form(
                                  key: resetPasswordController.resetFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: resetPasswordController
                                            .passwordTextController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 20),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Enter new password',
                                          hintStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                          // prefixIcon: _buildFlagsButton(
                                          //   context,
                                          //   loginController
                                          // ),
                                        ),
                                        keyboardType: TextInputType.name,
                                        validator: (String? value) => value!
                                                    .trim()
                                                    .isEmpty ||
                                                value.trim().length < 5
                                            ? "Password must be at least 5 characters long"
                                            : null,
                                      ),

                                      const SizedBox(height: 20),

                                      TextFormField(
                                        controller: resetPasswordController
                                            .passwordConfirmTextController,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 20),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Re-enter your password',
                                          hintStyle: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                          // prefixIcon: _buildFlagsButton(
                                          //   context,
                                          //   loginController
                                          // ),
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (String? value) => value!
                                                    .trim()
                                                    .isEmpty !=
                                                resetPasswordController
                                                    .passwordTextController.text
                                                    .trim()
                                            ? "Password must be at least 5 characters long"
                                            : null,
                                      ),

                                      // IntlPhoneField(
                                      //   controller: loginController.phoneTextController,
                                      //   decoration: InputDecoration(
                                      //       contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //       enabledBorder: inputBorder,
                                      //       focusedBorder: inputBorderFocused,
                                      //       errorBorder: inputBorder,
                                      //       focusedErrorBorder: inputBorderFocused,
                                      //       filled: true,
                                      //       fillColor: Colors.white,
                                      //       hintText: 'Enter your phone number',
                                      //       hintStyle: TextStyle(fontSize: 12, color: Colors.black54)
                                      //   ),
                                      //     validator: (String? value) => value!.trim().isEmpty || value.trim().length < 13 || (value.trim().startsWith('0') && value.trim().length < 14)
                                      //         ? "Valid phone number required"
                                      //         : null,
                                      //   disableLengthCheck: true,
                                      //   showDropdownIcon: false,
                                      //   flagsButtonPadding: EdgeInsets.only(left: 20),
                                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                                      //   initialCountryCode: 'GH',
                                      //   onChanged: (phone) {
                                      //     loginController.phoneNumberWithCountryCode = phone.completeNumber;
                                      //
                                      //     // print(phone.completeNumber);
                                      //   },
                                      // )
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColor.primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    AppBorderRadius.xl))),
                                      ),
                                      onPressed: () {
                                        if (resetPasswordController
                                            .resetFormKey.currentState!
                                            .validate()) {
                                          // loginController.sendOTP(loginController.phoneTextController.text.trim());
                                          // loginController.sendOTP();
                                          resetPasswordController
                                              .resetPassword();
                                        }
                                      },
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        child: Text(
                                          "Change Password",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )),

                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container()
                      ],
                    ),
                  ),
                ),

                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          const Text(
                            'A PRODUCT OF',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black54),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/cocoa_monitor/af_logo.png",
                                fit: BoxFit.contain,
                                height: MediaQuery.of(context).size.width * 0.2,
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                "assets/images/cocoa_monitor/k_logo.png",
                                fit: BoxFit.contain,
                                height: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.07),
                          // Text(
                          //   'Copyright \u00a9 ${now.year}',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
                          // ),
                        ],
                      ),
                    ))

                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.only(bottom: 50),
                //     child: Image.asset('assets/logo/green_ghana_logo.png', height: size.width * 0.13,),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


