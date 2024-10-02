import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/notification_data.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/assigned_farms_map/assigned_farms_map.dart';
import 'package:cocoa_monitor/view/assigned_outbreaks_map/assigned_outbreaks_map.dart';
import 'package:cocoa_monitor/view/equipments/equipments.dart';
import 'package:cocoa_monitor/view/farms_status/farms_status.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/global_components/tile_button.dart';
import 'package:cocoa_monitor/view/home/components/generate_report_bottomsheet.dart';
import 'package:cocoa_monitor/view/home/components/initial_treatment_options_bottomsheet.dart';
import 'package:cocoa_monitor/view/home/components/map_farms_options_bottomsheet.dart';
import 'package:cocoa_monitor/view/home/components/menu_card2.dart';
import 'package:cocoa_monitor/view/home/components/menu_options_bottomsheet.dart';
import 'package:cocoa_monitor/view/home/components/workdone_certificate_options_bottomsheet.dart';
import 'package:cocoa_monitor/view/home/components/workdone_verification_options_bottomsheet.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/notifications/notifications.dart';
import 'package:cocoa_monitor/view/ra_list/ra_list.dart';
import 'package:cocoa_monitor/view/submit_issue/submit_issue_tab.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:cocoa_monitor/view/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  GeneralCocoaRehabApiInterface generalCocoaRehabApiInterface =
  GeneralCocoaRehabApiInterface();
  GlobalController globalController = Get.find();
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      generalCocoaRehabApiInterface.syncUserLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    homeController.homeScreenContext = context;
    // IndexController indexController = Get.find();

    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

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
          key: homeController.scaffoldKey,
          drawer: const MainDrawer(),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Padding(
                  padding: MediaQuery.of(context).orientation ==
                      Orientation.landscape
                      ? const EdgeInsets.only(left: 80.0)
                      : const EdgeInsets.all(0.0),
                  child: FloatingActionButton(
                      tooltip: 'Submit An Issue',
                      backgroundColor: Colors.green,
                      child: appIconComment(color: AppColor.white, size: 25),
                      onPressed: () {
                        Get.to(() => const IssueTabScreen(),
                            transition: Transition.fadeIn);
                      }),
                ),
              ),
              Obx(
                    () => FloatingActionButton(
                    heroTag: null,
                    tooltip: 'Log Location',
                    backgroundColor: homeController.isLoading.value
                        ? Colors.white
                        : Colors.red,
                    child: homeController.isLoading.value
                        ? CircularProgressIndicator()
                        : appIconMarker(color: AppColor.white, size: 25),
                    onPressed: () => homeController.globals.newConfirmDialog(
                        title: 'Farm Location Data',
                        context: context,
                        content: const Text(
                          'Are you sure you want to save your current location?',
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        okayTap: () async {
                          Get.back();
                          homeController.saveUserLocation();
                        },
                        cancelTap: () {
                          Get.back();
                        })),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //     decoration: const BoxDecoration(
              //         color: Colors.green,
              //         borderRadius: BorderRadius.only(
              //             bottomLeft: Radius.circular(20),
              //             bottomRight: Radius.circular(20))),
              //             child: Column(children: const [

              //             ]),
              //             ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 15,
                    bottom: 10,
                    left: AppPadding.horizontal,
                    right: AppPadding.horizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedIconButton(
                      icon: appIconMenu(color: AppColor.black, size: 17),
                      size: 45,
                      backgroundColor: AppColor.white,
                      onTap: () =>
                          homeController.scaffoldKey.currentState!.openDrawer(),
                    ),
                    Row(
                      children: [
                        // TextButton(
                        //   onPressed: () => throw Exception(),
                        //   child: const Text("Throw Test Exception"),
                        // ),
                        Obx(() {
                          return homeController.isLoadingRAs.value
                              ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            period: Duration(milliseconds: 800),
                            child: CircleIconButton(
                              icon: appIconDownload(
                                  color: AppColor.white, size: 20),
                              size: 45,
                              backgroundColor: AppColor.black,
                              hasShadow: false,
                              onTap: () => homeController
                                  .checkAppVersionBeforeSync(),
                            ),
                          )
                              : CircleIconButton(
                            icon: appIconDownload(
                                color: AppColor.white, size: 20),
                            size: 45,
                            backgroundColor: AppColor.black,
                            hasShadow: false,
                            onTap: () => homeController
                                .checkAppVersionBeforeSync(),
                          );
                        }),
                        const SizedBox(width: 20),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleIconButton(
                              icon:
                              appIconBell(color: AppColor.white, size: 20),
                              size: 45,
                              backgroundColor: AppColor.black,
                              hasShadow: false,
                              onTap: () => Get.to(() => const Notifications(),
                                  transition: Transition.fadeIn),
                            ),
                            GetBuilder(
                                init: homeController,
                                builder: (context) {
                                  return notificationStream(globalController);
                                })
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 50, top: 10),
                  // padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal, bottom: 50, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: AppPadding.horizontal,
                            right: AppPadding.horizontal),
                        child: Text(
                            'Welcome ${globalController.userInfo.value.firstName}, - ${globalController.userInfo.value.staffId}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColor.black)),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(
                            left: AppPadding.horizontal,
                            right: AppPadding.horizontal),
                        child: Text(
                          'Continue where you left off',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.black),
                        ),
                      ),
                      SizedBox(height: AppPadding.sectionDividerSpace),

                      SizedBox(
                        height: 130,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            SizedBox(width: AppPadding.horizontal),
                            TileButtonDetached(
                              label: "Calculate\nArea",
                              backgroundColor: Colors.white,
                              foreColor: AppColor.black,
                              icon:
                              appIconRuler(color: AppColor.black, size: 40),
                              onTap: () =>
                                  homeController.usePolygonDrawingTool(),
                            ),
                            const SizedBox(width: 30),
                            TileButtonDetached(
                                label: "Assigned\nFarms",
                                backgroundColor: Colors.white,
                                foreColor: AppColor.black,
                                icon: appIconSeedlingInHand(
                                    color: AppColor.black, size: 40),
                                onTap: () => Get.to(
                                        () => const AssignedFarmsMap(),
                                    transition: Transition.fadeIn)),
                            const SizedBox(width: 30),
                            TileButtonDetached(
                                label: "Farm\nStatus",
                                backgroundColor: Colors.white,
                                foreColor: AppColor.black,
                                icon: appIconTractor(
                                    color: AppColor.black, size: 40),
                                onTap: () => Get.to(() => const FarmsStatus(),
                                    transition: Transition.fadeIn)),
                            const SizedBox(width: 30),
                            TileButtonDetached(
                                label: "Assigned\nOutbreaks",
                                backgroundColor: Colors.white,
                                foreColor: AppColor.black,
                                icon: appIconLayers(
                                    color: AppColor.black, size: 40),
                                onTap: () => Get.to(
                                        () => const AssignedOutbreaksMap(),
                                    transition: Transition.fadeIn)),
                            /*SizedBox(width: 30),
                              TileButtonDetached(
                                  label: "RA\nList",
                                  backgroundColor: Colors.white,
                                  foreColor: AppColor.black,
                                  icon: appIconRAList(color: AppColor.black, size: 40),
                                  onTap: () => Get.to(() => RAList(), transition: Transition.fadeIn)
                              ),*/
                            // SizedBox(width: 30),
                            // TileButtonDetached(
                            //     label: "Generate\nReport",
                            //     backgroundColor: Colors.white,
                            //     foreColor: AppColor.black,
                            //     icon: appIconDownloadCSV(
                            //         color: AppColor.black, size: 40),
                            //     onTap: () => Get.to(() => FarmCSV(),
                            //         transition: Transition.fadeIn)),
                            const SizedBox(width: 30),
                            TileButtonDetached(
                                label: "Equipment\nList",
                                backgroundColor: Colors.white,
                                foreColor: AppColor.black,
                                icon: appIconKnife(
                                    color: AppColor.black, size: 40),
                                onTap: () => Get.to(() => const EquipmentList(),
                                    transition: Transition.fadeIn)),
                            SizedBox(width: AppPadding.horizontal),
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       TileButtonDetached(
                      //         label: "Calculate\nArea",
                      //         backgroundColor: Colors.white,
                      //         foreColor: AppColor.black,
                      //         icon: appIconRuler(color: AppColor.black, size: 40),
                      //         onTap: () => homeController.usePolygonDrawingTool(),
                      //       ),
                      //       SizedBox(width: 30),
                      //       TileButtonDetached(
                      //         label: "Assigned\nFarms",
                      //         backgroundColor: Colors.white,
                      //         foreColor: AppColor.black,
                      //         icon: appIconSeedlingInHand(color: AppColor.black, size: 40),
                      //           onTap: () => Get.to(() => AssignedFarmsMap(), transition: Transition.fadeIn)
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       TileButtonDetached(
                      //           label: "Farm\nStatus",
                      //           backgroundColor: Colors.white,
                      //           foreColor: AppColor.black,
                      //           icon: appIconTractor(color: AppColor.black, size: 40),
                      //           onTap: () => Get.to(() => FarmsStatus(), transition: Transition.fadeIn)
                      //       ),
                      //       SizedBox(width: 30),
                      //       TileButtonDetached(
                      //           label: "Farm\nStatus",
                      //           backgroundColor: Colors.white,
                      //           foreColor: AppColor.black,
                      //           icon: appIconTractor(color: AppColor.black, size: 40),
                      //           onTap: () => Get.to(() => FarmsStatus(), transition: Transition.fadeIn)
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      SizedBox(height: AppPadding.sectionDividerSpace + 10),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/chainsaw.png',
                          label: 'Initial Treatment',
                          onTap: () => homeController.showMenuOptions(
                              AllMomitoringsMenuOptionsBottomSheet(
                                allMonitorings: AllMonitorings.InitialTreatment,
                              )),
                          // onTap: () => homeController.showMenuOptions('Outbreak Farms', HomeMenuItem.OutbreakFarm),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/binoculars.png',
                          label: 'Maintenance',
                          onTap: () => homeController.showMenuOptions(
                              AllMomitoringsMenuOptionsBottomSheet(
                                allMonitorings: AllMonitorings.Maintenance,
                              )),
                          // onTap: () => homeController.showMenuOptions('Maintenance', HomeMenuItem.Monitoring),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/cocoa.png',
                          label: 'Establishment',
                          onTap: () => homeController.showMenuOptions(
                              AllMomitoringsMenuOptionsBottomSheet(
                                allMonitorings: AllMonitorings.Establishment,
                              )),
                          // onTap: () => homeController.showMenuOptions('Outbreak Farms', HomeMenuItem.OutbreakFarm),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/assignment2.png',
                          label: 'Map Farms',
                          onTap: () => homeController.showMenuOptions(
                              const MapFarmsMenuOptionsBottomSheet()),
                          // onTap: () => homeController.showMenuOptions('Outbreak Farms', HomeMenuItem.OutbreakFarm),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/note.png',
                          label: 'Contractors Certificate  ',
                          onTap: () => homeController.showMenuOptions(
                              const WorkDoneCertificateMenuOptionsBottomSheet()),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/note.png',
                          label: 'Verification Form  ',
                          onTap: () => homeController.showMenuOptions(
                              const WorkDoneCertificateVerificationMenuOptionsBottomSheet()),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/farmer.png',
                          label: 'Rehab Assistant',
                          onTap: () => homeController.showMenuOptions(
                              MenuOptionsBottomSheet(
                                  title: 'Rehab Assistant',
                                  menuItem: HomeMenuItem.Personnel)),
                          // onTap: () => homeController.showMenuOptions('Rehab Assistant', HomeMenuItem.Personnel),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                            image: 'assets/images/cocoa_monitor/group2.png',
                            label: 'RA / RT List',
                            onTap: () => Get.to(() => const RAList(),
                                transition: Transition.fadeIn)),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/history.png',
                          label: 'Generate Report',
                          onTap: () => homeController.showMenuOptions(
                            GenerateReportBottomSheet(
                                title: 'Generate Report',
                                menuItem: HomeMenuItem.report),
                          ),
                          // onTap: () => homeController.showMenuOptions('Rehab Assistant', HomeMenuItem.Personnel),
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      /*Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                        child: MenuCard2(
                          image: 'assets/images/cocoa_monitor/farmer1.png',
                          label: 'Assign Rehab Assistant',
                          onTap: () => homeController.showMenuOptions('Assign Rehab Assistant', HomeMenuItem.AssignPersonnel),
                        ),
                      ),
                      SizedBox(height: AppPadding.sectionDividerSpace),*/

                      /*Padding(
                        padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
                                  boxShadow: [const BoxShadow(
                                    color: Color.fromRGBO(2, 41, 10, 0.08),
                                    blurRadius: 80,
                                    offset: Offset(0, -4),
                                  )]
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/cocoa_monitor/digger.png',
                                          height: width * 0.15
                                      ),
                                      SizedBox(width: 15),
                                      Text('Initial Treatment',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                            child: Text(
                                              'History',
                                              style: TextStyle(color: AppColor.black, fontSize: 14),
                                            ),
                                            isFullWidth: true,
                                            backgroundColor: AppColor.black.withOpacity(0.1),
                                            verticalPadding: 0.0,
                                            horizontalPadding: 8.0,
                                            onTap: () => Get.to(() => OutbreakFarmHistory(), transition: Transition.fadeIn)
                                            // onTap: () {}
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                          icon: appIconRefresh(color: AppColor.primary, size: 20),
                                          size: 45,
                                          backgroundColor:  AppColor.white,
                                          hasShadow: true,
                                          // onTap: () => homeController.syncMonitoringData()
                                          onTap: () {}
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                          icon: appIconPlus(color: AppColor.white, size: 20),
                                          size: 45,
                                          backgroundColor:  AppColor.primary,
                                          hasShadow: true,
                                          onTap: () => Get.to(() => AddOutbreakFarm(), transition: Transition.fadeIn)
                                          // onTap: (){}
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
                                  boxShadow: [const BoxShadow(
                                    color: Color.fromRGBO(2, 41, 10, 0.08),
                                    blurRadius: 80,
                                    offset: Offset(0, -4),
                                  )]
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/cocoa_monitor/espionage.png',
                                          height: width * 0.15
                                      ),
                                      SizedBox(width: 15),
                                      Text('Monitoring',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          child: Text(
                                            'History',
                                            style: TextStyle(color: AppColor.black, fontSize: 14),
                                          ),
                                          isFullWidth: true,
                                          backgroundColor: AppColor.black.withOpacity(0.1),
                                          verticalPadding: 0.0,
                                          horizontalPadding: 8.0,
                                            onTap: () => Get.to(() => MonitoringHistory(), transition: Transition.fadeIn)
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                          icon: appIconRefresh(color: AppColor.primary, size: 20),
                                          size: 45,
                                          backgroundColor:  AppColor.white,
                                          hasShadow: true,
                                          onTap: () => homeController.syncMonitoringData()
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                          icon: appIconPlus(color: AppColor.white, size: 20),
                                          size: 45,
                                          backgroundColor:  AppColor.primary,
                                          hasShadow: true,
                                          onTap: () => Get.to(() => AddMonitoringRecord(), transition: Transition.fadeIn)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
                                boxShadow: [const BoxShadow(
                                  color: Color.fromRGBO(2, 41, 10, 0.08),
                                  blurRadius: 80,
                                  offset: Offset(0, -4),
                                )]
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/cocoa_monitor/group2.png',
                                          height: width * 0.15
                                      ),
                                      SizedBox(width: 15),
                                      Text('Personnel',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          child: Text(
                                            'History',
                                            style: TextStyle(color: AppColor.black, fontSize: 14),
                                          ),
                                          isFullWidth: true,
                                          backgroundColor: AppColor.black.withOpacity(0.1),
                                          verticalPadding: 0.0,
                                          horizontalPadding: 8.0,
                                            onTap: () => Get.to(() => PersonnelHistory(), transition: Transition.fadeIn)
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                          icon: appIconRefresh(color: AppColor.primary, size: 20),
                                          size: 45,
                                          backgroundColor:  AppColor.white,
                                          hasShadow: true,
                                          onTap: () => homeController.syncPersonnelData()
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                        icon: appIconPlus(color: AppColor.white, size: 20),
                                        size: 45,
                                        backgroundColor:  AppColor.primary,
                                        hasShadow: true,
                                          onTap: () => Get.to(() => AddPersonnel(), transition: Transition.fadeIn)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
                                  boxShadow: [const BoxShadow(
                                    color: Color.fromRGBO(2, 41, 10, 0.08),
                                    blurRadius: 80,
                                    offset: Offset(0, -4),
                                  )]
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/cocoa_monitor/assignment.png',
                                          height: width * 0.15
                                      ),
                                      SizedBox(width: 15),
                                      Text('Assign Personnel',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          child: Text(
                                            'History',
                                            style: TextStyle(color: AppColor.black, fontSize: 14),
                                          ),
                                          isFullWidth: true,
                                          backgroundColor: AppColor.black.withOpacity(0.1),
                                          verticalPadding: 0.0,
                                          horizontalPadding: 8.0,
                                            onTap: () => Get.to(() => PersonnelAssignmentHistory(), transition: Transition.fadeIn)
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                          icon: appIconRefresh(color: AppColor.primary, size: 20),
                                          size: 45,
                                          backgroundColor:  AppColor.white,
                                          hasShadow: true,
                                          onTap: () => homeController.syncPersonnelAssignmentData()
                                      ),
                                      SizedBox(width: 30),
                                      CircleIconButton(
                                          icon: appIconPlus(color: AppColor.white, size: 20),
                                          size: 45,
                                          backgroundColor:  AppColor.primary,
                                          hasShadow: true,
                                          onTap: () => Get.to(() => AssignRA(), transition: Transition.fadeIn)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationStream(GlobalController globalController) {
    final notificationDao = globalController.database!.notificationDao;
    return StreamBuilder<List<NotificationData>>(
      stream: notificationDao.findNotificationByReadStream(false),
      builder: (BuildContext context,
          AsyncSnapshot<List<NotificationData>> snapshot) {
        final notificationCount = snapshot.hasData ? snapshot.data!.length : 0;
        if (notificationCount > 0) {
          return Positioned(
            right: -5,
            top: -7,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}