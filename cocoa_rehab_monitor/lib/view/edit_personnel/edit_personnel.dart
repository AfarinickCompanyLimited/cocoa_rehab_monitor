import 'dart:convert';

import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:cocoa_rehab_monitor/view/global_components/image_field_card.dart';
import 'edit_personnel_controller.dart';

class EditPersonnel extends StatefulWidget {
  final Personnel personnel;
  final bool isViewMode;
  const EditPersonnel(
      {Key? key, required this.personnel, required this.isViewMode})
      : super(key: key);

  @override
  State<EditPersonnel> createState() => _EditPersonnelState();
}

class _EditPersonnelState extends State<EditPersonnel> {
  EditPersonnelController editPersonnelController =
      Get.put(EditPersonnelController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    editPersonnelController.personnel = widget.personnel;
  }

  @override
  Widget build(BuildContext context) {
    editPersonnelController.editPersonnelControllerScreenContext = context;

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
                          child: Text(
                              widget.isViewMode
                                  ? 'View Rehab Assistant'
                                  : 'Edit Rehab Assistant',
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
                        AbsorbPointer(
                          absorbing: widget.isViewMode,
                          child: GetBuilder(
                              init: editPersonnelController,
                              builder: (ctx) {
                                return Form(
                                  key: editPersonnelController
                                      .editPersonnelFormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Staff Type',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppBorderRadius.sm))),
                                        items: editPersonnelController
                                            .designationItems,
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
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
                                        ),
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return "Staff type is required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) =>
                                            editPersonnelController
                                                .designation.value = val!,
                                        selectedItem:
                                            widget.personnel.designation,
                                      ),
                                      const SizedBox(height: 20),

                                      const Text(
                                        'Full Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            editPersonnelController.nameTC,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        validator: (String? value) =>
                                            value!.trim().isEmpty
                                                ? "First name is required"
                                                : null,
                                      ),
                                      const SizedBox(height: 20),

                                      // const Text('Middle Name',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // TextFormField(
                                      //   controller: editPersonnelController.middleNameTC,
                                      //   textCapitalization: TextCapitalization.words,
                                      //   decoration: InputDecoration(
                                      //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //     enabledBorder: inputBorder,
                                      //     focusedBorder: inputBorderFocused,
                                      //     errorBorder: inputBorder,
                                      //     focusedErrorBorder: inputBorderFocused,
                                      //     filled: true,
                                      //     fillColor: AppColor.xLightBackground,
                                      //   ),
                                      //   textInputAction: TextInputAction.next,
                                      // ),
                                      // const SizedBox(height: 20),
                                      //
                                      // const Text('Last Name',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // TextFormField(
                                      //   controller: editPersonnelController.lastNameTC,
                                      //   textCapitalization: TextCapitalization.words,
                                      //   decoration: InputDecoration(
                                      //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //     enabledBorder: inputBorder,
                                      //     focusedBorder: inputBorderFocused,
                                      //     errorBorder: inputBorder,
                                      //     focusedErrorBorder: inputBorderFocused,
                                      //     filled: true,
                                      //     fillColor: AppColor.xLightBackground,
                                      //   ),
                                      //   textInputAction: TextInputAction.next,
                                      //   validator: (String? value) => value!.trim().isEmpty
                                      //       ? "Last name is required"
                                      //       : null,
                                      // ),
                                      // const SizedBox(height: 20),

                                      const Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppBorderRadius.sm))),
                                        items:
                                            editPersonnelController.genderItems,
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
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
                                        ),
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return "Gender is required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) =>
                                            editPersonnelController.gender =
                                                val!,
                                        selectedItem: widget.personnel.gender,
                                      ),
                                      const SizedBox(height: 20),

                                      const Text(
                                        'Date of Birth',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      DateTimePicker(
                                        type: DateTimePickerType.date,
                                        dateMask: 'yyyy-MM-dd',
                                        firstDate: DateTime(1600),
                                        lastDate: DateTime.now(),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                        onChanged: (val) =>
                                            editPersonnelController
                                                .dateOfBirth = val,
                                        validator: (String? value) =>
                                            value!.trim().isEmpty
                                                ? "Date of birth is required"
                                                : null,
                                        onSaved: (val) =>
                                            editPersonnelController
                                                .dateOfBirth = val,
                                        initialValue: widget.personnel.dob,
                                      ),

                                      // Obx(() => editPersonnelController.designation == PersonnelDesignation.projectOfficer
                                      //     ? Column(
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     const SizedBox(height: 20),
                                      //     const Text('Email',
                                      //       style: TextStyle(fontWeight: FontWeight.w500),
                                      //     ),
                                      //     const SizedBox(height: 5,),
                                      //     TextFormField(
                                      //       controller: editPersonnelController.emailTC,
                                      //       decoration: InputDecoration(
                                      //         contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //         enabledBorder: inputBorder,
                                      //         focusedBorder: inputBorderFocused,
                                      //         errorBorder: inputBorder,
                                      //         focusedErrorBorder: inputBorderFocused,
                                      //         filled: true,
                                      //         fillColor: AppColor.xLightBackground,
                                      //       ),
                                      //       keyboardType: TextInputType.emailAddress,
                                      //       textInputAction: TextInputAction.next,
                                      //       validator: (String? value) => value!.trim().isEmpty
                                      //           ? "Email is required"
                                      //           : null,
                                      //     ),
                                      //   ],
                                      // )
                                      //     : Container(),
                                      // ),

                                      const SizedBox(height: 20),

                                      const Text(
                                        'Phone Number',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            editPersonnelController.phoneTC,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.next,
                                        validator: (String? value) =>
                                            value!.trim().isEmpty ||
                                                    value.trim().length != 10
                                                ? "Enter a valid phone number"
                                                : null,
                                      ),
                                      const SizedBox(height: 20),

                                      // const Text(
                                      //   'Region',
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // FutureBuilder(
                                      //   builder: (ctx, snapshot) {
                                      //     // Checking if future is resolved or not
                                      //     if (snapshot.connectionState ==
                                      //         ConnectionState.done) {
                                      //       if (snapshot.hasError) {
                                      //         return Center(
                                      //           child: Text(
                                      //             '${snapshot.error} occurred',
                                      //             style: const TextStyle(
                                      //                 fontSize: 18),
                                      //           ),
                                      //         );
                                      //       } else if (snapshot.hasData) {
                                      //         List? dataList =
                                      //             snapshot.data as List;
                                      //         RegionDistrict? data =
                                      //             dataList.isNotEmpty
                                      //                 ? dataList.first
                                      //                     as RegionDistrict?
                                      //                 : RegionDistrict();
                                      //         editPersonnelController.region =
                                      //             data;
                                      //
                                      //         return DropdownSearch<
                                      //             RegionDistrict>(
                                      //           popupProps:
                                      //               PopupProps.modalBottomSheet(
                                      //                   showSelectedItems: true,
                                      //                   showSearchBox: true,
                                      //                   title: const Padding(
                                      //                     padding: EdgeInsets
                                      //                         .symmetric(
                                      //                             vertical: 15),
                                      //                     child: Center(
                                      //                       child: Text(
                                      //                         'Select Region',
                                      //                         style: TextStyle(
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .w500),
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                   disabledItemFn:
                                      //                       (RegionDistrict
                                      //                               s) =>
                                      //                           false,
                                      //                   modalBottomSheetProps:
                                      //                       ModalBottomSheetProps(
                                      //                     elevation: 6,
                                      //                     shape: RoundedRectangleBorder(
                                      //                         borderRadius: BorderRadius.only(
                                      //                             topLeft: Radius
                                      //                                 .circular(
                                      //                                     AppBorderRadius
                                      //                                         .md),
                                      //                             topRight: Radius
                                      //                                 .circular(
                                      //                                     AppBorderRadius
                                      //                                         .md))),
                                      //                   ),
                                      //                   searchFieldProps:
                                      //                       TextFieldProps(
                                      //                     decoration:
                                      //                         InputDecoration(
                                      //                       contentPadding:
                                      //                           const EdgeInsets
                                      //                                   .symmetric(
                                      //                               vertical: 4,
                                      //                               horizontal:
                                      //                                   15),
                                      //                       enabledBorder:
                                      //                           inputBorder,
                                      //                       focusedBorder:
                                      //                           inputBorderFocused,
                                      //                       errorBorder:
                                      //                           inputBorder,
                                      //                       focusedErrorBorder:
                                      //                           inputBorderFocused,
                                      //                       filled: true,
                                      //                       fillColor: AppColor
                                      //                           .xLightBackground,
                                      //                     ),
                                      //                   )),
                                      //           dropdownDecoratorProps:
                                      //               DropDownDecoratorProps(
                                      //             dropdownSearchDecoration:
                                      //                 InputDecoration(
                                      //               contentPadding:
                                      //                   const EdgeInsets
                                      //                           .symmetric(
                                      //                       vertical: 4,
                                      //                       horizontal: 15),
                                      //               enabledBorder: inputBorder,
                                      //               focusedBorder:
                                      //                   inputBorderFocused,
                                      //               errorBorder: inputBorder,
                                      //               focusedErrorBorder:
                                      //                   inputBorderFocused,
                                      //               filled: true,
                                      //               fillColor: AppColor
                                      //                   .xLightBackground,
                                      //             ),
                                      //           ),
                                      //
                                      //           asyncItems:
                                      //               (String filter) async {
                                      //             var response =
                                      //                 await editPersonnelController
                                      //                     .globalController
                                      //                     .database!
                                      //                     .regionDistrictDao
                                      //                     .findRegions();
                                      //             return response;
                                      //           },
                                      //           itemAsString:
                                      //               (RegionDistrict d) =>
                                      //                   d.regionName ?? '',
                                      //           // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                      //           compareFn: (regionDistrict,
                                      //                   filter) =>
                                      //               regionDistrict.regionName ==
                                      //               filter.regionName,
                                      //           onChanged: (val) {
                                      //             editPersonnelController
                                      //                 .region = val;
                                      //             editPersonnelController
                                      //                     .district =
                                      //                 RegionDistrict();
                                      //           },
                                      //           autoValidateMode:
                                      //               AutovalidateMode.always,
                                      //           selectedItem: data,
                                      //           validator: (item) {
                                      //             if (item == null) {
                                      //               return 'Region is required';
                                      //             } else {
                                      //               return null;
                                      //             }
                                      //           },
                                      //         );
                                      //       }
                                      //     }
                                      //
                                      //     // Displaying LoadingSpinner to indicate waiting state
                                      //     return const Center(
                                      //       child: CircularProgressIndicator(),
                                      //     );
                                      //   },
                                      //
                                      //   // Future that needs to be resolved
                                      //   // inorder to display something on the Canvas
                                      //   future: globalController
                                      //       .database!.regionDistrictDao
                                      //       .findRegionDistrictByRegionId(
                                      //           widget.personnel.region!),
                                      // ),
                                      // const SizedBox(height: 20),
                                      //
                                      // const Text(
                                      //   'District',
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // FutureBuilder(
                                      //   builder: (ctx, snapshot) {
                                      //     // Checking if future is resolved or not
                                      //     if (snapshot.connectionState ==
                                      //         ConnectionState.done) {
                                      //       if (snapshot.hasError) {
                                      //         return Center(
                                      //           child: Text(
                                      //             '${snapshot.error} occurred',
                                      //             style: const TextStyle(
                                      //                 fontSize: 18),
                                      //           ),
                                      //         );
                                      //       } else if (snapshot.hasData) {
                                      //         List? dataList =
                                      //             snapshot.data as List;
                                      //         RegionDistrict? data =
                                      //             dataList.isNotEmpty
                                      //                 ? dataList.first
                                      //                     as RegionDistrict?
                                      //                 : RegionDistrict();
                                      //         editPersonnelController.district =
                                      //             data;
                                      //
                                      //         return DropdownSearch<
                                      //             RegionDistrict>(
                                      //           popupProps:
                                      //               PopupProps.modalBottomSheet(
                                      //                   showSelectedItems: true,
                                      //                   showSearchBox: true,
                                      //                   title: const Padding(
                                      //                     padding: EdgeInsets
                                      //                         .symmetric(
                                      //                             vertical: 15),
                                      //                     child: Center(
                                      //                       child: Text(
                                      //                         'Select District',
                                      //                         style: TextStyle(
                                      //                             fontWeight:
                                      //                                 FontWeight
                                      //                                     .w500),
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                   disabledItemFn:
                                      //                       (RegionDistrict
                                      //                               s) =>
                                      //                           false,
                                      //                   modalBottomSheetProps:
                                      //                       ModalBottomSheetProps(
                                      //                     elevation: 6,
                                      //                     shape: RoundedRectangleBorder(
                                      //                         borderRadius: BorderRadius.only(
                                      //                             topLeft: Radius
                                      //                                 .circular(
                                      //                                     AppBorderRadius
                                      //                                         .md),
                                      //                             topRight: Radius
                                      //                                 .circular(
                                      //                                     AppBorderRadius
                                      //                                         .md))),
                                      //                   ),
                                      //                   searchFieldProps:
                                      //                       TextFieldProps(
                                      //                     decoration:
                                      //                         InputDecoration(
                                      //                       contentPadding:
                                      //                           const EdgeInsets
                                      //                                   .symmetric(
                                      //                               vertical: 4,
                                      //                               horizontal:
                                      //                                   15),
                                      //                       enabledBorder:
                                      //                           inputBorder,
                                      //                       focusedBorder:
                                      //                           inputBorderFocused,
                                      //                       errorBorder:
                                      //                           inputBorder,
                                      //                       focusedErrorBorder:
                                      //                           inputBorderFocused,
                                      //                       filled: true,
                                      //                       fillColor: AppColor
                                      //                           .xLightBackground,
                                      //                     ),
                                      //                   )),
                                      //           dropdownDecoratorProps:
                                      //               DropDownDecoratorProps(
                                      //             dropdownSearchDecoration:
                                      //                 InputDecoration(
                                      //               contentPadding:
                                      //                   const EdgeInsets
                                      //                           .symmetric(
                                      //                       vertical: 4,
                                      //                       horizontal: 15),
                                      //               enabledBorder: inputBorder,
                                      //               focusedBorder:
                                      //                   inputBorderFocused,
                                      //               errorBorder: inputBorder,
                                      //               focusedErrorBorder:
                                      //                   inputBorderFocused,
                                      //               filled: true,
                                      //               fillColor: AppColor
                                      //                   .xLightBackground,
                                      //             ),
                                      //           ),
                                      //           asyncItems:
                                      //               (String filter) async {
                                      //             var response =
                                      //                 await editPersonnelController
                                      //                     .globalController
                                      //                     .database!
                                      //                     .regionDistrictDao
                                      //                     .findDistrictsInRegion(
                                      //                         editPersonnelController
                                      //                                 .region
                                      //                                 ?.regionName ??
                                      //                             '');
                                      //             return response;
                                      //           },
                                      //           itemAsString:
                                      //               (RegionDistrict d) =>
                                      //                   d.districtName ?? '',
                                      //           compareFn:
                                      //               (regionDistrict, filter) =>
                                      //                   regionDistrict
                                      //                       .districtName ==
                                      //                   filter.districtName,
                                      //           onChanged: (val) {
                                      //             editPersonnelController
                                      //                 .district = val;
                                      //           },
                                      //           autoValidateMode:
                                      //               AutovalidateMode.always,
                                      //           selectedItem: data,
                                      //           validator: (item) {
                                      //             if (item == null &&
                                      //                 editPersonnelController
                                      //                         .district?.id ==
                                      //                     null) {
                                      //               return 'District is required';
                                      //             } else {
                                      //               return null;
                                      //             }
                                      //           },
                                      //         );
                                      //       }
                                      //     }
                                      //
                                      //     // Displaying LoadingSpinner to indicate waiting state
                                      //     return const Center(
                                      //       child: CircularProgressIndicator(),
                                      //     );
                                      //   },
                                      //
                                      //   // Future that needs to be resolved
                                      //   // inorder to display something on the Canvas
                                      //   future: globalController
                                      //       .database!.regionDistrictDao
                                      //       .findRegionDistrictByDistrictId(
                                      //           widget.personnel.district!
                                      //               ),
                                      // ),
                                      // const SizedBox(height: 20),

                                      // const Text('Operational Area',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // TextFormField(
                                      //   controller: editPersonnelController.operationalAreaTC,
                                      //   textCapitalization: TextCapitalization.words,
                                      //   decoration: InputDecoration(
                                      //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //     enabledBorder: inputBorder,
                                      //     focusedBorder: inputBorderFocused,
                                      //     errorBorder: inputBorder,
                                      //     focusedErrorBorder: inputBorderFocused,
                                      //     filled: true,
                                      //     fillColor: AppColor.xLightBackground,
                                      //   ),
                                      //   textInputAction: TextInputAction.next,
                                      //   validator: (String? value) => value!.trim().isEmpty
                                      //       ? "Operational area is required"
                                      //       : null,
                                      // ),

                                      // const SizedBox(height: 20),

                                      const Text(
                                        'Personnel Photo',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      GetBuilder(
                                          init: editPersonnelController,
                                          builder: (context) {
                                            return ImageFieldCard(
                                              onTap: () =>
                                                  editPersonnelController
                                                      .chooseMediaSource(
                                                          PersonnelImageData
                                                              .personnelImage),
                                              image: editPersonnelController
                                                  .personnelPhoto?.file,
                                              base64Image: base64Encode(
                                                  widget.personnel.photoStaff ??
                                                      []),
                                            );
                                          }),

                                      // if (!widget.isViewMode)
                                      // GetBuilder(
                                      //     init: editPersonnelController,
                                      //     builder: (ctx) {
                                      //       return editPersonnelController.personnelPhoto?.file == null
                                      //           ? Padding(
                                      //         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      //         child: Column(
                                      //           crossAxisAlignment: CrossAxisAlignment.start,
                                      //           mainAxisSize: MainAxisSize.min,
                                      //           children: [
                                      //             const SizedBox(height: 8),
                                      //             Text('Personnel photo is required',
                                      //               style: Theme.of(context).textTheme.caption!.copyWith(
                                      //                   color: Colors.red[700]
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       )
                                      //           : Container();
                                      //     }
                                      // ),

                                      // const SizedBox(height: 20),

                                      // const Text('Marital Status',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // DropdownSearch<String>(
                                      //   popupProps: PopupProps.menu(
                                      //       showSelectedItems: true,
                                      //       disabledItemFn: (String s) => false,
                                      //       fit: FlexFit.loose,
                                      //       menuProps: MenuProps(
                                      //           elevation: 6,
                                      //           borderRadius: BorderRadius.circular(AppBorderRadius.sm)
                                      //       )
                                      //   ),
                                      //   items: editPersonnelController.maritalStatusItems,
                                      //   dropdownDecoratorProps: DropDownDecoratorProps(
                                      //     dropdownSearchDecoration: InputDecoration(
                                      //       contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                      //       enabledBorder: inputBorder,
                                      //       focusedBorder: inputBorderFocused,
                                      //       errorBorder: inputBorder,
                                      //       focusedErrorBorder: inputBorderFocused,
                                      //       filled: true,
                                      //       fillColor: AppColor.xLightBackground,
                                      //     ),
                                      //   ),
                                      //   autoValidateMode: AutovalidateMode.always,
                                      //   selectedItem: widget.personnel.maritalStatus,
                                      //   validator: (item) {
                                      //     if (item == null) {
                                      //       return "Marital status is required";
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      //   onChanged: (val) => editPersonnelController.maritalStatus = val!,
                                      // ),
                                      // const SizedBox(height: 20),

                                      // const Text('Highest Education Level',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // DropdownSearch<String>(
                                      //   popupProps: PopupProps.menu(
                                      //       showSelectedItems: true,
                                      //       disabledItemFn: (String s) => false,
                                      //       fit: FlexFit.loose,
                                      //       menuProps: MenuProps(
                                      //           elevation: 6,
                                      //           borderRadius: BorderRadius.circular(AppBorderRadius.sm)
                                      //       )
                                      //   ),
                                      //   items: editPersonnelController.educationLevelItems,
                                      //   dropdownDecoratorProps: DropDownDecoratorProps(
                                      //     dropdownSearchDecoration: InputDecoration(
                                      //       contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                      //       enabledBorder: inputBorder,
                                      //       focusedBorder: inputBorderFocused,
                                      //       errorBorder: inputBorder,
                                      //       focusedErrorBorder: inputBorderFocused,
                                      //       filled: true,
                                      //       fillColor: AppColor.xLightBackground,
                                      //     ),
                                      //   ),
                                      //   autoValidateMode: AutovalidateMode.always,
                                      //   selectedItem: widget.personnel.highestLevelEducation,
                                      //   validator: (item) {
                                      //     if (item == null) {
                                      //       return "Education level is required";
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      //   onChanged: (val) => editPersonnelController.educationLevel = val!,
                                      // ),
                                      // const SizedBox(height: 20),

                                      // const Text('Type of ID',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // DropdownSearch<String>(
                                      //   popupProps: PopupProps.menu(
                                      //       showSelectedItems: true,
                                      //       disabledItemFn: (String s) => false,
                                      //       fit: FlexFit.loose,
                                      //       menuProps: MenuProps(
                                      //           elevation: 6,
                                      //           borderRadius: BorderRadius.circular(AppBorderRadius.sm)
                                      //       )
                                      //   ),
                                      //   items: editPersonnelController.idTypes,
                                      //   dropdownDecoratorProps: DropDownDecoratorProps(
                                      //     dropdownSearchDecoration: InputDecoration(
                                      //       contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                      //       enabledBorder: inputBorder,
                                      //       focusedBorder: inputBorderFocused,
                                      //       errorBorder: inputBorder,
                                      //       focusedErrorBorder: inputBorderFocused,
                                      //       filled: true,
                                      //       fillColor: AppColor.xLightBackground,
                                      //     ),
                                      //   ),
                                      //   autoValidateMode: AutovalidateMode.always,
                                      //   selectedItem: widget.personnel.nationalIdType,
                                      //   validator: (item) {
                                      //     if (item == null) {
                                      //       return "ID type is required";
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      //   onChanged: (val) => editPersonnelController.idType = val!,
                                      // ),
                                      // const SizedBox(height: 20),

                                      // const Text('ID Number',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // TextFormField(
                                      //   controller: editPersonnelController.idNumberTC,
                                      //   decoration: InputDecoration(
                                      //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //     enabledBorder: inputBorder,
                                      //     focusedBorder: inputBorderFocused,
                                      //     errorBorder: inputBorder,
                                      //     focusedErrorBorder: inputBorderFocused,
                                      //     filled: true,
                                      //     fillColor: AppColor.xLightBackground,
                                      //   ),
                                      //   textInputAction: TextInputAction.next,
                                      //   validator: (String? value) => value!.trim().isEmpty
                                      //       ? "ID number is required"
                                      //       : null,
                                      // ),
                                      //
                                      // const SizedBox(height: 20),

                                      // const Text('Photo of ID',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // GetBuilder(
                                      //     init: editPersonnelController,
                                      //     builder: (context) {
                                      //       return ImageFieldCard(
                                      //         onTap: () => editPersonnelController.chooseMediaSource(PersonnelImageData.idImage),
                                      //         image: editPersonnelController.personnelIDImage?.file,
                                      //         base64Image: base64Encode(widget.personnel.photoId ?? []),
                                      //       );
                                      //     }
                                      // ),

                                      // if (!widget.isViewMode)
                                      // GetBuilder(
                                      //   init: editPersonnelController,
                                      //   builder: (ctx) {
                                      //     return editPersonnelController.personnelIDImage?.file == null
                                      //     ? Padding(
                                      //       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                      //       child: Column(
                                      //         crossAxisAlignment: CrossAxisAlignment.start,
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           const SizedBox(height: 8),
                                      //           Text('Photo of ID is required',
                                      //             style: Theme.of(context).textTheme.caption!.copyWith(
                                      //                 color: Colors.red[700]
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     )
                                      //     : Container();
                                      //   }
                                      // ),

                                      const SizedBox(height: 20),

                                      const Text(
                                        'SSNIT Number',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: editPersonnelController
                                            .sSNITNumberTC,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                        textInputAction: TextInputAction.next,
                                        // validator: (String? value) => value!.trim().isEmpty
                                        //     ? "SSNIT number is required"
                                        //     : null,
                                      ),
                                      const SizedBox(height: 20),

                                      // const Text('Photo of SSNIT Card',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // GetBuilder(
                                      //     init: editPersonnelController,
                                      //     builder: (context) {
                                      //       return ImageFieldCard(
                                      //         onTap: () => editPersonnelController.chooseMediaSource(PersonnelImageData.SSNITCardImage),
                                      //         image: editPersonnelController.SSNITCardImage?.file,
                                      //         base64Image: base64Encode(widget.personnel.photoSsnitCard ?? []),
                                      //       );
                                      //     }
                                      // ),
                                      //
                                      // const SizedBox(height: 20),

                                      const Text(
                                        'Payment Method',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppBorderRadius.sm))),
                                        items: editPersonnelController
                                            .paymentMethodItems,
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
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
                                        ),
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        selectedItem:
                                            widget.personnel.paymentOption,
                                        validator: (item) {
                                          if (item == null) {
                                            return "Payment method is required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) {
                                          editPersonnelController
                                              .paymentMethod = val!;
                                          editPersonnelController.update();
                                        },
                                      ),

                                      GetBuilder(
                                          init: editPersonnelController,
                                          builder: (ctx) {
                                            return editPersonnelController
                                                        .paymentMethod ==
                                                    PaymentMethod.mobileMoney
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 20),
                                                      const Text(
                                                        'MOMO Owner\'s Name',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            editPersonnelController
                                                                .momoOwnerNameTC,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      15),
                                                          enabledBorder:
                                                              inputBorder,
                                                          focusedBorder:
                                                              inputBorderFocused,
                                                          errorBorder:
                                                              inputBorder,
                                                          focusedErrorBorder:
                                                              inputBorderFocused,
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .xLightBackground,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        validator: (String?
                                                                value) =>
                                                            value!
                                                                    .trim()
                                                                    .isEmpty
                                                                ? "MOMO owner's name is required"
                                                                : null,
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      const Text(
                                                        'Does the MOMO Number Belong To The RA',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      DropdownSearch<String>(
                                                        popupProps: PopupProps.menu(
                                                            showSelectedItems:
                                                                true,
                                                            disabledItemFn:
                                                                (String s) =>
                                                                    false,
                                                            fit: FlexFit.loose,
                                                            menuProps: MenuProps(
                                                                elevation: 6,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        AppBorderRadius
                                                                            .sm))),
                                                        items:
                                                            editPersonnelController
                                                                .yesNoItems,
                                                        dropdownDecoratorProps:
                                                            DropDownDecoratorProps(
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        15),
                                                            enabledBorder:
                                                                inputBorder,
                                                            focusedBorder:
                                                                inputBorderFocused,
                                                            errorBorder:
                                                                inputBorder,
                                                            focusedErrorBorder:
                                                                inputBorderFocused,
                                                            filled: true,
                                                            fillColor: AppColor
                                                                .xLightBackground,
                                                          ),
                                                        ),
                                                        autoValidateMode:
                                                            AutovalidateMode
                                                                .always,
                                                        validator: (item) {
                                                          if (item == null) {
                                                            return "field is required";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        onChanged: (val) {
                                                          editPersonnelController
                                                              .isMomoOWner
                                                              .value = val!;
                                                        },
                                                        selectedItem: widget
                                                            .personnel
                                                            .isOwnerOfMomo,
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      const Text(
                                                        'MOMO Number',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            editPersonnelController
                                                                .momoNumberTC,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      15),
                                                          enabledBorder:
                                                              inputBorder,
                                                          focusedBorder:
                                                              inputBorderFocused,
                                                          errorBorder:
                                                              inputBorder,
                                                          focusedErrorBorder:
                                                              inputBorderFocused,
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .xLightBackground,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        validator: (String? value) => value!
                                                                    .trim()
                                                                    .isEmpty ||
                                                                value
                                                                        .trim()
                                                                        .length !=
                                                                    10
                                                            ? "MOMO number is required"
                                                            : null,
                                                      ),
                                                    ],
                                                  )
                                                : Container();
                                          }),

                                      const SizedBox(height: 20),

                                      GetBuilder(
                                          init: editPersonnelController,
                                          builder: (ctx) {
                                            return editPersonnelController
                                                        .paymentMethod ==
                                                    PaymentMethod.bank
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                          height: 20),

                                                      const Text(
                                                        'Bank Name',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            editPersonnelController
                                                                .bankNameTC,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      15),
                                                          enabledBorder:
                                                              inputBorder,
                                                          focusedBorder:
                                                              inputBorderFocused,
                                                          errorBorder:
                                                              inputBorder,
                                                          focusedErrorBorder:
                                                              inputBorderFocused,
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .xLightBackground,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        validator: (String?
                                                                value) =>
                                                            value!
                                                                    .trim()
                                                                    .isEmpty
                                                                ? "Bank name is required"
                                                                : null,
                                                      ),
                                                      const SizedBox(
                                                          height: 20),

                                                      const Text(
                                                        'Bank Branch',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            editPersonnelController
                                                                .bankBranchTC,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      15),
                                                          enabledBorder:
                                                              inputBorder,
                                                          focusedBorder:
                                                              inputBorderFocused,
                                                          errorBorder:
                                                              inputBorder,
                                                          focusedErrorBorder:
                                                              inputBorderFocused,
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .xLightBackground,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        validator: (String?
                                                                value) =>
                                                            value!
                                                                    .trim()
                                                                    .isEmpty
                                                                ? "Bank branch is required"
                                                                : null,
                                                      ),

                                                      const SizedBox(
                                                          height: 20),

                                                      // const Text('Account Holder Name',
                                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                                      // ),
                                                      // const SizedBox(height: 5,),
                                                      // TextFormField(
                                                      //   controller: editPersonnelController.accountHolderNameTC,
                                                      //   textCapitalization: TextCapitalization.words,
                                                      //   decoration: InputDecoration(
                                                      //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                      //     enabledBorder: inputBorder,
                                                      //     focusedBorder: inputBorderFocused,
                                                      //     errorBorder: inputBorder,
                                                      //     focusedErrorBorder: inputBorderFocused,
                                                      //     filled: true,
                                                      //     fillColor: AppColor.xLightBackground,
                                                      //   ),
                                                      //   textInputAction: TextInputAction.next,
                                                      //   validator: (String? value) => value!.trim().isEmpty
                                                      //       ? "Account holder name is required"
                                                      //       : null,
                                                      // ),
                                                      //
                                                      // const SizedBox(height: 20),

                                                      const Text(
                                                        'Account Number',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            editPersonnelController
                                                                .accountNumberTC,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15,
                                                                  horizontal:
                                                                      15),
                                                          enabledBorder:
                                                              inputBorder,
                                                          focusedBorder:
                                                              inputBorderFocused,
                                                          errorBorder:
                                                              inputBorder,
                                                          focusedErrorBorder:
                                                              inputBorderFocused,
                                                          filled: true,
                                                          fillColor: AppColor
                                                              .xLightBackground,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        validator: (String?
                                                                value) =>
                                                            value!
                                                                    .trim()
                                                                    .isEmpty
                                                                ? "Account number is required"
                                                                : null,
                                                      ),
                                                    ],
                                                  )
                                                : Container();
                                          }),

                                      // GetBuilder(
                                      //   init: editPersonnelController,
                                      //   builder: (ctx) {
                                      //     return editPersonnelController.paymentMethod == PaymentMethod.mobileMoney
                                      //     ? Column(
                                      //       mainAxisSize: MainAxisSize.min,
                                      //       crossAxisAlignment: CrossAxisAlignment.start,
                                      //       children: [
                                      //         const SizedBox(height: 20),
                                      //         const Text('Momo Number',
                                      //           style: TextStyle(fontWeight: FontWeight.w500),
                                      //         ),
                                      //         const SizedBox(height: 5,),
                                      //         TextFormField(
                                      //           controller: editPersonnelController.momoNumberTC,
                                      //           decoration: InputDecoration(
                                      //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //             enabledBorder: inputBorder,
                                      //             focusedBorder: inputBorderFocused,
                                      //             errorBorder: inputBorder,
                                      //             focusedErrorBorder: inputBorderFocused,
                                      //             filled: true,
                                      //             fillColor: AppColor.xLightBackground,
                                      //           ),
                                      //           keyboardType: TextInputType.phone,
                                      //           textInputAction: TextInputAction.next,
                                      //           validator: (String? value) => value!.trim().isEmpty || value.trim().length < 9 || (value.trim().startsWith('0') && value.trim().length < 10)
                                      //               ? "Enter a valid phone number"
                                      //               : null,
                                      //         ),
                                      //       ],
                                      //     )
                                      //     : Container();
                                      //   }
                                      // ),

                                      // const SizedBox(height: 20),

                                      // const Text('Is Cocoa Board Rehab Assistant',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // DropdownSearch<String>(
                                      //   popupProps: PopupProps.menu(
                                      //       showSelectedItems: true,
                                      //       disabledItemFn: (String s) => false,
                                      //       fit: FlexFit.loose,
                                      //       menuProps: MenuProps(
                                      //           elevation: 6,
                                      //           borderRadius: BorderRadius.circular(AppBorderRadius.sm)
                                      //       )
                                      //   ),
                                      //   items: editPersonnelController.yesNoItems,
                                      //   dropdownDecoratorProps: DropDownDecoratorProps(
                                      //     dropdownSearchDecoration: InputDecoration(
                                      //       contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                      //       enabledBorder: inputBorder,
                                      //       focusedBorder: inputBorderFocused,
                                      //       errorBorder: inputBorder,
                                      //       focusedErrorBorder: inputBorderFocused,
                                      //       filled: true,
                                      //       fillColor: AppColor.xLightBackground,
                                      //     ),
                                      //   ),
                                      //   autoValidateMode: AutovalidateMode.always,
                                      //   selectedItem: widget.personnel.cocoaBoardFarmHand,
                                      //   validator: (item) {
                                      //     if (item == null) {
                                      //       return "Confirm if is cocoa board rehab assistant";
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      //   onChanged: (val){
                                      //     editPersonnelController.isCocoaBoardRehabAssistant = val!;
                                      //   },
                                      // ),

                                      // const SizedBox(height: 20),
                                      // const Text('Cocoa District',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // TextFormField(
                                      //   controller: editPersonnelController.cocoaDistrictTC,
                                      //   decoration: InputDecoration(
                                      //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //     enabledBorder: inputBorder,
                                      //     focusedBorder: inputBorderFocused,
                                      //     errorBorder: inputBorder,
                                      //     focusedErrorBorder: inputBorderFocused,
                                      //     filled: true,
                                      //     fillColor: AppColor.xLightBackground,
                                      //   ),
                                      //   textInputAction: TextInputAction.next,
                                      //   validator: (String? value) => value!.trim().isEmpty
                                      //       ? "Cocoa district is required"
                                      //       : null,
                                      // ),

                                      // const SizedBox(height: 20),
                                      //
                                      // const Text('Community Respondent',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      // TextFormField(
                                      //   controller: editPersonnelController.communityRespondentTC,
                                      //   textCapitalization: TextCapitalization.words,
                                      //   decoration: InputDecoration(
                                      //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      //     enabledBorder: inputBorder,
                                      //     focusedBorder: inputBorderFocused,
                                      //     errorBorder: inputBorder,
                                      //     focusedErrorBorder: inputBorderFocused,
                                      //     filled: true,
                                      //     fillColor: AppColor.xLightBackground,
                                      //   ),
                                      //   textInputAction: TextInputAction.next,
                                      //   validator: (String? value) => value!.trim().isEmpty
                                      //       ? "Community respondent is required"
                                      //       : null,
                                      // ),
                                      //
                                      // const SizedBox(height: 20),

                                      // const Text('Activity',
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // const SizedBox(height: 5,),
                                      //
                                      // FutureBuilder(
                                      //   builder: (ctx, snapshot) {
                                      //     // Checking if future is resolved or not
                                      //     if (snapshot.connectionState == ConnectionState.done) {
                                      //
                                      //       if (snapshot.hasError) {
                                      //         return Center(
                                      //           child: Text(
                                      //             '${snapshot.error} occurred',
                                      //             style: TextStyle(fontSize: 18),
                                      //           ),
                                      //         );
                                      //
                                      //
                                      //       } else if (snapshot.hasData) {
                                      //         List<Activity> dataList = snapshot.data as List<Activity>;
                                      //         editPersonnelController.selectedFarmActivities = dataList;
                                      //
                                      //         return DropdownSearch<Activity>.multiSelection(
                                      //           popupProps: PopupPropsMultiSelection.modalBottomSheet(
                                      //             showSelectedItems: true,
                                      //             showSearchBox: false,
                                      //             disabledItemFn: (Activity s) => false,
                                      //             modalBottomSheetProps: ModalBottomSheetProps(
                                      //               elevation: 6,
                                      //               shape: RoundedRectangleBorder(
                                      //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                                      //               ),
                                      //             ),
                                      //             title: Padding(
                                      //               padding: const EdgeInsets.symmetric(vertical: 15),
                                      //               child: Center(
                                      //                 child: Text('Select Activity',
                                      //                   style: const TextStyle(fontWeight: FontWeight.w500),),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //           dropdownDecoratorProps: DropDownDecoratorProps(
                                      //             dropdownSearchDecoration: InputDecoration(
                                      //               contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                      //               enabledBorder: inputBorder,
                                      //               focusedBorder: inputBorderFocused,
                                      //               errorBorder: inputBorder,
                                      //               focusedErrorBorder: inputBorderFocused,
                                      //               filled: true,
                                      //               fillColor: AppColor.xLightBackground,
                                      //             ),
                                      //           ),
                                      //           asyncItems: (String filter) async {
                                      //             var response = await editPersonnelController.globalController.database!.activityDao.findAllMainActivity();
                                      //             return response;
                                      //           },
                                      //           itemAsString: (Activity d) => d.mainActivity!.toString(),
                                      //           compareFn: (activity, filter) => activity.mainActivity == filter.mainActivity,
                                      //           autoValidateMode: AutovalidateMode.always,
                                      //           selectedItems: dataList,
                                      //           validator: (item) {
                                      //             if (item!.isEmpty) {
                                      //               return 'Activity is required';
                                      //             } else {
                                      //               return null;
                                      //             }
                                      //           },
                                      //           onChanged: (val) => editPersonnelController.selectedFarmActivities = val,
                                      //           // selectedItems: assignRAController.selectedRehabAssistantsActivities,
                                      //         );
                                      //       }
                                      //     }
                                      //
                                      //     // Displaying LoadingSpinner to indicate waiting state
                                      //     return Center(
                                      //       child: CircularProgressIndicator(),
                                      //     );
                                      //   },
                                      //
                                      //   // Future that needs to be resolved
                                      //   // inorder to display something on the Canvas
                                      //   future: globalController.database!.activityDao.findAllActivityWithMainActivityList(widget.personnel.activity!.split(", ").toList()),
                                      // ),

                                      /*      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            'LOCATION',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: AppColor.black),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Lat : ${widget.personnel.lat}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Lng : ${widget.personnel.lng}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            'Accuracy : ${widget.personnel.accuracy}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      */

                                      if (!widget.isViewMode)
                                        const SizedBox(
                                          height: 40,
                                        ),

                                      if (!widget.isViewMode)
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomButton(
                                                isFullWidth: true,
                                                backgroundColor: AppColor.black,
                                                verticalPadding: 0.0,
                                                horizontalPadding: 8.0,
                                                onTap: () async {
                                                  // if (!editPersonnelController
                                                  //     .isSaveButtonDisabled
                                                  //     .value) {
                                                    if (editPersonnelController
                                                        .editPersonnelFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      editPersonnelController
                                                          .handleSaveOfflinePersonnel();
                                                    } else {
                                                      editPersonnelController
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
                                                    // editPersonnelController
                                                    //         .isSaveButtonDisabled
                                                    //         .value
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
                                                backgroundColor:
                                                    AppColor.primary,
                                                verticalPadding: 0.0,
                                                horizontalPadding: 8.0,
                                                onTap: () async {
                                                  // if (!editPersonnelController
                                                  //     .isButtonDisabled.value) {
                                                    if (editPersonnelController
                                                        .editPersonnelFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      editPersonnelController
                                                          .handleAddPersonnel();
                                                    } else {
                                                      editPersonnelController
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
                                                    // editPersonnelController
                                                    //         .isButtonDisabled
                                                    //         .value
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
                                      // CustomButton(
                                      //   child: Text(
                                      //     'Submit',
                                      //     style: TextStyle(color: AppColor.white, fontSize: 14),
                                      //   ),
                                      //   isFullWidth: true,
                                      //   backgroundColor: AppColor.primary,
                                      //   verticalPadding: 0.0,
                                      //   horizontalPadding: 8.0,
                                      //   onTap: () async{
                                      //     if (!editPersonnelController.isButtonDisabled.value){
                                      //       if (editPersonnelController.editPersonnelFormKey.currentState!.validate()) {
                                      //         editPersonnelController.handleAddPersonnel();
                                      //       }else{
                                      //         editPersonnelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
                                      //       }
                                      //     }
                                      //   },
                                      // ),

                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                );
                              }),
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
