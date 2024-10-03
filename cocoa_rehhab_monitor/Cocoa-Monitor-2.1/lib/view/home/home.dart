import 'dart:math';

import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/leave_request/leave_request.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/entity/cocoa_rehub_monitor/notification_data.dart';
import '../../controller/global_controller.dart';
import '../assigned_farms_map/assigned_farms_map.dart';
import '../assigned_outbreaks_map/assigned_outbreaks_map.dart';
import '../equipments/equipments.dart';
import '../farms_status/farms_status.dart';
import '../global_components/round_icon_button.dart';
import '../global_components/tile_button.dart';
import '../notifications/notifications.dart';
import '../ra_list/ra_list.dart';
import '../reports/generate_detailed_report_form.dart';
import '../reports/generate_payment_report_form.dart';
import '../submit_issue/submit_issue_tab.dart';
import '../widgets/main_drawer.dart';
import 'components/grid_container.dart';
import 'components/grid_container_2.dart';
import 'home_controller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  final HomeController homeController = Get.put(HomeController());
  final GlobalController globalController = Get.put(GlobalController());

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 50));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_controller!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    homeController.homeScreenContext = context;
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: AppColor.xLightBackground,
      key: homeController.scaffoldKey,
      drawer: const MainDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            /// Main Column to hold all elements vertically
            Column(
              children: [
                // Header Section
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.horizontal,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu Button
                      RoundedIconButton(
                        icon: appIconMenu(color: AppColor.black, size: 17),
                        size: 45,
                        backgroundColor: AppColor.white,
                        onTap: () => homeController.scaffoldKey.currentState!
                            .openDrawer(),
                      ),
                      // Action Buttons
                      Row(
                        children: [
                          Obx(() {
                            return homeController.isLoadingRAs.value
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    period: const Duration(milliseconds: 800),
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
                          // Notification Button with Badge
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleIconButton(
                                icon: appIconBell(
                                    color: AppColor.white, size: 20),
                                size: 45,
                                backgroundColor: AppColor.black,
                                hasShadow: false,
                                onTap: () => Get.to(() => const Notifications(),
                                    transition: Transition.fadeIn),
                              ),
                              // Notification Badge
                              GetBuilder<HomeController>(builder: (controller) {
                                return notificationStream(globalController);
                              })
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Greeting Section
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning, Francis",
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "PO105",
                              style: TextStyle(
                                color: AppColor.black,
                              ),
                            ),
                            Text(" | ",
                                style: TextStyle(color: AppColor.black)),
                            Text(
                              "Sankore",
                              style: TextStyle(
                                color: AppColor.black,
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

            /// Bottom Black Container
            Positioned(
              bottom: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.6, // Adjust as needed
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColor.black,
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Report",
                                  style: TextStyle(
                                    color: AppColor.white,
                                  )),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  CustomButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    horizontalPadding: 10,
                                    isFullWidth: false,
                                    borderColor: AppColor.white,
                                    child: Text(
                                      "Payment",
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                    onTap: () => Get.to(
                                        () => const GeneratePaymentReportForm(),
                                        transition: Transition.topLevel),
                                  ),
                                  Spacer(),
                                  CustomButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    horizontalPadding: 10,
                                    isFullWidth: false,
                                    borderColor: AppColor.white,
                                    child: Text(
                                      "Detailed",
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                    onTap: () => Get.to(
                                        () =>
                                            const GenerateDetailedReportForm(),
                                        transition: Transition.topLevel),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Overlapping White Container
            Positioned(
              bottom: screenHeight *
                  0.4, // Positioned above the black container for overlap
              left: AppPadding.horizontal * 0.5, // Adjust margin from sides
              right: AppPadding.horizontal * 0.5,
              child: AnimatedBuilder(
                animation: _animation!,
                builder: (context, child) {
                  double rotation = pi * _animation!.value;
                  bool isSecondHalf = _animation!.value > 0.5;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Adds perspective
                      ..rotateY(rotation),
                    child: isSecondHalf
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: _buildSecondContainer(),
                          )
                        : _buildFirstContainer(),
                  );
                },
              ),
            ),

            /// bottom navigation bar
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                height: 90,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColor.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: const Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Row(
                  children: [
                    Spacer(),
                    Obx(() => Column(
                      children: [
                        FloatingActionButton(
                              tooltip: 'Submit An Issue',
                              backgroundColor:
                                  homeController.activeButtonIndex.value == 0
                                      ? AppColor.black // Active color
                                      : AppColor.white, // Default color
                              child: appIconComment(
                                  color: homeController.activeButtonIndex.value == 0
                                      ? AppColor.white // Active icon color
                                      : AppColor.black, // Default icon color
                                  size: 25),
                              onPressed: () {
                                homeController.activeButtonIndex.value = 0;
                                Get.to(() => const IssueTabScreen(),
                                    transition: Transition.fadeIn);
                              },
                            ),
                        Text("Issues")
                      ],
                    )),
                    Spacer(),
                    Obx(() => Column(
                      children: [
                        FloatingActionButton(
                              tooltip: 'Submit Leave Request',
                              backgroundColor:
                                  homeController.activeButtonIndex.value == 1
                                      ? AppColor.black
                                      : AppColor.white,
                              child: appIconLeaveRequest(
                                  color: homeController.activeButtonIndex.value == 1
                                      ? AppColor.white
                                      : AppColor.black,
                                  size: 25),
                              onPressed: () {
                                homeController.activeButtonIndex.value = 1;
                                Get.to(() => const LeaveRequest(),
                                    transition: Transition.fadeIn);
                              },
                            ),
                        Text("Leave")
                      ],
                    )),
                    Spacer(),
                    Obx(() => Column(
                      children: [
                        FloatingActionButton(
                              tooltip: 'RA / RT List',
                              backgroundColor:
                                  homeController.activeButtonIndex.value == 2
                                      ? AppColor.black
                                      : AppColor.white,
                              child: appIconGroup(
                                  color: homeController.activeButtonIndex.value == 2
                                      ? AppColor.white
                                      : AppColor.black,
                                  size: 40),
                              onPressed: () {
                                homeController.activeButtonIndex.value = 2;
                                Get.to(() => const RAList(),
                                    transition: Transition.fadeIn);
                              },
                            ),
                        Text("RA/RT")
                      ],
                    )),
                    Spacer(),
                    Obx(() => Column(
                      children: [
                        FloatingActionButton(
                              tooltip: 'Log Location',
                              backgroundColor:
                                  homeController.activeButtonIndex.value == 3
                                      ? AppColor.black
                                      : AppColor.white,
                              child: homeController.isLoading.value
                                  ? CircularProgressIndicator()
                                  : appIconMarker(
                                      color:
                                          homeController.activeButtonIndex.value ==
                                                  3
                                              ? AppColor.white
                                              : AppColor.black,
                                      size: 25),
                              onPressed: () {
                                homeController.activeButtonIndex.value = 3;
                                homeController.globals.newConfirmDialog(
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
                                    });
                              },
                            ),
                        Text("Location")
                      ],
                    )),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationStream(GlobalController globalController) {
    final notificationDao = globalController.database?.notificationDao;
    if (notificationDao == null) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<List<NotificationData>>(
      stream: notificationDao.findNotificationByReadStream(false),
      builder: (BuildContext context,
          AsyncSnapshot<List<NotificationData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink(); // Handle waiting state
        }
        if (snapshot.hasError) {
          return const SizedBox.shrink(); // Handle error state
        }

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
                  fontSize: 12, // Adjusted font size for better fit
                  fontWeight: FontWeight.bold,
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

  Widget _buildFirstContainer() {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    return Container(
      padding: EdgeInsets.all(10),
      height: screenHeight * 0.38,
      width: screenWidth - (AppPadding.horizontal * 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(children: [
            /// Initial Treatment
            GridContainer(
              label: "Initial\nTreatment",
              image: "assets/images/cocoa_monitor/chainsaw.png",
              onTap: () {
                homeController.check.value = 0;
                homeController.setTitle();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
            ),
            Spacer(),
            GridContainer(
              onTap: () {
                homeController.check.value = 1;
                homeController.setTitle();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
              gap: 10,
              label: "Maintenance",
              image: "assets/images/cocoa_monitor/binoculars.png",
            ),
            Spacer(),
            GridContainer(
              onTap: () {
                homeController.check.value = 2;
                homeController.setTitle();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
              gap: 10,
              label: "Establishment",
              image: "assets/images/cocoa_monitor/cocoa.png",
            ),
          ]),
          Spacer(),
          Row(children: [
            GridContainer(
              onTap: () {
                homeController.check.value = 3;
                homeController.setTitle();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
              gap: 10,
              label: "Contractor's\nCertificate",
              image: "assets/images/cocoa_monitor/note.png",
            ),
            Spacer(),
            GridContainer(
              onTap: () {
                homeController.check.value = 4;
                homeController.setTitle();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
              gap: 10,
              label: "Map\nFarms",
              image: "assets/images/farmhouse.png",
            ),
            Spacer(),
            GridContainer(
              onTap: () {
                homeController.check.value = 5;
                homeController.setTitle();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
              gap: 10,
              label: "Verification\nForm",
              image: "assets/images/cocoa_monitor/note.png",
            ),
          ]),
          Spacer(),
          Row(children: [
            GridContainer(
              onTap: () {
                homeController.check.value = 6;
                homeController.setTitle();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
              gap: 10,
              label: "Rehab\nAssistant",
              image: "assets/images/cocoa_monitor/farmer.png",
            ),
            Spacer(),
            GridContainer(
              onTap: () {
                Get.to(() => const AssignedFarmsMap(),
                    transition: Transition.fadeIn);
              },
              gap: 10,
              label: "Assigned\nFarms",
              image: "assets/images/field.png",
            ),
            Spacer(),
            GridContainer(
              onTap: () {
                Get.to(() => const AssignedOutbreaksMap(),
                    transition: Transition.fadeIn);
              },
              gap: 10,
              label: "Assigned\nOutbreaks",
              image: "assets/images/outbreak.png",
            ),
          ])
        ],
      ),
    );
  }

  Widget _buildSecondContainer() {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    return Container(
      padding: EdgeInsets.all(10),
      height: screenHeight * 0.38, // Adjust height of the white container
      width: screenWidth - (AppPadding.horizontal * 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
              onPressed: () {
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
              child: Text(
                "Back",
                style: TextStyle(color: AppColor.black),
              )),
          Spacer(),
          GetBuilder(
              init: homeController,
              builder: (_) {
                return Text(
                  homeController.title.value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              }),
          // Obx(
          //   () => Text(
          //     homeController.title.value,
          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          // ),
          Spacer(),
          Row(children: [
            /// Initial Treatment
            GridContainer2(
              color: AppColor().primaryMaterial.shade50,
              borderColor: AppColor.black,
              label: "Add",
              icon: Icons.add_circle_outline_sharp,
              onTap: () {
                homeController.navigateToPageForAddingData();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
            ),
            Spacer(),
            GridContainer2(
              color: AppColor().primaryMaterial.shade50,
              borderColor: AppColor.black,
              label: "History",
              icon: Icons.history_rounded,
              onTap: () {
                homeController.navigateToPageForHistory();
                if (_animationStatus == AnimationStatus.dismissed) {
                  _controller!.forward();
                } else {
                  _controller!.reverse();
                }
              },
            ),
            Spacer(),
            GridContainer2(
              color: AppColor().primaryMaterial.shade50,
              borderColor: AppColor.black,
              label: "Sync",
              icon: Icons.sync_sharp,
              onTap: () {
                homeController.globals.newConfirmDialog(
                    title: 'Activity Data',
                    context: context,
                    content: const Text(
                      'Are you sure you want to sync data to the server?',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    okayTap: () async {
                      Get.back();
                      homeController.syncAllMonitorings();
                    },
                    cancelTap: () {
                      Get.back();
                    });
              },
            ),
          ]),
          Spacer(),
        ],
      ),
    );
  }
}
