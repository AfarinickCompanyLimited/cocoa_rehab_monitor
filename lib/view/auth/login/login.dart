import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/reset_password/reset_password.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    loginController.loginScreenContext = context;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.black,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
                padding: EdgeInsets.all(AppPadding.horizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Cocoa Rehab Monitor",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppBorderRadius.md),
                      topRight: Radius.circular(AppBorderRadius.md)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login to access your account",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Form(
                        key: loginController.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("username"),
                            TextFormField(
                              controller: loginController.phoneTextController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: AppColor.primary,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                enabledBorder: inputBorder,
                                focusedBorder: inputBorderFocused,
                                errorBorder: inputBorder,
                                focusedErrorBorder: inputBorderFocused,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Enter your phone number',
                                hintStyle: const TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (String? value) =>
                                  value!.trim().isEmpty
                                      ? "username is required"
                                      : null,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("password"),
                            Obx(
                              () => TextFormField(
                                obscureText: loginController.showPassword.value,
                                controller:
                                    loginController.passwordTextController,
                                decoration: InputDecoration(
                                  suffixIcon: loginController.showPassword.value
                                      ? IconButton(
                                          onPressed: () {
                                            loginController.showPassword.value =
                                                false;
                                            loginController.update();
                                          },
                                          icon: Icon(Icons.visibility))
                                      : IconButton(
                                          onPressed: () {
                                            loginController.showPassword.value =
                                                true;
                                            loginController.update();
                                          },
                                          icon: Icon(Icons.visibility_off)),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: AppColor.primary,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  enabledBorder: inputBorder,
                                  focusedBorder: inputBorderFocused,
                                  errorBorder: inputBorder,
                                  focusedErrorBorder: inputBorderFocused,
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                                //keyboardType: TextInputType.phone,
                                validator: (String? value) =>
                                    value!.trim().isEmpty
                                        ? "Password is required"
                                        : null,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.to(() => ResetPassword());
                                },
                                child: Text("Reset Password", style: TextStyle(
                                  color: AppColor.black, fontWeight: FontWeight.bold
                                ),))
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                              //foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppBorderRadius.xl))),
                            ),
                            onPressed: () {
                              print(
                                  'PHONE NUMBER::::: ${loginController.phoneTextController}');
                              if (loginController.loginFormKey.currentState!
                                  .validate()) {
                                print('PHONE VERIFICATION STARTED');
                                // loginController.sendOTP(loginController.phoneTextController.text.trim());
                                // loginController.sendOTP();
                                // loginController
                                //     .lookupUsernamePassword();
                                loginController.lookupUsernamePassword();
                                print('PHONE VERIFICATION HAS ENDED');
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/cocoa_monitor/af_logo.png",
                            fit: BoxFit.contain,
                            height: 80,
                          ),
                          Image.asset(
                            "assets/images/cocoa_monitor/k_logo.png",
                            fit: BoxFit.contain,
                            height: 80,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
