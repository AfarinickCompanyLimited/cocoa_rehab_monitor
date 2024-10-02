import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/calculated_area.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SavedAreaCard extends StatelessWidget {
  final CalculatedArea calculatedArea;
  const SavedAreaCard({Key? key, required this.calculatedArea}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    GlobalController globalController = Get.find();

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
                child: Text(DateFormat('yMMMMEEEEd').format(calculatedArea.date),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13, color: AppColor.black),
                ),
              ),
              // Container(
              //   height: 15,
              //   width: 15,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: AppColor.lightBackground
              //   ),
              // )
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleIconButton(
                  icon: appIconTrash(color: Colors.white, size: 15),
                  size: 35,
                  backgroundColor: Colors.red,
                  onTap: () async {
                    final calculatedAreaDao = globalController.database!.calculatedAreaDao;
                    await calculatedAreaDao.deleteCalculatedArea(calculatedArea);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(calculatedArea.title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColor.black),
          ),
          const SizedBox(height: 5),
          Text(calculatedArea.value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.black),
          ),

        ],
      ),
    );
  }
}
