import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/db/contractor_certificate_of_workdone_db.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:cocoa_rehab_monitor/controller/model/contractor_certificate_of_workdone_model.dart';
import 'package:cocoa_rehab_monitor/view/edit_contractor_certificate_record/edit_contractor_certificate_record.dart';
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
    contractorCertificateHistoryController.tabController!.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {});
    //await Future.delayed(const Duration(seconds: 1));
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
                          'Contractor Certificate History',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.black),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      RefreshIndicator(
                        onRefresh: () =>
                            _refreshData(),
                        child: FutureBuilder(
                          future: contractorCertificateHistoryController
                              .db.getSubmittedData(),
                          builder: (ctx, snapshot) {
                            return _buildListView(false,ctx, snapshot as AsyncSnapshot<List<ContractorCertificateModel>>);
                          },
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: () =>
                            _refreshData(),
                        child: FutureBuilder(
                          future: contractorCertificateHistoryController
                              .db.getPendingData(),
                          builder: (ctx, snapshot) {
                            return _buildListView(true,ctx, snapshot as AsyncSnapshot<List<ContractorCertificateModel>>);
                          },
                        ),
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

  Widget _buildListView(
      bool edit,
      BuildContext ctx, AsyncSnapshot<List<ContractorCertificateModel>> snapshot) {
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
              contractorCertificateHistoryController.globals
                  .primaryConfirmDialog(
                context: contractorCertificateHistoryController
                    .contractorCertificateHistoryScreenContext,
                title: 'Delete Record',
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
                okayTap: () async {
                  ContractorCertificateDatabaseHelper db =
                      ContractorCertificateDatabaseHelper.instance;
                  Get.back();
                  await db.deleteData(data[index].uid!);
                  setState(() {});
                },
              );
            },
            allowDelete: true,
            allowEdit: edit,
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
}
