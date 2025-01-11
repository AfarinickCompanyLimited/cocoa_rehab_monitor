// import 'package:cocoa_monitor/controller/constants.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant_model.dart';
// import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm_status.dart';
// import 'package:cocoa_monitor/controller/global_controller.dart';
// import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
// import 'package:cocoa_monitor/view/ra_list/ra_list_controller.dart';
// import 'package:cocoa_monitor/view/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import 'components/ra_list_card.dart';
//
//
// class RAList extends StatefulWidget {
//   const RAList({Key? key}) : super(key: key);
//
//   @override
//   State<RAList> createState() => _RAListState();
// }
//
// class _RAListState extends State<RAList> with SingleTickerProviderStateMixin {
//
//   RAListController raListController = Get.put(RAListController());
//   GlobalController globalController = Get.find();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     raListController.RAListScreenContext = context;
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
//                   decoration: BoxDecoration(
//                     border: Border(bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)))
//                   ),
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
//                           child: Text('RA / RT List',
//                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 SizedBox(height: 12,),
//
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15),
//                   child: TextFormField(
//                     controller: raListController.searchTC,
//                     textCapitalization: TextCapitalization.words,
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                       enabledBorder: inputBorder,
//                       focusedBorder: inputBorderFocused,
//                       errorBorder: inputBorder,
//                       focusedErrorBorder: inputBorderFocused,
//                       filled: true,
//                       fillColor: AppColor.white,
//                       hintText: 'Search name or staff ID',
//                       hintStyle: TextStyle(color: AppColor.lightText, fontSize: 13),
//                       prefixIcon: Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: appIconSearch(color: AppColor.lightText, size: 15),
//                       ),
//                     ),
//                     textInputAction: TextInputAction.search,
//                     onChanged: (val){
//                       raListController.update();
//                     },
//                   ),
//                 ),
//
//                 SizedBox(height: 8),
//
//                 Expanded(
//                   child:  GetBuilder(
//                     init: raListController,
//                     builder: (context) {
//                       return raListStream(globalController, raListController);
//                     }
//                   ),
//                 )
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
//   Widget raListStream(GlobalController globalController, RAListController raListController) {
//     final rehabAssistantDao = globalController.database!.rehabAssistantDao;
//     return StreamBuilder<List<RehabAssistant>>(
//       // stream: rehabAssistantDao.findAllRehabAssistantStream(),
//       stream: raListController.searchTC!.text.isEmpty ? rehabAssistantDao.findAllRehabAssistantStream() : rehabAssistantDao.streamAllRehabAssistantWithNamesLike("%${raListController.searchTC!.text.toLowerCase()}%"),
//       // stream: raListController.searchTC!.text.isEmpty ? rehabAssistantDao.findAllRehabAssistantStream() : rehabAssistantDao.streamAllRehabAssistantWithNamesLike("%${raListController.searchTC!.text.toLowerCase()}%"),
//       builder:
//           (BuildContext context, AsyncSnapshot<List<RehabAssistant>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: Image.asset('assets/gif/loading2.gif', height: 60),
//           );
//         } else if (snapshot.connectionState == ConnectionState.active
//             || snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError) {
//             return Center(child: const Text('Oops.. Something went wrong'));
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             return SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // const SizedBox(height: 10,),
//                   ListView.builder(
//                     padding: EdgeInsets.only(top: 8),
//                       physics: const NeverScrollableScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         RehabAssistant rehabAssistant = snapshot.data![index];
//                         // return Text("haaa");
//                         return RAListCard(
//                           rehabAssistant: rehabAssistant,
//                           onTap: () => raListController.viewRA(rehabAssistant),
//                         );
//                       }),
//                 ],
//               ),
//             );
//           } else {
//             return Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 50),
//                     Image.asset(
//                       'assets/images/cocoa_monitor/empty-box.png',
//                       width: 80,
//                     ),
//                     const SizedBox(height: 20),
//                     Text(
//                       "There is nothing to display here",
//                       style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 13),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         } else {
//           return Center(
//             child: Image.asset('assets/gif/loading2.gif', height: 60),
//           );
//         }
//
//       },
//     );
//   }
//
// }
