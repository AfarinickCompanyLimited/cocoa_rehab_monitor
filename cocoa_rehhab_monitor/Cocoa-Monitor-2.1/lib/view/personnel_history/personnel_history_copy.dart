// import 'package:cocoa_monitor/controller/constants.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
// import 'package:cocoa_monitor/controller/global_controller.dart';
// import 'package:cocoa_monitor/view/edit_personnel/edit_personnel.dart';
// import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
// import 'package:cocoa_monitor/view/personnel_history/personnel_history_controller.dart';
// import 'package:cocoa_monitor/view/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import 'components/personnel_card.dart';
//
//
// class PersonnelHistory extends StatefulWidget {
//   const PersonnelHistory({Key? key}) : super(key: key);
//
//   @override
//   State<PersonnelHistory> createState() => _PersonnelHistoryState();
// }
//
// class _PersonnelHistoryState extends State<PersonnelHistory> with SingleTickerProviderStateMixin {
//
//   PersonnelHistoryController personnelHistoryController = Get.put(PersonnelHistoryController());
//   GlobalController globalController = Get.find();
//
//   @override
//   void initState() {
//     super.initState();
//     personnelHistoryController.submittedPersonnelRepository.initializeData();
//     personnelHistoryController.pendingPersonnelRepository.initializeData();
//     personnelHistoryController.tabController = TabController(length: 2, vsync: this);
//     personnelHistoryController.tabController!.addListener(() {
//       personnelHistoryController.activeTabIndex.value = personnelHistoryController.tabController!.index;
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     personnelHistoryController.tabController!.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     personnelHistoryController.personnelHistoryScreenContext = context;
//
//     return Material(
//       child: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle(
//           statusBarColor: AppColor.lightBackground,
//           statusBarIconBrightness: Brightness.dark,
//           systemNavigationBarColor: Colors.white,
//           systemNavigationBarIconBrightness: Brightness.dark,
//         ),
//         child: Scaffold(
//           backgroundColor: AppColor.lightBackground,
//           body: GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 Container(
//                   // decoration: BoxDecoration(
//                   //   border: Border(bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)))
//                   // ),
//                   child: Padding(
//                     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: AppPadding.horizontal, right: AppPadding.horizontal),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         RoundedIconButton(
//                           icon: appIconBack(color: AppColor.black, size: 25),
//                           size: 45,
//                           backgroundColor: Colors.transparent,
//                           onTap: () => Get.back(),
//                         ),
//
//                         SizedBox(width: 12,),
//
//                         Expanded(
//                           child: Text('Personnel Added',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // SizedBox(height: 8),
//
//                 Container(
//                   decoration: BoxDecoration(
//                       border: Border(bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)))
//                   ),
//                   child: Obx(() => TabBar(
//                     onTap: (index) {
//                       personnelHistoryController.activeTabIndex.value = index;
//                     },
//                     labelColor: AppColor.black,
//                     unselectedLabelColor: Colors.black87,
//                     indicatorSize: TabBarIndicatorSize.label,
//                     // indicator: BoxDecoration(
//                     //     borderRadius: BorderRadius.circular(AppBorderRadius.xl),
//                     //     color: AppColor.primary
//                     // ),
//                     indicator: BoxDecoration(
//                         color: Colors.transparent,
//                         border: Border(bottom: BorderSide(width: 3.0, color: AppColor.primary))
//                     ),
//                     controller: personnelHistoryController.tabController,
//                     tabs: [
//                       Tab(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text('Submitted',
//                           style: TextStyle(fontWeight: personnelHistoryController.activeTabIndex.value == 0 ? FontWeight.bold : FontWeight.w400),
//                       ),
//                         ),
//                       ),
//                       Tab(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Text('Pending',
//                           style: TextStyle(fontWeight: personnelHistoryController.activeTabIndex.value == 1 ? FontWeight.bold : FontWeight.w400),
//                       ),
//                         ),
//                       )
//                     ],
//                   ),
//                   ),
//                 ),
//
//                 Expanded(
//                   child: TabBarView(
//                     controller: personnelHistoryController.tabController,
//                     children: [
//
//                       Obx(
//                             () {
//                           final personnelList = personnelHistoryController.submittedPersonnelRepository.personnelList;
//
//                           if (personnelList.isEmpty) {
//                             return Center(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const SizedBox(height: 50),
//                                     Image.asset(
//                                       'assets/images/cocoa_monitor/empty-box.png',
//                                       width: 60,
//                                     ),
//                                     const SizedBox(height: 20),
//                                     Text(
//                                       "No data found",
//                                       style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 13),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//
//                           return ListView.builder(
//                             padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85, top: 5),
//                             itemCount: personnelList.length,
//                             itemBuilder: (context, index) {
//                               final personnel = personnelList[index];
//                               return PersonnelCard(
//                                 personnel: personnel,
//                                 onViewTap: () => Get.to(() => EditPersonnel(personnel: personnel, isViewMode: true), transition: Transition.fadeIn),
//                                 onEditTap: () => Get.to(() => EditPersonnel(personnel: personnel, isViewMode: false), transition: Transition.fadeIn),
//                                 onDeleteTap: () => personnelHistoryController.confirmDeletePersonnel(personnel),
//                                 allowDelete: false,
//                                 allowEdit: false,
//                                 // allowDelete: status == SubmissionStatus.submitted,
//                                 // allowEdit: status == SubmissionStatus.submitted,
//                               );
//                             },
//                           );
//                         },
//                       ),
//
//                       Obx(
//                             () {
//                           final personnelList = personnelHistoryController.pendingPersonnelRepository.personnelList;
//
//                           if (personnelList.isEmpty) {
//                             return Center(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     const SizedBox(height: 50),
//                                     Image.asset(
//                                       'assets/images/cocoa_monitor/empty-box.png',
//                                       width: 60,
//                                     ),
//                                     const SizedBox(height: 20),
//                                     Text(
//                                       "No data found",
//                                       style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 13),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           }
//
//                           return ListView.builder(
//                             padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
//                             itemCount: personnelList.length,
//                             itemBuilder: (context, index) {
//                               final personnel = personnelList[index];
//                               return PersonnelCard(
//                                 personnel: personnel,
//                                 onViewTap: () => Get.to(() => EditPersonnel(personnel: personnel, isViewMode: true), transition: Transition.fadeIn),
//                                 onEditTap: () {
//                                   Get.to(() =>
//                                       EditPersonnel(
//                                           personnel: personnel,
//                                           isViewMode: false,
//                                       ),
//                                       transition: Transition.fadeIn,
//                                   )?.then((updatedPersonnel){
//                                     if (updatedPersonnel != null){
//                                       final index = personnelList.indexWhere((p) => p.uid == updatedPersonnel.uid);
//                                       if (index != -1) {
//                                         personnelList[index] = updatedPersonnel;
//                                       }
//                                     }
//                                   });
//                                 },
//                                 onDeleteTap: () => personnelHistoryController.confirmDeletePersonnel(personnel),
//                                 allowDelete: true,
//                                 allowEdit: true,
//                                 // allowDelete: status == SubmissionStatus.submitted,
//                                 // allowEdit: status == SubmissionStatus.submitted,
//                               );
//                             },
//                           );
//                         },
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//                 /*GetBuilder(
//                     init: personnelHistoryController,
//                     builder: (context) {
//                       return Expanded(
//                         child: TabBarView(
//                           controller: personnelHistoryController.tabController,
//                           children: [
//
//                             personnelStream(globalController, personnelHistoryController, SubmissionStatus.submitted),
//
//                             personnelStream(globalController, personnelHistoryController, SubmissionStatus.pending),
//
//                           ],
//                         ),
//                       );
//                     }
//                 ),*/
//
//               ],
//
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget personnelStream(GlobalController globalController, PersonnelHistoryController personnelHistoryController, int status) {
//     final personnelDao = globalController.database!.personnelDao;
//     return StreamBuilder<List<Personnel>>(
//       stream: personnelDao.findPersonnelByStatusStream(status),
//       builder:
//           (BuildContext context, AsyncSnapshot<List<Personnel>> snapshot) {
//
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: Image.asset('assets/gif/loading2.gif', height: 60),
//               );
//             } else if (snapshot.connectionState == ConnectionState.active
//                 || snapshot.connectionState == ConnectionState.done) {
//               if (snapshot.hasError) {
//                 return Center(child: const Text('Oops.. Something went wrong'));
//               } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                   return SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // const SizedBox(height: 10,),
//                         ListView.builder(
//                             physics: const NeverScrollableScrollPhysics(),
//                             scrollDirection: Axis.vertical,
//                             shrinkWrap: true,
//                             itemCount: snapshot.data!.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               Personnel personnel = snapshot.data![index];
//                               return PersonnelCard(
//                                 personnel: personnel,
//                                 onViewTap: () => Get.to(() => EditPersonnel(personnel: personnel, isViewMode: true), transition: Transition.fadeIn),
//                                 onEditTap: () => Get.to(() => EditPersonnel(personnel: personnel, isViewMode: false), transition: Transition.fadeIn),
//                                 onDeleteTap: () => personnelHistoryController.confirmDeletePersonnel(personnel),
//                                 allowDelete: status != SubmissionStatus.submitted,
//                                 allowEdit: status != SubmissionStatus.submitted,
//                                 // allowDelete: status == SubmissionStatus.submitted,
//                                 // allowEdit: status == SubmissionStatus.submitted,
//                               );
//                             }),
//                       ],
//                     ),
//                   );
//               } else {
//                 return Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 50),
//                         Image.asset(
//                           'assets/images/cocoa_monitor/empty-box.png',
//                           width: 80,
//                         ),
//                         const SizedBox(height: 20),
//                         Text(
//                           "There is nothing to display here",
//                           style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 13),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//             } else {
//               return Center(
//                 child: Image.asset('assets/gif/loading2.gif', height: 60),
//               );
//             }
//
//       },
//     );
//   }
//
//
// }
