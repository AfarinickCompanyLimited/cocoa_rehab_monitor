import 'dart:convert';

import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
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

import 'edit_assign_ra_controller.dart';



class EditAssignRA extends StatefulWidget {
  final PersonnelAssignment personnelAssignment;
  final bool isViewMode;
  const EditAssignRA({Key? key, required this.personnelAssignment, required this.isViewMode}) : super(key: key);

  @override
  State<EditAssignRA> createState() => _EditAssignRAState();
}

class _EditAssignRAState extends State<EditAssignRA> {

  EditAssignRAController editAssignRAController = Get.put(EditAssignRAController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    editAssignRAController.personnelAssignment = widget.personnelAssignment;
    editAssignRAController.isViewMode = widget.isViewMode;

  }

  @override
  Widget build(BuildContext context) {

    editAssignRAController.editAssignRAScreenContext = context;

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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)))
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, bottom: 10, left: AppPadding.horizontal, right: AppPadding.horizontal),
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
                        child: Text(widget.isViewMode ? 'View Personnel Assignment' : 'Edit Personnel Assignment',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal, bottom: AppPadding.vertical, top: 10),
                  child: Column(
                    children: [

                      AbsorbPointer(
                        absorbing: widget.isViewMode,
                        child: GetBuilder(
                            init: editAssignRAController,
                          builder: (ctx) {
                            return Form(
                              key: editAssignRAController.assignRAFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  const Text('Assignment Date',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  DateTimePicker(
                                    controller: editAssignRAController.assignmentDateTC,
                                    type: DateTimePickerType.date,
                                    initialDate: DateTime.now(),
                                    dateMask: 'yyyy-MM-dd',
                                    firstDate: DateTime(1600),
                                    lastDate: DateTime.now(),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorderFocused,
                                      errorBorder: inputBorder,
                                      focusedErrorBorder: inputBorderFocused,
                                      filled: true,
                                      fillColor: AppColor.xLightBackground,
                                    ),
                                    onChanged: (val) => editAssignRAController.assignmentDateTC?.text = val,
                                    validator: (String? value) => value!.trim().isEmpty
                                        ? "Assignment date is required"
                                        : null,
                                    onSaved: (val) => editAssignRAController.assignmentDateTC?.text = val!,
                                  ),

                                  const SizedBox(height: 20),

                                  const Text('Farm',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  FutureBuilder(
                                    builder: (ctx, snapshot) {
                                      // Checking if future is resolved or not
                                      if (snapshot.connectionState == ConnectionState.done) {

                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              '${snapshot.error} occurred',
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                          );


                                        } else if (snapshot.hasData) {

                                          List? dataList = snapshot.data as List;
                                          Farm? data = dataList.isNotEmpty ? dataList.first as Farm? : Farm();
                                          editAssignRAController.farm = data!;

                                          return  DropdownSearch<Farm>(
                                            popupProps: PopupProps.modalBottomSheet(
                                                showSelectedItems: true,
                                                showSearchBox: true,
                                                itemBuilder: (context, item, selected){
                                                  return ListTile(
                                                    title: Text(item.farmerNam.toString(),
                                                        style: selected ? TextStyle(color: AppColor.primary) : const TextStyle()),
                                                    subtitle: Text(item.farmId.toString(),
                                                    ),
                                                  );
                                                },
                                                title: const Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 15),
                                                  child: Center(
                                                    child: Text('Select Farm',
                                                      style: TextStyle(fontWeight: FontWeight.w500),),
                                                  ),
                                                ),
                                                disabledItemFn: (Farm s) => false,
                                                modalBottomSheetProps: ModalBottomSheetProps(
                                                  elevation: 6,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                                                  ),
                                                ),
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                    enabledBorder: inputBorder,
                                                    focusedBorder: inputBorderFocused,
                                                    errorBorder: inputBorder,
                                                    focusedErrorBorder: inputBorderFocused,
                                                    filled: true,
                                                    fillColor: AppColor.xLightBackground,
                                                  ),
                                                )
                                            ),
                                            dropdownDecoratorProps: DropDownDecoratorProps(
                                              dropdownSearchDecoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                enabledBorder: inputBorder,
                                                focusedBorder: inputBorderFocused,
                                                errorBorder: inputBorder,
                                                focusedErrorBorder: inputBorderFocused,
                                                filled: true,
                                                fillColor: AppColor.xLightBackground,
                                              ),
                                            ),
                                            asyncItems: (String filter) async {
                                              var response = await editAssignRAController.globalController.database!.farmDao.findAllFarm();
                                              return response;
                                            },
                                            itemAsString: (Farm d) => d.farmId ?? '',
                                            filterFn: (Farm d, filter) => d.farmerNam.toString().toLowerCase().contains(filter.toLowerCase()),
                                            compareFn: (farm, filter) => farm.farmId == filter.farmId,
                                            onChanged: (val) {
                                              editAssignRAController.farm = val!;
                                            },
                                            autoValidateMode: AutovalidateMode.always,
                                            selectedItem: data,
                                            validator: (item) {
                                              if (item == null) {
                                                return 'Farm is required';
                                              } else {
                                                return null;
                                              }
                                            },
                                          );
                                        }
                                      }

                                      // Displaying LoadingSpinner to indicate waiting state
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },

                                    // Future that needs to be resolved
                                    // inorder to display something on the Canvas
                                    future: globalController.database!.farmDao.findFarmByFarmCode(int.parse(widget.personnelAssignment.farmid!)),
                                  ),

                                  GetBuilder(
                                      init: editAssignRAController,
                                      builder: (ctx) {
                                        var estimatedRas = (editAssignRAController.farm?.farmSize ?? 0.0) / 1.6;
                                        if(estimatedRas < 1) estimatedRas = 1;
                                        return editAssignRAController.farm?.farmSize != null
                                            ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            Text('FARM DETAILS',
                                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text('Owner : ${editAssignRAController.farm?.farmerNam}',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            Text('Size in hectares : ${editAssignRAController.farm?.farmSize}',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            Text('Estimated number of RAs required : ${estimatedRas.round().toString()}',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ):
                                        Container();
                                      }
                                  ),

                                  // const SizedBox(height: 20),
                                  // const Text('Blocks',
                                  //   style: TextStyle(fontWeight: FontWeight.w500),
                                  // ),
                                  // const SizedBox(height: 5,),
                                  // TextFormField(
                                  //   controller: editAssignRAController.blocksTC,
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
                                  //       ? "Blocks is required"
                                  //       : null,
                                  // ),

                                  const SizedBox(height: 20),

                                  const Text('Activity',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  GetBuilder(
                                    init: editAssignRAController,
                                    builder: (ctx) {
                                      return  DropdownSearch<Activity>(
                                        popupProps: PopupProps.modalBottomSheet(
                                            showSelectedItems: true,
                                            showSearchBox: true,
                                            title: const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 15),
                                              child: Center(
                                                child: Text('Select Activity',
                                                  style: TextStyle(fontWeight: FontWeight.w500),),
                                              ),
                                            ),
                                            disabledItemFn: (Activity s) => false,
                                            modalBottomSheetProps: ModalBottomSheetProps(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                                              ),
                                            ),
                                            searchFieldProps: TextFieldProps(
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                enabledBorder: inputBorder,
                                                focusedBorder: inputBorderFocused,
                                                errorBorder: inputBorder,
                                                focusedErrorBorder: inputBorderFocused,
                                                filled: true,
                                                fillColor: AppColor.xLightBackground,
                                              ),
                                            )
                                        ),
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                            enabledBorder: inputBorder,
                                            focusedBorder: inputBorderFocused,
                                            errorBorder: inputBorder,
                                            focusedErrorBorder: inputBorderFocused,
                                            filled: true,
                                            fillColor: AppColor.xLightBackground,
                                          ),
                                        ),
                                        asyncItems: (String filter) async {
                                          var response = await editAssignRAController.globalController.database!.activityDao.findAllMainActivity();
                                          return response;
                                        },
                                        itemAsString: (Activity d) => d.mainActivity?.toString() ?? '',
                                        // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                        compareFn: (activity, filter) => activity.mainActivity == filter.mainActivity,
                                        onChanged: (val) {
                                          editAssignRAController.activity = val!;
                                          editAssignRAController.subActivity = Activity();
                                          editAssignRAController.update();
                                        },
                                        autoValidateMode: AutovalidateMode.always,
                                        selectedItem: editAssignRAController.activity,
                                        validator: (item) {
                                          if (item == null) {
                                            return 'Activity is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      );
                                    }
                                  ),
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
                                  //
                                  //         List? dataList = snapshot.data as List;
                                  //         Activity? data = dataList.first as Activity?;
                                  //         editAssignRAController.activity = data!;
                                  //
                                  //         return  DropdownSearch<Activity>(
                                  //           popupProps: PopupProps.modalBottomSheet(
                                  //               showSelectedItems: true,
                                  //               showSearchBox: true,
                                  //               title: Padding(
                                  //                 padding: const EdgeInsets.symmetric(vertical: 15),
                                  //                 child: Center(
                                  //                   child: Text('Select Activity',
                                  //                     style: const TextStyle(fontWeight: FontWeight.w500),),
                                  //                 ),
                                  //               ),
                                  //               disabledItemFn: (Activity s) => false,
                                  //               modalBottomSheetProps: ModalBottomSheetProps(
                                  //                 elevation: 6,
                                  //                 shape: RoundedRectangleBorder(
                                  //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                                  //                 ),
                                  //               ),
                                  //               searchFieldProps: TextFieldProps(
                                  //                 decoration: InputDecoration(
                                  //                   contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                  //                   enabledBorder: inputBorder,
                                  //                   focusedBorder: inputBorderFocused,
                                  //                   errorBorder: inputBorder,
                                  //                   focusedErrorBorder: inputBorderFocused,
                                  //                   filled: true,
                                  //                   fillColor: AppColor.xLightBackground,
                                  //                 ),
                                  //               )
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
                                  //             var response = await editAssignRAController.globalController.database!.activityDao.findAllMainActivity();
                                  //             return response;
                                  //           },
                                  //           itemAsString: (Activity d) => d.mainActivity!.toString(),
                                  //           // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                  //           compareFn: (activity, filter) => activity.mainActivity == filter.mainActivity,
                                  //           onChanged: (val) {
                                  //             editAssignRAController.activity = val!;
                                  //             editAssignRAController.subActivity = Activity();
                                  //             editAssignRAController.update();
                                  //           },
                                  //           autoValidateMode: AutovalidateMode.always,
                                  //           selectedItem: data,
                                  //           validator: (item) {
                                  //             if (item == null) {
                                  //               return 'Activity is required';
                                  //             } else {
                                  //               return null;
                                  //             }
                                  //           },
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
                                  //   future: globalController.database!.activityDao.findActivityByCode(widget.personnelAssignment.activity!),
                                  // ),
                                  const SizedBox(height: 20),

                                  const Text('Sub Activity',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  GetBuilder(
                                    init: editAssignRAController,
                                    builder: (ctx) {
                                      return  DropdownSearch<Activity>(
                                        popupProps: PopupProps.modalBottomSheet(
                                            showSelectedItems: true,
                                            showSearchBox: true,
                                            title: const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 15),
                                              child: Center(
                                                child: Text('Select Sub Activity',
                                                  style: TextStyle(fontWeight: FontWeight.w500),),
                                              ),
                                            ),
                                            disabledItemFn: (Activity s) => false,
                                            modalBottomSheetProps: ModalBottomSheetProps(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                                              ),
                                            ),
                                            searchFieldProps: TextFieldProps(
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                enabledBorder: inputBorder,
                                                focusedBorder: inputBorderFocused,
                                                errorBorder: inputBorder,
                                                focusedErrorBorder: inputBorderFocused,
                                                filled: true,
                                                fillColor: AppColor.xLightBackground,
                                              ),
                                            )
                                        ),
                                        dropdownDecoratorProps: DropDownDecoratorProps(
                                          dropdownSearchDecoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                            enabledBorder: inputBorder,
                                            focusedBorder: inputBorderFocused,
                                            errorBorder: inputBorder,
                                            focusedErrorBorder: inputBorderFocused,
                                            filled: true,
                                            fillColor: AppColor.xLightBackground,
                                          ),
                                        ),
                                        asyncItems: (String filter) async {
                                          var response = await editAssignRAController.globalController.database!.activityDao.findSubActivities(editAssignRAController.activity.mainActivity ?? '');
                                          return response;
                                        },
                                        itemAsString: (Activity d) => d.subActivity?.toString() ?? '',
                                        // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                        compareFn: (activity, filter) => activity.subActivity == filter.subActivity,
                                        onChanged: (val) {
                                          editAssignRAController.subActivity = val!;
                                          editAssignRAController.update();
                                        },
                                        autoValidateMode: AutovalidateMode.always,
                                        selectedItem: editAssignRAController.subActivity,
                                        validator: (item) {
                                          if (item == null) {
                                            return 'Sub activity is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      );
                                    }
                                  ),
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
                                  //
                                  //         List? dataList = snapshot.data as List;
                                  //         Activity? data = dataList.first as Activity?;
                                  //         editAssignRAController.activity = data!;
                                  //
                                  //         return  DropdownSearch<Activity>(
                                  //           popupProps: PopupProps.modalBottomSheet(
                                  //               showSelectedItems: true,
                                  //               showSearchBox: true,
                                  //               title: Padding(
                                  //                 padding: const EdgeInsets.symmetric(vertical: 15),
                                  //                 child: Center(
                                  //                   child: Text('Select Sub Activity',
                                  //                     style: const TextStyle(fontWeight: FontWeight.w500),),
                                  //                 ),
                                  //               ),
                                  //               disabledItemFn: (Activity s) => false,
                                  //               modalBottomSheetProps: ModalBottomSheetProps(
                                  //                 elevation: 6,
                                  //                 shape: RoundedRectangleBorder(
                                  //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                                  //                 ),
                                  //               ),
                                  //               searchFieldProps: TextFieldProps(
                                  //                 decoration: InputDecoration(
                                  //                   contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                  //                   enabledBorder: inputBorder,
                                  //                   focusedBorder: inputBorderFocused,
                                  //                   errorBorder: inputBorder,
                                  //                   focusedErrorBorder: inputBorderFocused,
                                  //                   filled: true,
                                  //                   fillColor: AppColor.xLightBackground,
                                  //                 ),
                                  //               )
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
                                  //             var response = await editAssignRAController.globalController.database!.activityDao.findSubActivities(editAssignRAController.activity.mainActivity ?? '');
                                  //             return response;
                                  //           },
                                  //           itemAsString: (Activity d) => d.subActivity!.toString(),
                                  //           // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                  //           compareFn: (activity, filter) => activity.subActivity == filter.subActivity,
                                  //           onChanged: (val) {
                                  //             editAssignRAController.subActivity = val!;
                                  //             editAssignRAController.update();
                                  //           },
                                  //           autoValidateMode: AutovalidateMode.always,
                                  //           selectedItem: data,
                                  //           validator: (item) {
                                  //             if (item == null) {
                                  //               return 'Sub activity is required';
                                  //             } else {
                                  //               return null;
                                  //             }
                                  //           },
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
                                  //   future: globalController.database!.activityDao.findActivityByCode(widget.personnelAssignment.activity!),
                                  // ),

                                  const SizedBox(height: 20),

                                  const Text('Rehab Assistants',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),

                                  FutureBuilder(
                                    builder: (ctx, snapshot) {
                                      // Checking if future is resolved or not
                                      if (snapshot.connectionState == ConnectionState.done) {

                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              '${snapshot.error} occurred',
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                          );


                                        } else if (snapshot.hasData) {
                                          List<RehabAssistant> dataList = snapshot.data as List<RehabAssistant>;
                                          editAssignRAController.selectedRehabAssistants = dataList;

                                          return DropdownSearch<RehabAssistant>.multiSelection(
                                            // items: addPersonnelController.farmActivitiesItems,
                                            popupProps: PopupPropsMultiSelection.modalBottomSheet(
                                                showSelectedItems: true,
                                                showSearchBox: true,
                                                disabledItemFn: (RehabAssistant s) => false,
                                                modalBottomSheetProps: ModalBottomSheetProps(
                                                  elevation: 6,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
                                                  ),
                                                ),
                                                title: const Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 15),
                                                  child: Center(
                                                    child: Text('Select Rehab Assistants',
                                                      style: TextStyle(fontWeight: FontWeight.w500),),
                                                  ),
                                                ),
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                    enabledBorder: inputBorder,
                                                    focusedBorder: inputBorderFocused,
                                                    errorBorder: inputBorder,
                                                    focusedErrorBorder: inputBorderFocused,
                                                    filled: true,
                                                    fillColor: AppColor.xLightBackground,
                                                  ),
                                                )
                                            ),
                                            dropdownDecoratorProps: DropDownDecoratorProps(
                                              dropdownSearchDecoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                                                enabledBorder: inputBorder,
                                                focusedBorder: inputBorderFocused,
                                                errorBorder: inputBorder,
                                                focusedErrorBorder: inputBorderFocused,
                                                filled: true,
                                                fillColor: AppColor.xLightBackground,
                                              ),
                                            ),
                                            asyncItems: (String filter) async {
                                              var response = await editAssignRAController.globalController.database!.rehabAssistantDao.findAllRehabAssistants();
                                              return response;
                                            },
                                            itemAsString: (RehabAssistant d) => d.rehabName!.toString(),
                                            compareFn: (rehabAssistant, filter) => rehabAssistant.rehabName == filter.rehabName,
                                            autoValidateMode: AutovalidateMode.always,
                                            selectedItems: dataList,
                                            validator: (item) {
                                              if (item!.isEmpty) {
                                                return 'Rehab assistants required';
                                              } else {
                                                return null;
                                              }
                                            },
                                            onChanged: (val) {
                                              editAssignRAController.selectedRehabAssistants = val;
                                            },
                                            // selectedItems: editAssignRAController.selectedRehabAssistantsActivities,
                                          );
                                        }
                                      }

                                      // Displaying LoadingSpinner to indicate waiting state
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },

                                    // Future that needs to be resolved
                                    // inorder to display something on the Canvas
                                    future: globalController.database!.rehabAssistantDao.findRehabAssistantsByRehabCodes(jsonDecode(widget.personnelAssignment.rehabAssistants!).cast<int>()),
                                  ),

                                  if (!widget.isViewMode)
                                  const SizedBox(height: 40,),

                                  if (!widget.isViewMode)
                                    Row(
                                      children: [

                                        Expanded(
                                          child: CustomButton(
                                            isFullWidth: true,
                                            backgroundColor: AppColor.black,
                                            verticalPadding: 0.0,
                                            horizontalPadding: 8.0,
                                            onTap: () async{
                                              if (!editAssignRAController.isButtonDisabled.value){
                                                if (editAssignRAController.assignRAFormKey.currentState!.validate()) {
                                                  editAssignRAController.handleOfflineAssignRA();
                                                }else{
                                                  editAssignRAController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Save',
                                              style: TextStyle(color: AppColor.white, fontSize: 14),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        Expanded(
                                          child: CustomButton(
                                            isFullWidth: true,
                                            backgroundColor: AppColor.primary,
                                            verticalPadding: 0.0,
                                            horizontalPadding: 8.0,
                                            onTap: () async{
                                              if (!editAssignRAController.isButtonDisabled.value){
                                                if (editAssignRAController.assignRAFormKey.currentState!.validate()) {
                                                  editAssignRAController.handleAssignRA();
                                                }else{
                                                  editAssignRAController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
                                                }
                                              }
                                            },
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(color: AppColor.white, fontSize: 14),
                                            ),
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
                                  //       if (editAssignRAController.assignRAFormKey.currentState!.validate()) {
                                  //         editAssignRAController.handleAssignRA();
                                  //       } else {
                                  //         editAssignRAController.globals.showSnackBar(
                                  //             title: 'Alert',
                                  //             message: 'Kindly provide all required information');
                                  //       }
                                  //   },
                                  // ),

                                  const SizedBox(height: 30),

                                ],
                              ),
                            );
                          }
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
    );
  }
}
