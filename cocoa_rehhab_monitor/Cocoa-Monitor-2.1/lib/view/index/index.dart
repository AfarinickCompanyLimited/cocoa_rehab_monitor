/*
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'index_controller.dart';


class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with TickerProviderStateMixin {

  // late AnimationController _fabAnimationController;
  // late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  // late AnimationController _hideBottomBarAnimationController;

  final iconList = [
    {'icon': 'assets/icon/home.svg', 'label': 'Home'},
    {'icon': 'assets/icon/calendar-clock.svg', 'label': 'Monitoring Log'},
    {'icon': 'assets/icon/wifi.svg', 'label': 'Unpublished'},
  ];

  @override
  void initState() {
    super.initState();
    // final systemTheme = SystemUiOverlayStyle.light.copyWith(
    //   systemNavigationBarColor: Colors.white,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    //   statusBarColor: AppColor.lightBackground
    // );
    // SystemChrome.setSystemUIOverlayStyle(systemTheme);
    //
    // _fabAnimationController = AnimationController(
    //   duration: const Duration(milliseconds: 500),
    //   vsync: this,
    // );
    //
    // Future.delayed(
    //   const Duration(seconds: 1),
    //       () => _fabAnimationController.forward(),
    // );
  }


  @override
  Widget build(BuildContext context) {

    IndexController indexController = Get.put(IndexController());
    indexController.indexScreenContext = context;

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColor.lightBackground,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          extendBody: true,
          body: GetBuilder(
              init: indexController,
              builder: (context) {
                return indexController.screens[indexController.bottomNavIndex];
              }
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: GetBuilder(
              init: indexController,
              builder: (context) {
                return AnimatedBottomNavigationBar.builder(
                  itemCount: iconList.length,
                  tabBuilder: (int index, bool isActive) {
                    final color = isActive ? AppColor.primary : AppColor.lightText;
                    const fontSize = 12.0;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          iconList[index]['icon']!,
                          color: color,
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Text(
                            iconList[index]['label']!,
                            // maxLines: 1,
                            style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w600),
                            // group: autoSizeGroup,
                          ),
                        )
                      ],
                    );
                  },
                  height: 70,
                  backgroundColor: Colors.white,
                  activeIndex: indexController.bottomNavIndex,
                  splashColor: AppColor.primary,
                  // notchAndCornersAnimation: borderRadiusAnimation,
                  splashSpeedInMilliseconds: 300,
                  notchSmoothness: NotchSmoothness.softEdge,
                  gapLocation: GapLocation.none,
                  leftCornerRadius: 0,
                  rightCornerRadius: 0,
                  onTap: (index) => setState(() => indexController.bottomNavIndex = index),
                  // hideAnimationController: _hideBottomBarAnimationController,
                  shadow: const BoxShadow(
                    color: Color.fromRGBO(2, 41, 10, 0.08),
                    blurRadius: 80,
                    offset: Offset(0, -4),
                  ),
                );
              }
          ),
        ),
      ),
    );

  }
}
*/