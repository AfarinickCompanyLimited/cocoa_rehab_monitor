import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/controller/model/activity_data_model.dart';
import 'package:cocoa_monitor/view/edit_initial_treatment_monitoring_record/edit_initial_treatment_monitoring_record.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/db/initail_activity_db.dart';
import 'components/initial_treatment_monitoring_card.dart';
import 'initial_treatment_monitoring_history_controller.dart';

class InitialTreatmentMonitoringHistory extends StatefulWidget {
  //final String allMonitorings;

  const InitialTreatmentMonitoringHistory({
    Key? key,
    //required this.allMonitorings,
  }) : super(key: key);

  @override
  State<InitialTreatmentMonitoringHistory> createState() =>
      _InitialTreatmentMonitoringHistoryState();
}

class _InitialTreatmentMonitoringHistoryState
    extends State<InitialTreatmentMonitoringHistory>
    with SingleTickerProviderStateMixin {
  InitialTreatmentMonitoringHistoryController
      initialTreatmentMonitoringHistoryController =
      Get.put(InitialTreatmentMonitoringHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    initialTreatmentMonitoringHistoryController.tabController =
        TabController(length: 2, vsync: this);
    initialTreatmentMonitoringHistoryController.tabController!.addListener(() {
      initialTreatmentMonitoringHistoryController.activeTabIndex.value =
          initialTreatmentMonitoringHistoryController.tabController!.index;
    });
    super.initState();
  }


  Future<void> _refreshData() async {
    setState(() {});
    //await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    initialTreatmentMonitoringHistoryController.pendingRecordsController
        .dispose();
    initialTreatmentMonitoringHistoryController.submittedRecordsController
        .dispose();
    initialTreatmentMonitoringHistoryController.tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initialTreatmentMonitoringHistoryController.monitoringHistoryScreenContext =
        context;

    initialTreatmentMonitoringHistoryController.fetchData();

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
                          child: Text('Activity Data History',
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
                        initialTreatmentMonitoringHistoryController
                            .activeTabIndex.value = index;
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
                      controller: initialTreatmentMonitoringHistoryController
                          .tabController,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Submitted',
                              style: TextStyle(
                                  fontWeight:
                                      initialTreatmentMonitoringHistoryController
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
                              'Pending',
                              style: TextStyle(
                                  fontWeight:
                                      initialTreatmentMonitoringHistoryController
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
                    controller: initialTreatmentMonitoringHistoryController
                        .tabController,
                    children: [
                      RefreshIndicator(
                        onRefresh: () =>
                            _refreshData(),
                        child: FutureBuilder(
                          future: initialTreatmentMonitoringHistoryController
                              .db.getSubmittedData(),
                          builder: (ctx, snapshot) {
                            return _buildListView(ctx, snapshot as AsyncSnapshot<List<InitialTreatmentMonitorModel>>);
                          },
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: () =>
                            _refreshData(),
                        child: FutureBuilder(
                          future: initialTreatmentMonitoringHistoryController
                              .db.getPendingData(),
                          builder: (ctx, snapshot) {
                            return _buildListView(ctx, snapshot as AsyncSnapshot<List<InitialTreatmentMonitorModel>>);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /*GetBuilder(
                    init: initialTreatmentMonitoringHistoryController,
                    builder: (context) {
                      return Expanded(
                        child: TabBarView(
                          controller: initialTreatmentMonitoringHistoryController.tabController,
                          children: [

                            personnelStream(globalController, initialTreatmentMonitoringHistoryController, SubmissionStatus.submitted),

                            personnelStream(globalController, initialTreatmentMonitoringHistoryController, SubmissionStatus.pending),

                          ],
                        ),
                      );
                    }
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildListView(
      BuildContext ctx, AsyncSnapshot<List<InitialTreatmentMonitorModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColor.primary,
        ),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Something went wrong: ${snapshot.error}',
          style: TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (snapshot.hasData) {
      final data = snapshot.data!;

      if (data.isEmpty) {
        return Center(
          child: Text(
            'No records found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        itemBuilder: (ctx, index) {
          return InitialTreatmentMonitoringCard(
            monitor: data[index],
            onViewTap: () => Get.to(
                    () =>
                    EditInitialTreatmentMonitoringRecord(
                      monitor: data[index],
                      isViewMode: true,
                      // allMonitorings:
                      //     widget.allMonitorings,
                    ),
                transition: Transition.fadeIn),
            onEditTap: () {
              Get.to(
                      () =>
                      EditInitialTreatmentMonitoringRecord(
                        monitor: data[index],
                        isViewMode: false,
                        // allMonitorings:
                        //     widget.allMonitorings,
                      ),
                  transition: Transition.fadeIn);
            },
            onDeleteTap: () =>
               confirmDeleteMonitoring(data[index]),
            allowDelete: true,
            allowEdit: data[index].status==SubmissionStatus.pending,
          );
        },
        separatorBuilder: (ctx, index) {
          return SizedBox(height: 10);
        },
        itemCount: data.length,
      );
    }

    return Center(
      child: Text(
        'No data available.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
  confirmDeleteMonitoring(InitialTreatmentMonitorModel monitor) async {
    initialTreatmentMonitoringHistoryController.globals.primaryConfirmDialog(
        context: initialTreatmentMonitoringHistoryController.monitoringHistoryScreenContext,
        title: 'Delete Record',
        image: 'assets/images/cocoa_monitor/question.png',
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
              "This action is irreversible. Are you sure you want to delete this record?",
              textAlign: TextAlign.center),
        ),
        cancelTap: () {
          Get.back();
        },
        okayTap: () {
          final db = InitialTreatmentMonitorDatabaseHelper.instance;
          Get.back();
          db.deleteData(monitor.uid!);
          setState(() {

          });
        });
  }
}

