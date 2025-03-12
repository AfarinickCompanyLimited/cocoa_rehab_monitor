import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'maintenance_fuel_controller.dart';


class MaintenanceFuel extends StatefulWidget {
  const MaintenanceFuel({Key? key}) : super(key: key);

  @override
  State<MaintenanceFuel> createState() => _MaintenanceFuelState();
}

class _MaintenanceFuelState extends State<MaintenanceFuel> {
  @override
  Widget build(BuildContext context) {

    MaintenanceFuelController maintenanceFuelController = Get.put(MaintenanceFuelController());
    maintenanceFuelController.context = context;

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
                        child: Text('Report Maintenance Fuel',
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

                      Form(
                        key: maintenanceFuelController.assignRAFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            const Text('Date Received',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5,),
                            DateTimePicker(
                              controller: maintenanceFuelController.dateReceivedTC,
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
                              onChanged: (val) => maintenanceFuelController.dateReceivedTC?.text = val,
                              validator: (String? value) => value!.trim().isEmpty
                                  ? "Date is required"
                                  : null,
                              onSaved: (val) => maintenanceFuelController.dateReceivedTC?.text = val!,
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
                                var response = await maintenanceFuelController.globalController.database!.farmDao.findAllFarm();
                                return response;
                              },
                              itemAsString: (Farm d) => d.farmId!.toString(),
                              filterFn: (Farm d, filter) => d.farmerNam.toString().toLowerCase().contains(filter.toLowerCase()),
                              compareFn: (farm, filter) => farm.farmId == filter.farmId,
                              onChanged: (val) {
                                maintenanceFuelController.farm = val!;
                                maintenanceFuelController.update();
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
                              init: maintenanceFuelController,
                              builder: (ctx) {
                                return maintenanceFuelController.farm?.farmSize != null
                                ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text('FARM DETAILS',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text('Owner : ${maintenanceFuelController.farm?.farmerNam}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Text('Size in hectares : ${maintenanceFuelController.farm?.farmSize}',
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

                            DropdownSearch<RehabAssistant>(
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
                                var response = await maintenanceFuelController.globalController.database!.rehabAssistantDao.findAllRehabAssistants();
                                return response;
                              },
                              itemAsString: (RehabAssistant d) => d.rehabName!.toString(),
                              compareFn: (rehabAssistant, filter) => rehabAssistant.rehabName == filter.rehabName,
                              autoValidateMode: AutovalidateMode.always,
                              validator: (item) {
                                if (item == null) {
                                  return 'RA is required';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                maintenanceFuelController.rehabAssistant = val;
                              },
                              // selectedItems: maintenanceFuelController.selectedRehabAssistantsActivities,
                            ),

                            const SizedBox(height: 20),

                            const Text('Quantity (Ltr)',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 5,),
                            TextFormField(
                              controller: maintenanceFuelController.quantityTC,
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
                                controller: maintenanceFuelController.remarksTC,
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
                                      if (!maintenanceFuelController.isButtonDisabled.value){
                                        if (maintenanceFuelController.assignRAFormKey.currentState!.validate()) {
                                          maintenanceFuelController.handleOfflineSave();
                                        }else{
                                          maintenanceFuelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
                                      if (!maintenanceFuelController.isButtonDisabled.value){
                                        if (maintenanceFuelController.assignRAFormKey.currentState!.validate()) {
                                          // maintenanceFuelController.handleSubmit();
                                        }else{
                                          maintenanceFuelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
