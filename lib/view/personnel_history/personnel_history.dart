import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/edit_personnel/edit_personnel.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/personnel_history/personnel_history_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'components/personnel_card.dart';

class PersonnelHistory extends StatefulWidget {
  const PersonnelHistory({Key? key}) : super(key: key);

  @override
  State<PersonnelHistory> createState() => _PersonnelHistoryState();
}

class _PersonnelHistoryState extends State<PersonnelHistory>
    with SingleTickerProviderStateMixin {
  PersonnelHistoryController personnelHistoryController = Get.put(
    PersonnelHistoryController(),
  );
  GlobalController globalController = Get.find();

  @override
  void initState() {
    personnelHistoryController.pendingRecordsController.addPageRequestListener((
      pageKey,
    ) {
      personnelHistoryController.fetchPersonnel(
        status: SubmissionStatus.pending,
        pageKey: pageKey,
        controller: personnelHistoryController.pendingRecordsController,
      );
    });

    personnelHistoryController.submittedRecordsController
        .addPageRequestListener((pageKey) {
          personnelHistoryController.fetchPersonnel(
            status: SubmissionStatus.submitted,
            pageKey: pageKey,
            controller: personnelHistoryController.submittedRecordsController,
          );
        });

    // personnelHistoryController.submittedPersonnelRepository.initializeData();
    // personnelHistoryController.pendingPersonnelRepository.initializeData();
    personnelHistoryController.tabController = TabController(
      length: 2,
      vsync: this,
    );
    personnelHistoryController.tabController!.addListener(() {
      personnelHistoryController.activeTabIndex.value =
          personnelHistoryController.tabController!.index;
    });
    super.initState();
  }

  @override
  void dispose() {
    personnelHistoryController.pendingRecordsController.dispose();
    personnelHistoryController.submittedRecordsController.dispose();
    personnelHistoryController.tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    personnelHistoryController.personnelHistoryScreenContext = context;

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
                    right: AppPadding.horizontal,
                  ),
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
                          'Personnel Added',
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

                // SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColor.lightText.withOpacity(0.5),
                      ),
                    ),
                  ),
                  child: Obx(
                    () => TabBar(
                      onTap: (index) {
                        personnelHistoryController.activeTabIndex.value = index;
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
                            width: 3.0,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                      controller: personnelHistoryController.tabController,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Text(
                              'Submitted',
                              style: TextStyle(
                                fontWeight:
                                    personnelHistoryController
                                                .activeTabIndex
                                                .value ==
                                            0
                                        ? FontWeight.bold
                                        : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Text(
                              'Pending',
                              style: TextStyle(
                                fontWeight:
                                    personnelHistoryController
                                                .activeTabIndex
                                                .value ==
                                            1
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
                    controller: personnelHistoryController.tabController,
                    children: [
                      GetBuilder(
                        init: personnelHistoryController,
                        builder: (ctx) {
                          return PagedListView<int, Personnel>(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: 20,
                              top: 15,
                            ),
                            pagingController:
                                personnelHistoryController
                                    .submittedRecordsController,
                            builderDelegate: PagedChildBuilderDelegate<
                              Personnel
                            >(
                              itemBuilder: (context, personnel, index) {
                                return PersonnelCard(
                                  personnel: personnel,
                                  onViewTap:
                                      () => Get.to(
                                        () => EditPersonnel(
                                          personnel: personnel,
                                          isViewMode: true,
                                        ),
                                        transition: Transition.fadeIn,
                                      ),
                                  onEditTap:
                                      () => Get.to(
                                        () => EditPersonnel(
                                          personnel: personnel,
                                          isViewMode: false,
                                        ),
                                        transition: Transition.fadeIn,
                                      ),
                                  onDeleteTap: () {
                                    confirmDeletePersonnel(personnel);

                                    setState(() {});
                                  },
                                  allowDelete: true,
                                  allowEdit: false,
                                  // allowDelete: status == SubmissionStatus.submitted,
                                  // allowEdit: status == SubmissionStatus.submitted,
                                );
                              },
                              noItemsFoundIndicatorBuilder:
                                  (context) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.horizontal,
                                    ),
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
                        },
                      ),

                      GetBuilder(
                        init: personnelHistoryController,
                        id: 'pendingRecordsBuilder',
                        builder: (ctx) {
                          return PagedListView<int, Personnel>(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              bottom: 20,
                              top: 15,
                            ),
                            pagingController:
                                personnelHistoryController
                                    .pendingRecordsController,
                            builderDelegate: PagedChildBuilderDelegate<
                              Personnel
                            >(
                              itemBuilder: (context, personnel, index) {
                                return PersonnelCard(
                                  personnel: personnel,
                                  onViewTap:
                                      () => Get.to(
                                        () => EditPersonnel(
                                          personnel: personnel,
                                          isViewMode: true,
                                        ),
                                        transition: Transition.fadeIn,
                                      ),
                                  onEditTap: () {
                                    Get.to(
                                      () => EditPersonnel(
                                        personnel: personnel,
                                        isViewMode: false,
                                      ),
                                      transition: Transition.fadeIn,
                                    )?.then((data) {
                                      if (data != null) {
                                        var updatedPersonnel =
                                            data['personnel'];
                                        bool submitted = data['submitted'];
                                        // personnelHistoryController.pendingRecordsController.updateItem(index, updatedPersonnel);

                                        final index = personnelHistoryController
                                            .pendingRecordsController
                                            .itemList
                                            ?.indexWhere(
                                              (p) =>
                                                  p.uid == updatedPersonnel.uid,
                                            );
                                        if (index != -1) {
                                          if (submitted) {
                                            personnelHistoryController
                                                .pendingRecordsController
                                                .itemList!
                                                .remove(personnel);
                                            personnelHistoryController.update([
                                              'pendingRecordsBuilder',
                                            ]);
                                            personnelHistoryController
                                                .submittedRecordsController
                                                .refresh();
                                          } else {
                                            personnelHistoryController
                                                    .pendingRecordsController
                                                    .itemList![index!] =
                                                updatedPersonnel;
                                            personnelHistoryController.update([
                                              'pendingRecordsBuilder',
                                            ]);
                                          }
                                        }
                                      }
                                    });
                                  },
                                  onDeleteTap: () {
                                    confirmDeletePersonnel(personnel);

                                    setState(() {});
                                  },
                                  allowDelete: true,
                                  allowEdit: true,
                                  // allowDelete: status == SubmissionStatus.submitted,
                                  // allowEdit: status == SubmissionStatus.submitted,
                                );
                              },
                              noItemsFoundIndicatorBuilder:
                                  (context) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.horizontal,
                                    ),
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
                        },
                      ),
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

  confirmDeletePersonnel(Personnel personnel) async {
    personnelHistoryController.globals.primaryConfirmDialog(
      context: personnelHistoryController.personnelHistoryScreenContext,
      title: 'Delete Personnel',
      image: 'assets/images/cocoa_monitor/question.png',
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "This action is irreversible. Are you sure you want to delete this record?",
          textAlign: TextAlign.center,
        ),
      ),
      cancelTap: () {
        Get.back();
      },
      okayTap: () {
        Get.back();
        globalController.database!.personnelDao.deletePersonnelByUID(
          personnel.uid!,
        );
      },
    );
  }
}
