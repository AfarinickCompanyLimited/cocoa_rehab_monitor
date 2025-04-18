import 'package:cocoa_rehab_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_rehab_monitor/view/appraisal/appraisal.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/leave_request/leave_request.dart';
import 'package:cocoa_rehab_monitor/view/saved_area_calculations/saved_area_calculations.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/view/equipments/equipments.dart';
import 'package:cocoa_rehab_monitor/view/farms_status/farms_status.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalController indexController = Get.find();

    HomeController homeController = Get.find();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    ListTile(
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${indexController.userInfo.value.firstName!} ${indexController.userInfo.value.lastName!}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),

                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'Submit Recorded Locations',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      minLeadingWidth: 10,
                      leading: appIconMarker(color: AppColor.black, size: 25),
                      onTap: () {
                        Navigator.of(context).pop();
                        homeController.syncRecordedLocations();
                      },
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.lightText
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Calculate Area',
                              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                            ),
                            minLeadingWidth: 10,
                            leading: appIconRuler(
                                color: Colors.black, size: 25),
                            onTap: () {
                              Navigator.of(context).pop();
                              Get.to(() => homeController.usePolygonDrawingTool(),
                                  transition: Transition.fadeIn);
                            },
                          ),
                          ListTile(
                            title: const Text(
                              'Calculated Area List',
                              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                            ),
                            minLeadingWidth: 10,
                            leading: appIconRuler(color: Colors.black, size: 25),
                            onTap: () {
                              Navigator.of(context).pop();
                              Get.to(() => const SavedAreaCalculations(),
                                  transition: Transition.fadeIn);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        'Farm Status',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      minLeadingWidth: 10,
                      leading: appIconTractor(
                          color: AppColor.black, size: 25),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => const FarmsStatus(),
                            transition: Transition.fadeIn);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Equipment List',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      minLeadingWidth: 10,
                      leading: appIconKnife(
                        color: AppColor.black, size: 25),
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => const EquipmentList(),
                            transition: Transition.fadeIn);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        'Appraisal',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      minLeadingWidth: 10,
                      leading: Image.asset("assets/images/appraisal.png", width: 25, color: AppColor.black,),
                      onTap: () {Navigator.of(context).pop();
                      Get.to(() => const Appraisal(),
                          transition: Transition.fadeIn);},
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        'Leave Request',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      minLeadingWidth: 10,
                      leading: Image.asset("assets/images/leave-request.png",  width: 25, color: AppColor.black,),
                      onTap: () {Navigator.of(context).pop();
                      Get.to(() => const LeaveRequest(),
                          transition: Transition.fadeIn);},
                    ),
                    const Divider(),

                    ListTile(
                      title: const Text(
                        'Logout',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      minLeadingWidth: 10,
                      leading: appIconSignOut(color: AppColor.black, size: 25),
                      onTap: () {
                        Navigator.of(context).pop();
                        UserInfoApiInterface().logout();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Build No. ${Build.buildNumber}',
                    style: TextStyle(
                        color: AppColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPress: () {
                    Navigator.of(context).pop();
                    homeController.showEnterDebugScreenPasscode();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.black,
                        border: Border(
                            top:
                                BorderSide(color: AppColor.primary, width: 3))),
                    child: Column(
                      children: [
                        const Text(
                          "Cocoa Rehab Monitor",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 6),
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
                        const SizedBox(height: 6),
                        Text(
                          '\u00a9 Copyright ${currentYear()}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  currentYear() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy');
    String year = formatter.format(now);
    return year;
  }

  shareApp() {
    String toShare =
        "Download the Cocoa Rehab Monitor App now on Google Play Store : \nhttp://play.google.com/store/apps/details?id=com.afarinick.kumad.cocoamonitor";
    Share.share(toShare);
  }

  // void _launchMailClient() async {
  //   const mailUrl = 'mailto:info@afarinic.com?subject=Cocoa Rehab Monitor: SUPPORT';
  //   try {
  //     await launchUrl(Uri.parse(mailUrl));
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
