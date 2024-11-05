import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor_certificate_verification.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/model/contractor_certificate_of_workdone_model.dart';
import '../edit_certificate_verification/edit_certificate_verification_record.dart';
import 'components/certificate_verification_card.dart';
import 'certificate_verification_history_controller.dart';

class CertificateVerificationHistory extends StatefulWidget {
  const CertificateVerificationHistory({Key? key}) : super(key: key);

  @override
  State<CertificateVerificationHistory> createState() => _CertificateVerificationHistoryState();
}

class _CertificateVerificationHistoryState extends State<CertificateVerificationHistory>
    with SingleTickerProviderStateMixin {
  final CertificateVerificationHistoryController certificateVerificationHistoryController =
  Get.put(CertificateVerificationHistoryController());
  final GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    certificateVerificationHistoryController.pendingRecordsController
        .addPageRequestListener((pageKey) {
      certificateVerificationHistoryController.fetchData(
          status: SubmissionStatus.pending,
          pageKey: pageKey,
          controller: certificateVerificationHistoryController.pendingRecordsController);
    });

    certificateVerificationHistoryController.submittedRecordsController
        .addPageRequestListener((pageKey) {
      certificateVerificationHistoryController.fetchData(
          status: SubmissionStatus.submitted,
          pageKey: pageKey,
          controller: certificateVerificationHistoryController.submittedRecordsController);
    });

    certificateVerificationHistoryController.tabController =
        TabController(length: 2, vsync: this);
    certificateVerificationHistoryController.tabController!.addListener(() {
      certificateVerificationHistoryController.activeTabIndex.value = certificateVerificationHistoryController.tabController!.index;
    });
  }

  @override
  void dispose() {
    certificateVerificationHistoryController.pendingRecordsController.dispose();
    certificateVerificationHistoryController.submittedRecordsController.dispose();
    certificateVerificationHistoryController.tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    certificateVerificationHistoryController.certificateVerificationHistoryScreenContext = context;

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColor.lightBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColor.lightBackground,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 15,
                      left: AppPadding.horizontal,
                      right: AppPadding.horizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedIconButton(
                        icon: appIconBack(color: AppColor.black, size: 25),
                        size: 45,
                        backgroundColor: Colors.transparent,
                        onTap: () => Get.back(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Certificate Verification History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)),
                    ),
                  ),
                  child: Obx(
                        () => TabBar(
                      onTap: (index) {
                        certificateVerificationHistoryController.activeTabIndex.value = index;
                      },
                      labelColor: AppColor.black,
                      unselectedLabelColor: Colors.black87,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(bottom: BorderSide(width: 3.0, color: AppColor.primary)),
                      ),
                      controller: certificateVerificationHistoryController.tabController,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Submitted',
                              style: TextStyle(
                                fontWeight: certificateVerificationHistoryController.activeTabIndex.value == 0
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Pending',
                              style: TextStyle(
                                fontWeight: certificateVerificationHistoryController.activeTabIndex.value == 1
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: certificateVerificationHistoryController.tabController,
                    children: [
                      buildCertificateData(certificateVerificationHistoryController.db.getSubmittedData(), allowEdit: false),
                      buildCertificateData(certificateVerificationHistoryController.db.getPendingData()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCertificateData(Future<List<ContractorCertificateVerificationModel>>? future, {bool allowEdit = true}) {
    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return CertificateVerificationCard(
                  contractorCertificateVerification: item,
                  onViewTap: () => Get.to(
                        () => EditCertificateVerificationRecord(contractorCertificateVerification: item, isViewMode: true),
                    transition: Transition.fadeIn,
                  ),
                  onEditTap: () {
                    Get.to(
                          () => EditCertificateVerificationRecord(contractorCertificateVerification: item, isViewMode: false),
                      transition: Transition.fadeIn,
                    )?.then((data) {
                      if (data != null) {
                        var item = data['CertificateVerification'];
                        bool submitted = data['submitted'];

                        final index = certificateVerificationHistoryController.pendingRecordsController.itemList?.indexWhere((p) => p.uid == item.uid);
                        if (index != -1) {
                          if (submitted) {
                            certificateVerificationHistoryController.pendingRecordsController.itemList!.remove(item);
                            certificateVerificationHistoryController.update(['pendingRecordsBuilder']);
                            certificateVerificationHistoryController.submittedRecordsController.refresh();
                          } else {
                            certificateVerificationHistoryController.pendingRecordsController.itemList![index!] = item;
                            certificateVerificationHistoryController.update(['pendingRecordsBuilder']);
                          }
                        }
                      }
                    });
                  },
                  onDeleteTap: () => certificateVerificationHistoryController.confirmDeleteMonitoring(item),
                  allowDelete: true,
                  allowEdit: allowEdit,
                );
              },
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset('assets/images/cocoa_monitor/empty-box.png', width: 60),
                const SizedBox(height: 20),
                Text(
                  "No data found",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
