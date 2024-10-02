import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/edit_assign_ra/edit_assign_ra.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'components/personnel_assignment_card.dart';
import 'personnel_assignment_history_controller.dart';


class PersonnelAssignmentHistory extends StatefulWidget {
  const PersonnelAssignmentHistory({Key? key}) : super(key: key);

  @override
  State<PersonnelAssignmentHistory> createState() => _PersonnelAssignmentHistoryState();
}

class _PersonnelAssignmentHistoryState extends State<PersonnelAssignmentHistory> with SingleTickerProviderStateMixin {

  PersonnelAssignmentHistoryController personnelAssignmentHistoryController = Get.put(PersonnelAssignmentHistoryController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();
    personnelAssignmentHistoryController.tabController = TabController(length: 2, vsync: this);
    personnelAssignmentHistoryController.tabController!.addListener(() {
      personnelAssignmentHistoryController.activeTabIndex.value = personnelAssignmentHistoryController.tabController!.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    personnelAssignmentHistoryController.tabController!.dispose();
  }


  @override
  Widget build(BuildContext context) {

    personnelAssignmentHistoryController.personnelAssignmentHistoryScreenContext = context;

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
                          child: Text('Personnel Assignment History',
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
                      personnelAssignmentHistoryController.activeTabIndex.value = index;
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
                    controller: personnelAssignmentHistoryController.tabController,
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Submitted',
                            style: TextStyle(fontWeight: personnelAssignmentHistoryController.activeTabIndex.value == 0 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Pending',
                            style: TextStyle(fontWeight: personnelAssignmentHistoryController.activeTabIndex.value == 1 ? FontWeight.bold : FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                  ),
                ),

                GetBuilder(
                    init: personnelAssignmentHistoryController,
                    builder: (context) {
                      return Expanded(
                        child: TabBarView(
                          controller: personnelAssignmentHistoryController.tabController,
                          children: [

                            personnelAssignmentStream(globalController, personnelAssignmentHistoryController, SubmissionStatus.submitted),

                            personnelAssignmentStream(globalController, personnelAssignmentHistoryController, SubmissionStatus.pending),

                          ],
                        ),
                      );
                    }
                ),

              ],

            ),
          ),
        ),
      ),
    );
  }

  Widget personnelAssignmentStream(GlobalController globalController, PersonnelAssignmentHistoryController personnelAssignmentHistoryController, int status) {
    final personnelAssignmentDao = globalController.database!.personnelAssignmentDao;
    return StreamBuilder<List<PersonnelAssignment>>(
      stream: personnelAssignmentDao.findPersonnelAssignmentByStatusStream(status),
      builder:
          (BuildContext context, AsyncSnapshot<List<PersonnelAssignment>> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/gif/loading2.gif', height: 60),
          );
        } else if (snapshot.connectionState == ConnectionState.active
            || snapshot.connectionState == ConnectionState.done) {
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
                        PersonnelAssignment personnelAssignment = snapshot.data![index];
                        // return Text("haaa");
                        return PersonnelAssignmentCard(
                          personnelAssignment: personnelAssignment,
                          onViewTap: () => Get.to(() => EditAssignRA(personnelAssignment: personnelAssignment, isViewMode: true), transition: Transition.fadeIn),
                          onEditTap: () => Get.to(() => EditAssignRA(personnelAssignment: personnelAssignment, isViewMode: false), transition: Transition.fadeIn),
                          onDeleteTap: () => personnelAssignmentHistoryController.confirmDeletePersonnelAssignment(personnelAssignment),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
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
