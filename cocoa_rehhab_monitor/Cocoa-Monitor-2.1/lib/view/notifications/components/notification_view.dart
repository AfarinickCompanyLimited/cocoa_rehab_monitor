// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/notification_data.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class NotificationView extends StatelessWidget {
  final NotificationData notificationData;
  const NotificationView({Key? key, required this.notificationData})
      : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      print('URL URL:: $url');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalController globalController = Get.find();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppBorderRadius.md),
              topRight: Radius.circular(AppBorderRadius.md)),
        ),
        // padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(width: 40, height: 4, color: AppColor.lightBackground),
            const SizedBox(
              height: 10,
            ),
            Text(
              DateFormat('yMMMMEEEEd').format(notificationData.date),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          '${notificationData.title}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColor.black),
                        ),
                        const SizedBox(height: 10),
                        SelectableLinkify(
                          onOpen: (link) => _launchURL(link.url),
                          text: '${notificationData.message}',
                          style: TextStyle(color: AppColor.black),
                          options: const LinkifyOptions(humanize: false),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topRight,
                          child: CustomButton(
                            isFullWidth: false,
                            backgroundColor: Colors.red.shade50,
                            verticalPadding: 0.0,
                            horizontalPadding: 8.0,
                            // onTap: () => okayTap?.call() ?? Navigator.of(context!).pop(),
                            onTap: () {
                              Get.back();
                              globalController.database!.notificationDao
                                  .deleteNotification(notificationData);
                            },
                            child: const Text('Delete',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13)),
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
