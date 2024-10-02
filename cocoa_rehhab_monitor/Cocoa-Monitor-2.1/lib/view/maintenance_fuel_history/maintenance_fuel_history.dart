import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/maintenance_fuel.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/edit_maintenance_fuel/edit_maintenance_fuel.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'components/maintenance_fuel_card.dart';
import 'maintenance_fuel_history_controller.dart';

class MaintenanceFuelHistory extends StatefulWidget {
  const MaintenanceFuelHistory({Key? key}) : super(key: key);

  @override
  State<MaintenanceFuelHistory> createState() => _MaintenanceFuelHistoryState();
}

class _MaintenanceFuelHistoryState extends State<MaintenanceFuelHistory> with SingleTickerProviderStateMixin {

  MaintenanceFuelHistoryController maintenanceFuelHistoryController = Get.put(MaintenanceFuelHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
  

    maintenanceFuelHistoryController.pendingRecordsController.addPageRequestListener((pageKey) {
      maintenanceFuelHistoryController.fetchData(status: SubmissionStatus.pending, pageKey: pageKey, controller: maintenanceFuelHistoryController.pendingRecordsController);
    });

    maintenanceFuelHistoryController.submittedRecordsController.addPageRequestListener((pageKey) {
      maintenanceFuelHistoryController.fetchData(status: SubmissionStatus.submitted, pageKey: pageKey, controller: maintenanceFuelHistoryController.submittedRecordsController);
    });
    
    maintenanceFuelHistoryController.tabController = TabController(length: 2, vsync: this);
    maintenanceFuelHistoryController.tabController!.addListener(() {
      maintenanceFuelHistoryController.activeTabIndex.value = maintenanceFuelHistoryController.tabController!.index;
    });
    super.initState();
  }

  @override
  void dispose() {
    
    maintenanceFuelHistoryController.pendingRecordsController.dispose();
    maintenanceFuelHistoryController.submittedRecordsController.dispose();
    maintenanceFuelHistoryController.tabController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    maintenanceFuelHistoryController.context = context;

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
                          child: Text('Maintenance Fuel History',
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
                      maintenanceFuelHistoryController.activeTabIndex.value = index;
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
                    controller: maintenanceFuelHistoryController.tabController,
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Submitted',
                            style: TextStyle(fontWeight: maintenanceFuelHistoryController.activeTabIndex.value == 0 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Pending',
                            style: TextStyle(fontWeight: maintenanceFuelHistoryController.activeTabIndex.value == 1 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: maintenanceFuelHistoryController.tabController,
                    children: [

                      GetBuilder(
                          init: maintenanceFuelHistoryController,
                          builder: (ctx) {
                            return PagedListView<int, MaintenanceFuel>(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: maintenanceFuelHistoryController.submittedRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<MaintenanceFuel>(
                                  itemBuilder: (context, maintenanceFuel, index){
                                    return MaintenanceFuelCard(
                                      maintenanceFuel: maintenanceFuel,
                                      onViewTap: () => Get.to(() => EditMaintenanceFuel(maintenanceFuel: maintenanceFuel, isViewMode: true), transition: Transition.fadeIn),
                                      onEditTap: () => Get.to(() => EditMaintenanceFuel(maintenanceFuel: maintenanceFuel, isViewMode: false), transition: Transition.fadeIn),
                                      onDeleteTap: () => maintenanceFuelHistoryController.confirmDelete(maintenanceFuel),
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
                          init: maintenanceFuelHistoryController,
                          id: 'pendingRecordsBuilder',
                          builder: (ctx) {
                            return PagedListView<int, MaintenanceFuel>(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: maintenanceFuelHistoryController.pendingRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<MaintenanceFuel>(
                                  itemBuilder: (context, maintenanceFuel, index){
                                    return MaintenanceFuelCard(
                                      maintenanceFuel: maintenanceFuel,
                                      onViewTap: () => Get.to(() => EditMaintenanceFuel(maintenanceFuel: maintenanceFuel, isViewMode: true), transition: Transition.fadeIn),
                                      onEditTap: () {
                                        Get.to(() =>
                                            EditMaintenanceFuel(
                                                maintenanceFuel: maintenanceFuel,
                                                isViewMode: false),
                                            transition: Transition.fadeIn
                                        )?.then((data){
                                          if (data != null){
                                            var item = data['maintenanceFuel'];
                                            bool submitted = data['submitted'];

                                            final index = maintenanceFuelHistoryController.pendingRecordsController.itemList?.indexWhere((p) => p.uid == item.uid);
                                            if (index != -1) {
                                              if(submitted){
                                                maintenanceFuelHistoryController.pendingRecordsController.itemList!.remove(maintenanceFuel);
                                                maintenanceFuelHistoryController.update(['pendingRecordsBuilder']);
                                                maintenanceFuelHistoryController.submittedRecordsController.refresh();
                                              }else{
                                                maintenanceFuelHistoryController.pendingRecordsController.itemList![index!] = item;
                                                maintenanceFuelHistoryController.update(['pendingRecordsBuilder']);
                                              }
                                            }
                                          }
                                        });
                                      },
                                      onDeleteTap: () => maintenanceFuelHistoryController.confirmDelete(maintenanceFuel),
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
                    init: maintenanceFuelHistoryController,
                    builder: (context) {
                      return Expanded(
                        child: TabBarView(
                          controller: maintenanceFuelHistoryController.tabController,
                          children: [

                            historyStream(globalController, maintenanceFuelHistoryController, SubmissionStatus.submitted),

                            historyStream(globalController, maintenanceFuelHistoryController, SubmissionStatus.pending),

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

  /*Widget historyStream(GlobalController globalController, MaintenanceFuelHistoryController maintenanceFuelHistoryController, int status) {
    final maintenanceFuelDao = globalController.database!.maintenanceFuelDao;
    return StreamBuilder<List<MaintenanceFuel>>(
      stream: maintenanceFuelDao.findMaintenanceFuelByStatusStream(status),
      builder:
          (BuildContext context, AsyncSnapshot<List<MaintenanceFuel>> snapshot) {

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
                        MaintenanceFuel maintenanceFuel = snapshot.data![index];
                        // return Text("haaa");
                        return MaintenanceFuelCard(
                          maintenanceFuel: maintenanceFuel,
                          onViewTap: () => Get.to(() => EditMaintenanceFuel(maintenanceFuel: maintenanceFuel, isViewMode: true), transition: Transition.fadeIn),
                          onEditTap: () => Get.to(() => EditMaintenanceFuel(maintenanceFuel: maintenanceFuel, isViewMode: false), transition: Transition.fadeIn),
                          onDeleteTap: () => maintenanceFuelHistoryController.confirmDelete(maintenanceFuel),
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
