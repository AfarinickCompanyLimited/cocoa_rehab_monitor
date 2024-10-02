// ignore_for_file: use_build_context_synchronously

import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexController extends GetxController{

  late BuildContext indexScreenContext;

  var bottomNavIndex = 0;

  List screens = [
    const Home(),
    const Home(),
    const Home(),
  ];

  var loadingInitialData = true.obs;

  GeneralCocoaRehabApiInterface generalCocoaRehabApiInterface = GeneralCocoaRehabApiInterface();
  Globals globals = Globals();

  @override
  void onInit() async {

    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      syncData();
    });

  }


  syncData() async{
    if (await ConnectionVerify.connectionIsAvailable()) {
      loadingInitialData.value = true;
      globals.startWait(indexScreenContext);
      // var futures = 
      await Future.wait([
        generalCocoaRehabApiInterface.loadActivities(),
        generalCocoaRehabApiInterface.loadFarms(),
        generalCocoaRehabApiInterface.loadRegionDistricts(),
        generalCocoaRehabApiInterface.loadRehabAssistants(),
      ]);
      globals.endWait(indexScreenContext);
      loadingInitialData.value = false;
    }
  }

}

