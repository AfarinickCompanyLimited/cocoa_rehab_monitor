import 'package:cocoa_monitor/view/about/about.dart';
import 'package:cocoa_monitor/view/auth/login/login.dart';
import 'package:cocoa_monitor/view/auth/register/register.dart';
import 'package:cocoa_monitor/view/intro/intro.dart';
import 'package:cocoa_monitor/view/splash_screen/splash_screen.dart';
import 'package:cocoa_monitor/view/user_account/user_account.dart';
import 'package:flutter/material.dart';


const String splashScreen = 'splash';
const String loginScreen = 'login';
const String registerScreen = 'register';
const String userAccountScreen = 'userAccount';
const String trackMyTreeIndex = 'trackMyTreeIndex';
const String aboutScreen = 'aboutScreen';
const String introScreen = 'introScreen';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case splashScreen:
      return MaterialPageRoute(builder: (context) => const Splash());
    case introScreen:
      return MaterialPageRoute(builder: (context) => const IntroScreen());
    case loginScreen:
      return MaterialPageRoute(builder: (context) => const Login());
    case registerScreen:
      return MaterialPageRoute(builder: (context) => const Register());
    case userAccountScreen:
      return MaterialPageRoute(builder: (context) => const UserAccount());
    case aboutScreen:
      return MaterialPageRoute(builder: (context) => const About());
    default:
      throw('This route name does not exit');
  }
}

