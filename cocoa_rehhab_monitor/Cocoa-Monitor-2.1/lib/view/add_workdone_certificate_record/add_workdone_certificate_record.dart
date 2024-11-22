// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../../controller/constants.dart';
// import '../../controller/entity/cocoa_rehub_monitor/activity.dart';
// import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
// import '../../controller/entity/cocoa_rehub_monitor/region_district.dart';
// import '../global_components/custom_button.dart';
// import '../global_components/round_icon_button.dart';
// import '../global_components/text_input_decoration.dart';
// import '../utils/pattern_validator.dart';
// import '../utils/style.dart';
// import 'add_workdone_record_controller.dart';
// import 'farm_id_bottom_sheet.dart';
//
// class AddContractorCertificateRecord extends StatefulWidget {
//   const AddContractorCertificateRecord({Key? key}) : super(key: key);
//
//   @override
//   State<AddContractorCertificateRecord> createState() =>
//       _AddContractorCertificateRecordState();
// }
//
// class _AddContractorCertificateRecordState
//     extends State<AddContractorCertificateRecord> {
//   bool activityCheck = false;
//   bool subActivityCheck = false;
//   @override
//   Widget build(BuildContext context) {
//     int currentYear = DateTime.now().year;
//     int startingYear = 2022;
//     List<int> yearList =
//         List.generate((currentYear - startingYear) + 1, (index) {
//       return startingYear + index;
//     });
//     // HomeController homeController = Get.find();
//     AddContractorCertificateRecordController
//         addContractorCertificateRecordController =
//         Get.put(AddContractorCertificateRecordController());
//     addContractorCertificateRecordController
//         .addContractorCertificateRecordScreenContext = context;
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
//                 Container(
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: AppColor.lightText.withOpacity(0.5)))),
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).padding.top + 15,
//                         bottom: 10,
//                         left: AppPadding.horizontal,
//                         right: AppPadding.horizontal),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         RoundedIconButton(
//                           icon: appIconBack(color: AppColor.black, size: 25),
//                           size: 45,
//                           backgroundColor: Colors.transparent,
//                           onTap: () => Get.back(),
//                         ),
//                         const SizedBox(
//                           width: 12,
//                         ),
//                         Expanded(
//                           child: Text('New WD By Contractor Certificate',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColor.black)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(
//                         left: AppPadding.horizontal,
//                         right: AppPadding.horizontal,
//                         bottom: AppPadding.vertical,
//                         top: 10),
//                     child: Column(
//                       children: [
//                         Form(
//                           key: addContractorCertificateRecordController
//                               .addContractorCertificateRecordFormKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 'Current Year',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<String>(
//                                 popupProps: PopupProps.menu(
//                                     showSelectedItems: true,
//                                     disabledItemFn: (String s) => false,
//                                     fit: FlexFit.loose,
//                                     menuProps: MenuProps(
//                                         elevation: 6,
//                                         borderRadius: BorderRadius.circular(
//                                             AppBorderRadius.sm))),
//                                 items: yearList
//                                     .map((year) => year.toString())
//                                     .toList(),
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (item) {
//                                   if (item == null) {
//                                     return "Current year is required";
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .selectedYear = val!;
//                                   addContractorCertificateRecordController
//                                       .update();
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Current Month',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<String>(
//                                 popupProps: PopupProps.menu(
//                                     showSelectedItems: true,
//                                     disabledItemFn: (String s) => false,
//                                     fit: FlexFit.loose,
//                                     menuProps: MenuProps(
//                                         elevation: 6,
//                                         borderRadius: BorderRadius.circular(
//                                             AppBorderRadius.sm))),
//                                 items: addContractorCertificateRecordController
//                                     .listOfMonths,
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (item) {
//                                   if (item == null) {
//                                     return "Current month is required";
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .selectedMonth = val!;
//                                   addContractorCertificateRecordController
//                                       .update();
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Current Week',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<String>(
//                                 popupProps: PopupProps.menu(
//                                     showSelectedItems: true,
//                                     disabledItemFn: (String s) => false,
//                                     fit: FlexFit.loose,
//                                     menuProps: MenuProps(
//                                         elevation: 6,
//                                         borderRadius: BorderRadius.circular(
//                                             AppBorderRadius.sm))),
//                                 items: addContractorCertificateRecordController
//                                     .listOfWeeks,
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (item) {
//                                   if (item == null) {
//                                     return "Current week is required";
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .selectedWeek = val!;
//                                   addContractorCertificateRecordController
//                                       .update();
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Farm Reference Number',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//
//                               TextFormField(
//                                 onTap: () {
//                                   // Show the bottom sheet when the TextFormField is tapped
//                                   showModalBottomSheet(
//                                     context: context,
//                                     isScrollControlled:
//                                         true, // Allows the bottom sheet to be sized based on its content
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(20),
//                                       ),
//                                     ),
//                                     builder: (context) {
//                                       return FarmIdBottomSheet(); // Your custom bottom sheet widget
//                                     },
//                                   );
//                                 },
//                                 controller:
//                                     addContractorCertificateRecordController
//                                         .farmReferenceNumberTC,
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 15, horizontal: 15),
//                                   enabledBorder: inputBorder,
//                                   focusedBorder: inputBorderFocused,
//                                   errorBorder: inputBorder,
//                                   focusedErrorBorder: inputBorderFocused,
//                                   filled: true,
//                                   fillColor: AppColor.xLightBackground,
//                                 ),
//                                 keyboardType: TextInputType.none,
//                                 textCapitalization:
//                                     TextCapitalization.characters,
//                                 textInputAction: TextInputAction.next,
//                                 autovalidateMode: AutovalidateMode.always,
//                                 validator:
//                                     FarmReferencePatternValidator.validate,
//                               ),
//
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Farmer Name',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               TextFormField(
//                                 controller:
//                                 addContractorCertificateRecordController
//                                     .farmerNameTC,
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 15, horizontal: 15),
//                                   enabledBorder: inputBorder,
//                                   focusedBorder: inputBorderFocused,
//                                   errorBorder: inputBorder,
//                                   focusedErrorBorder: inputBorderFocused,
//                                   filled: true,
//                                   fillColor: AppColor.lightText,
//                                 ),
//                                 keyboardType: TextInputType.numberWithOptions(
//                                     decimal: true),
//                                 textInputAction: TextInputAction.next,
//                                 autovalidateMode: AutovalidateMode.always,
//                                 validator: (String? value) =>
//                                 value!.trim().isEmpty
//                                     ? "Farmer name is required"
//                                     : null,
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Farm Size (in hectares)',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               TextFormField(
//
//                                 controller:
//                                     addContractorCertificateRecordController
//                                         .farmSizeTC,
//                                 readOnly: true,
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 15, horizontal: 15),
//                                   enabledBorder: inputBorder,
//                                   focusedBorder: inputBorderFocused,
//                                   errorBorder: inputBorder,
//                                   focusedErrorBorder: inputBorderFocused,
//                                   filled: true,
//                                   fillColor: AppColor.lightText,
//                                 ),
//                                 keyboardType: TextInputType.numberWithOptions(
//                                     decimal: true),
//                                 textInputAction: TextInputAction.next,
//                                 autovalidateMode: AutovalidateMode.always,
//                                 validator: (String? value) =>
//                                     value!.trim().isEmpty
//                                         ? "Farm size is required"
//                                         : null,
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Community',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               TextFormField(
//                                 readOnly: true,
//                                 controller:
//                                     addContractorCertificateRecordController
//                                         .communityTC,
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 15, horizontal: 15),
//                                   enabledBorder: inputBorder,
//                                   focusedBorder: inputBorderFocused,
//                                   errorBorder: inputBorder,
//                                   focusedErrorBorder: inputBorderFocused,
//                                   filled: true,
//                                   fillColor: AppColor.lightText,
//                                 ),
//                                 keyboardType: TextInputType.text,
//                                 textCapitalization: TextCapitalization.words,
//                                 textInputAction: TextInputAction.next,
//                                 autovalidateMode: AutovalidateMode.always,
//                                 validator: (String? value) =>
//                                     value!.trim().isEmpty
//                                         ? "Community is required"
//                                         : null,
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'District',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<RegionDistrict>(
//                                 popupProps: PopupProps.modalBottomSheet(
//                                     showSelectedItems: true,
//                                     showSearchBox: true,
//                                     itemBuilder: (context, item, selected) {
//                                       return ListTile(
//                                         title: Text(
//                                             item.districtName.toString(),
//                                             style: selected
//                                                 ? TextStyle(
//                                                     color: AppColor.primary)
//                                                 : const TextStyle()),
//                                         subtitle: Text(
//                                           item.regionName.toString(),
//                                         ),
//                                       );
//                                     },
//                                     title: const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 15),
//                                       child: Center(
//                                         child: Text(
//                                           'Select district',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                     ),
//                                     disabledItemFn: (RegionDistrict s) => false,
//                                     modalBottomSheetProps:
//                                         ModalBottomSheetProps(
//                                       elevation: 6,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(
//                                                   AppBorderRadius.md),
//                                               topRight: Radius.circular(
//                                                   AppBorderRadius.md))),
//                                     ),
//                                     searchFieldProps: TextFieldProps(
//                                       decoration: InputDecoration(
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                                 vertical: 4, horizontal: 15),
//                                         enabledBorder: inputBorder,
//                                         focusedBorder: inputBorderFocused,
//                                         errorBorder: inputBorder,
//                                         focusedErrorBorder: inputBorderFocused,
//                                         filled: true,
//                                         fillColor: AppColor.xLightBackground,
//                                       ),
//                                     )),
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 asyncItems: (String filter) async {
//                                   var response =
//                                       await addContractorCertificateRecordController
//                                           .globalController
//                                           .database!
//                                           .regionDistrictDao
//                                           .findAllRegionDistrict();
//                                   return response;
//                                 },
//                                 itemAsString: (RegionDistrict d) =>
//                                     d.districtName ?? '',
//                                 // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                 compareFn: (d, filter) =>
//                                     d.districtName == filter.districtName,
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .regionDistrict = val;
//                                 },
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (item) {
//                                   if (item == null) {
//                                     return 'District is required';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                               ),
//
//                               /* const Text(
//                                 'Community',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<Community>(
//                                 popupProps: PopupProps.modalBottomSheet(
//                                     showSelectedItems: true,
//                                     showSearchBox: true,
//                                     itemBuilder: (context, item, selected) {
//                                       return ListTile(
//                                         title: Text(item.community.toString(),
//                                             style: selected
//                                                 ? TextStyle(
//                                                     color: AppColor.primary)
//                                                 : const TextStyle()),
//                                         subtitle: Text(
//                                           item.operationalArea.toString(),
//                                         ),
//                                       );
//                                     },
//                                     title: const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 15),
//                                       child: Center(
//                                         child: Text(
//                                           'Select community',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                     ),
//                                     disabledItemFn: (Community s) => false,
//                                     modalBottomSheetProps:
//                                         ModalBottomSheetProps(
//                                       elevation: 6,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(
//                                                   AppBorderRadius.md),
//                                               topRight: Radius.circular(
//                                                   AppBorderRadius.md))),
//                                     ),
//                                     searchFieldProps: TextFieldProps(
//                                       decoration: InputDecoration(
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                                 vertical: 4, horizontal: 15),
//                                         enabledBorder: inputBorder,
//                                         focusedBorder: inputBorderFocused,
//                                         errorBorder: inputBorder,
//                                         focusedErrorBorder: inputBorderFocused,
//                                         filled: true,
//                                         fillColor: AppColor.xLightBackground,
//                                       ),
//                                     )),
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 asyncItems: (String filter) async {
//                                   var response =
//                                       await addContractorCertificateRecordController
//                                           .globalController
//                                           .database!
//                                           .communityDao
//                                           .findAllCommunity();
//                                   return response;
//                                 },
//                                 itemAsString: (Community d) =>
//                                     d.community ?? '',
//                                 // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                 compareFn: (d, filter) =>
//                                     d.community == filter.community,
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .community = val;
//                                 },
//                                 selectedItem:
//                                     addContractorCertificateRecordController
//                                         .community,
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (item) {
//                                   if (item == null) {
//                                     return 'Community is required';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                               ),*/
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Activity',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<Activity>(
//                                 popupProps: PopupProps.modalBottomSheet(
//                                     showSelectedItems: true,
//                                     showSearchBox: true,
//                                     title: const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 15),
//                                       child: Center(
//                                         child: Text(
//                                           'Select Activity',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                     ),
//                                     disabledItemFn: (Activity s) => false,
//                                     modalBottomSheetProps:
//                                         ModalBottomSheetProps(
//                                       elevation: 6,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(
//                                                   AppBorderRadius.md),
//                                               topRight: Radius.circular(
//                                                   AppBorderRadius.md))),
//                                     ),
//                                     searchFieldProps: TextFieldProps(
//                                       decoration: InputDecoration(
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                                 vertical: 4, horizontal: 15),
//                                         enabledBorder: inputBorder,
//                                         focusedBorder: inputBorderFocused,
//                                         errorBorder: inputBorder,
//                                         focusedErrorBorder: inputBorderFocused,
//                                         filled: true,
//                                         fillColor: AppColor.xLightBackground,
//                                       ),
//                                     )),
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 asyncItems: (String filter) async {
//                                   // var response = await addInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findAllMainActivity();
//                                   var response =
//                                       await addContractorCertificateRecordController
//                                           .globalController
//                                           .database!
//                                           .activityDao
//                                           .findAllActivityWithMainActivityList([
//                                     MainActivities.InitialTreatment,
//                                     MainActivities.Maintenance,
//                                     MainActivities.Establishment
//                                   ]);
//                                   return response;
//                                 },
//                                 itemAsString: (Activity d) =>
//                                     d.mainActivity!.toString(),
//                                 // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                 compareFn: (activity, filter) =>
//                                     activity.mainActivity ==
//                                     filter.mainActivity,
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .activity = val!;
//
//                                   print(
//                                       "Activity ------------- ${addContractorCertificateRecordController.activity.mainActivity}");
//
//                                   if (addContractorCertificateRecordController
//                                           .activity.mainActivity ==
//                                       MainActivities.Maintenance) {
//                                     addContractorCertificateRecordController
//                                         .activityCheck.value = true;
//                                   }
//
//                                   // addContractorCertificateRecordController
//                                   //     .subActivity = Activity() as List<Activity>;
//                                   addContractorCertificateRecordController
//                                       .update();
//                                   print(
//                                       ' SHOWWWW ${addContractorCertificateRecordController.activity.code}');
//                                 },
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (item) {
//                                   if (item == null) {
//                                     return 'Activity is required';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 'Sub Activity',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<Activity>.multiSelection(
//                                 popupProps:
//                                     PopupPropsMultiSelection.modalBottomSheet(
//                                         showSelectedItems: true,
//                                         showSearchBox: true,
//                                         title: const Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 15),
//                                           child: Center(
//                                             child: Text(
//                                               'Select Sub Activity',
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                         ),
//                                         disabledItemFn: (Activity s) => false,
//                                         modalBottomSheetProps:
//                                             ModalBottomSheetProps(
//                                           elevation: 6,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.only(
//                                                   topLeft: Radius.circular(
//                                                       AppBorderRadius.md),
//                                                   topRight: Radius.circular(
//                                                       AppBorderRadius.md))),
//                                         ),
//                                         searchFieldProps: TextFieldProps(
//                                           decoration: InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 4,
//                                                     horizontal: 15),
//                                             enabledBorder: inputBorder,
//                                             focusedBorder: inputBorderFocused,
//                                             errorBorder: inputBorder,
//                                             focusedErrorBorder:
//                                                 inputBorderFocused,
//                                             filled: true,
//                                             fillColor:
//                                                 AppColor.xLightBackground,
//                                           ),
//                                         )),
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 asyncItems: (String filter) async {
//                                   var response =
//                                       await addContractorCertificateRecordController
//                                           .globalController
//                                           .database!
//                                           .activityDao
//                                           .findSubActivities(
//                                               addContractorCertificateRecordController
//                                                       .activity.mainActivity ??
//                                                   "");
//
//                                   return response;
//                                 },
//                                 itemAsString: (Activity d) =>
//                                     d.subActivity!.toString(),
//                                 // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                 compareFn: (activity, filter) =>
//                                     activity.subActivity == filter.subActivity,
//                                 onChanged: (vals) {
//                                   addContractorCertificateRecordController
//                                       .subActivity = vals;
//
//                                   if (addContractorCertificateRecordController
//                                               .subActivity.length ==
//                                           1 &&
//                                       addContractorCertificateRecordController
//                                               .subActivity[0].subActivity
//                                               .toString()
//                                               .toUpperCase() ==
//                                           "weeding of replanted farms"
//                                               .toUpperCase()) {
//                                     print(
//                                         "SubActivity ======= ${addContractorCertificateRecordController.subActivity[0].subActivity}");
//
//                                     addContractorCertificateRecordController
//                                         .subActivityCheck.value = true;
//                                   }
//
//                                   addContractorCertificateRecordController
//                                       .update();
//                                 },
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (items) {
//                                   if (items == null || items.isEmpty) {
//                                     return 'Sub activity is required';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                               ),
//                               const SizedBox(height: 20),
//
//                               // if (addContractorCertificateRecordController
//                               //         .activityCheck.value &&
//                               //     addContractorCertificateRecordController
//                               //         .subActivityCheck.value)
//                               const Text(
//                                 'Rounds of weeding',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(height: 5),
//                               DropdownSearch<String>(
//                                 popupProps: PopupProps.menu(
//                                   showSelectedItems: true,
//                                   disabledItemFn: (String s) => false,
//                                   fit: FlexFit.loose,
//                                   menuProps: MenuProps(
//                                     elevation: 6,
//                                     borderRadius: BorderRadius.circular(
//                                         AppBorderRadius.sm),
//                                   ),
//                                 ),
//                                 items: addContractorCertificateRecordController
//                                     .listOfRoundsOfWeeding,
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 autoValidateMode: AutovalidateMode.always,
//                                 // validator: (item) {
//                                 //   if (addContractorCertificateRecordController
//                                 //               .activity.mainActivity ==
//                                 //           MainActivities.Maintenance &&
//                                 //       addContractorCertificateRecordController
//                                 //               .subActivity[0].subActivity ==
//                                 //           "Weeding Of Replanted Farms") {
//                                 //     return "Rounds of weeding is required";
//                                 //   } else {
//                                 //     return null;
//                                 //   }
//                                 // },
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .roundsOfWeeding = val!;
//                                   addContractorCertificateRecordController
//                                       .update();
//                                 },
//                               ),
//                               const SizedBox(height: 5),
//
//                               const Text(
//                                 'Contractor Name',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               DropdownSearch<Contractor>(
//                                 popupProps: PopupProps.modalBottomSheet(
//                                     showSelectedItems: true,
//                                     showSearchBox: true,
//                                     itemBuilder: (context, item, selected) {
//                                       return ListTile(
//                                         title: Text(
//                                             item.contractorName.toString(),
//                                             style: selected
//                                                 ? TextStyle(
//                                                     color: AppColor.primary)
//                                                 : const TextStyle()),
//                                       );
//                                     },
//                                     title: const Padding(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 15),
//                                       child: Center(
//                                         child: Text(
//                                           'Select contractor',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                     ),
//                                     disabledItemFn: (Contractor s) => false,
//                                     modalBottomSheetProps:
//                                         ModalBottomSheetProps(
//                                       elevation: 6,
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.only(
//                                               topLeft: Radius.circular(
//                                                   AppBorderRadius.md),
//                                               topRight: Radius.circular(
//                                                   AppBorderRadius.md))),
//                                     ),
//                                     searchFieldProps: TextFieldProps(
//                                       decoration: InputDecoration(
//                                         contentPadding:
//                                             const EdgeInsets.symmetric(
//                                                 vertical: 4, horizontal: 15),
//                                         enabledBorder: inputBorder,
//                                         focusedBorder: inputBorderFocused,
//                                         errorBorder: inputBorder,
//                                         focusedErrorBorder: inputBorderFocused,
//                                         filled: true,
//                                         fillColor: AppColor.xLightBackground,
//                                       ),
//                                     )),
//                                 dropdownDecoratorProps: DropDownDecoratorProps(
//                                   dropdownSearchDecoration: InputDecoration(
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 15),
//                                     enabledBorder: inputBorder,
//                                     focusedBorder: inputBorderFocused,
//                                     errorBorder: inputBorder,
//                                     focusedErrorBorder: inputBorderFocused,
//                                     filled: true,
//                                     fillColor: AppColor.xLightBackground,
//                                   ),
//                                 ),
//                                 asyncItems: (String filter) async {
//                                   var response =
//                                       await addContractorCertificateRecordController
//                                           .globalController
//                                           .database!
//                                           .contractorDao
//                                           .findAllContractors();
//                                   return response;
//                                 },
//                                 itemAsString: (Contractor d) =>
//                                     d.contractorName ?? '',
//                                 // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                 compareFn: (d, filter) =>
//                                     d.contractorName == filter.contractorName,
//                                 onChanged: (val) {
//                                   addContractorCertificateRecordController
//                                       .contractor = val;
//                                 },
//
//                                 autoValidateMode: AutovalidateMode.always,
//                                 validator: (item) {
//                                   if (item == null) {
//                                     return 'Contractor name is required';
//                                   } else {
//                                     return null;
//                                   }
//                                 },
//                               ),
//                               // const SizedBox(height: 20),
//                               // const Divider(),
//                               // GetBuilder(
//                               //     init:
//                               //         addContractorCertificateRecordController,
//                               //     builder: (context) {
//                               //       return addContractorCertificateRecordController
//                               //                   .locationData !=
//                               //               null
//                               //           ? Column(
//                               //               mainAxisSize: MainAxisSize.min,
//                               //               crossAxisAlignment:
//                               //                   CrossAxisAlignment.start,
//                               //               children: [
//                               //                 const SizedBox(height: 20),
//                               //                 Text(
//                               //                   'LOCATION',
//                               //                   style: TextStyle(
//                               //                       fontWeight: FontWeight.w700,
//                               //                       fontSize: 16,
//                               //                       color: AppColor.black),
//                               //                 ),
//                               //                 const SizedBox(height: 5),
//                               //                 Text(
//                               //                   'Lat : ${addContractorCertificateRecordController.locationData!.latitude}',
//                               //                   style: const TextStyle(
//                               //                       fontWeight:
//                               //                           FontWeight.w500),
//                               //                 ),
//                               //                 Text(
//                               //                   'Lng : ${addContractorCertificateRecordController.locationData!.longitude}',
//                               //                   style: const TextStyle(
//                               //                       fontWeight:
//                               //                           FontWeight.w500),
//                               //                 ),
//                               //                 Text(
//                               //                   'Accuracy : ${addContractorCertificateRecordController.locationData!.accuracy!.truncateToDecimalPlaces(2).toString()}',
//                               //                   style: const TextStyle(
//                               //                       fontWeight:
//                               //                           FontWeight.w500),
//                               //                 ),
//                               //               ],
//                               //             )
//                               //           : Container();
//                               //     }),
//                               const SizedBox(
//                                 height: 40,
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: CustomButton(
//                                       isFullWidth: true,
//                                       backgroundColor: AppColor.black,
//                                       verticalPadding: 0.0,
//                                       horizontalPadding: 8.0,
//                                       onTap: () async {
//                                         // if (!addContractorCertificateRecordController
//                                         //     .isSaveButtonDisabled.value) {
//                                         if (addContractorCertificateRecordController
//                                             .addContractorCertificateRecordFormKey
//                                             .currentState!
//                                             .validate()) {
//                                           addContractorCertificateRecordController
//                                               .handleSaveOfflineMonitoringRecord();
//                                         } else {
//                                           addContractorCertificateRecordController
//                                               .globals
//                                               .showSnackBar(
//                                                   title: 'Alert',
//                                                   message:
//                                                       'Kindly provide all required information');
//                                         }
//                                         // }
//                                       },
//                                       child:
//                                           // Obx(
//                                           // () =>
//                                           Text(
//                                         // addContractorCertificateRecordController
//                                         //         .isSaveButtonDisabled.value
//                                         //     ? 'Please wait ...'
//                                         //     :
//                                         'Save',
//                                         style: TextStyle(
//                                             color: AppColor.white,
//                                             fontSize: 14),
//                                       ),
//                                       // ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 20),
//                                   Expanded(
//                                     child: CustomButton(
//                                       isFullWidth: true,
//                                       backgroundColor: AppColor.primary,
//                                       verticalPadding: 0.0,
//                                       horizontalPadding: 8.0,
//                                       onTap: () async {
//                                         addContractorCertificateRecordController
//                                             .handleAddMonitoringRecord();
//                                         // if (!addContractorCertificateRecordController
//                                         //     .isButtonDisabled.value) {
//                                         if (addContractorCertificateRecordController
//                                             .addContractorCertificateRecordFormKey
//                                             .currentState!
//                                             .validate()) {
//                                           addContractorCertificateRecordController
//                                               .handleAddMonitoringRecord();
//                                         } else {
//                                           addContractorCertificateRecordController
//                                               .globals
//                                               .showSnackBar(
//                                                   title: 'Alert',
//                                                   message:
//                                                       'Kindly provide all required information');
//                                         }
//                                         // }
//                                       },
//                                       child:
//                                           // Obx(
//                                           //   () =>
//                                           Text(
//                                         // addContractorCertificateRecordController
//                                         //         .isButtonDisabled.value
//                                         //     ? 'Please wait ...'
//                                         //     :
//                                         'Submit',
//                                         style: TextStyle(
//                                             color: AppColor.white,
//                                             fontSize: 14),
//                                       ),
//                                       // ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 30),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
// import 'package:cocoa_monitor/view/global_components/image_field_card.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
// import 'package:cocoa_monitor/view/home/home_controller.dart';
// import 'package:cocoa_monitor/view/utils/double_value_trimmer.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/constants.dart';
import '../../controller/db/activity_db.dart';
import '../../controller/model/activity_model.dart';
import '../utils/pattern_validator.dart';
import 'add_workdone_record_controller.dart';

class AddContractorCertificateRecord extends StatefulWidget {
  const AddContractorCertificateRecord({Key? key}) : super(key: key);

  @override
  State<AddContractorCertificateRecord> createState() =>
      _AddContractorCertificateRecordState();
}

class _AddContractorCertificateRecordState
    extends State<AddContractorCertificateRecord> {
  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    int startingYear = 2022;
    List<int> yearList =
    List.generate((currentYear - startingYear) + 1, (index) {
      return startingYear + index;
    });
    // HomeController homeController = Get.find();
    AddContractorCertificateRecordController
    addContractorCertificateRecordController =
    Get.put(AddContractorCertificateRecordController());
    addContractorCertificateRecordController
        .addContractorCertificateRecordScreenContext = context;

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
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: AppColor.lightText.withOpacity(0.5)))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 15,
                        bottom: 10,
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
                          child: Text('New WD By Contractor Certificate',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: AppPadding.horizontal,
                        right: AppPadding.horizontal,
                        bottom: AppPadding.vertical,
                        top: 10),
                    child: Column(
                      children: [
                        Form(
                          key: addContractorCertificateRecordController
                              .addContractorCertificateRecordFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Current Year',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                    disabledItemFn: (String s) => false,
                                    fit: FlexFit.loose,
                                    menuProps: MenuProps(
                                        elevation: 6,
                                        borderRadius: BorderRadius.circular(
                                            AppBorderRadius.sm))),
                                items: yearList
                                    .map((year) => year.toString())
                                    .toList(),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return "Current year is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addContractorCertificateRecordController
                                      .selectedYear = val!;
                                  addContractorCertificateRecordController
                                      .update();
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Current Month',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                    disabledItemFn: (String s) => false,
                                    fit: FlexFit.loose,
                                    menuProps: MenuProps(
                                        elevation: 6,
                                        borderRadius: BorderRadius.circular(
                                            AppBorderRadius.sm))),
                                items: addContractorCertificateRecordController
                                    .listOfMonths,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return "Current month is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addContractorCertificateRecordController
                                      .selectedMonth = val!;
                                  addContractorCertificateRecordController
                                      .update();
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Current Week',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<String>(
                                popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                    disabledItemFn: (String s) => false,
                                    fit: FlexFit.loose,
                                    menuProps: MenuProps(
                                        elevation: 6,
                                        borderRadius: BorderRadius.circular(
                                            AppBorderRadius.sm))),
                                items: addContractorCertificateRecordController
                                    .listOfWeeks,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return "Current week is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addContractorCertificateRecordController
                                      .selectedWeek = val!;
                                  addContractorCertificateRecordController
                                      .update();
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Farm Reference Number',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller:
                                addContractorCertificateRecordController
                                    .farmReferenceNumberTC,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  enabledBorder: inputBorder,
                                  focusedBorder: inputBorderFocused,
                                  errorBorder: inputBorder,
                                  focusedErrorBorder: inputBorderFocused,
                                  filled: true,
                                  fillColor: AppColor.xLightBackground,
                                ),
                                keyboardType: TextInputType.url,
                                textCapitalization:
                                TextCapitalization.characters,
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.always,
                                validator:
                                FarmReferencePatternValidator.validate,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Farm Size (in hectares)',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller:
                                addContractorCertificateRecordController
                                    .farmSizeTC,
                                // readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  enabledBorder: inputBorder,
                                  focusedBorder: inputBorderFocused,
                                  errorBorder: inputBorder,
                                  focusedErrorBorder: inputBorderFocused,
                                  filled: true,
                                  fillColor: AppColor.xLightBackground,
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (String? value) =>
                                value!.trim().isEmpty
                                    ? "Farm size is required"
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Community',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller:
                                addContractorCertificateRecordController
                                    .communityTC,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  enabledBorder: inputBorder,
                                  focusedBorder: inputBorderFocused,
                                  errorBorder: inputBorder,
                                  focusedErrorBorder: inputBorderFocused,
                                  filled: true,
                                  fillColor: AppColor.xLightBackground,
                                ),
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.always,
                                validator: (String? value) =>
                                value!.trim().isEmpty
                                    ? "Community is required"
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'District',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<RegionDistrict>(
                                popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    itemBuilder: (context, item, selected) {
                                      return ListTile(
                                        title: Text(
                                            item.districtName.toString(),
                                            style: selected
                                                ? TextStyle(
                                                color: AppColor.primary)
                                                : const TextStyle()),
                                        subtitle: Text(
                                          item.regionName.toString(),
                                        ),
                                      );
                                    },
                                    title: const Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select district',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    disabledItemFn: (RegionDistrict s) => false,
                                    modalBottomSheetProps:
                                    ModalBottomSheetProps(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  AppBorderRadius.md),
                                              topRight: Radius.circular(
                                                  AppBorderRadius.md))),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                    )),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                asyncItems: (String filter) async {
                                  var response =
                                  await addContractorCertificateRecordController
                                      .globalController
                                      .database!
                                      .regionDistrictDao
                                      .findAllRegionDistrict();
                                  return response;
                                },
                                itemAsString: (RegionDistrict d) =>
                                d.districtName ?? '',
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn: (d, filter) =>
                                d.districtName == filter.districtName,
                                onChanged: (val) {
                                  addContractorCertificateRecordController
                                      .regionDistrict = val;
                                },
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return 'District is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),

                              /* const Text(
                                'Community',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<Community>(
                                popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    itemBuilder: (context, item, selected) {
                                      return ListTile(
                                        title: Text(item.community.toString(),
                                            style: selected
                                                ? TextStyle(
                                                    color: AppColor.primary)
                                                : const TextStyle()),
                                        subtitle: Text(
                                          item.operationalArea.toString(),
                                        ),
                                      );
                                    },
                                    title: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select community',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    disabledItemFn: (Community s) => false,
                                    modalBottomSheetProps:
                                        ModalBottomSheetProps(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  AppBorderRadius.md),
                                              topRight: Radius.circular(
                                                  AppBorderRadius.md))),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                    )),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                asyncItems: (String filter) async {
                                  var response =
                                      await addContractorCertificateRecordController
                                          .globalController
                                          .database!
                                          .communityDao
                                          .findAllCommunity();
                                  return response;
                                },
                                itemAsString: (Community d) =>
                                    d.community ?? '',
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn: (d, filter) =>
                                    d.community == filter.community,
                                onChanged: (val) {
                                  addContractorCertificateRecordController
                                      .community = val;
                                },
                                selectedItem:
                                    addContractorCertificateRecordController
                                        .community,
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return 'Community is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),*/
                              const SizedBox(height: 20),

                              const Text(
                                'Activity',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              DropdownSearch<String>(
                                popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    title: const Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select Activity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    disabledItemFn: (String s) => false,
                                    modalBottomSheetProps:
                                    ModalBottomSheetProps(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  AppBorderRadius.md),
                                              topRight: Radius.circular(
                                                  AppBorderRadius.md))),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                    )),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                items: [
                                  "Establishment",
                                  "Initial Treatment",
                                  "Maintenance",
                                ],
                                // asyncItems: (String filter) async {
                                //   ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
                                //   var response = await db.findAllActivityWithMainActivityList(
                                //   [
                                //       MainActivities.InitialTreatment,
                                //       MainActivities.Maintenance,
                                //       MainActivities.Establishment
                                //     ]
                                //   );
                                //
                                //   print("THE RESPONSE ::::::: ${response}");
                                //
                                //    // var response = await addContractorCertificateVerificationRecordController.globalController.database!.activityDao.findAllMainActivity();
                                //   // var response =
                                //   //     await addContractorCertificateVerificationRecordController
                                //   //         .globalController
                                //   //         .database!
                                //   //         .activityDao
                                //   //         .findAllActivityWithMainActivityList([
                                //   //   MainActivities.InitialTreatment,
                                //   //   MainActivities.Maintenance,
                                //   //   MainActivities.Establishment
                                //   // ]);
                                //   return response;
                                // },
                                itemAsString: (String d) =>
                                d,
                                //filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                // compareFn: (activity, filter) =>
                                //     activity.mainActivity ==
                                //     filter.mainActivity,
                                onChanged: (val) {

                                  print("YESSSSS");
                                  addContractorCertificateRecordController
                                      .activity = val!;
                                  // print("CODE ::::::::::: ${addContractorCertificateVerificationRecordController.activity.mainActivity}");
                                  // print("MAIN ACTIVITY :::::::::::::: ${addContractorCertificateVerificationRecordController.activity.code}");

                                  // addContractorCertificateRecordController
                                  //     .subActivity = Activity() as List<Activity>;
                                  addContractorCertificateRecordController
                                      .update();
                                },
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return 'Activity is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Sub Activity',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<ActivityModel>.multiSelection(
                                popupProps:
                                PopupPropsMultiSelection.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    title: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select Sub Activity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    disabledItemFn: (ActivityModel s) => false,
                                    modalBottomSheetProps:
                                    ModalBottomSheetProps(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  AppBorderRadius.md),
                                              topRight: Radius.circular(
                                                  AppBorderRadius.md))),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 4,
                                            horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder:
                                        inputBorderFocused,
                                        filled: true,
                                        fillColor:
                                        AppColor.xLightBackground,
                                      ),
                                    )),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                asyncItems: (String filter) async {

                                  ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
                                  var response = await db.getSubActivityByMainActivity(
                                      addContractorCertificateRecordController
                                          .activity ?? ""
                                  );

                                  // var response =
                                  //     await addContractorCertificateVerificationRecordController
                                  //         .globalController
                                  //         .database!
                                  //         .activityDao
                                  //         .findSubActivities(
                                  //             addContractorCertificateVerificationRecordController
                                  //                     .activity ?? ""
                                  //                 );

                                  return response;
                                },
                                itemAsString: (ActivityModel d) =>
                                    d.subActivity!.toString(),
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn: (activity, filter) =>
                                activity.subActivity == filter.subActivity,
                                onChanged: (vals) {
                                  addContractorCertificateRecordController
                                      .subActivity = vals;
                                  addContractorCertificateRecordController
                                      .update();
                                },
                                autoValidateMode: AutovalidateMode.always,
                                validator: (items) {
                                  if (items == null || items.isEmpty) {
                                    return 'Sub activity is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 20),

                              const Text(
                                'Contractor Name',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<Contractor>(
                                popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    itemBuilder: (context, item, selected) {
                                      return ListTile(
                                        title: Text(
                                            item.contractorName.toString(),
                                            style: selected
                                                ? TextStyle(
                                                color: AppColor.primary)
                                                : const TextStyle()),
                                      );
                                    },
                                    title: const Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select contractor',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    disabledItemFn: (Contractor s) => false,
                                    modalBottomSheetProps:
                                    ModalBottomSheetProps(
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  AppBorderRadius.md),
                                              topRight: Radius.circular(
                                                  AppBorderRadius.md))),
                                    ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                    )),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                ),
                                asyncItems: (String filter) async {
                                  var response =
                                  await addContractorCertificateRecordController
                                      .globalController
                                      .database!
                                      .contractorDao
                                      .findAllContractors();
                                  return response;
                                },
                                itemAsString: (Contractor d) =>
                                d.contractorName ?? '',
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn: (d, filter) =>
                                d.contractorName == filter.contractorName,
                                onChanged: (val) {
                                  addContractorCertificateRecordController
                                      .contractor = val;
                                },

                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return 'Contractor name is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              // const SizedBox(height: 20),
                              // const Divider(),
                              // GetBuilder(
                              //     init:
                              //         addContractorCertificateRecordController,
                              //     builder: (context) {
                              //       return addContractorCertificateRecordController
                              //                   .locationData !=
                              //               null
                              //           ? Column(
                              //               mainAxisSize: MainAxisSize.min,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.start,
                              //               children: [
                              //                 const SizedBox(height: 20),
                              //                 Text(
                              //                   'LOCATION',
                              //                   style: TextStyle(
                              //                       fontWeight: FontWeight.w700,
                              //                       fontSize: 16,
                              //                       color: AppColor.black),
                              //                 ),
                              //                 const SizedBox(height: 5),
                              //                 Text(
                              //                   'Lat : ${addContractorCertificateRecordController.locationData!.latitude}',
                              //                   style: const TextStyle(
                              //                       fontWeight:
                              //                           FontWeight.w500),
                              //                 ),
                              //                 Text(
                              //                   'Lng : ${addContractorCertificateRecordController.locationData!.longitude}',
                              //                   style: const TextStyle(
                              //                       fontWeight:
                              //                           FontWeight.w500),
                              //                 ),
                              //                 Text(
                              //                   'Accuracy : ${addContractorCertificateRecordController.locationData!.accuracy!.truncateToDecimalPlaces(2).toString()}',
                              //                   style: const TextStyle(
                              //                       fontWeight:
                              //                           FontWeight.w500),
                              //                 ),
                              //               ],
                              //             )
                              //           : Container();
                              //     }),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      isFullWidth: true,
                                      backgroundColor: AppColor.black,
                                      verticalPadding: 0.0,
                                      horizontalPadding: 8.0,
                                      onTap: () async {
                                        // if (!addContractorCertificateRecordController
                                        //     .isSaveButtonDisabled.value) {
                                        if (addContractorCertificateRecordController
                                            .addContractorCertificateRecordFormKey
                                            .currentState!
                                            .validate()) {
                                          addContractorCertificateRecordController
                                              .handleSaveOfflineMonitoringRecord();
                                        } else {
                                          addContractorCertificateRecordController
                                              .globals
                                              .showSnackBar(
                                              title: 'Alert',
                                              message:
                                              'Kindly provide all required information');
                                        }
                                        // }
                                      },
                                      child:
                                      // Obx(
                                      // () =>
                                      Text(
                                        // addContractorCertificateRecordController
                                        //         .isSaveButtonDisabled.value
                                        //     ? 'Please wait ...'
                                        //     :
                                        'Save',
                                        style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 14),
                                      ),
                                      // ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: CustomButton(
                                      isFullWidth: true,
                                      backgroundColor: AppColor.primary,
                                      verticalPadding: 0.0,
                                      horizontalPadding: 8.0,
                                      onTap: () async {
                                        // if (!addContractorCertificateRecordController
                                        //     .isButtonDisabled.value) {
                                        if (addContractorCertificateRecordController
                                            .addContractorCertificateRecordFormKey
                                            .currentState!
                                            .validate()) {
                                          addContractorCertificateRecordController
                                              .handleAddMonitoringRecord();
                                        } else {
                                          addContractorCertificateRecordController
                                              .globals
                                              .showSnackBar(
                                              title: 'Alert',
                                              message:
                                              'Kindly provide all required information');
                                        }
                                        // }
                                      },
                                      child:
                                      // Obx(
                                      //   () =>
                                      Text(
                                        // addContractorCertificateRecordController
                                        //         .isButtonDisabled.value
                                        //     ? 'Please wait ...'
                                        //     :
                                        'Submit',
                                        style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 14),
                                      ),
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}