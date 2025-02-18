import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_fuel.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/edit_initial_treatment_fuel/edit_initial_treatment_fuel.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'components/initial_treatment_fuel_card.dart';
import 'initial_treatment_fuel_history_controller.dart';


class InitialTreatmentFuelHistory extends StatefulWidget {
  const InitialTreatmentFuelHistory({Key? key}) : super(key: key);

  @override
  State<InitialTreatmentFuelHistory> createState() => _InitialTreatmentFuelHistoryState();
}

class _InitialTreatmentFuelHistoryState extends State<InitialTreatmentFuelHistory> with SingleTickerProviderStateMixin {

  InitialTreatmentFuelHistoryController initialTreatmentFuelHistoryController = Get.put(InitialTreatmentFuelHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    initialTreatmentFuelHistoryController.pendingRecordsController.addPageRequestListener((pageKey) {
      initialTreatmentFuelHistoryController.fetchData(status: SubmissionStatus.pending, pageKey: pageKey, controller: initialTreatmentFuelHistoryController.pendingRecordsController);
    });

    initialTreatmentFuelHistoryController.submittedRecordsController.addPageRequestListener((pageKey) {
      initialTreatmentFuelHistoryController.fetchData(status: SubmissionStatus.submitted, pageKey: pageKey, controller: initialTreatmentFuelHistoryController.submittedRecordsController);
    });
    
    initialTreatmentFuelHistoryController.tabController = TabController(length: 2, vsync: this);
    initialTreatmentFuelHistoryController.tabController!.addListener(() {
      initialTreatmentFuelHistoryController.activeTabIndex.value = initialTreatmentFuelHistoryController.tabController!.index;
    });
  }

  @override
  void dispose() {
    initialTreatmentFuelHistoryController.pendingRecordsController.dispose();
    initialTreatmentFuelHistoryController.submittedRecordsController.dispose();
    initialTreatmentFuelHistoryController.tabController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    initialTreatmentFuelHistoryController.context = context;

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
                          child: Text('Initial Treatment Fuel History',
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
                      initialTreatmentFuelHistoryController.activeTabIndex.value = index;
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
                    controller: initialTreatmentFuelHistoryController.tabController,
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Submitted',
                            style: TextStyle(fontWeight: initialTreatmentFuelHistoryController.activeTabIndex.value == 0 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Pending',
                            style: TextStyle(fontWeight: initialTreatmentFuelHistoryController.activeTabIndex.value == 1 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: initialTreatmentFuelHistoryController.tabController,
                    children: [

                      GetBuilder(
                          init: initialTreatmentFuelHistoryController,
                          builder: (ctx) {
                            return PagedListView<int, InitialTreatmentFuel>(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: initialTreatmentFuelHistoryController.submittedRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<InitialTreatmentFuel>(
                                  itemBuilder: (context, initialTreatmentFuel, index){
                                    return InitialTreatmentFuelCard(
                                      fuel: initialTreatmentFuel,
                                      onViewTap: () => Get.to(() => EditInitialTreatmentFuel(initialTreatmentFuel: initialTreatmentFuel, isViewMode: true), transition: Transition.fadeIn),
                                      onEditTap: () => Get.to(() => EditInitialTreatmentFuel(initialTreatmentFuel: initialTreatmentFuel, isViewMode: false), transition: Transition.fadeIn),
                                      onDeleteTap: () => initialTreatmentFuelHistoryController.confirmDelete(initialTreatmentFuel),
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
                          init: initialTreatmentFuelHistoryController,
                          id: 'pendingRecordsBuilder',
                          builder: (ctx) {
                            return PagedListView<int, InitialTreatmentFuel>(
                              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: initialTreatmentFuelHistoryController.pendingRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<InitialTreatmentFuel>(
                                  itemBuilder: (context, initialTreatmentFuel, index){
                                    return InitialTreatmentFuelCard(
                                      fuel: initialTreatmentFuel,
                                      onViewTap: () => Get.to(() => EditInitialTreatmentFuel(initialTreatmentFuel: initialTreatmentFuel, isViewMode: true), transition: Transition.fadeIn),
                                      onEditTap: () {
                                        Get.to(() =>
                                            EditInitialTreatmentFuel(
                                                initialTreatmentFuel: initialTreatmentFuel,
                                                isViewMode: false),
                                            transition: Transition.fadeIn
                                        )?.then((data){
                                          if (data != null){
                                            var item = data['initialTreatmentFuel'];
                                            bool submitted = data['submitted'];

                                            final index = initialTreatmentFuelHistoryController.pendingRecordsController.itemList?.indexWhere((p) => p.uid == item.uid);
                                            if (index != -1) {
                                              if(submitted){
                                                initialTreatmentFuelHistoryController.pendingRecordsController.itemList!.remove(initialTreatmentFuel);
                                                initialTreatmentFuelHistoryController.update(['pendingRecordsBuilder']);
                                                initialTreatmentFuelHistoryController.submittedRecordsController.refresh();
                                              }else{
                                                initialTreatmentFuelHistoryController.pendingRecordsController.itemList![index!] = item;
                                                initialTreatmentFuelHistoryController.update(['pendingRecordsBuilder']);
                                              }
                                            }
                                          }
                                        });
                                      },
                                      onDeleteTap: () => initialTreatmentFuelHistoryController.confirmDelete(initialTreatmentFuel),
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
                    init: initialTreatmentFuelHistoryController,
                    builder: (context) {
                      return Expanded(
                        child: TabBarView(
                          controller: initialTreatmentFuelHistoryController.tabController,
                          children: [

                            historyStream(globalController, initialTreatmentFuelHistoryController, SubmissionStatus.submitted),

                            historyStream(globalController, initialTreatmentFuelHistoryController, SubmissionStatus.pending),

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

  /*Widget historyStream(GlobalController globalController, InitialTreatmentFuelHistoryController initialTreatmentFuelHistoryController, int status) {
    final initialTreatmentFuelDao = globalController.database!.initialTreatmentFuelDao;
    return StreamBuilder<List<InitialTreatmentFuel>>(
      stream: initialTreatmentFuelDao.findInitialTreatmentFuelByStatusStream(status),
      builder:
          (BuildContext context, AsyncSnapshot<List<InitialTreatmentFuel>> snapshot) {

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
                        InitialTreatmentFuel initialTreatmentFuel = snapshot.data![index];
                        // return Text("haaa");
                        return InitialTreatmentFuelCard(
                          fuel: initialTreatmentFuel,
                          onViewTap: () => Get.to(() => EditInitialTreatmentFuel(initialTreatmentFuel: initialTreatmentFuel, isViewMode: true), transition: Transition.fadeIn),
                          onEditTap: () => Get.to(() => EditInitialTreatmentFuel(initialTreatmentFuel: initialTreatmentFuel, isViewMode: false), transition: Transition.fadeIn),
                          onDeleteTap: () => initialTreatmentFuelHistoryController.confirmDelete(initialTreatmentFuel),
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
