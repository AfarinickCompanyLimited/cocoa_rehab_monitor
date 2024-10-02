import 'dart:async';
import 'dart:ui';
import 'package:cocoa_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_monitor/view/auth/login/login.dart';
import 'package:cocoa_monitor/view/home/home.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  UserInfoApiInterface userInfoApiInterface = UserInfoApiInterface();
  DateTime now = DateTime.now();

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    var userIsLoggedIn = await userInfoApiInterface.userIsLoggedIn() ?? false;

    if (userIsLoggedIn == true) {
      // Get.offAll(() => Index());
      Get.offAll(() => const Home(), arguments: {});
    } else {
      Get.offAll(() => const Login());
    }

    // final prefs = await SharedPreferences.getInstance();
    // if (prefs.containsKey('byPassIntro') && await prefs.getBool('byPassIntro') == true){
    //
    //   var userIsLoggedIn = await userInfoApiInterface.userIsLoggedIn() ?? false;
    //   if (userIsLoggedIn == true){
    //     // Navigator.of(context).pushReplacementNamed(route.trackMyTreeIndex);
    //     Get.offAll(() => Index());
    //   }else{
    //     // Navigator.of(context).pushReplacementNamed(route.trackMyTreeIndex);
    //     Get.offAll(() => Index());
    //   }
    //
    // }else{
    //   Get.offNamed(route.introScreen);
    // }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarBrightness: Brightness.dark,
    //   statusBarIconBrightness: Brightness.dark,
    // ));

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColor.lightBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColor.lightBackground,
          body: Stack(
            children: [
              // Positioned(
              //   bottom: 0,
              //   right: 0,
              //   left: 0,
              //   child: Image.asset("assets/images/cocoa_monitor/cocoa_beans.jpg"),
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
                // filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: SizedBox(
                            height: 0,
                          ),
                        ),
                        Expanded(
                          // flex: 2,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: "welcomeHero",
                                      child: Image.asset(
                                        "assets/images/cocoa_monitor/cocoa_monitor.png",
                                        fit: BoxFit.contain,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Cocoa Rehab Monitor",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25,
                                          color: AppColor.black),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Expanded(
                          // child: Container(),
                          child: Align(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/cocoa_monitor/af_logo.png",
                                          fit: BoxFit.contain,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                        ),
                                        const SizedBox(width: 10),
                                        Image.asset(
                                          "assets/images/cocoa_monitor/k_logo.png",
                                          fit: BoxFit.contain,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07),
                                    // Text(
                                    //   'Copyright \u00a9 ${now.year}',
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
                                    // ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
