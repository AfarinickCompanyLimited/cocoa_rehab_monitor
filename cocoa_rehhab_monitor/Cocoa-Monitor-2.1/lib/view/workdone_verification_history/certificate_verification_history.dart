import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor_certificate_verification.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../edit_certificate_verification/edit_certificate_verification_record.dart';
import 'components/certificate_verification_card.dart';
import 'certificate_verification_history_controller.dart';

class CertificateVerificationHistory extends StatefulWidget {
  const CertificateVerificationHistory({Key? key}) : super(key: key);

  @override
  State<CertificateVerificationHistory> createState() =>
      _CertificateVerificationHistoryState();
}

class _CertificateVerificationHistoryState
    extends State<CertificateVerificationHistory>
    with SingleTickerProviderStateMixin {
  CertificateVerificationHistoryController
      certificateVerificationHistoryController =
      Get.put(CertificateVerificationHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    certificateVerificationHistoryController.pendingRecordsController
        .addPageRequestListener((pageKey) {
      certificateVerificationHistoryController.fetchData(
          status: SubmissionStatus.pending,
          pageKey: pageKey,
          controller: certificateVerificationHistoryController
              .pendingRecordsController);
    });

    certificateVerificationHistoryController.submittedRecordsController
        .addPageRequestListener((pageKey) {
      certificateVerificationHistoryController.fetchData(
          status: SubmissionStatus.submitted,
          pageKey: pageKey,
          controller: certificateVerificationHistoryController
              .submittedRecordsController);
    });

    certificateVerificationHistoryController.tabController =
        TabController(length: 2, vsync: this);
    certificateVerificationHistoryController.tabController!.addListener(() {
      certificateVerificationHistoryController.activeTabIndex.value =
          certificateVerificationHistoryController.tabController!.index;
    });
    super.initState();
  }

  @override
  void dispose() {
    certificateVerificationHistoryController.pendingRecordsController.dispose();
    certificateVerificationHistoryController.submittedRecordsController
        .dispose();
    certificateVerificationHistoryController.tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    certificateVerificationHistoryController
        .certificateVerificationHistoryScreenContext = context;

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
                          child: Text('Certificate Verification History',
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
                        certificateVerificationHistoryController
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
                      controller: certificateVerificationHistoryController
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
                                      certificateVerificationHistoryController
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
                                      certificateVerificationHistoryController
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
                        certificateVerificationHistoryController.tabController,
                    children: [
                      GetBuilder(
                          init: certificateVerificationHistoryController,
                          builder: (ctx) {
                            return PagedListView<int,
                                ContractorCertificateVerification>(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20, top: 15),
                              pagingController:
                                  certificateVerificationHistoryController
                                      .submittedRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<
                                  ContractorCertificateVerification>(
                                itemBuilder: (context,
                                    contractorCertificateVerification, index) {
                                  return CertificateVerificationCard(
                                    contractorCertificateVerification:
                                        contractorCertificateVerification,
                                    onViewTap: () => Get.to(
                                        () => EditCertificateVerificationRecord(
                                            contractorCertificateVerification:
                                                contractorCertificateVerification,
                                            isViewMode: true),
                                        transition: Transition.fadeIn),
                                    onEditTap: () => Get.to(
                                        () => EditCertificateVerificationRecord(
                                            contractorCertificateVerification:
                                                contractorCertificateVerification,
                                            isViewMode: false),
                                        transition: Transition.fadeIn),
                                    onDeleteTap: () =>
                                        certificateVerificationHistoryController
                                            .confirmDeleteMonitoring(
                                                contractorCertificateVerification),
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
                          init: certificateVerificationHistoryController,
                          id: 'pendingRecordsBuilder',
                          builder: (ctx) {
                            return PagedListView<int,
                                ContractorCertificateVerification>(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20, top: 15),
                              pagingController:
                                  certificateVerificationHistoryController
                                      .pendingRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<
                                      ContractorCertificateVerification>(
                                  itemBuilder:
                                      (context, contractorCertificate, index) {
                                    return CertificateVerificationCard(
                                      contractorCertificateVerification:
                                          contractorCertificate,
                                      onViewTap: () => Get.to(
                                          () => EditCertificateVerificationRecord(
                                            contractorCertificateVerification:
                                                  contractorCertificate,
                                              isViewMode: true),
                                          transition: Transition.fadeIn),
                                      onEditTap: () {
                                        Get.to(
                                                () => EditCertificateVerificationRecord(
                                            contractorCertificateVerification:
                                                        contractorCertificate,
                                                    isViewMode: false),
                                                transition: Transition.fadeIn)
                                            ?.then((data) {
                                          if (data != null) {
                                            var item =
                                                data['CertificateVerification'];
                                            bool submitted = data['submitted'];

                                            final index =
                                                certificateVerificationHistoryController
                                                    .pendingRecordsController
                                                    .itemList
                                                    ?.indexWhere((p) =>
                                                        p.uid == item.uid);
                                            if (index != -1) {
                                              if (submitted) {
                                                certificateVerificationHistoryController
                                                    .pendingRecordsController
                                                    .itemList!
                                                    .remove(
                                                        contractorCertificate);
                                                certificateVerificationHistoryController
                                                    .update([
                                                  'pendingRecordsBuilder'
                                                ]);
                                                certificateVerificationHistoryController
                                                    .submittedRecordsController
                                                    .refresh();
                                              } else {
                                                certificateVerificationHistoryController
                                                    .pendingRecordsController
                                                    .itemList![index!] = item;
                                                certificateVerificationHistoryController
                                                    .update([
                                                  'pendingRecordsBuilder'
                                                ]);
                                              }
                                            }
                                          }
                                        });
                                      },
                                      onDeleteTap: () =>
                                          certificateVerificationHistoryController
                                              .confirmDeleteMonitoring(
                                                  contractorCertificate),
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

  Widget personnelStream(GlobalController globalController,
      contractorCertificateHistoryController, int status) {
    final contractorCertificateVerificationDao =
        globalController.database!.contractorCertificateVerificationDao;
    return StreamBuilder<List<ContractorCertificateVerification>>(
      stream: contractorCertificateVerificationDao
          .findContractorCertificateVerificationByStatusStream(status),
      builder: (BuildContext context,
          AsyncSnapshot<List<ContractorCertificateVerification>> snapshot) {
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
                        ContractorCertificateVerification
                            contractorCertificate = snapshot.data![index];
                        return CertificateVerificationCard(
                          contractorCertificateVerification:
                              contractorCertificate,
                          onViewTap: () => Get.to(
                              () => EditCertificateVerificationRecord(
                                            contractorCertificateVerification: contractorCertificate,
                                  isViewMode: true),
                              transition: Transition.fadeIn),
                          onEditTap: () => Get.to(
                              () => EditCertificateVerificationRecord(
                                            contractorCertificateVerification: contractorCertificate,
                                  isViewMode: false),
                              transition: Transition.fadeIn),
                          onDeleteTap: () =>
                              contractorCertificateHistoryController
                                  .confirmDeleteMonitoring(
                                      contractorCertificate),
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
