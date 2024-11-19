import 'package:cocoa_monitor/view/farm_history/farm_history.dart';
import 'package:cocoa_monitor/view/global_components/tile_button.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/add_map_farm/map_farm.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MapFarmsMenuOptionsBottomSheet extends StatelessWidget {
  const MapFarmsMenuOptionsBottomSheet({Key? key}) : super(key: key);

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
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: Center(
              child: Text(
                'Farm Mapping',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: Text(
              'Farm Data',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColor.black),
            ),
          ),
          Flexible(
              child: Container(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 3
                          : 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.7),
              children: [
                TileButton(
                  label: "Map New",
                  backgroundColor: AppColor().primaryMaterial.shade50,
                  foreColor: AppColor().primaryMaterial,
                  icon: appIconAdd(color: AppColor().primaryMaterial, size: 20),
                  onTap: () {
                    Get.back();
                    Get.to(() => const MapNewFarm(),
                        transition: Transition.topLevel);
                  },
                ),
                TileButton(
                  label: "History",
                  backgroundColor: AppColor().primaryMaterial.shade50,
                  foreColor: AppColor().primaryMaterial,
                  icon: appIconTimePast(
                      color: AppColor().primaryMaterial, size: 20),
                  onTap: () {
                    Get.back();
                    Get.to(() => const MapFarmHistory(),
                        transition: Transition.topLevel);
                  },
                ),
                TileButton(
                  label: "Sync Data",
                  backgroundColor: AppColor().primaryMaterial.shade50,
                  foreColor: AppColor().primaryMaterial,
                  icon: appIconRefresh(
                      color: AppColor().primaryMaterial, size: 20),
                  onTap: () {
                    Get.back();
                    homeController.globals.newConfirmDialog(
                        title: 'Mapped Farms Data',
                        context: context,
                        content: const Text(
                          'Are you sure you want to sync data to the server?',
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        okayTap: () async {
                          Get.back();
                          homeController.syncMapFarmData();
                          //// TrueKing changed
                        },
                        cancelTap: () {
                          Get.back();
                        });
                  },
                ),
              ],
            ),
          )),
          const SizedBox(
            height: 10.0,
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
