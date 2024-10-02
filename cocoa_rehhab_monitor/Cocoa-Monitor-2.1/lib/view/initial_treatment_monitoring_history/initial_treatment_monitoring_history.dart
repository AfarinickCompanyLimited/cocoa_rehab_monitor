import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/edit_initial_treatment_monitoring_record/edit_initial_treatment_monitoring_record.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'components/initial_treatment_monitoring_card.dart';
import 'initial_treatment_monitoring_history_controller.dart';

class InitialTreatmentMonitoringHistory extends StatefulWidget {
  final String allMonitorings;

  const InitialTreatmentMonitoringHistory({
    Key? key,
    required this.allMonitorings,
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
    initialTreatmentMonitoringHistoryController.pendingRecordsController
        .addPageRequestListener((pageKey) {
      initialTreatmentMonitoringHistoryController.fetchData(
        status: SubmissionStatus.pending,
        pageKey: pageKey,
        controller: initialTreatmentMonitoringHistoryController
            .pendingRecordsController,
      );
    });

    initialTreatmentMonitoringHistoryController.submittedRecordsController
        .addPageRequestListener((pageKey) {
      initialTreatmentMonitoringHistoryController.fetchData(
          status: SubmissionStatus.submitted,
          pageKey: pageKey,
          controller: initialTreatmentMonitoringHistoryController
              .submittedRecordsController);
    });

    initialTreatmentMonitoringHistoryController.tabController =
        TabController(length: 2, vsync: this);
    initialTreatmentMonitoringHistoryController.tabController!.addListener(() {
      initialTreatmentMonitoringHistoryController.activeTabIndex.value =
          initialTreatmentMonitoringHistoryController.tabController!.index;
    });
    super.initState();
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
                          child: Text('All Monitoring History',
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
                      GetBuilder(
                          init: initialTreatmentMonitoringHistoryController,
                          builder: (ctx) {
                            return PagedListView<int, InitialTreatmentMonitor>(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20, top: 15),
                              pagingController:
                                  initialTreatmentMonitoringHistoryController
                                      .submittedRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<
                                  InitialTreatmentMonitor>(
                                itemBuilder: (context, monitor, index) {
                                  return InitialTreatmentMonitoringCard(
                                    monitor: monitor,
                                    onViewTap: () => Get.to(
                                        () =>
                                            EditInitialTreatmentMonitoringRecord(
                                              monitor: monitor,
                                              isViewMode: true,
                                              allMonitorings:
                                                  widget.allMonitorings,
                                            ),
                                        transition: Transition.fadeIn),
                                    onEditTap: () => Get.to(
                                        () =>
                                            EditInitialTreatmentMonitoringRecord(
                                              monitor: monitor,
                                              isViewMode: false,
                                              allMonitorings:
                                                  widget.allMonitorings,
                                            ),
                                        transition: Transition.fadeIn),
                                    onDeleteTap: () =>
                                        initialTreatmentMonitoringHistoryController
                                            .confirmDeleteMonitoring(monitor),
                                    allowDelete: false,
                                    allowEdit: false,
                                  );
                                },
                                noItemsFoundIndicatorBuilder: (context) =>
                                    Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.horizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 50),
                                      Image.asset(
                                        'assets/images/cocoa_monitor/empty-box.png',
                                        width: 60,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "No data found",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      GetBuilder(
                          init: initialTreatmentMonitoringHistoryController,
                          id: 'pendingRecordsBuilder',
                          builder: (ctx) {
                            return PagedListView<int, InitialTreatmentMonitor>(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20, top: 15),
                              pagingController:
                                  initialTreatmentMonitoringHistoryController
                                      .pendingRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<
                                      InitialTreatmentMonitor>(
                                  itemBuilder: (context, monitor, index) {
                                    return InitialTreatmentMonitoringCard(
                                      monitor: monitor,
                                      onViewTap: () => Get.to(
                                          () =>
                                              EditInitialTreatmentMonitoringRecord(
                                                monitor: monitor,
                                                isViewMode: true,
                                                allMonitorings:
                                                    widget.allMonitorings,
                                              ),
                                          transition: Transition.fadeIn),
                                      onEditTap: () {
                                        Get.to(
                                                () =>
                                                    EditInitialTreatmentMonitoringRecord(
                                                      monitor: monitor,
                                                      isViewMode: false,
                                                      allMonitorings:
                                                          widget.allMonitorings,
                                                    ),
                                                transition: Transition.fadeIn)
                                            ?.then((data) {
                                          if (data != null) {
                                            var item = data['monitor'];
                                            bool submitted = data['submitted'];

                                            final index =
                                                initialTreatmentMonitoringHistoryController
                                                    .pendingRecordsController
                                                    .itemList
                                                    ?.indexWhere((p) =>
                                                        p.uid == item.uid);
                                            if (index != -1) {
                                              if (submitted) {
                                                initialTreatmentMonitoringHistoryController
                                                    .pendingRecordsController
                                                    .itemList!
                                                    .remove(monitor);
                                                initialTreatmentMonitoringHistoryController
                                                    .update([
                                                  'pendingRecordsBuilder'
                                                ]);
                                                initialTreatmentMonitoringHistoryController
                                                    .submittedRecordsController
                                                    .refresh();
                                              } else {
                                                initialTreatmentMonitoringHistoryController
                                                    .pendingRecordsController
                                                    .itemList![index!] = item;
                                                initialTreatmentMonitoringHistoryController
                                                    .update([
                                                  'pendingRecordsBuilder'
                                                ]);
                                              }
                                            }
                                          }
                                        });
                                      },
                                      onDeleteTap: () =>
                                          initialTreatmentMonitoringHistoryController
                                              .confirmDeleteMonitoring(monitor),
                                      allowDelete: true,
                                      allowEdit: true,
                                    );
                                  },
                                  noItemsFoundIndicatorBuilder: (context) =>
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: AppPadding.horizontal),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 50),
                                            Image.asset(
                                              'assets/images/cocoa_monitor/empty-box.png',
                                              width: 60,
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              "No data found",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(fontSize: 13),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )),
                            );
                          }),
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

  Widget personnelStream(
      GlobalController globalController,
      InitialTreatmentMonitoringHistoryController
          initialTreatmentMonitoringHistoryController,
      int status) {
    final monitorDao = globalController.database!.initialTreatmentMonitorDao;
    return StreamBuilder<List<InitialTreatmentMonitor>>(
      stream: monitorDao.findInitialTreatmentMonitorByStatusStream(status),
      builder: (BuildContext context,
          AsyncSnapshot<List<InitialTreatmentMonitor>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/gif/loading2.gif', height: 60),
          );
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Oops.. Something went wrong'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10,),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        InitialTreatmentMonitor monitor = snapshot.data![index];
                        return InitialTreatmentMonitoringCard(
                          monitor: monitor,
                          onViewTap: () => Get.to(
                              () => EditInitialTreatmentMonitoringRecord(
                                    monitor: monitor,
                                    isViewMode: true,
                                    allMonitorings: widget.allMonitorings,
                                  ),
                              transition: Transition.fadeIn),
                          onEditTap: () => Get.to(
                              () => EditInitialTreatmentMonitoringRecord(
                                    monitor: monitor,
                                    isViewMode: false,
                                    allMonitorings: widget.allMonitorings,
                                  ),
                              transition: Transition.fadeIn),
                          onDeleteTap: () =>
                              initialTreatmentMonitoringHistoryController
                                  .confirmDeleteMonitoring(monitor),
                          allowDelete: status != SubmissionStatus.submitted,
                          allowEdit: status != SubmissionStatus.submitted,
                          // allowDelete: status == SubmissionStatus.submitted,
                          // allowEdit: status == SubmissionStatus.submitted,
                        );
                      }),
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'assets/images/cocoa_monitor/empty-box.png',
                      width: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "There is nothing to display here",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(
            child: Image.asset('assets/gif/loading2.gif', height: 60),
          );
        }
      },
    );
  }
}
