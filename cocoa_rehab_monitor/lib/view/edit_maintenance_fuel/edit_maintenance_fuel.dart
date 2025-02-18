
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/maintenance_fuel.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
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

import 'edit_maintenance_fuel_controller.dart';


class EditMaintenanceFuel extends StatefulWidget {
  final MaintenanceFuel maintenanceFuel;
  final bool isViewMode;
  const EditMaintenanceFuel({Key? key, required this.maintenanceFuel, required this.isViewMode}) : super(key: key);

  @override
  State<EditMaintenanceFuel> createState() => _EditMaintenanceFuelState();
}

class _EditMaintenanceFuelState extends State<EditMaintenanceFuel> {

  EditMaintenanceFuelController editMaintenanceFuelController = Get.put(EditMaintenanceFuelController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    editMaintenanceFuelController.maintenanceFuel = widget.maintenanceFuel;
    editMaintenanceFuelController.isViewMode = widget.isViewMode;

  }

  @override
  Widget build(BuildContext context) {

    editMaintenanceFuelController.context = context;

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
                        child: Text(widget.isViewMode ? 'View Fuel Details' : 'Edit Fuel',
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
                            init: editMaintenanceFuelController,
                          builder: (ctx) {
                            return Form(
                              key: editMaintenanceFuelController.assignRAFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  const Text('Date Received',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  DateTimePicker(
                                    controller: editMaintenanceFuelController.dateReceivedTC,
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
                                    onChanged: (val) => editMaintenanceFuelController.dateReceivedTC?.text = val,
                                    validator: (String? value) => value!.trim().isEmpty
                                        ? "Date is required"
                                        : null,
                                    onSaved: (val) => editMaintenanceFuelController.dateReceivedTC?.text = val!,
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
                                          editMaintenanceFuelController.farm = data!;

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
                                              var response = await editMaintenanceFuelController.globalController.database!.farmDao.findAllFarm();
                                              return response;
                                            },
                                            itemAsString: (Farm d) => d.farmId ?? '',
                                            filterFn: (Farm d, filter) => d.farmerNam.toString().toLowerCase().contains(filter.toLowerCase()),
                                            compareFn: (farm, filter) => farm.farmId == filter.farmId,
                                            onChanged: (val) {
                                              editMaintenanceFuelController.farm = val!;
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
                                    future: globalController.database!.farmDao.findFarmByFarmCode(widget.maintenanceFuel.farmdetailstblForeignkey!),
                                  ),

                                  GetBuilder(
                                      init: editMaintenanceFuelController,
                                      builder: (ctx) {
                                        return editMaintenanceFuelController.farm?.farmSize != null
                                            ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            Text('FARM DETAILS',
                                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text('Owner : ${editMaintenanceFuelController.farm?.farmerNam}',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            Text('Size in hectares : ${editMaintenanceFuelController.farm?.farmSize}',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ):
                                        Container();
                                      }
                                  ),

                                  const SizedBox(height: 20),

                                  const Text('Rehab Assistant',
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
                                          RehabAssistant? data = dataList.isNotEmpty ? dataList.first as RehabAssistant? : RehabAssistant();
                                          editMaintenanceFuelController.rehabAssistant = data!;

                                          return  DropdownSearch<RehabAssistant>(
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
                                              var response = await editMaintenanceFuelController.globalController.database!.rehabAssistantDao.findAllRehabAssistants();
                                              return response;
                                            },
                                            itemAsString: (RehabAssistant d) => d.rehabName ?? '',
                                            compareFn: (rehabAssistant, filter) => rehabAssistant.rehabName == filter.rehabName,
                                            autoValidateMode: AutovalidateMode.always,
                                            onChanged: (val) {
                                              editMaintenanceFuelController.rehabAssistant = val;
                                            },
                                            selectedItem: data,
                                            validator: (item) {
                                              if (item == null) {
                                                return 'RA is required';
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

                                    future: globalController.database!.rehabAssistantDao.findRehabAssistantByRehabCode(widget.maintenanceFuel.rehabassistantsTblForeignkey!),
                                  ),

                                  const SizedBox(height: 20),

                                  const Text('Quantity (Ltr)',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  TextFormField(
                                    controller: editMaintenanceFuelController.quantityTC,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorderFocused,
                                      errorBorder: inputBorder,
                                      focusedErrorBorder: inputBorderFocused,
                                      filled: true,
                                      fillColor: AppColor.xLightBackground,
                                    ),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    validator: (String? value) => value!.trim().isEmpty
                                        ? "Quantity is required"
                                        : null,
                                  ),
                                  const SizedBox(height: 20),

                                  const Text('Remarks',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  TextFormField(
                                      controller: editMaintenanceFuelController.remarksTC,
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                      maxLines: null,
                                      textInputAction: TextInputAction.done
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
                                              if (!editMaintenanceFuelController.isButtonDisabled.value){
                                                if (editMaintenanceFuelController.assignRAFormKey.currentState!.validate()) {
                                                  editMaintenanceFuelController.handleOfflineSave();
                                                }else{
                                                  editMaintenanceFuelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
                                              if (!editMaintenanceFuelController.isButtonDisabled.value){
                                                if (editMaintenanceFuelController.assignRAFormKey.currentState!.validate()) {
                                                  // editMaintenanceFuelController.handleSubmit();
                                                }else{
                                                  editMaintenanceFuelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
                                  //       if (editMaintenanceFuelController.assignRAFormKey.currentState!.validate()) {
                                  //         editMaintenanceFuelController.handleAssignRA();
                                  //       } else {
                                  //         editMaintenanceFuelController.globals.showSnackBar(
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
