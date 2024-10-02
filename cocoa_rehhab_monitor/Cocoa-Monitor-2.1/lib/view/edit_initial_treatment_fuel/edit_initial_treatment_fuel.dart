
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_fuel.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
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

import 'edit_initial_treatment_fuel_controller.dart';

class EditInitialTreatmentFuel extends StatefulWidget {
  final InitialTreatmentFuel initialTreatmentFuel;
  final bool isViewMode;
  const EditInitialTreatmentFuel({Key? key, required this.initialTreatmentFuel, required this.isViewMode}) : super(key: key);

  @override
  State<EditInitialTreatmentFuel> createState() => _EditInitialTreatmentFuelState();
}

class _EditInitialTreatmentFuelState extends State<EditInitialTreatmentFuel> {

  EditInitialTreatmentFuelController editInitialTreatmentFuelController = Get.put(EditInitialTreatmentFuelController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    editInitialTreatmentFuelController.initialTreatmentFuel = widget.initialTreatmentFuel;
    editInitialTreatmentFuelController.isViewMode = widget.isViewMode;

  }

  @override
  Widget build(BuildContext context) {

    editInitialTreatmentFuelController.context = context;

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
                            init: editInitialTreatmentFuelController,
                          builder: (ctx) {
                            return Form(
                              key: editInitialTreatmentFuelController.assignRAFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  const Text('Date Received',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  DateTimePicker(
                                    controller: editInitialTreatmentFuelController.dateReceivedTC,
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
                                    onChanged: (val) => editInitialTreatmentFuelController.dateReceivedTC?.text = val,
                                    validator: (String? value) => value!.trim().isEmpty
                                        ? "Date is required"
                                        : null,
                                    onSaved: (val) => editInitialTreatmentFuelController.dateReceivedTC?.text = val!,
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
                                          OutbreakFarmFromServer? data = dataList.isNotEmpty ? dataList.first as OutbreakFarmFromServer? : OutbreakFarmFromServer();
                                          editInitialTreatmentFuelController.farm = data!;

                                          return  DropdownSearch<OutbreakFarmFromServer>(
                                            popupProps: PopupProps.modalBottomSheet(
                                                showSelectedItems: true,
                                                showSearchBox: true,
                                                itemBuilder: (context, item, selected){
                                                  return ListTile(
                                                    title: Text(item.farmerName.toString(),
                                                        style: selected ? TextStyle(color: AppColor.primary) : const TextStyle()),
                                                    subtitle: Text(item.outbreaksId.toString(),
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
                                                disabledItemFn: (OutbreakFarmFromServer s) => false,
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
                                              var response = await editInitialTreatmentFuelController.globalController.database!.outbreakFarmFromServerDao.findAllOutbreakFarmFromServer();
                                              return response;
                                            },
                                            itemAsString: (OutbreakFarmFromServer d) => d.farmId?.toString() ?? '',
                                            filterFn: (OutbreakFarmFromServer d, filter) => d.farmerName.toString().toLowerCase().contains(filter.toLowerCase()),
                                            compareFn: (farm, filter) => farm.farmId == filter.farmId,
                                            onChanged: (val) {
                                              editInitialTreatmentFuelController.farm = val!;
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
                                    future: globalController.database!.outbreakFarmFromServerDao.findOutbreakFarmFromServerByFarmId(widget.initialTreatmentFuel.farmdetailstblForeignkey.toString()),
                                  ),

                                  GetBuilder(
                                      init: editInitialTreatmentFuelController,
                                      builder: (ctx) {
                                        return editInitialTreatmentFuelController.farm?.farmArea != null
                                            ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            Text('FARM DETAILS',
                                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text('Owner : ${editInitialTreatmentFuelController.farm?.farmerName}',
                                              style: const TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            Text('Size in hectares : ${editInitialTreatmentFuelController.farm?.farmArea}',
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
                                          editInitialTreatmentFuelController.rehabAssistant = data!;

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
                                              var response = await editInitialTreatmentFuelController.globalController.database!.rehabAssistantDao.findAllRehabAssistants();
                                              return response;
                                            },
                                            itemAsString: (RehabAssistant d) => d.rehabName ?? '',
                                            compareFn: (rehabAssistant, filter) => rehabAssistant.rehabName == filter.rehabName,
                                            autoValidateMode: AutovalidateMode.always,
                                            onChanged: (val) {
                                              editInitialTreatmentFuelController.rehabAssistant = val;
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

                                    future: globalController.database!.rehabAssistantDao.findRehabAssistantByRehabCode(widget.initialTreatmentFuel.rehabassistantsTblForeignkey!),
                                  ),

                                  const SizedBox(height: 20),

                                  const Text('Quantity (Ltr)',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5,),
                                  TextFormField(
                                    controller: editInitialTreatmentFuelController.quantityTC,
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
                                      controller: editInitialTreatmentFuelController.remarksTC,
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
                                              if (!editInitialTreatmentFuelController.isButtonDisabled.value){
                                                if (editInitialTreatmentFuelController.assignRAFormKey.currentState!.validate()) {
                                                  editInitialTreatmentFuelController.handleOfflineSave();
                                                }else{
                                                  editInitialTreatmentFuelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
                                              if (!editInitialTreatmentFuelController.isButtonDisabled.value){
                                                if (editInitialTreatmentFuelController.assignRAFormKey.currentState!.validate()) {
                                                  editInitialTreatmentFuelController.handleSubmit();
                                                }else{
                                                  editInitialTreatmentFuelController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
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
