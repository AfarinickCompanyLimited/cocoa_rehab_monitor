import 'dart:ui';

import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register_controller.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    RegisterController registerController = Get.put(RegisterController());
    registerController.registerScreenContext = context;
    Size size = MediaQuery.of(context).size;


    return Container(
      color: Colors.white,
      // height: size.height,
      // height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [

          Container(
            width: double.infinity,
            height: size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstOut),
                    // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    image: const AssetImage('assets/images/track_my_tree/forest1.png'),
                    fit: BoxFit.none
                )
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Scaffold(
              backgroundColor: Colors.transparent,

              body: Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: appMainHorizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: registerController.registerFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text("Green Ghana Tracker",
                                    style: TextStyle(
                                      color: appColorPrimary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5,),
                                const Center(
                                  child: Text('Sign Up',
                                    style: TextStyle(
                                      // color: appColorPrimary,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30,),
                                const Text('Name',
                                  style: TextStyle(fontWeight: FontWeight.w500 ),
                                ),
                                const SizedBox(height: 5,),
                                TextFormField(
                                  controller: registerController.nameTextController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorderFocused,
                                      errorBorder: inputBorder,
                                      focusedErrorBorder: inputBorderFocused,
                                      filled: true,
                                      fillColor: Colors.white,
                                      // fillColor: appColorInputBackgroundWhite,
                                      hintText: 'Enter your name',
                                      hintStyle: const TextStyle(fontSize: 12, color: Colors.black54)
                                  ),
                                  keyboardType: TextInputType.name,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.toString().trim() == "" || value!.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 15,),

                                const Text('Email Address',
                                  style: TextStyle(fontWeight: FontWeight.w500 ),
                                ),
                                const SizedBox(height: 5,),
                                TextFormField(
                                  controller: registerController.emailTextController,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorderFocused,
                                      errorBorder: inputBorder,
                                      focusedErrorBorder: inputBorderFocused,
                                      filled: true,
                                      // fillColor: appColorInputBackgroundWhite,
                                      fillColor: Colors.white,
                                      hintText: 'Enter your email',
                                      hintStyle: const TextStyle(fontSize: 12, color: Colors.black54)
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (!GetUtils.isEmail(value!)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 15,),

                                const Text('Gender',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5,),
                                Obx(() => Row(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                          value: Gender.male,
                                          groupValue: registerController.gender.value,
                                          onChanged: (value) {
                                            registerController.gender.value = value.toString();
                                          },
                                          activeColor: Colors.green,
                                        ),
                                        GestureDetector(
                                            onTap: () => registerController.gender.value = Gender.male,
                                            child: const Text('Male')
                                        )
                                      ],
                                    ),

                                    const SizedBox(width: 12,),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Radio(
                                          value: Gender.female,
                                          groupValue: registerController.gender.value,
                                          onChanged: (value) {
                                            registerController.gender.value = value.toString();
                                            // registerController.genderVal = int.parse(value.toString());
                                          },
                                          activeColor: Colors.green,
                                        ),
                                        GestureDetector(
                                            onTap: () => registerController.gender.value = Gender.female,
                                            child: const Text('Female')
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                ),

                                Obx(() => registerController.gender.value == Gender.none ?
                                    Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text('Please select your gender',
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: Colors.red
                                      )
                                    ),
                                  ) : Container(),
                                ),


                                // SizedBox(height: 30,),

                                // Container(
                                //     width: double.infinity,
                                //     child: TextButton(
                                //       child: Padding(
                                //         padding: EdgeInsets.symmetric(vertical: 5.0),
                                //         child: Text(
                                //           "Sign Up",
                                //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                //         ),
                                //       ),
                                //       style: TextButton.styleFrom(
                                //         backgroundColor: appColorPrimary,
                                //         primary: Colors.white,
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.xl))),
                                //       ),
                                //       onPressed: () {
                                //         registerController.sendOTP(registerController.phoneTextController.text);
                                //       },
                                //     )),
                                //
                                // SizedBox(height: 30,),

                              ],
                            ),
                          ),


                          const SizedBox(height: 30,),

                          SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: appColorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.xl))),
                                ),
                                onPressed: () {
                                  if (registerController.registerFormKey.currentState!.validate() &&
                                      registerController.gender.value != Gender.none) {
                                    registerController.registerUser();
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),

                          // Container(
                          //     width: double.infinity,
                          //     child: TextButton(
                          //       child: Padding(
                          //         padding: EdgeInsets.symmetric(vertical: 5.0),
                          //         child: Text(
                          //           "Login",
                          //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          //         ),
                          //       ),
                          //       style: TextButton.styleFrom(
                          //         backgroundColor: appColorPrimary,
                          //         primary: Colors.white,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.xl))),
                          //       ),
                          //       onPressed: () {
                          //         if (loginController.loginFormKey.currentState!.validate()) {
                          //           // loginController.sendOTP(loginController.phoneTextController.text.trim());
                          //           // loginController.sendOTP();
                          //           loginController.lookupPhoneNumber();
                          //         }
                          //       },
                          //     )),

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
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Image.asset('assets/logo/green_ghana_logo.png', height: size.width * 0.13,),
            ),
          )

        ],
      ),
    );


  }
}


var inputBorder =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 0.2, color: appColorPrimary.withOpacity(0.5))
);

var inputBorderFocused =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: appColorPrimary)
);

var inputBorderError =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: appColorPrimary)
);