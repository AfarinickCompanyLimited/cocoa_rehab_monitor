import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/equipment.dart';
// import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'equipment_bottomsheet.dart';

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final Function? onTap;
  const EquipmentCard({Key? key, required this.equipment, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    // GlobalController globalController = Get.find();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        showModalBottomSheet<void>(
          elevation: 5,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppBorderRadius.md),
            ),
          ),
          context: context,
          builder: (context) {
            return EquipmentBottomSheet(equipment: equipment);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
            boxShadow: const [ BoxShadow(
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
                  child: Text('${equipment.equipment}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  decoration: BoxDecoration(
                      color: AppColor.lightText,
                      borderRadius: BorderRadius.circular(AppBorderRadius.md)
                  ),
                  child: Text("${equipment.status}",
                      style: const TextStyle(color: Colors.white, fontSize: 12)
                  ),
                ),
              ],
            ),

           const SizedBox(height: 2),
            Text('${equipment.equipmentCode}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.lightText),
            ),

           /* SizedBox(height: 7),
            Container(
              height: 2,
              width: width * 0.05,
              color: AppColor.black.withOpacity(0.3),
            ),*/
           const SizedBox(height: 8),
            Text("${equipment.staffName}",
                style: const TextStyle(fontSize: 13)
            ),
          const  SizedBox(height: 3,),
            Text(DateFormat('yMMMMEEEEd').format(equipment.dateOfCapturing),
              style: TextStyle(fontSize: 12, color: AppColor.lightText, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
