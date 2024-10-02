import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm_status.dart';
import 'package:cocoa_monitor/view/utils/double_value_trimmer.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class FarmStatusCard extends StatelessWidget {
  final FarmStatus farmStatus;
  final Function? onTap;
  const FarmStatusCard({Key? key, required this.farmStatus, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    // GlobalController globalController = Get.find();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
          boxShadow: const [BoxShadow(
            color: Color.fromRGBO(2, 41, 10, 0.08),
            blurRadius: 80,
            offset: Offset(0, -4),
          )]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${farmStatus.farmerName}',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                    ),
                    const SizedBox(height: 2),
                    Text('Ref: ${farmStatus.farmid}',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.black),
                    ),
                  ],
                ),
              ),
              appIconBadgeCheck(color: (farmStatus.area! - farmStatus.areaCovered!) <= 0.0 ? AppColor.primary : AppColor.lightBackground, size: 30),
            ],
          ),
         
          const SizedBox(height: 7),
          Container(
            height: 2,
            width: width * 0.05,
            color: AppColor.black.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            decoration: BoxDecoration(
                color: AppColor.lightText,
                borderRadius: BorderRadius.circular(AppBorderRadius.md)
            ),
            child: Text("${farmStatus.activity}",
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text("Farm\nArea",
                      style: TextStyle(color: AppColor.lightText, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  Text("${farmStatus.area.toString()} ha",
                      style: TextStyle(color: AppColor.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Area\nCovered",
                      style: TextStyle(color: AppColor.lightText, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  Text("${farmStatus.areaCovered?.truncateToDecimalPlaces(3).toString()} ha",
                      style: TextStyle(color: AppColor.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                children: [
                  Text("Area\nRemaining",
                      style: TextStyle(color: AppColor.lightText, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  Text("${(farmStatus.area! - farmStatus.areaCovered!).truncateToDecimalPlaces(3).toString()} ha",
                      style: TextStyle(color: AppColor.black, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}
