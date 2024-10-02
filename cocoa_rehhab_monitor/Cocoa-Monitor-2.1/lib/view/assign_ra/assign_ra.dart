import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'assign_ra_controller.dart';


class AssignRA extends StatefulWidget {
  const AssignRA({Key? key}) : super(key: key);

  @override
  State<AssignRA> createState() => _AssignRAState();
}

class _AssignRAState extends State<AssignRA> {
  @override
  Widget build(BuildContext context) {

    AssignRAController assignRAController = Get.put(AssignRAController());
    assignRAController.assignRAScreenContext = context;

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

              Padding(
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
                      child: Text('Assign Rehab Assistant',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: AppPadding.horizontal, right: AppPadding.horizontal, bottom: AppPadding.vertical, top: 10),
                  child: Column(
                    children: [

                      Form(
                        key: assignRAController.assignRAFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            const Text('Assignment Date',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5,),
                            DateTimePicker(
                              controller: assignRAController.assignmentDateTC,
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
                              onChanged: (val) => assignRAController.assignmentDateTC?.text = val,
                              validator: (String? value) => value!.trim().isEmpty
                                  ? "Assignment date is required"
                                  : null,
                              onSaved: (val) => assignRAController.assignmentDateTC?.text = val!,
                            ),

                            const SizedBox(height: 20),

                            const Text('Farm',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5,),
                            DropdownSearch<Farm>(
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
                                var response = await assignRAController.globalController.database!.farmDao.findAllFarm();
                                return response;
                              },
                              itemAsString: (Farm d) => d.farmId!.toString(),
                              filterFn: (Farm d, filter) => d.farmerNam.toString().toLowerCase().contains(filter.toLowerCase()),
                              compareFn: (farm, filter) => farm.farmId == filter.farmId,
                              onChanged: (val) {
                                assignRAController.farm = val!;
                                assignRAController.update();
                              },
                              autoValidateMode: AutovalidateMode.always,
                              validator: (item) {
                                if (item == null) {
                                  return 'Farm is required';
                                } else {
                                  return null;
                                }
                              },
                            ),


                            GetBuilder(
                              init: assignRAController,
                              builder: (ctx) {
                                var estimatedRas = (assignRAController.farm?.farmSize ?? 0.0) / 1.6;
                                if(estimatedRas < 1) estimatedRas = 1;
                                return assignRAController.farm?.farmSize != null
                                ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text('FARM DETAILS',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text('Owner : ${assignRAController.farm?.farmerNam}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text('Size in hectares : ${assignRAController.farm?.farmSize}',
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
                            //   controller: assignRAController.blocksTC,
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
                            DropdownSearch<Activity>(
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
                                var response = await assignRAController.globalController.database!.activityDao.findAllMainActivity();
                                return response;
                              },
                              itemAsString: (Activity d) => d.mainActivity!.toString(),
                              // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                              compareFn: (activity, filter) => activity.mainActivity == filter.mainActivity,
                              onChanged: (val) {
                                assignRAController.activity = val!;
                                assignRAController.subActivity = Activity();
                                assignRAController.update();
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

                            const Text('Sub Activity',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5,),
                            DropdownSearch<Activity>(
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
                                var response = await assignRAController.globalController.database!.activityDao.findSubActivities(assignRAController.activity.mainActivity ?? '');
                                return response;
                              },
                              itemAsString: (Activity d) => d.subActivity!.toString(),
                              // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                              compareFn: (activity, filter) => activity.subActivity == filter.subActivity,
                              onChanged: (val) {
                                assignRAController.subActivity = val!;
                              },
                              autoValidateMode: AutovalidateMode.always,
                              validator: (item) {
                                if (item == null) {
                                  return 'Sub activity is required';
                                } else {
                                  return null;
                                }
                              },
                            ),

                            const SizedBox(height: 20),

                            const Text('Rehab Assistants',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5,),

                            DropdownSearch<RehabAssistant>.multiSelection(
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
                                var response = await assignRAController.globalController.database!.rehabAssistantDao.findAllRehabAssistants();
                                return response;
                              },
                              itemAsString: (RehabAssistant d) => d.rehabName!.toString(),
                              compareFn: (rehabAssistant, filter) => rehabAssistant.rehabName == filter.rehabName,
                              autoValidateMode: AutovalidateMode.always,
                              validator: (item) {
                                if (item!.isEmpty) {
                                  return 'Rehab assistants required';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                assignRAController.selectedRehabAssistants = val;
                              },
                              // selectedItems: assignRAController.selectedRehabAssistantsActivities,
                            ),

                            const SizedBox(height: 40,),

                            Row(
                              children: [

                                Expanded(
                                  child: CustomButton(
                                    isFullWidth: true,
                                    backgroundColor: AppColor.black,
                                    verticalPadding: 0.0,
                                    horizontalPadding: 8.0,
                                    onTap: () async{
                                      if (!assignRAController.isButtonDisabled.value){
                                        if (assignRAController.assignRAFormKey.currentState!.validate()) {
                                          assignRAController.handleOfflineAssignRA();
                                        }else{
                                          assignRAController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
                                      if (!assignRAController.isButtonDisabled.value){
                                        if (assignRAController.assignRAFormKey.currentState!.validate()) {
                                          assignRAController.handleAssignRA();
                                        }else{
                                          assignRAController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
                            //       if (assignRAController.assignRAFormKey.currentState!.validate()) {
                            //         assignRAController.handleAssignRA();
                            //       } else {
                            //         assignRAController.globals.showSnackBar(
                            //             title: 'Alert',
                            //             message: 'Kindly provide all required information');
                            //       }
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
    );
  }
}
