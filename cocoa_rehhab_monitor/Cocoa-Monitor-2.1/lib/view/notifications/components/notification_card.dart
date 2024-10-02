import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/notification_data.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationData notificationData;
  final Function? onTap;
  const NotificationCard({Key? key, required this.notificationData, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;


    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
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
                  child: Text(DateFormat('yMMMMEEEEd').format(notificationData.date),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.black),
                  ),
                ),
                // appIconBadgeCheck(color: AppColor.primary, size: 30),
                Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: notificationData.read! ? AppColor.lightBackground : AppColor.primary
                  ),
                )
              ],
            ),

            const SizedBox(height: 8),
            Text('${notificationData.title}',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColor.black),
            ),

          ],
        ),
      ),
    );
  }
}
