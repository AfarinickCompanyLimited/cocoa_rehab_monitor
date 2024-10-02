import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'add_personnel_controller.dart';
import '../global_components/image_field_card.dart';

class AddPersonnel extends StatefulWidget {
  const AddPersonnel({Key? key}) : super(key: key);

  @override
  State<AddPersonnel> createState() => _AddPersonnelState();
}

class _AddPersonnelState extends State<AddPersonnel> {
  GlobalController globalController = Get.find();
  AddPersonnelController addPersonnelController =
      Get.put(AddPersonnelController());

  @override
  void initState() {
    super.initState();

    addPersonnelController.region = globalController.userRegionDistrict;
  }

  @override
  Widget build(BuildContext context) {
    addPersonnelController.addPersonnelControllerScreenContext = context;

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
                          child: Text('Add Rehab Assistant',
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
                          key: addPersonnelController.addPersonnelFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Staff Type',
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
                                items: addPersonnelController.designationItems,
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
                                    return "Staff type is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) => addPersonnelController
                                    .designation.value = val!,
                              ),
                              const SizedBox(height: 20),

                              const Text(
                                'Full Name',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: addPersonnelController.nameTC,
                                textCapitalization: TextCapitalization.words,
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
                              //   controller: addPersonnelController.middleNameTC,
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
                              //   controller: addPersonnelController.lastNameTC,
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
                                items: addPersonnelController.genderItems,
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
                                    return "Gender is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) =>
                                    addPersonnelController.gender = val!,
                              ),
                              const SizedBox(height: 20),

                              const Text(
                                'Date of Birth',
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  enabledBorder: inputBorder,
                                  focusedBorder: inputBorderFocused,
                                  errorBorder: inputBorder,
                                  focusedErrorBorder: inputBorderFocused,
                                  filled: true,
                                  fillColor: AppColor.xLightBackground,
                                ),
                                onChanged: (val) =>
                                    addPersonnelController.dateOfBirth = val,
                                validator: (String? value) =>
                                    value!.trim().isEmpty
                                        ? "Date of birth is required"
                                        : null,
                                onSaved: (val) =>
                                    addPersonnelController.dateOfBirth = val,
                              ),

                              // Obx(() => addPersonnelController.designation == PersonnelDesignation.projectOfficer
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
                              //       controller: addPersonnelController.emailTC,
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
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: addPersonnelController.phoneTC,
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
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                validator: (String? value) =>
                                    value!.trim().isEmpty ||
                                            value.trim().length != 10
                                        ? "Enter a valid phone number"
                                        : null,
                              ),
                              const SizedBox(height: 20),

                              const Text(
                                'Region',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<RegionDistrict>(
                                popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    title: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select Region',
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
                                // items: ['Greater Accra', 'Volta', 'Western'],
                                asyncItems: (String filter) async {
                                  var response = await addPersonnelController
                                      .globalController
                                      .database!
                                      .regionDistrictDao
                                      .findRegions();
                                  return response;
                                },
                                itemAsString: (RegionDistrict d) =>
                                    d.regionName ?? '',
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn: (regionDistrict, filter) =>
                                    regionDistrict.regionName ==
                                    filter.regionName,
                                onChanged: (val) {
                                  addPersonnelController.region = val;
                                  addPersonnelController.district =
                                      RegionDistrict();
                                },
                                selectedItem: addPersonnelController.region,
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return 'Region is required';
                                  } else {
                                    return null;
                                  }
                                },
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
                                    title: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select District',
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
                                  var response = await addPersonnelController
                                      .globalController
                                      .database!
                                      .regionDistrictDao
                                      .findDistrictsInRegion(
                                          addPersonnelController
                                                  .region?.regionName ??
                                              '');
                                  return response;
                                },
                                itemAsString: (RegionDistrict d) =>
                                    d.districtName ?? '',
                                compareFn: (regionDistrict, filter) =>
                                    regionDistrict.districtName ==
                                    filter.districtName,
                                onChanged: (val) {
                                  addPersonnelController.district = val;
                                },
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null &&
                                      addPersonnelController.district?.id ==
                                          null) {
                                    return 'District is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 20),

                              // const Text('Operational Area',
                              //   style: TextStyle(fontWeight: FontWeight.w500),
                              // ),
                              // const SizedBox(height: 5,),
                              // TextFormField(
                              //   controller: addPersonnelController.operationalAreaTC,
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

                              const SizedBox(height: 20),

                              const Text(
                                'Personnel Photo',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GetBuilder(
                                  init: addPersonnelController,
                                  builder: (context) {
                                    return ImageFieldCard(
                                      onTap: () => addPersonnelController
                                          .chooseMediaSource(PersonnelImageData
                                              .personnelImage),
                                      image: addPersonnelController
                                          .personnelPhoto?.file,
                                    );
                                  }),

                              // GetBuilder(
                              //     init: addPersonnelController,
                              //     builder: (ctx) {
                              //       return addPersonnelController
                              //                   .personnelPhoto?.file ==
                              //               null
                              //           ? Padding(
                              //               padding: const EdgeInsets.only(
                              //                   left: 15.0, right: 15.0),
                              //               child: Column(
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.start,
                              //                 mainAxisSize: MainAxisSize.min,
                              //                 children: [
                              //                   const SizedBox(height: 8),
                              //                   Text(
                              //                     'Personnel photo is required',
                              //                     style: Theme.of(context)
                              //                         .textTheme
                              //                         .bodySmall!
                              //                         .copyWith(
                              //                             color:
                              //                                 Colors.red[700]),
                              //                   ),
                              //                 ],
                              //               ),
                              //             )
                              //           : Container();
                              //     }),

                              const SizedBox(height: 20),

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
                              //   items: addPersonnelController.maritalStatusItems,
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
                              //   validator: (item) {
                              //     if (item == null) {
                              //       return "Marital status is required";
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              //   onChanged: (val) => addPersonnelController.maritalStatus = val!,
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
                              //   items: addPersonnelController.educationLevelItems,
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
                              //   validator: (item) {
                              //     if (item == null) {
                              //       return "Education level is required";
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              //   onChanged: (val) => addPersonnelController.educationLevel = val!,
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
                              //   items: addPersonnelController.idTypes,
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
                              //   validator: (item) {
                              //     if (item == null) {
                              //       return "ID type is required";
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              //   onChanged: (val) => addPersonnelController.idType = val!,
                              // ),
                              // const SizedBox(height: 20),

                              // const Text('ID Number',
                              //   style: TextStyle(fontWeight: FontWeight.w500),
                              // ),
                              // const SizedBox(height: 5,),
                              // TextFormField(
                              //   controller: addPersonnelController.idNumberTC,
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
                              //     init: addPersonnelController,
                              //     builder: (context) {
                              //       return ImageFieldCard(
                              //         onTap: () => addPersonnelController.chooseMediaSource(PersonnelImageData.idImage),
                              //         image: addPersonnelController.personnelIDImage?.file,
                              //       );
                              //     }
                              // ),
                              //
                              // GetBuilder(
                              //   init: addPersonnelController,
                              //   builder: (ctx) {
                              //     return addPersonnelController.personnelIDImage?.file == null
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

                              // const SizedBox(height: 20),

                              const Text(
                                'SSNIT Number',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller:
                                    addPersonnelController.sSNITNumberTC,
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
                              //     init: addPersonnelController,
                              //     builder: (context) {
                              //       return ImageFieldCard(
                              //         onTap: () => addPersonnelController.chooseMediaSource(PersonnelImageData.SSNITCardImage),
                              //         image: addPersonnelController.SSNITCardImage?.file,
                              //       );
                              //     }
                              // ),
                              //
                              // const SizedBox(height: 20),

                              const Text(
                                'Payment Method',
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
                                items:
                                    addPersonnelController.paymentMethodItems,
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
                                    return "Payment method is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addPersonnelController.paymentMethod = val!;
                                  addPersonnelController.update();
                                },
                              ),

                              GetBuilder(
                                  init: addPersonnelController,
                                  builder: (ctx) {
                                    return addPersonnelController
                                                .paymentMethod ==
                                            PaymentMethod.mobileMoney
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              const Text(
                                                'MOMO Owner\'s Name',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    addPersonnelController
                                                        .momoOwnerNameTC,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15,
                                                          horizontal: 15),
                                                  enabledBorder: inputBorder,
                                                  focusedBorder:
                                                      inputBorderFocused,
                                                  errorBorder: inputBorder,
                                                  focusedErrorBorder:
                                                      inputBorderFocused,
                                                  filled: true,
                                                  fillColor:
                                                      AppColor.xLightBackground,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (String? value) =>
                                                    value!.trim().isEmpty
                                                        ? "MOMO owner's name is required"
                                                        : null,
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                'Does the MOMO Number Belong To The RA',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              DropdownSearch<String>(
                                                popupProps: PopupProps.menu(
                                                    showSelectedItems: true,
                                                    disabledItemFn:
                                                        (String s) => false,
                                                    fit: FlexFit.loose,
                                                    menuProps: MenuProps(
                                                        elevation: 6,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                AppBorderRadius
                                                                    .sm))),
                                                items: addPersonnelController
                                                    .yesNoItems,
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 4,
                                                            horizontal: 15),
                                                    enabledBorder: inputBorder,
                                                    focusedBorder:
                                                        inputBorderFocused,
                                                    errorBorder: inputBorder,
                                                    focusedErrorBorder:
                                                        inputBorderFocused,
                                                    filled: true,
                                                    fillColor: AppColor
                                                        .xLightBackground,
                                                  ),
                                                ),
                                                autoValidateMode:
                                                    AutovalidateMode.always,
                                                validator: (item) {
                                                  if (item == null) {
                                                    return "field is required";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val) {
                                                  addPersonnelController
                                                      .isMomoOWner.value = val!;
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              const Text(
                                                'MOMO Number',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    addPersonnelController
                                                        .momoNumberTC,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15,
                                                          horizontal: 15),
                                                  enabledBorder: inputBorder,
                                                  focusedBorder:
                                                      inputBorderFocused,
                                                  errorBorder: inputBorder,
                                                  focusedErrorBorder:
                                                      inputBorderFocused,
                                                  filled: true,
                                                  fillColor:
                                                      AppColor.xLightBackground,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (String? value) => value!
                                                            .trim()
                                                            .isEmpty ||
                                                        value.trim().length !=
                                                            10
                                                    ? "Enter a valid MOMO number"
                                                    : null,
                                              ),
                                            ],
                                          )
                                        : Container();
                                  }),

                              const SizedBox(height: 20),

                              GetBuilder(
                                  init: addPersonnelController,
                                  builder: (ctx) {
                                    return addPersonnelController
                                                .paymentMethod ==
                                            PaymentMethod.bank
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),

                                              const Text(
                                                'Bank Name',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    addPersonnelController
                                                        .bankNameTC,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15,
                                                          horizontal: 15),
                                                  enabledBorder: inputBorder,
                                                  focusedBorder:
                                                      inputBorderFocused,
                                                  errorBorder: inputBorder,
                                                  focusedErrorBorder:
                                                      inputBorderFocused,
                                                  filled: true,
                                                  fillColor:
                                                      AppColor.xLightBackground,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (String? value) =>
                                                    value!.trim().isEmpty
                                                        ? "Bank name is required"
                                                        : null,
                                              ),
                                              const SizedBox(height: 20),

                                              const Text(
                                                'Bank Branch',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    addPersonnelController
                                                        .bankBranchTC,
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15,
                                                          horizontal: 15),
                                                  enabledBorder: inputBorder,
                                                  focusedBorder:
                                                      inputBorderFocused,
                                                  errorBorder: inputBorder,
                                                  focusedErrorBorder:
                                                      inputBorderFocused,
                                                  filled: true,
                                                  fillColor:
                                                      AppColor.xLightBackground,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (String? value) =>
                                                    value!.trim().isEmpty
                                                        ? "Bank branch is required"
                                                        : null,
                                              ),

                                              const SizedBox(height: 20),

                                              // const Text('Account Holder Name',
                                              //   style: TextStyle(fontWeight: FontWeight.w500),
                                              // ),
                                              // const SizedBox(height: 5,),
                                              // TextFormField(
                                              //   controller: addPersonnelController.accountHolderNameTC,
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
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              TextFormField(
                                                controller:
                                                    addPersonnelController
                                                        .accountNumberTC,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          vertical: 15,
                                                          horizontal: 15),
                                                  enabledBorder: inputBorder,
                                                  focusedBorder:
                                                      inputBorderFocused,
                                                  errorBorder: inputBorder,
                                                  focusedErrorBorder:
                                                      inputBorderFocused,
                                                  filled: true,
                                                  fillColor:
                                                      AppColor.xLightBackground,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                validator: (String? value) =>
                                                    value!.trim().isEmpty
                                                        ? "Account number is required"
                                                        : null,
                                              ),
                                            ],
                                          )
                                        : Container();
                                  }),

                              // GetBuilder(
                              //   init: addPersonnelController,
                              //   builder: (ctx) {
                              //     return addPersonnelController.paymentMethod == PaymentMethod.mobileMoney
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
                              //           controller: addPersonnelController.momoNumberTC,
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

                              const SizedBox(height: 20),

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
                              //   items: addPersonnelController.yesNoItems,
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
                              //   validator: (item) {
                              //     if (item == null) {
                              //       return "Confirm if is cocoa board rehab assistant";
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              //   onChanged: (val){
                              //     addPersonnelController.isCocoaBoardRehabAssistant = val!;
                              //   },
                              // ),

                              // const SizedBox(height: 20),
                              // const Text('Cocoa District',
                              //   style: TextStyle(fontWeight: FontWeight.w500),
                              // ),
                              // const SizedBox(height: 5,),
                              // TextFormField(
                              //   controller: addPersonnelController.cocoaDistrictTC,
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
                              //   controller: addPersonnelController.communityRespondentTC,
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
                              //
                              // const Text('Activity',
                              //   style: TextStyle(fontWeight: FontWeight.w500),
                              // ),
                              // const SizedBox(height: 5,),
                              //
                              // DropdownSearch<Activity>.multiSelection(
                              //   // items: addPersonnelController.farmActivitiesItems,
                              //   popupProps: PopupPropsMultiSelection.modalBottomSheet(
                              //     showSelectedItems: true,
                              //     showSearchBox: false,
                              //     disabledItemFn: (Activity s) => false,
                              //     modalBottomSheetProps: ModalBottomSheetProps(
                              //       elevation: 6,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                              //       ),
                              //     ),
                              //     title: Padding(
                              //       padding: const EdgeInsets.symmetric(vertical: 15),
                              //       child: Center(
                              //         child: Text('Select Activity',
                              //           style: const TextStyle(fontWeight: FontWeight.w500),),
                              //       ),
                              //     ),
                              //   ),
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
                              //   asyncItems: (String filter) async {
                              //     var response = await addPersonnelController.globalController.database!.activityDao.findAllMainActivity();
                              //     return response;
                              //   },
                              //   itemAsString: (Activity d) => d.mainActivity ?? '',
                              //   compareFn: (activity, filter) => activity.mainActivity == filter.mainActivity,
                              //     autoValidateMode: AutovalidateMode.always,
                              //   validator: (item) {
                              //     if (item!.isEmpty) {
                              //       return 'Activity is required';
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              //   onChanged: (val) => addPersonnelController.selectedFarmActivities = val,
                              //   // selectedItems: assignRAController.selectedRehabAssistantsActivities,
                              // ),

                              /*   GetBuilder(
                                  init: addPersonnelController,
                                  builder: (context) {
                                    return addPersonnelController
                                                .locationData !=
                                            null
                                        ? Column(
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
                                                'Lat : ${addPersonnelController.locationData!.latitude}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'Lng : ${addPersonnelController.locationData!.longitude}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                'Accuracy : ${addPersonnelController.locationData!.accuracy!.truncateToDecimalPlaces(2).toString()}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        : Container();
                                  }),
                                  */

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
                                        // if (!addPersonnelController
                                        //     .isSaveButtonDisabled.value) {
                                        if (addPersonnelController
                                            .addPersonnelFormKey.currentState!
                                            .validate()) {
                                          addPersonnelController
                                              .handleSaveOfflinePersonnel();
                                        } else {
                                          addPersonnelController.globals
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
                                        // addPersonnelController
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
                                        // if (!addPersonnelController
                                        //     .isButtonDisabled.value) {
                                        if (addPersonnelController
                                            .addPersonnelFormKey.currentState!
                                            .validate()) {
                                          addPersonnelController
                                              .handleAddPersonnel();
                                        } else {
                                          addPersonnelController.globals
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
                                        // addPersonnelController
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
                              //     if (!addPersonnelController.isButtonDisabled.value){
                              //       if (addPersonnelController.addPersonnelFormKey.currentState!.validate()) {
                              //         addPersonnelController.handleAddPersonnel();
                              //       }else{
                              //         addPersonnelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
                              //       }
                              //     }
                              //   },
                              // ),

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
