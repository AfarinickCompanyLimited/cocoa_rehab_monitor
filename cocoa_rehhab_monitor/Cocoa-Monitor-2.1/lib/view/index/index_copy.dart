// import 'package:cocoa_monitor/view/utils/style.dart';
// import 'package:cocoa_monitor/view/widgets/main_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
//
// import 'index_controller.dart';
//
//
// class Index extends StatelessWidget {
//   const Index({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     IndexController indexController = Get.put(IndexController());
//     indexController.indexScreenContext = context;
//
//     return Scaffold(
//       key: indexController.scaffoldKey,
//       drawer: MainDrawer(),
//       body: PersistentTabView(
//         context,
//         backgroundColor: AppColor.lightBackground,
//         navBarHeight: 66,
//         controller: indexController.controller,
//         screens: indexController.buildScreens(),
//         items: indexController.navItems(),
//         confineInSafeArea: true,
//         onItemSelected: (index) => indexController.getTabIndex(index),
//         handleAndroidBackButtonPress: true,
//         resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
//         stateManagement: true,
//         hideNavigationBarWhenKeyboardShows: true,
//         decoration: NavBarDecoration(
//           // borderRadius: BorderRadius.circular(10.0),
//           colorBehindNavBar: Colors.white,
//         ),
//         popAllScreensOnTapOfSelectedTab: true,
//         popActionScreens: PopActionScreensType.all,
//         itemAnimationProperties: ItemAnimationProperties(
//           // Navigation Bar's items animation properties.
//           duration: Duration(milliseconds: 200),
//           curve: Curves.ease,
//         ),
//         screenTransitionAnimation: ScreenTransitionAnimation(
//           // Screen transition animation on change of selected tab.
//           animateTabTransition: true,
//           curve: Curves.ease,
//           duration: Duration(milliseconds: 200),
//         ),
//         navBarStyle: NavBarStyle.simple,
//         // navBarStyle: NavBarStyle.style8,
//       ),
//     );
//   }
// }
