import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_rehab_monitor/controller/model/contractor_certificate_of_workdone_verification_model.dart';

class CertificateVerificationCard extends StatelessWidget {
  final ContractorCertificateVerificationModel contractorCertificateVerification;
  final Function? onViewTap;
  final Function? onEditTap;
  final Function? onDeleteTap;
  final bool allowEdit;
  final bool allowDelete;
  const CertificateVerificationCard(
      {super.key,
      required this.contractorCertificateVerification,
      this.onViewTap,
      this.onEditTap,
      this.onDeleteTap,
      required this.allowEdit,
      required this.allowDelete});

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
                child: Text(
                  '${contractorCertificateVerification.farmRefNumber ?? ''}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColor.black),
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
        
        // if (contractorCertificateVerification.contractor != null)
        //   FutureBuilder(
        //       builder: (ctx, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.done) {
        //           if (snapshot.hasError) {
        //             return Center(
        //               child: Text(
        //                 '${snapshot.error} occurred',
        //                 style: const TextStyle(fontSize: 18),
        //               ),
        //             );
        //           } else if (snapshot.hasData) {
        //             List<Contractor> dataList =
        //                 snapshot.data as List<Contractor>;
        //
        //             return Text(dataList.first.contractorName ?? '',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.w600,
        //                     color: AppColor.black));
        //           }
        //         }
        //
        //         // Displaying LoadingSpinner to indicate waiting state
        //         return const Center(
        //           child: Text('...'),
        //         );
        //       },
        //       future: globalController.database!.contractorDao
        //           .findContractorById(
        //               contractorCertificateVerification.contractor!)),
          const SizedBox(height: 10),
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

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Activity activity = dataList[index];

                      return Text(
                        "${activity.mainActivity ?? ''} / ${activity.subActivity ?? ''}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      );
                    },
                  );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return const Center(
                child: Text('...'),
              );
            },
            future: globalController.database!.activityDao
                .findAllActivityWithCodeList(
                    contractorCertificateVerification.activity),
          ),
          const SizedBox(height: 10),
          Text(
            '${contractorCertificateVerification.reportingDate ?? ''}',
            style: TextStyle(color: AppColor.lightText),
          ),
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
                  List<Activity> dataList = snapshot.data as List<Activity>;

                  return Text("${dataList.first.mainActivity ?? ''} / ${dataList.first.subActivity ?? ''}",
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.black)
                  );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return const Center(
                child: Text('...'),
              );
            },data.remove('main_activity');
    data.remove('submission_status');
    data.remove('current_farm_pic');
            future: globalController.database!.activityDao.findActivityByCode(monitor.activity!),
          ),
          const SizedBox(height: 10),
          Text(monitor.monitoringDate ?? '',
              style: TextStyle(color: AppColor.lightText)
          ),*/

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
