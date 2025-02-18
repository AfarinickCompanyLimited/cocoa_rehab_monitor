import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/map_farm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/edit_farm/edit_farm.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'components/farm_card.dart';
import 'farm_history_controller.dart';

class MapFarmHistory extends StatefulWidget {
  const MapFarmHistory({Key? key}) : super(key: key);

  @override
  State<MapFarmHistory> createState() => _MapFarmHistoryState();
}

class _MapFarmHistoryState extends State<MapFarmHistory>
    with SingleTickerProviderStateMixin {
  MapFarmHistoryController farmHistoryController =
      Get.put(MapFarmHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    farmHistoryController.pendingRecordsController
        .addPageRequestListener((pageKey) {
      farmHistoryController.fetchData(
          status: SubmissionStatus.pending,
          pageKey: pageKey,
          controller: farmHistoryController.pendingRecordsController);
    });

    farmHistoryController.submittedRecordsController
        .addPageRequestListener((pageKey) {
      farmHistoryController.fetchData(
          status: SubmissionStatus.submitted,
          pageKey: pageKey,
          controller: farmHistoryController.submittedRecordsController);
    });

    farmHistoryController.tabController = TabController(length: 2, vsync: this);
    farmHistoryController.tabController!.addListener(() {
      farmHistoryController.activeTabIndex.value =
          farmHistoryController.tabController!.index;
    });
  }

  @override
  void dispose() {
    farmHistoryController.pendingRecordsController.dispose();
    farmHistoryController.submittedRecordsController.dispose();
    farmHistoryController.tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    farmHistoryController.farmHistoryScreenContext = context;

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
                          child: Text('Mapped Farms',
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
                        farmHistoryController.activeTabIndex.value = index;
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
                      controller: farmHistoryController.tabController,
                      tabs: [
                        Tab(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Submitted',
                              style: TextStyle(
                                  fontWeight: farmHistoryController
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
                                  fontWeight: farmHistoryController
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
                    controller: farmHistoryController.tabController,
                    children: [
                      GetBuilder(
                          init: farmHistoryController,
                          builder: (ctx) {
                            return PagedListView<int, MapFarm>(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: farmHistoryController
                                  .submittedRecordsController,
                              builderDelegate:
                                  PagedChildBuilderDelegate<MapFarm>(
                                      itemBuilder: (context, farm, index) {
                                        return MapFarmCard(
                                          farm: farm,
                                          onViewTap: () => Get.to(
                                              () => EditMapFarm(
                                                  mapFarm: farm,
                                                  isViewMode: true),
                                              transition: Transition.fadeIn),
                                          onEditTap: () => Get.to(
                                              () => EditMapFarm(
                                                  mapFarm: farm,
                                                  isViewMode: false),
                                              transition: Transition.fadeIn),
                                          onDeleteTap: () =>
                                              farmHistoryController
                                                  .confirmDeleteRecord(farm),
                                          allowDelete: false,
                                          allowEdit: false,
                                        );
                                      },
                                      noItemsFoundIndicatorBuilder: (context) =>
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppPadding.horizontal),
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
                      GetBuilder(
                          init: farmHistoryController,
                          id: 'pendingRecordsBuilder',
                          builder: (ctx) {
                            return PagedListView<int, MapFarm>(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 20, top: 15),
                              pagingController: farmHistoryController
                                  .pendingRecordsController,
                              builderDelegate: PagedChildBuilderDelegate<
                                      MapFarm>(
                                  itemBuilder: (context, farm, index) {
                                    return MapFarmCard(
                                      farm: farm,
                                      onViewTap: () => Get.to(
                                          () => EditMapFarm(
                                              mapFarm: farm, isViewMode: true),
                                          transition: Transition.fadeIn),
                                      onEditTap: () {
                                        Get.to(
                                                () => EditMapFarm(
                                                    mapFarm: farm,
                                                    isViewMode: false),
                                                transition: Transition.fadeIn)
                                            ?.then((data) {
                                          if (data != null) {
                                            var updatedFarm = data['farm'];
                                            bool submitted = data['submitted'];

                                            final index = farmHistoryController
                                                .pendingRecordsController
                                                .itemList
                                                ?.indexWhere((MapFarm p) =>
                                                    p.uid == updatedFarm.uid);
                                            if (index != -1) {
                                              if (submitted) {
                                                farmHistoryController
                                                    .pendingRecordsController
                                                    .itemList!
                                                    .remove(farm);
                                                farmHistoryController.update(
                                                    ['pendingRecordsBuilder']);
                                                farmHistoryController
                                                    .submittedRecordsController
                                                    .refresh();
                                              } else {
                                                farmHistoryController
                                                        .pendingRecordsController
                                                        .itemList![index!] =
                                                    updatedFarm;
                                                farmHistoryController.update(
                                                    ['pendingRecordsBuilder']);
                                              }
                                            }
                                          }
                                        });
                                      },
                                      onDeleteTap: () => farmHistoryController
                                          .confirmDeleteRecord(farm),
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
                    init: outbreakMapFarmHistoryController,
                    builder: (context) {
                      return Expanded(
                        child: TabBarView(
                          controller: outbreakMapFarmHistoryController.tabController,
                          children: [

                            outbreakFarmStream(globalController, outbreakMapFarmHistoryController, SubmissionStatus.submitted),

                            outbreakFarmStream(globalController, outbreakMapFarmHistoryController, SubmissionStatus.pending),

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

  /*Widget outbreakFarmStream(GlobalController globalController, OutbreakMapFarmHistoryController outbreakMapFarmHistoryController, int status) {
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
                          onDeleteTap: () => outbreakMapFarmHistoryController.confirmDeleteRecord(outbreakFarm),
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
