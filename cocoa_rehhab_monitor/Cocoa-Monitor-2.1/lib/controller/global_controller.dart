import 'package:cocoa_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_monitor/controller/database/database.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';

import 'package:get/get.dart';

import 'model/cm_user.dart';

class GlobalController extends GetxController {
  UserInfoApiInterface userInfoApiInterface = UserInfoApiInterface();
  String serverUrl = 'https://cocoarehabmonitor.com';

  late final AppDatabase? database;

  // Rx<UserInfo> userInfo = UserInfo().obs;
  Rx<CmUser> userInfo = CmUser().obs;
  RxBool userIsLoggedIn = false.obs;

  RegionDistrict userRegionDistrict = RegionDistrict();

  buildAppDB() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  }

  loadUserInfo() async {
    userIsLoggedIn.value = await userInfoApiInterface.userIsLoggedIn() ?? false;
    if (userIsLoggedIn.value == true) {
      userInfo.value =
          await userInfoApiInterface.retrieveUserInfoFromSharedPrefs();
    }
  }

  clearSavedTimestamp() async {
    await userInfoApiInterface.clearTimestamp();
  }
}
