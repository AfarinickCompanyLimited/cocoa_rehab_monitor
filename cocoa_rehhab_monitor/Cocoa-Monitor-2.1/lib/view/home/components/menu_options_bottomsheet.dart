import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/view/add_outbreak_farm/add_outbreak_farm.dart';
import 'package:cocoa_monitor/view/add_personnel/add_personnel.dart';
import 'package:cocoa_monitor/view/assign_ra/assign_ra.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/outbreak_farm_history/outbreak_farm_history.dart';
import 'package:cocoa_monitor/view/personnel_assignment_history/personnel_assignment_history.dart';
import 'package:cocoa_monitor/view/personnel_history/personnel_history.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuOptionsBottomSheet extends StatelessWidget {
  final String title;
  final String menuItem;
  const MenuOptionsBottomSheet(
      {Key? key, required this.title, required this.menuItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.md),
            topRight: Radius.circular(AppBorderRadius.md)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), //color of shadow
            spreadRadius: 5, //spread radius
            blurRadius: 7, // blur radius
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: 4,
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColor.black),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            title: const Text(
              'Add New',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            minLeadingWidth: 10,
            leading: appIconAdd(color: AppColor.black, size: 25),
            trailing: appIconAngleRight(color: AppColor.black, size: 20),
            onTap: () {
              Get.back();
              if (menuItem == HomeMenuItem.OutbreakFarm) {
                Get.to(() => const AddOutbreakFarm(),
                    transition: Transition.topLevel);
              } else if (menuItem == HomeMenuItem.Personnel) {
                Get.to(() => const AddPersonnel(),
                    transition: Transition.topLevel);
              } else if (menuItem == HomeMenuItem.AssignPersonnel) {
                Get.to(() => const AssignRA(), transition: Transition.topLevel);
              }
            },
          ),
          Divider(indent: 60, endIndent: AppPadding.horizontal),
          const SizedBox(
            height: 15.0,
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            title: const Text(
              'History',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            minLeadingWidth: 10,
            leading: appIconTimePast(color: AppColor.black, size: 25),
            trailing: appIconAngleRight(color: AppColor.black, size: 20),
            onTap: () {
              Get.back();
              if (menuItem == HomeMenuItem.OutbreakFarm) {
                Get.to(() => const OutbreakFarmHistory(),
                    transition: Transition.topLevel);
              } else if (menuItem == HomeMenuItem.Personnel) {
                Get.to(() => const PersonnelHistory(),
                    transition: Transition.topLevel);
              } else if (menuItem == HomeMenuItem.AssignPersonnel) {
                Get.to(() => const PersonnelAssignmentHistory(),
                    transition: Transition.topLevel);
              }
            },
          ),
          Divider(indent: 60, endIndent: AppPadding.horizontal),
          const SizedBox(
            height: 15.0,
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            title: const Text(
              'Sync Data',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            minLeadingWidth: 10,
            leading: appIconRefresh(color: AppColor.black, size: 25),
            trailing: appIconAngleRight(color: AppColor.black, size: 20),
            onTap: () {
              Get.back();
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
                    if (menuItem == HomeMenuItem.OutbreakFarm) {
                      homeController.syncOutbreakFarmData();
                    } else if (menuItem == HomeMenuItem.Personnel) {
                      homeController.syncPersonnelData();
                    } else if (menuItem == HomeMenuItem.AssignPersonnel) {
                      homeController.syncPersonnelAssignmentData();
                    }
                  },
                  cancelTap: () {
                    Get.back();
                  });
            },
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}


/*
select ob

change monitoring to maintenane
monitor activities
fuel monitor

changr outbre farms to initial treatme

chanfe add new to demarcate farm
monitor it activity (monitoring clone)
fuel reports*/
