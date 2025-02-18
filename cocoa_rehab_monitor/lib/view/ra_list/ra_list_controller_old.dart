// import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant_model.dart';
// import 'package:cocoa_monitor/controller/global_controller.dart';
// import 'package:cocoa_monitor/view/global_components/globals.dart';
// import 'package:cocoa_monitor/view/home/home_controller.dart';
// import 'package:cocoa_monitor/view/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'components/ra_bottomsheet.dart';
//
// class RAListController extends GetxController{
//
//   BuildContext? RAListScreenContext;
//
//   HomeController homeController = Get.find();
//
//   GlobalController globalController = Get.find();
//
//   Globals globals = Globals();
//
//   PersonnelAssignmentApiInterface personnelAssignmentApiInterface = PersonnelAssignmentApiInterface();
//
//   TextEditingController? searchTC = TextEditingController();
//
//   // TabController? tabController;
//   // var activeTabIndex = 0.obs;
//
//   // INITIALISE
//   @override
//   void onInit() async {
//
//     super.onInit();
//
//   }
//
//
//   viewRA(RehabAssistant rehabAssistant){
//     showModalBottomSheet<void>(
//       elevation: 5,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(AppBorderRadius.md),
//         ),
//       ),
//       context: RAListScreenContext!,
//       builder: (context) {
//         return RABottomSheet(rehabAssistant: rehabAssistant);
//       },
//     );
//   }
//
// }
//
