import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/initial_treatment_monitoring_history/initial_treatment_monitoring_history_controller.dart';
import 'package:cocoa_rehab_monitor/view/submit_issue/sumbit_issue.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'issue_history.dart';

class IssueTabScreen extends StatefulWidget {
  const IssueTabScreen({Key? key}) : super(key: key);

  @override
  State<IssueTabScreen> createState() => _IssueTabScreenState();
}

class _IssueTabScreenState extends State<IssueTabScreen>
    with SingleTickerProviderStateMixin {
  InitialTreatmentMonitoringHistoryController submitIssueTabScreenController =
      Get.put(InitialTreatmentMonitoringHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    // submitIssueTabScreenController.pendingRecordsController
    //     .addPageRequestListener((pageKey) {
    //   submitIssueTabScreenController.fetchData(
    //       status: SubmissionStatus.pending,
    //       pageKey: pageKey,
    //       controller: submitIssueTabScreenController.pendingRecordsController);
    // });
    //
    // submitIssueTabScreenController.submittedRecordsController
    //     .addPageRequestListener((pageKey) {
    //   submitIssueTabScreenController.fetchData(
    //       status: SubmissionStatus.submitted,
    //       pageKey: pageKey,
    //       controller:
    //           submitIssueTabScreenController.submittedRecordsController);
    // });

    submitIssueTabScreenController.tabController =
        TabController(length: 2, vsync: this);
    submitIssueTabScreenController.tabController!.addListener(() {
      submitIssueTabScreenController.activeTabIndex.value =
          submitIssueTabScreenController.tabController!.index;
    });
    super.initState();
  }

  @override
  void dispose() {
    submitIssueTabScreenController.pendingRecordsController.dispose();
    submitIssueTabScreenController.submittedRecordsController.dispose();
    submitIssueTabScreenController.tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    submitIssueTabScreenController.monitoringHistoryScreenContext = context;

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
                SizedBox(
                  // decoration: BoxDecoration(
                  //   border: Border(bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)))
                  // ),
                  child: Padding(
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
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text('Issues Panel',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black)),
                        ),
                      ],
                    ),
                  ),
                ),

                // SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppColor.lightText.withOpacity(0.5)))),
                  child: Obx(
                    () => TabBar(
                      onTap: (index) {
                        submitIssueTabScreenController.activeTabIndex.value =
                            index;
                      },
                      labelColor: AppColor.black,
                      unselectedLabelColor: Colors.black87,
                      indicatorSize: TabBarIndicatorSize.label,
                      // indicator: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      //     color: AppColor.primary
                      // ),
                      indicator: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                              bottom: BorderSide(
                                  width: 3.0, color: AppColor.primary))),
                      controller: submitIssueTabScreenController.tabController,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Send Issue',
                              style: TextStyle(
                                  fontWeight: submitIssueTabScreenController
                                              .activeTabIndex.value ==
                                          0
                                      ? FontWeight.bold
                                      : FontWeight.w400),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'History',
                              style: TextStyle(
                                  fontWeight: submitIssueTabScreenController
                                              .activeTabIndex.value ==
                                          1
                                      ? FontWeight.bold
                                      : FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: submitIssueTabScreenController.tabController,
                    children: const [
                      SubmitIssue(),
                      IssueHistory(),
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
}
