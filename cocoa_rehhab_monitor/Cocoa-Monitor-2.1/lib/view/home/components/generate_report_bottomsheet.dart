import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/view/reports/generate_detailed_report_form.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../reports/generate_payment_report_form.dart';

class GenerateReportBottomSheet extends StatelessWidget {
  final String title;
  final String menuItem;
  const GenerateReportBottomSheet({
    Key? key,
    required this.title,
    required this.menuItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // HomeController homeController = Get.find();

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
              'Payment Report',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            minLeadingWidth: 10,
            leading: appIconAdd(color: AppColor.black, size: 25),
            trailing: appIconAngleRight(color: AppColor.black, size: 20),
            onTap: () {
              Get.back();
              if (menuItem == HomeMenuItem.report) {
                Get.to(() =>const GeneratePaymentReportForm(),
                    transition: Transition.topLevel);
              }
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            title: const Text(
              'Detailed Report',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            minLeadingWidth: 10,
            leading: appIconAdd(color: AppColor.black, size: 25),
            trailing: appIconAngleRight(color: AppColor.black, size: 20),
            onTap: () {
              Get.back();
              if (menuItem == HomeMenuItem.report) {
                Get.to(() =>const GenerateDetailedReportForm(),
                    transition: Transition.topLevel);
              }
            },
          ),
          
          Divider(indent: 60, endIndent: AppPadding.horizontal),
          const SizedBox(
            height: 15.0,
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
