import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/edit_outbreak_farm/edit_outbreak_farm.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'components/outbreak_farm_card.dart';
import 'outbreak_farm_history_controller.dart';


class OutbreakFarmHistory extends StatefulWidget {
  const OutbreakFarmHistory({Key? key}) : super(key: key);

  @override
  State<OutbreakFarmHistory> createState() => _OutbreakFarmHistoryState();
}

class _OutbreakFarmHistoryState extends State<OutbreakFarmHistory> with SingleTickerProviderStateMixin {

  OutbreakFarmHistoryController outbreakFarmHistoryController = Get.put(OutbreakFarmHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    outbreakFarmHistoryController.pendingRecordsController.addPageRequestListener((pageKey) {
      outbreakFarmHistoryController.fetchData(status: SubmissionStatus.pending, pageKey: pageKey, controller: outbreakFarmHistoryController.pendingRecordsController);
    });

    outbreakFarmHistoryController.submittedRecordsController.addPageRequestListener((pageKey) {
      outbreakFarmHistoryController.fetchData(status: SubmissionStatus.submitted, pageKey: pageKey, controller: outbreakFarmHistoryController.submittedRecordsController);
    });
    
    outbreakFarmHistoryController.tabController = TabController(length: 2, vsync: this);
    outbreakFarmHistoryController.tabController!.addListener(() {
      outbreakFarmHistoryController.activeTabIndex.value = outbreakFarmHistoryController.tabController!.index;
    });
  }

  @override
  void dispose() {
    outbreakFarmHistoryController.pendingRecordsController.dispose();
    outbreakFarmHistoryController.submittedRecordsController.dispose();
    outbreakFarmHistoryController.tabController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    outbreakFarmHistoryController.outbreakFarmHistoryScreenContext = context;

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
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: AppPadding.horizontal, right: AppPadding.horizontal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedIconButton(
                          icon: appIconBack(color: AppColor.black, size: 25),
                          size: 45,
                          backgroundColor: Colors.transparent,
                          onTap: () => Get.back(),
                        ),

                        const SizedBox(width: 12,),

                        Expanded(
                          child: Text('Outbreak Farms',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                // SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)))
                  ),
                  child: Obx(() => TabBar(
                    onTap: (index) {
                      outbreakFarmHistoryController.activeTabIndex.value = index;
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
                        border: Border(bottom: BorderSide(width: 3.0, color: AppColor.primary))
                    ),
                    controller: outbreakFarmHistoryController.tabController,
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Submitted',
                            style: TextStyle(fontWeight: outbreakFarmHistoryController.activeTabIndex.value == 0 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Pending',
                            style: TextStyle(fontWeight: outbreakFarmHistoryController.activeTabIndex.value == 1 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                  ),
                ),


                Expanded(
                  child: TabBarView(
                    controller: outbreakFarmHistoryController.tabController,
                    children: [

                      GetBuilder(
                          init: outbreakFarmHistoryController,
                          builder: (ctx) {
                            return PagedListView<int, OutbreakFarm>(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: outbreakFarmHistoryController.submittedRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<OutbreakFarm>(
                                  itemBuilder: (context, outbreakFarm, index){
                                    return OutbreakFarmCard(
                                      outbreakFarm: outbreakFarm,
                                      onViewTap: () => Get.to(() => EditOutbreakFarm(outbreakFarm: outbreakFarm, isViewMode: true), transition: Transition.fadeIn),
                                      onEditTap: () => Get.to(() => EditOutbreakFarm(outbreakFarm: outbreakFarm, isViewMode: false), transition: Transition.fadeIn),
                                      onDeleteTap: () => outbreakFarmHistoryController.confirmDeleteRecord(outbreakFarm),
                                      allowDelete: false,
                                      allowEdit: false,
                                    );
                                  },
                                  noItemsFoundIndicatorBuilder: (context) => Padding(
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 50),
                                        Image.asset(
                                          'assets/images/cocoa_monitor/empty-box.png',
                                          width: 60,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "No data found",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            );
                          }
                      ),

                      GetBuilder(
                          init: outbreakFarmHistoryController,
                          id: 'pendingRecordsBuilder',
                          builder: (ctx) {
                            return PagedListView<int, OutbreakFarm>(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: outbreakFarmHistoryController.pendingRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<OutbreakFarm>(
                                  itemBuilder: (context, outbreakFarm, index){
                                    return OutbreakFarmCard(
                                      outbreakFarm: outbreakFarm,
                                      onViewTap: () => Get.to(() => EditOutbreakFarm(outbreakFarm: outbreakFarm, isViewMode: true), transition: Transition.fadeIn),
                                      onEditTap: () {
                                        Get.to(() =>
                                            EditOutbreakFarm(
                                                outbreakFarm: outbreakFarm,
                                                isViewMode: false),
                                                transition: Transition.fadeIn
                                        )?.then((data){
                                          if (data != null){
                                            var updatedOutbreakFarm = data['outbreakFarm'];
                                            bool submitted = data['submitted'];

                                            final index = outbreakFarmHistoryController.pendingRecordsController.itemList?.indexWhere((p) => p.uid == updatedOutbreakFarm.uid);
                                            if (index != -1) {
                                              if(submitted){
                                                outbreakFarmHistoryController.pendingRecordsController.itemList!.remove(outbreakFarm);
                                                outbreakFarmHistoryController.update(['pendingRecordsBuilder']);
                                                outbreakFarmHistoryController.submittedRecordsController.refresh();
                                              }else{
                                                outbreakFarmHistoryController.pendingRecordsController.itemList![index!] = updatedOutbreakFarm;
                                                outbreakFarmHistoryController.update(['pendingRecordsBuilder']);
                                              }
                                            }
                                          }
                                        });
                                      },
                                      onDeleteTap: () => outbreakFarmHistoryController.confirmDeleteRecord(outbreakFarm),
                                      allowDelete: true,
                                      allowEdit: true,
                                    );
                                  },
                                  noItemsFoundIndicatorBuilder: (context) => Padding(
                                    padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 50),
                                        Image.asset(
                                          'assets/images/cocoa_monitor/empty-box.png',
                                          width: 60,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "No data found",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                            );
                          }
                      ),

                    ],
                  ),
                ),

                /*GetBuilder(
                    init: outbreakFarmHistoryController,
                    builder: (context) {
                      return Expanded(
                        child: TabBarView(
                          controller: outbreakFarmHistoryController.tabController,
                          children: [

                            outbreakFarmStream(globalController, outbreakFarmHistoryController, SubmissionStatus.submitted),

                            outbreakFarmStream(globalController, outbreakFarmHistoryController, SubmissionStatus.pending),

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

  /*Widget outbreakFarmStream(GlobalController globalController, OutbreakFarmHistoryController outbreakFarmHistoryController, int status) {
    final outbreakFarmDao = globalController.database!.outbreakFarmDao;
    return StreamBuilder<List<OutbreakFarm>>(
      stream: outbreakFarmDao.findOutbreakFarmByStatusStream(status),
      builder:
          (BuildContext context, AsyncSnapshot<List<OutbreakFarm>> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/gif/loading2.gif', height: 60),
          );
        } else if (snapshot.connectionState == ConnectionState.active
            || snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: const Text('Oops.. Something went wrong'));
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
                        OutbreakFarm outbreakFarm = snapshot.data![index];
                        return OutbreakFarmCard(
                          outbreakFarm: outbreakFarm,
                          onViewTap: () => Get.to(() => EditOutbreakFarm(outbreakFarm: outbreakFarm, isViewMode: true), transition: Transition.fadeIn),
                          onEditTap: () => Get.to(() => EditOutbreakFarm(outbreakFarm: outbreakFarm, isViewMode: false), transition: Transition.fadeIn),
                          onDeleteTap: () => outbreakFarmHistoryController.confirmDeleteRecord(outbreakFarm),
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
                padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
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
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 13),
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
  }*/

}
