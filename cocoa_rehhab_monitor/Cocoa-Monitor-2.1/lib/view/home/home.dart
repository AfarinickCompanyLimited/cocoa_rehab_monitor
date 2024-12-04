// import 'dart:math';
//
// import 'package:cocoa_monitor/view/global_components/custom_button.dart';
// import 'package:cocoa_monitor/view/leave_request/leave_request.dart';
// import 'package:cocoa_monitor/view/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/entity/cocoa_rehub_monitor/notification_data.dart';
// import '../../controller/global_controller.dart';
// import '../assigned_farms_map/assigned_farms_map.dart';
// import '../assigned_outbreaks_map/assigned_outbreaks_map.dart';
// import '../global_components/round_icon_button.dart';
// import '../notifications/notifications.dart';
// import '../ra_list/ra_list.dart';
// import '../reports/generate_detailed_report_form.dart';
// import '../reports/generate_payment_report_form.dart';
// import '../submit_issue/submit_issue_tab.dart';
// import '../widgets/main_drawer.dart';
// import 'components/grid_container.dart';
// import 'components/grid_container_2.dart';
// import 'home_controller.dart';
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> with TickerProviderStateMixin {
//   AnimationController? _controller;
//   Animation<double>? _animation;
//   AnimationStatus _animationStatus = AnimationStatus.dismissed;
//
//   final HomeController homeController = Get.put(HomeController());
//   final GlobalController globalController = Get.put(GlobalController());
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 0));
//     _animation = Tween(end: 1.0, begin: 0.0).animate(_controller!)
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         _animationStatus = status;
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     homeController.homeScreenContext = context;
//     final Size screenSize = MediaQuery.of(context).size;
//     final double screenHeight = screenSize.height;
//     final double screenWidth = screenSize.width;
//
//     return Scaffold(
//       backgroundColor: AppColor.xLightBackground,
//       key: homeController.scaffoldKey,
//       drawer: const MainDrawer(),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             /// Main Column to hold all elements vertically
//             Column(
//               children: [
//                 // Header Section
//                 Container(
//                   width: screenWidth,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: AppPadding.horizontal,
//                     vertical: 15,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(30),
//                       bottomRight: Radius.circular(30),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Menu Button
//                       RoundedIconButton(
//                         icon: appIconMenu(color: AppColor.black, size: 17),
//                         size: 45,
//                         backgroundColor: AppColor.white,
//                         onTap: () => homeController.scaffoldKey.currentState!
//                             .openDrawer(),
//                       ),
//                       // Action Buttons
//                       Row(
//                         children: [
//                           // Obx(() {
//                           //   return homeController.isLoadingRAs.value
//                           //       ? Shimmer.fromColors(
//                           //           baseColor: Colors.grey[300]!,
//                           //           highlightColor: Colors.grey[100]!,
//                           //           period: const Duration(milliseconds: 800),
//                           //           child: CircleIconButton(
//                           //             icon: appIconDownload(
//                           //                 color: AppColor.white, size: 20),
//                           //             size: 45,
//                           //             backgroundColor: AppColor.black,
//                           //             hasShadow: false,
//                           //             onTap: () => homeController
//                           //                 .checkAppVersionBeforeSync(),
//                           //           ),
//                           //         )
//                           //       : CircleIconButton(
//                           //           icon: appIconDownload(
//                           //               color: AppColor.white, size: 20),
//                           //           size: 45,
//                           //           backgroundColor: AppColor.black,
//                           //           hasShadow: false,
//                           //           onTap: () => homeController
//                           //               .checkAppVersionBeforeSync(),
//                           //         );
//                           // }),
//                           // const SizedBox(width: 20),
//                           // Notification Button with Badge
//                           Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               CircleIconButton(
//                                 icon: appIconBell(
//                                     color: AppColor.white, size: 20),
//                                 size: 45,
//                                 backgroundColor: AppColor.black,
//                                 hasShadow: false,
//                                 onTap: () => Get.to(() => const Notifications(),
//                                     transition: Transition.fadeIn),
//                               ),
//                               // Notification Badge
//                               GetBuilder<HomeController>(builder: (controller) {
//                                 return notificationStream(globalController);
//                               })
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Greeting Section
//                 Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Row(
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "${homeController.getGreetings()}, ${globalController.userInfo.value.firstName}",
//                               style: TextStyle(
//                                 color: AppColor.black,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               children: [
//                                 Text(
//                                   "${globalController.userInfo.value.staffId}",
//                                   style: TextStyle(
//                                     color: AppColor.black,
//                                   ),
//                                 ),
//                                 Text(" | ",
//                                     style: TextStyle(color: AppColor.black)),
//                                 Text(
//                                   "${globalController.userInfo.value.group}",
//                                   style: TextStyle(
//                                     color: AppColor.black,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         Spacer(),
//                         CircleIconButton(
//                             icon: appIconRefresh(
//                                 color: AppColor.primary, size: 20),
//                             size: 45,
//                             backgroundColor: AppColor.white,
//                             hasShadow: true,
//                             onTap: () => homeController.syncData()),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             /// Bottom Black Container
//             Positioned(
//               bottom: 0,
//               child: Container(
//                 width: screenWidth,
//                 height: screenHeight * 0.6, // Adjust as needed
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   color: AppColor.black,
//                 ),
//                 child: SingleChildScrollView(
//                   physics: AlwaysScrollableScrollPhysics(
//                       parent: BouncingScrollPhysics()),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 180),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Report",
//                                   style: TextStyle(
//                                     color: AppColor.white,
//                                   )),
//                               SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   CustomButton(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.4,
//                                     horizontalPadding: 10,
//                                     isFullWidth: false,
//                                     borderColor: AppColor.white,
//                                     child: Text(
//                                       "Payment",
//                                       style: TextStyle(color: AppColor.white),
//                                     ),
//                                     onTap: () => Get.to(
//                                         () => const GeneratePaymentReportForm(),
//                                         transition: Transition.topLevel),
//                                   ),
//                                   Spacer(),
//                                   CustomButton(
//                                     width:
//                                         MediaQuery.of(context).size.width * 0.4,
//                                     horizontalPadding: 10,
//                                     isFullWidth: false,
//                                     borderColor: AppColor.white,
//                                     child: Text(
//                                       "Detailed",
//                                       style: TextStyle(color: AppColor.white),
//                                     ),
//                                     onTap: () => Get.to(
//                                         () =>
//                                             const GenerateDetailedReportForm(),
//                                         transition: Transition.topLevel),
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             /// Overlapping White Container
//             Positioned(
//               bottom: screenHeight *
//                   0.4, // Positioned above the black container for overlap
//               left: AppPadding.horizontal * 0.5, // Adjust margin from sides
//               right: AppPadding.horizontal * 0.5,
//               child: AnimatedBuilder(
//                 animation: _animation!,
//                 builder: (context, child) {
//                   double rotation = pi * _animation!.value;
//                   bool isSecondHalf = _animation!.value > 0.5;
//
//                   return Transform(
//                     alignment: Alignment.center,
//                     transform: Matrix4.identity()
//                       ..setEntry(3, 2, 0.001) // Adds perspective
//                       ..rotateY(rotation),
//                     child: isSecondHalf
//                         ? Transform(
//                             alignment: Alignment.center,
//                             transform: Matrix4.identity()..rotateY(pi),
//                             child: _buildSecondContainer(),
//                           )
//                         : _buildFirstContainer(),
//                   );
//                 },
//               ),
//             ),
//
//             /// bottom navigation bar
//             Positioned(
//               bottom: 0,
//               child: Container(
//                 padding: EdgeInsets.only(top: 10),
//                 height: 90,
//                 width: screenWidth,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   color: AppColor.white,
//                   // boxShadow: [
//                   //   BoxShadow(
//                   //     color: Colors.grey.withOpacity(0.2),
//                   //     spreadRadius: 2,
//                   //     blurRadius: 5,
//                   //     offset: const Offset(0, 3),
//                   //   ),
//                   // ],
//                 ),
//                 child: Row(
//                   children: [
//                     Spacer(),
//                     Obx(() => Column(
//                           children: [
//                             FloatingActionButton(
//                               tooltip: 'Submit An Issue',
//                               backgroundColor:
//                                   homeController.activeButtonIndex.value == 0
//                                       ? AppColor.black // Active color
//                                       : AppColor.white, // Default color
//                               child: appIconComment(
//                                   color: homeController
//                                               .activeButtonIndex.value ==
//                                           0
//                                       ? AppColor.white // Active icon color
//                                       : AppColor.black, // Default icon color
//                                   size: 25),
//                               onPressed: () {
//                                 homeController.activeButtonIndex.value = 0;
//                                 Get.to(() => const IssueTabScreen(),
//                                     transition: Transition.fadeIn);
//                               },
//                             ),
//                             Text("Issues")
//                           ],
//                         )),
//                     Spacer(),
//                     Obx(() => Column(
//                           children: [
//                             FloatingActionButton(
//                               tooltip: 'Submit Leave Request',
//                               backgroundColor:
//                                   homeController.activeButtonIndex.value == 1
//                                       ? AppColor.black
//                                       : AppColor.white,
//                               child: appIconLeaveRequest(
//                                   color:
//                                       homeController.activeButtonIndex.value ==
//                                               1
//                                           ? AppColor.white
//                                           : AppColor.black,
//                                   size: 25),
//                               onPressed: () {
//                                 homeController.activeButtonIndex.value = 1;
//                                 Get.to(() => const LeaveRequest(),
//                                     transition: Transition.fadeIn);
//                               },
//                             ),
//                             Text("Leave")
//                           ],
//                         )),
//                     Spacer(),
//                     Obx(() => Column(
//                           children: [
//                             FloatingActionButton(
//                               tooltip: 'RA / RT List',
//                               backgroundColor:
//                                   homeController.activeButtonIndex.value == 2
//                                       ? AppColor.black
//                                       : AppColor.white,
//                               child: appIconGroup(
//                                   color:
//                                       homeController.activeButtonIndex.value ==
//                                               2
//                                           ? AppColor.white
//                                           : AppColor.black,
//                                   size: 40),
//                               onPressed: () {
//                                 homeController.activeButtonIndex.value = 2;
//                                 Get.to(() => const RAList(),
//                                     transition: Transition.fadeIn);
//                               },
//                             ),
//                             Text("RA/RT")
//                           ],
//                         )),
//                     Spacer(),
//                     Obx(() => Column(
//                           children: [
//                             FloatingActionButton(
//                               tooltip: 'Log Location',
//                               backgroundColor:
//                                   homeController.activeButtonIndex.value == 3
//                                       ? AppColor.secondary
//                                       : AppColor.secondary,
//                               child: homeController.isLoading.value
//                                   ? CircularProgressIndicator()
//                                   : appIconMarker(
//                                       color: homeController
//                                                   .activeButtonIndex.value ==
//                                               3
//                                           ? AppColor.white
//                                           : AppColor.black,
//                                       size: 25),
//                               onPressed: () {
//                                 homeController.activeButtonIndex.value = 3;
//                                 homeController.globals.newConfirmDialog(
//                                     title: 'Farm Location Data',
//                                     context: context,
//                                     content: const Text(
//                                       'Are you sure you want to save your current location?',
//                                       style: TextStyle(fontSize: 13),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                     okayTap: () async {
//                                       Get.back();
//                                       homeController.saveUserLocation();
//                                     },
//                                     cancelTap: () {
//                                       Get.back();
//                                     });
//                               },
//                             ),
//                             Text("Location")
//                           ],
//                         )),
//                     Spacer(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget notificationStream(GlobalController globalController) {
//     final notificationDao = globalController.database?.notificationDao;
//     if (notificationDao == null) {
//       return const SizedBox.shrink();
//     }
//
//     return StreamBuilder<List<NotificationData>>(
//       stream: notificationDao.findNotificationByReadStream(false),
//       builder: (BuildContext context,
//           AsyncSnapshot<List<NotificationData>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const SizedBox.shrink(); // Handle waiting state
//         }
//         if (snapshot.hasError) {
//           return const SizedBox.shrink(); // Handle error state
//         }
//
//         final notificationCount = snapshot.hasData ? snapshot.data!.length : 0;
//         if (notificationCount > 0) {
//           return Positioned(
//             right: -5,
//             top: -7,
//             child: Container(
//               padding: const EdgeInsets.all(5),
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 notificationCount.toString(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12, // Adjusted font size for better fit
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }
//
//   Widget _buildFirstContainer() {
//     final Size screenSize = MediaQuery.of(context).size;
//     final double screenHeight = screenSize.height;
//     final double screenWidth = screenSize.width;
//     return Container(
//       padding: EdgeInsets.all(10),
//       height: screenHeight * 0.38,
//       width: screenWidth - (AppPadding.horizontal * 2),
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//         color: AppColor.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(children: [
//             /// Initial Treatment
//             GridContainer(
//               label: "Initial\nTreatment",
//               image: "assets/images/cocoa_monitor/chainsaw.png",
//               onTap: () {
//                 homeController.check.value = 0;
//                 homeController.setTitle();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//             ),
//             Spacer(),
//             GridContainer(
//               onTap: () {
//                 homeController.check.value = 1;
//                 homeController.setTitle();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//               gap: 10,
//               label: "Maintenance",
//               image: "assets/images/cocoa_monitor/binoculars.png",
//             ),
//             Spacer(),
//             GridContainer(
//               onTap: () {
//                 homeController.check.value = 2;
//                 homeController.setTitle();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//               gap: 10,
//               label: "Establishment",
//               image: "assets/images/cocoa_monitor/cocoa.png",
//             ),
//           ]),
//           Spacer(),
//           Row(children: [
//             GridContainer(
//               onTap: () {
//                 homeController.check.value = 3;
//                 homeController.setTitle();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//               gap: 10,
//               label: "Contractor's\nCertificate",
//               image: "assets/images/cocoa_monitor/note.png",
//             ),
//             Spacer(),
//             GridContainer(
//               onTap: () {
//                 homeController.check.value = 4;
//                 homeController.setTitle();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//               gap: 10,
//               label: "Map\nFarms",
//               image: "assets/images/farmhouse.png",
//             ),
//             Spacer(),
//             GridContainer(
//               onTap: () {
//                 homeController.check.value = 5;
//                 homeController.setTitle();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//               gap: 10,
//               label: "Verification\nForm",
//               image: "assets/images/cocoa_monitor/note.png",
//             ),
//           ]),
//           Spacer(),
//           Row(children: [
//             GridContainer(
//               onTap: () {
//                 homeController.check.value = 6;
//                 homeController.setTitle();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//               gap: 10,
//               label: "Rehab\nAssistant",
//               image: "assets/images/cocoa_monitor/farmer.png",
//             ),
//             Spacer(),
//             GridContainer(
//               onTap: () {
//                 Get.to(() => const AssignedFarmsMap(),
//                     transition: Transition.fadeIn);
//               },
//               gap: 10,
//               label: "Assigned\nFarms",
//               image: "assets/images/field.png",
//             ),
//             Spacer(),
//             GridContainer(
//               onTap: () {
//                 Get.to(() => const AssignedOutbreaksMap(),
//                     transition: Transition.fadeIn);
//               },
//               gap: 10,
//               label: "Assigned\nOutbreaks",
//               image: "assets/images/outbreak.png",
//             ),
//           ])
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSecondContainer() {
//     final Size screenSize = MediaQuery.of(context).size;
//     final double screenHeight = screenSize.height;
//     final double screenWidth = screenSize.width;
//     return Container(
//       padding: EdgeInsets.all(10),
//       height: screenHeight * 0.38, // Adjust height of the white container
//       width: screenWidth - (AppPadding.horizontal * 2),
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//         color: AppColor.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextButton(
//               onPressed: () {
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//               child: Text(
//                 "Back",
//                 style: TextStyle(color: AppColor.black),
//               )),
//           Spacer(),
//           GetBuilder(
//               init: homeController,
//               builder: (_) {
//                 return Text(
//                   homeController.title.value,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 );
//               }),
//           // Obx(
//           //   () => Text(
//           //     homeController.title.value,
//           //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           //   ),
//           // ),
//           Spacer(),
//           Row(children: [
//             /// Initial Treatment
//             GridContainer2(
//               color: AppColor().primaryMaterial.shade50,
//               borderColor: AppColor.black,
//               label: "Add",
//               icon: Icons.add_circle_outline_sharp,
//               onTap: () {
//                 homeController.navigateToPageForAddingData();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//             ),
//             Spacer(),
//             GridContainer2(
//               color: AppColor().primaryMaterial.shade50,
//               borderColor: AppColor.black,
//               label: "History",
//               icon: Icons.history_rounded,
//               onTap: () {
//                 homeController.navigateToPageForHistory();
//                 if (_animationStatus == AnimationStatus.dismissed) {
//                   _controller!.forward();
//                 } else {
//                   _controller!.reverse();
//                 }
//               },
//             ),
//             Spacer(),
//             GridContainer2(
//               color: AppColor().primaryMaterial.shade50,
//               borderColor: AppColor.black,
//               label: "Sync",
//               icon: Icons.sync_sharp,
//               onTap: () {
//                 homeController.globals.newConfirmDialog(
//                     title: 'Activity Data',
//                     context: context,
//                     content: const Text(
//                       'Are you sure you want to sync data to the server?',
//                       style: TextStyle(fontSize: 13),
//                       textAlign: TextAlign.center,
//                     ),
//                     okayTap: () async {
//                       Get.back();
//                       homeController.syncAllMonitorings();
//                     },
//                     cancelTap: () {
//                       Get.back();
//                     });
//               },
//             ),
//           ]),
//           Spacer(),
//         ],
//       ),
//     );
//   }
// }

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

import '../appraisal/appraisal.dart';
import '../leave_request/leave_request.dart';

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
                            // TileButtonDetached(
                            //     label: "Farm\nStatus",
                            //     backgroundColor: Colors.white,
                            //     foreColor: AppColor.black,
                            //     icon: appIconTractor(
                            //         color: AppColor.black, size: 40),
                            //     onTap: () => Get.to(() => const FarmsStatus(),
                            //         transition: Transition.fadeIn)),
                            // const SizedBox(width: 30),
                            TileButtonDetached(
                                label: "Assigned\nOutbreaks",
                                backgroundColor: Colors.white,
                                foreColor: AppColor.black,
                                icon: appIconLayers(
                                    color: AppColor.black, size: 40),
                                onTap: () => Get.to(
                                    () => const AssignedOutbreaksMap(),
                                    transition: Transition.fadeIn)),
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

                      SizedBox(height: AppPadding.sectionDividerSpace + 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MenuCard2(
                              image: 'assets/images/cocoa_monitor/chainsaw.png',
                              label: '    Initial\nTreatment    ',
                              onTap: () => homeController.showMenuOptions(
                                  AllMomitoringsMenuOptionsBottomSheet(
                                allMonitorings: AllMonitorings.InitialTreatment,
                              )),
                              // onTap: () => homeController.showMenuOptions('Outbreak Farms', HomeMenuItem.OutbreakFarm),
                            ),

                            // SizedBox(height: AppPadding.sectionDividerSpace),

                            MenuCard2(
                              image:
                                  'assets/images/cocoa_monitor/binoculars.png',
                              label: 'Maintenance',
                              onTap: () => homeController.showMenuOptions(
                                  AllMomitoringsMenuOptionsBottomSheet(
                                allMonitorings: AllMonitorings.Maintenance,
                              )),
                              // onTap: () => homeController.showMenuOptions('Maintenance', HomeMenuItem.Monitoring),
                            ),

                            MenuCard2(
                              image: 'assets/images/cocoa_monitor/cocoa.png',
                              label: 'Establishment',
                              onTap: () => homeController.showMenuOptions(
                                  AllMomitoringsMenuOptionsBottomSheet(
                                allMonitorings: AllMonitorings.Establishment,
                              )),
                              // onTap: () => homeController.showMenuOptions('Outbreak Farms', HomeMenuItem.OutbreakFarm),
                            ),
                          ],
                        ),
                      ),

                      Divider(
                        color: AppColor.black.withOpacity(0.2),
                        thickness: 1,
                      ),
                      // SizedBox(height: AppPadding.sectionDividerSpace),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MenuCard2(
                              image:
                                  'assets/images/cocoa_monitor/assignment2.png',
                              label: '   Map Farms   ',
                              onTap: () => homeController.showMenuOptions(
                                  const MapFarmsMenuOptionsBottomSheet()),
                              // onTap: () => homeController.showMenuOptions('Outbreak Farms', HomeMenuItem.OutbreakFarm),
                            ),

                            // SizedBox(height: AppPadding.sectionDividerSpace),
                            MenuCard2(
                              image: 'assets/images/cocoa_monitor/farmer.png',
                              label: 'Rehab Assistant',
                              onTap: () => homeController.showMenuOptions(
                                  MenuOptionsBottomSheet(
                                      title: 'Rehab Assistant',
                                      menuItem: HomeMenuItem.Personnel)),
                              // onTap: () => homeController.showMenuOptions('Rehab Assistant', HomeMenuItem.Personnel),
                            ),

                            MenuCard2(
                                image: 'assets/images/cocoa_monitor/group2.png',
                                label: 'RA / RT List',
                                onTap: () => Get.to(() => const RAList(),
                                    transition: Transition.fadeIn)),
                          ],
                        ),
                      ),

                      Divider(
                        color: AppColor.black.withOpacity(0.2),
                        thickness: 1,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MenuCard2(
                              image: 'assets/images/cocoa_monitor/note.png',
                              label: '    Contractors\nCertificate    ',
                              onTap: () => homeController.showMenuOptions(
                                  const WorkDoneCertificateMenuOptionsBottomSheet()),
                            ),
                            MenuCard2(
                              image: 'assets/images/cocoa_monitor/note.png',
                              label: '    Verification\nForm    ',
                              onTap: () => homeController.showMenuOptions(
                                  const WorkDoneCertificateVerificationMenuOptionsBottomSheet()),
                            ),
                            MenuCard2(
                              image: 'assets/images/cocoa_monitor/history.png',
                              label: 'Generate Report',
                              onTap: () => homeController.showMenuOptions(
                                GenerateReportBottomSheet(
                                    title: 'Generate Report',
                                    menuItem: HomeMenuItem.report),
                              ),
                              // onTap: () => homeController.showMenuOptions('Rehab Assistant', HomeMenuItem.Personnel),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppPadding.sectionDividerSpace),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes space evenly
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.45, // 40% of screen width
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: ()=>Get.to(()=>LeaveRequest(),transition: Transition.fadeIn),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center contents
                                  children: [
                                    Image.asset(
                                      "assets/images/leave-request.png",
                                      width: 25,
                                      color: AppColor.black,
                                    ),
                                    const SizedBox(width: 8), // Add space between icon and text
                                    Text(
                                      "Leave Request",
                                      style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.45, // 40% of screen width
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: GestureDetector(
                                onTap: ()=>Get.to(()=>Appraisal(),transition: Transition.fadeIn),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center, // Center contents
                                  children: [
                                    Image.asset(
                                      "assets/images/appraisal.png",
                                      width: 25,
                                      color: AppColor.black,
                                    ),
                                    const SizedBox(width: 8), // Add space between icon and text
                                    Text(
                                      "Appraisal",
                                      style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )

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
