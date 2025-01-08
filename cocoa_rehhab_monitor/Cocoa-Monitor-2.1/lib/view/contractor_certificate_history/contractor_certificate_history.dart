import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/db/contractor_certificate_of_workdone_db.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/model/contractor_certificate_of_workdone_model.dart';
import '../edit_contractor_certificate_record/edit_contractor_certificate_record.dart';
import 'components/contractor_certificate_card.dart';
import 'contractor_certificate_history_controller.dart';

class ContractorCertificateHistory extends StatefulWidget {
  const ContractorCertificateHistory({Key? key}) : super(key: key);

  @override
  State<ContractorCertificateHistory> createState() =>
      _ContractorCertificateHistoryState();
}

class _ContractorCertificateHistoryState
    extends State<ContractorCertificateHistory>
    with SingleTickerProviderStateMixin {
  ContractorCertificateHistoryController
      contractorCertificateHistoryController =
      Get.put(ContractorCertificateHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    contractorCertificateHistoryController.pendingRecordsController
        .addPageRequestListener((pageKey) {
      contractorCertificateHistoryController.fetchData(
          status: SubmissionStatus.pending,
          pageKey: pageKey,
          controller:
              contractorCertificateHistoryController.pendingRecordsController);
    });

    contractorCertificateHistoryController.submittedRecordsController
        .addPageRequestListener((pageKey) {
      contractorCertificateHistoryController.fetchData(
          status: SubmissionStatus.submitted,
          pageKey: pageKey,
          controller: contractorCertificateHistoryController
              .submittedRecordsController);
    });

    contractorCertificateHistoryController.tabController =
        TabController(length: 2, vsync: this);
    contractorCertificateHistoryController.tabController!.addListener(() {
      contractorCertificateHistoryController.activeTabIndex.value =
          contractorCertificateHistoryController.tabController!.index;
    });
    super.initState();
  }

  @override
  void dispose() {
    contractorCertificateHistoryController.pendingRecordsController.dispose();
    contractorCertificateHistoryController.submittedRecordsController.dispose();
    contractorCertificateHistoryController.tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    contractorCertificateHistoryController
        .contractorCertificateHistoryScreenContext = context;

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
                          child: Text('Contractor Certificate History',
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
                        contractorCertificateHistoryController
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
                      controller:
                          contractorCertificateHistoryController.tabController,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Submitted',
                              style: TextStyle(
                                  fontWeight:
                                      contractorCertificateHistoryController
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
                                      contractorCertificateHistoryController
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
                    controller:
                        contractorCertificateHistoryController.tabController,
                    children: [
                      FutureBuilder(
                        future: contractorCertificateHistoryController
                            .db.getSubmittedData(),
                        builder: (ctx, snapshot) {
                          // Waiting state
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.primary,
                              ),
                            );
                          }

                          // Error state
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Something went wrong: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          // Data is fetched
                          if (snapshot.hasData) {
                            // Cast the data to the correct type
                            final List<ContractorCertificateModel> data =
                                snapshot.data
                                    as List<ContractorCertificateModel>;

                            // Handle empty data case
                            if (data.isEmpty) {
                              return Center(
                                child: Text(
                                  'No records found',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              );
                            }

                            // Build the ListView with data
                            return ListView.separated(
                              itemBuilder: (ctx, index) {
                                return ContractorCertificateCard(
                                  contractorCertificate: data[index],
                                  onViewTap: () => Get.to(
                                    () => EditContractorCertificateRecord(
                                      contractorCertificate: data[index],
                                      isViewMode: true,
                                    ),
                                    transition: Transition.fadeIn,
                                  ),
                                  onEditTap: () => Get.to(
                                    () => EditContractorCertificateRecord(
                                      contractorCertificate: data[index],
                                      isViewMode: false,
                                    ),
                                    transition: Transition.fadeIn,
                                  ),
                                  onDeleteTap: () {
                                    contractorCertificateHistoryController
                                        .globals
                                        .primaryConfirmDialog(
                                      context:
                                          contractorCertificateHistoryController
                                              .contractorCertificateHistoryScreenContext,
                                      title: 'Delete Record',
                                      image:
                                          'assets/images/cocoa_monitor/question.png',
                                      content: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          "This action is irreversible. Are you sure you want to delete this record?",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      cancelTap: () {
                                        Get.back();
                                      },
                                      okayTap: () async {
                                        ContractorCertificateDatabaseHelper db =
                                            ContractorCertificateDatabaseHelper
                                                .instance;
                                        Get.back(); // Close the confirmation dialog
                                        await db.deleteData(data[index].uid!);
                                        setState(() {});
                                      },
                                    );
                                  },
                                  allowDelete: true,
                                  allowEdit: false,
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return SizedBox(height: 10);
                              },
                              itemCount: data.length,
                            );
                          }

                          // Default case (snapshot has no data and no error)
                          return Center(
                            child: Text(
                              'No data available.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                      FutureBuilder(
                        future: contractorCertificateHistoryController
                            .db.getPendingData(),
                        builder: (ctx, snapshot) {
                          print("THE DATA IS ${snapshot.data  }");
                          // Waiting state
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColor.primary,
                              ),
                            );
                          }

                          // Error state
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Something went wrong: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          // Data is fetched
                          if (snapshot.hasData) {
                            // Cast the data to the correct type
                            final List<ContractorCertificateModel> data =
                                snapshot.data
                                    as List<ContractorCertificateModel>;

                            // Handle empty data case
                            if (data.isEmpty) {
                              return Center(
                                child: Text(
                                  'No records found',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              );
                            }

                            // Build the ListView with data
                            return ListView.separated(
                              itemBuilder: (ctx, index) {
                                print(data[index].status);
                                return ContractorCertificateCard(
                                  contractorCertificate: data[index],
                                  onViewTap: () => Get.to(
                                    () => EditContractorCertificateRecord(
                                      contractorCertificate: data[index],
                                      isViewMode: true,
                                    ),
                                    transition: Transition.fadeIn,
                                  ),
                                  onEditTap: () => Get.to(
                                    () => EditContractorCertificateRecord(
                                      contractorCertificate: data[index],
                                      isViewMode: false,
                                    ),
                                    transition: Transition.fadeIn,
                                  ),
                                  onDeleteTap: () {
                                    contractorCertificateHistoryController
                                        .globals
                                        .primaryConfirmDialog(
                                      context:
                                          contractorCertificateHistoryController
                                              .contractorCertificateHistoryScreenContext,
                                      title: 'Delete Record',
                                      image:
                                          'assets/images/cocoa_monitor/question.png',
                                      content: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          "This action is irreversible. Are you sure you want to delete this record?",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      cancelTap: () {
                                        Get.back();
                                      },
                                      okayTap: () async {
                                        ContractorCertificateDatabaseHelper db =
                                            ContractorCertificateDatabaseHelper
                                                .instance;
                                        Get.back(); // Close the confirmation dialog
                                        await db.deleteData(data[index].uid!);
                                        setState(() {});
                                      },
                                    );
                                  },
                                  allowDelete: true,
                                  allowEdit: true,
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return SizedBox(height: 10);
                              },
                              itemCount: data.length,
                            );
                          }

                          // Default case (snapshot has no data and no error)
                          return Center(
                            child: Text(
                              'No data available.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        },
                      ),

                      // GetBuilder(
                      //     init: contractorCertificateHistoryController,
                      //     builder: (ctx) {
                      //       return PagedListView<int, ContractorCertificate>(
                      //         padding: const EdgeInsets.only(
                      //             left: 15, right: 15, bottom: 20, top: 15),
                      //         pagingController:
                      //             contractorCertificateHistoryController
                      //                 .submittedRecordsController,
                      //         builderDelegate: PagedChildBuilderDelegate<
                      //             ContractorCertificate>(
                      //           itemBuilder:
                      //               (context, contractorCertificate, index) {
                      //             return ContractorCertificateCard(
                      //               contractorCertificate:
                      //                   contractorCertificate,
                      //               onViewTap: () => Get.to(
                      //                   () => EditContractorCertificateRecord(
                      //                       contractorCertificate:
                      //                           contractorCertificate,
                      //                       isViewMode: true),
                      //                   transition: Transition.fadeIn),
                      //               onEditTap: () => Get.to(
                      //                   () => EditContractorCertificateRecord(
                      //                       contractorCertificate:
                      //                           contractorCertificate,
                      //                       isViewMode: false),
                      //                   transition: Transition.fadeIn),
                      //               onDeleteTap: () {
                      //                 contractorCertificateHistoryController.globals.primaryConfirmDialog(
                      //                   context: contractorCertificateHistoryController.contractorCertificateHistoryScreenContext,
                      //                   title: 'Delete Record',
                      //                   image: 'assets/images/cocoa_monitor/question.png',
                      //                   content: const Padding(
                      //                     padding: EdgeInsets.symmetric(vertical: 8.0),
                      //                     child: Text(
                      //                       "This action is irreversible. Are you sure you want to delete this record?",
                      //                       textAlign: TextAlign.center,
                      //                     ),
                      //                   ),
                      //                   cancelTap: () {
                      //                     Get.back();
                      //                   },
                      //                   okayTap: () async {
                      //                     Get.back(); // Close the confirmation dialog
                      //                     await globalController.database!.contractorCertificateDao
                      //                         .deleteContractorCertificateByUID(contractorCertificate.uid!);
                      //
                      //                     // Update the list in real-time
                      //                     final isSubmittedTab = contractorCertificateHistoryController
                      //                         .activeTabIndex.value ==
                      //                         0;
                      //
                      //                     if (isSubmittedTab) {
                      //                       contractorCertificateHistoryController
                      //                           .submittedRecordsController.itemList
                      //                           ?.remove(contractorCertificate);
                      //                       contractorCertificateHistoryController
                      //                           .submittedRecordsController.refresh();
                      //                     } else {
                      //                       contractorCertificateHistoryController
                      //                           .pendingRecordsController.itemList
                      //                           ?.remove(contractorCertificate);
                      //                       contractorCertificateHistoryController
                      //                           .update(['pendingRecordsBuilder']);
                      //                     }
                      //                   },
                      //                 );
                      //               },
                      //
                      //               allowDelete: true,
                      //               allowEdit: false,
                      //             );
                      //           },
                      //           noItemsFoundIndicatorBuilder: (context) =>
                      //               Padding(
                      //             padding: EdgeInsets.symmetric(
                      //                 horizontal: AppPadding.horizontal),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 const SizedBox(height: 50),
                      //                 Image.asset(
                      //                   'assets/images/cocoa_monitor/empty-box.png',
                      //                   width: 60,
                      //                 ),
                      //                 const SizedBox(height: 20),
                      //                 Text(
                      //                   "No data found",
                      //                   style: Theme.of(context)
                      //                       .textTheme
                      //                       .bodySmall
                      //                       ?.copyWith(fontSize: 13),
                      //                   textAlign: TextAlign.center,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      // GetBuilder(
                      //     init: contractorCertificateHistoryController,
                      //     id: 'pendingRecordsBuilder',
                      //     builder: (ctx) {
                      //       return PagedListView<int, ContractorCertificate>(
                      //         padding: const EdgeInsets.only(
                      //             left: 15, right: 15, bottom: 20, top: 15),
                      //         pagingController:
                      //             contractorCertificateHistoryController
                      //                 .pendingRecordsController,
                      //         builderDelegate: PagedChildBuilderDelegate<
                      //                 ContractorCertificate>(
                      //             itemBuilder:
                      //                 (context, contractorCertificate, index) {
                      //               return ContractorCertificateCard(
                      //                 contractorCertificate:
                      //                     contractorCertificate,
                      //                 onViewTap: () => Get.to(
                      //                     () => EditContractorCertificateRecord(
                      //                         contractorCertificate:
                      //                             contractorCertificate,
                      //                         isViewMode: true),
                      //                     transition: Transition.fadeIn),
                      //                 onEditTap: () {
                      //                   Get.to(
                      //                           () => EditContractorCertificateRecord(
                      //                               contractorCertificate:
                      //                                   contractorCertificate,
                      //                               isViewMode: false),
                      //                           transition: Transition.fadeIn)
                      //                       ?.then((data) {
                      //                     if (data != null) {
                      //                       var item =
                      //                           data['contractorCertificate'];
                      //                       bool submitted = data['submitted'];
                      //
                      //                       final index =
                      //                           contractorCertificateHistoryController
                      //                               .pendingRecordsController
                      //                               .itemList
                      //                               ?.indexWhere((p) =>
                      //                                   p.uid == item.uid);
                      //                       if (index != -1) {
                      //                         if (submitted) {
                      //                           contractorCertificateHistoryController
                      //                               .pendingRecordsController
                      //                               .itemList!
                      //                               .remove(
                      //                                   contractorCertificate);
                      //                           contractorCertificateHistoryController
                      //                               .update([
                      //                             'pendingRecordsBuilder'
                      //                           ]);
                      //                           contractorCertificateHistoryController
                      //                               .submittedRecordsController
                      //                               .refresh();
                      //                         } else {
                      //                           contractorCertificateHistoryController
                      //                               .pendingRecordsController
                      //                               .itemList![index!] = item;
                      //                           contractorCertificateHistoryController
                      //                               .update([
                      //                             'pendingRecordsBuilder'
                      //                           ]);
                      //                         }
                      //                       }
                      //                     }
                      //                   });
                      //                 },
                      //                 onDeleteTap: () {
                      //                   contractorCertificateHistoryController.globals.primaryConfirmDialog(
                      //                     context: contractorCertificateHistoryController.contractorCertificateHistoryScreenContext,
                      //                     title: 'Delete Record',
                      //                     image: 'assets/images/cocoa_monitor/question.png',
                      //                     content: const Padding(
                      //                       padding: EdgeInsets.symmetric(vertical: 8.0),
                      //                       child: Text(
                      //                         "This action is irreversible. Are you sure you want to delete this record?",
                      //                         textAlign: TextAlign.center,
                      //                       ),
                      //                     ),
                      //                     cancelTap: () {
                      //                       Get.back();
                      //                     },
                      //                     okayTap: () async {
                      //                       Get.back(); // Close the confirmation dialog
                      //                       await globalController.database!.contractorCertificateDao
                      //                           .deleteContractorCertificateByUID(contractorCertificate.uid!);
                      //
                      //                       // Update the list in real-time
                      //                       final isSubmittedTab = contractorCertificateHistoryController
                      //                           .activeTabIndex.value ==
                      //                           0;
                      //
                      //                       if (isSubmittedTab) {
                      //                         contractorCertificateHistoryController
                      //                             .submittedRecordsController.itemList
                      //                             ?.remove(contractorCertificate);
                      //                         contractorCertificateHistoryController
                      //                             .submittedRecordsController.refresh();
                      //                       } else {
                      //                         contractorCertificateHistoryController
                      //                             .pendingRecordsController.itemList
                      //                             ?.remove(contractorCertificate);
                      //                         contractorCertificateHistoryController
                      //                             .update(['pendingRecordsBuilder']);
                      //                       }
                      //                     },
                      //                   );
                      //                 },
                      //
                      //                 allowDelete: true,
                      //                 allowEdit: true,
                      //               );
                      //             },
                      //             noItemsFoundIndicatorBuilder: (context) =>
                      //                 Padding(
                      //                   padding: EdgeInsets.symmetric(
                      //                       horizontal: AppPadding.horizontal),
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.center,
                      //                     children: [
                      //                       const SizedBox(height: 50),
                      //                       Image.asset(
                      //                         'assets/images/cocoa_monitor/empty-box.png',
                      //                         width: 60,
                      //                       ),
                      //                       const SizedBox(height: 20),
                      //                       Text(
                      //                         "No data found",
                      //                         style: Theme.of(context)
                      //                             .textTheme
                      //                             .bodySmall
                      //                             ?.copyWith(fontSize: 13),
                      //                         textAlign: TextAlign.center,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 )),
                      //       );
                      //     }),
                    ],
                  ),
                ),

                /*GetBuilder(
                    init: contractorCertificateHistoryController,
                    builder: (context) {
                      return Expanded(
                        child: TabBarView(
                          controller: contractorCertificateHistoryController.tabController,
                          children: [

                            personnelStream(globalController, contractorCertificateHistoryController, SubmissionStatus.submitted),

                            personnelStream(globalController, contractorCertificateHistoryController, SubmissionStatus.pending),

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

  // Widget personnelStream(GlobalController globalController,
  //     contractorCertificateHistoryController, int status) {
  //   final contractorCertificateDao =
  //       globalController.database!.contractorCertificateDao;
  //   return StreamBuilder<List<ContractorCertificate>>(
  //     stream: contractorCertificateDao
  //         .findContractorCertificateByStatusStream(status),
  //     builder: (BuildContext context,
  //         AsyncSnapshot<List<ContractorCertificate>> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: Image.asset('assets/gif/loading2.gif', height: 60),
  //         );
  //       } else if (snapshot.connectionState == ConnectionState.active ||
  //           snapshot.connectionState == ConnectionState.done) {
  //         if (snapshot.hasError) {
  //           return const Center(child: Text('Oops.. Something went wrong'));
  //         } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
  //           return SingleChildScrollView(
  //             physics: const BouncingScrollPhysics(),
  //             padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // const SizedBox(height: 10,),
  //                 ListView.builder(
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     scrollDirection: Axis.vertical,
  //                     shrinkWrap: true,
  //                     itemCount: snapshot.data!.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       ContractorCertificate contractorCertificate =
  //                           snapshot.data![index];
  //                       return ContractorCertificateCard(
  //                         contractorCertificate: contractorCertificate,
  //                         onViewTap: () => Get.to(
  //                             () => EditContractorCertificateRecord(
  //                                 contractorCertificate: contractorCertificate,
  //                                 isViewMode: true),
  //                             transition: Transition.fadeIn),
  //                         onEditTap: () => Get.to(
  //                             () => EditContractorCertificateRecord(
  //                                 contractorCertificate: contractorCertificate,
  //                                 isViewMode: false),
  //                             transition: Transition.fadeIn),
  //                         onDeleteTap: () =>
  //                             contractorCertificateHistoryController
  //                                 .confirmDeleteMonitoring(
  //                                     contractorCertificate),
  //                         allowDelete: status != SubmissionStatus.submitted,
  //                         allowEdit: status != SubmissionStatus.submitted,
  //                         // allowDelete: status == SubmissionStatus.submitted,
  //                         // allowEdit: status == SubmissionStatus.submitted,
  //                       );
  //                     }),
  //               ],
  //             ),
  //           );
  //         } else {
  //           return Center(
  //             child: Padding(
  //               padding:
  //                   EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   const SizedBox(height: 50),
  //                   Image.asset(
  //                     'assets/images/cocoa_monitor/empty-box.png',
  //                     width: 80,
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Text(
  //                     "There is nothing to display here",
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .bodySmall
  //                         ?.copyWith(fontSize: 13),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }
  //       } else {
  //         return Center(
  //           child: Image.asset('assets/gif/loading2.gif', height: 60),
  //         );
  //       }
  //     },
  //   );
  // }
}
