import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialTreatmentMonitoringCard extends StatelessWidget {
  final InitialTreatmentMonitor monitor;
  final Function? onViewTap;
  final Function? onEditTap;
  final Function? onDeleteTap;
  final bool allowEdit;
  final bool allowDelete;
  const InitialTreatmentMonitoringCard(
      {Key? key,
      required this.monitor,
      this.onViewTap,
      this.onEditTap,
      this.onDeleteTap,
      required this.allowEdit,
      required this.allowDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    GlobalController globalController = Get.find();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(2, 41, 10, 0.08),
              blurRadius: 80,
              offset: Offset(0, -4),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:
                    /* FutureBuilder(
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );

                      } else if (snapshot.hasData) {
                        List<OutbreakFarmFromServer> dataList = snapshot.data as List<OutbreakFarmFromServer>;
                        if (dataList.isNotEmpty) {
                          return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(dataList.first.farmerName ?? '',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                            ),
                            const SizedBox(height: 2),
                            Text('Code: ${dataList.first.outbreaksId ?? ''}',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.black),
                            ),
                          ],
                        );
                        }
                      }
                    }

                    // Displaying LoadingSpinner to indicate waiting state
                    return const Center(
                      child: Text('...'),
                    );
                  },
                  // future: globalController.database!.outbreakFarmFromServerDao.findOutbreakFarmFromServerByFarmId(monitor.farmTblForeignkey.toString()),
                ),*/

                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      monitor.farmRefNumber ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColor.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Farm Size: ${monitor.farmSizeHa ?? ''} Ha',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColor.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.lightText,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md)),
                child: const Text(
                  "Completed Task",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            height: 2,
            width: width * 0.05,
            color: AppColor.black.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          FutureBuilder(
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<Activity> dataList = snapshot.data as List<Activity>;

                  return Column(
                    children: [
                      Text(
                          "${dataList.first.mainActivity ?? ''} / ${dataList.first.subActivity ?? ''}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColor.black)),
                      const Text(
                        "Completed Task",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return const Center(
                child: Text('...'),
              );
            },
            future: globalController.database!.activityDao
                .findActivityByCode(monitor.activity!),
          ),
          const SizedBox(height: 10),
          Text(monitor.monitoringDate ?? '',
              style: TextStyle(color: AppColor.lightText)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleIconButton(
                  icon: appIconEye(color: Colors.white, size: 17),
                  size: 45,
                  backgroundColor: AppColor.primary,
                  onTap: () => onViewTap!(),
                ),
              ),
              if (allowEdit)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: CircleIconButton(
                    icon: appIconEdit(color: Colors.white, size: 17),
                    size: 45,
                    backgroundColor: AppColor.black,
                    onTap: () => onEditTap!(),
                  ),
                ),
              if (allowDelete)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: CircleIconButton(
                    icon: appIconTrash(color: Colors.white, size: 17),
                    size: 45,
                    backgroundColor: Colors.red,
                    onTap: () => onDeleteTap!(),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
