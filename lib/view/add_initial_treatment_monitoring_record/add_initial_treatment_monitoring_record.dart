import 'dart:math';

import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/model/job_order_farms_model.dart';
import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cocoa_rehab_monitor/controller/model/activity_model.dart';
import 'add_initial_treatment_monitoring_record_controller.dart';
import 'components/initial_treatment_rehab_assistant_select.dart';

class AddInitialTreatmentMonitoringRecord extends StatefulWidget {
  const AddInitialTreatmentMonitoringRecord({Key? key}) : super(key: key);

  @override
  State<AddInitialTreatmentMonitoringRecord> createState() =>
      _AddInitialTreatmentMonitoringRecordState();
}

class _AddInitialTreatmentMonitoringRecordState
    extends State<AddInitialTreatmentMonitoringRecord> {
  final AddInitialTreatmentMonitoringRecordController controller =
      Get.put(AddInitialTreatmentMonitoringRecordController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addMonitoringRecordScreenContext = context;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _buildAppBar(context),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: AppPadding.horizontal,
                      right: AppPadding.horizontal,
                      bottom: AppPadding.vertical,
                      top: 10,
                    ),
                    child: Form(
                      key: controller.addMonitoringRecordFormKey,
                      child: Column(
                        children: [
                          _buildDateFields(),
                          const SizedBox(height: 20),
                          _buildFarmReferenceDropdown(),
                          const SizedBox(height: 20),
                          _buildCommunityField(),
                          const SizedBox(height: 20),
                          _buildFarmSizeField(),
                          const SizedBox(height: 20),
                          _buildActivityDropdown(),
                          const SizedBox(height: 20),
                          _buildSubActivityDropdown(),
                          const SizedBox(height: 20),
                          _buildGroupActivitySection(),
                          const SizedBox(height: 20),
                          _buildRehabAssistantsSection(),
                          const SizedBox(height: 20),
                          _buildRemarksField(),
                          const SizedBox(height: 20),
                          _buildActionButtons(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)),
      )),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 15,
          bottom: 10,
          left: AppPadding.horizontal,
          right: AppPadding.horizontal,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedIconButton(
              icon: appIconBack(color: AppColor.black, size: 25),
              size: 45,
              backgroundColor: Colors.transparent,
              onTap: () => Get.back(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Activity reporting",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Completion Date',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DateTimePicker(
          controller: controller.monitoringDateTC,
          type: DateTimePickerType.date,
          dateMask: 'yyyy-MM-dd',
          firstDate: DateTime(1600),
          lastDate: DateTime.now(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: inputBorder,
            focusedBorder: inputBorderFocused,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorderFocused,
            filled: true,
            fillColor: AppColor.xLightBackground,
          ),
          onChanged: (val) => controller.monitoringDateTC!.text = val,
          validator: (String? value) =>
              value!.trim().isEmpty ? "Monitoring date is required" : null,
          onSaved: (val) => controller.monitoringDateTC!.text = val!,
        ),
        const SizedBox(height: 20),
        const Text(
          'Reporting Date',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DateTimePicker(
          controller: controller.reportingDateTC,
          type: DateTimePickerType.date,
          initialDate: DateTime.now(),
          dateMask: 'yyyy-MM-dd',
          firstDate: DateTime(1600),
          lastDate: DateTime.now(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: inputBorder,
            focusedBorder: inputBorderFocused,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorderFocused,
            filled: true,
            fillColor: AppColor.xLightBackground,
          ),
          onChanged: (val) => controller.reportingDateTC!.text = val,
          validator: (String? value) =>
              value!.trim().isEmpty ? "Reporting date is required" : null,
          onSaved: (val) => controller.reportingDateTC!.text = val!,
        ),
      ],
    );
  }

  Widget _buildFarmReferenceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Farm Reference Number',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DropdownSearch<JobOrderFarmModel>(
          popupProps: PopupProps.modalBottomSheet(
            showSelectedItems: true,
            showSearchBox: true,
            title: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'Select farm reference number',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            disabledItemFn: (JobOrderFarmModel s) => false,
            modalBottomSheetProps: ModalBottomSheetProps(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.md),
                  topRight: Radius.circular(AppBorderRadius.md),
                ),
              ),
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                enabledBorder: inputBorder,
                focusedBorder: inputBorderFocused,
                errorBorder: inputBorder,
                focusedErrorBorder: inputBorderFocused,
                filled: true,
                fillColor: AppColor.xLightBackground,
              ),
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              enabledBorder: inputBorder,
              focusedBorder: inputBorderFocused,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorderFocused,
              filled: true,
              fillColor: AppColor.xLightBackground,
            ),
          ),
          asyncItems: (String filter) async {
            final response = await controller.jobOrderDb.getAllFarms();
            debugPrint("Farm Reference Response: $response");
            return response;
          },
          itemAsString: (JobOrderFarmModel d) => d.farmId.toString(),
          compareFn: (activity, filter) => activity == filter,
          onChanged: (val) {
            if (val != null) {
              controller.farmReferenceNumberTC!.text = val.farmId.toString();
              controller.farmSizeTC!.text = val.farmSize.toString();
              controller.communityTC!.text = val.location.toString();

              if (controller.isDoneEqually.value.isNotEmpty &&
                  controller.numberInGroupTC!.text.isNotEmpty) {
                double area = double.parse(controller.farmSizeTC!.text) /
                    int.parse(controller.numberInGroupTC!.text);
                controller.rehabAssistants.forEach((ra) {
                  ra.areaCovered!.text = area.toString();
                });
              }
              controller.update();
            }
          },
          autoValidateMode: AutovalidateMode.always,
          validator: (item) =>
              item == null ? 'Farm reference is required' : null,
        ),
      ],
    );
  }

  Widget _buildCommunityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Community',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller.communityTC,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: inputBorder,
            focusedBorder: inputBorderFocused,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorderFocused,
            filled: true,
            fillColor: AppColor.lightText,
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          validator: (String? value) =>
              value!.trim().isEmpty ? "Community is required" : null,
        ),
      ],
    );
  }

  Widget _buildFarmSizeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Farm Size (in hectares)',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller.farmSizeTC,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: inputBorder,
            focusedBorder: inputBorderFocused,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorderFocused,
            filled: true,
            fillColor: AppColor.lightText,
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          validator: (String? value) =>
              value!.trim().isEmpty ? "Farm size is required" : null,
        ),
      ],
    );
  }

  Widget _buildActivityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DropdownSearch<String>(
          popupProps: PopupProps.modalBottomSheet(
            showSelectedItems: true,
            showSearchBox: true,
            title: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'Select Activity',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            disabledItemFn: (String s) => false,
            modalBottomSheetProps: ModalBottomSheetProps(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.md),
                  topRight: Radius.circular(AppBorderRadius.md),
                ),
              ),
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                enabledBorder: inputBorder,
                focusedBorder: inputBorderFocused,
                errorBorder: inputBorder,
                focusedErrorBorder: inputBorderFocused,
                filled: true,
                fillColor: AppColor.xLightBackground,
              ),
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              enabledBorder: inputBorder,
              focusedBorder: inputBorderFocused,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorderFocused,
              filled: true,
              fillColor: AppColor.xLightBackground,
            ),
          ),
          asyncItems: (String filter) async {
            final activities =
                await controller.db.getAllActivityWithMainActivityList([
              MainActivities.Maintenance,
              MainActivities.Establishment,
              MainActivities.InitialTreatment,
            ]);

            final uniqueActivities = activities
                .map((activity) => activity.mainActivity)
                .whereType<String>()
                .toSet()
                .toList();

            return uniqueActivities;
          },
          itemAsString: (String d) => d,
          compareFn: (activity, filter) => activity == filter,
          onChanged: (val) {
            if (val != null) {
              controller.activity = val;
              controller.update();
            }
          },
          autoValidateMode: AutovalidateMode.always,
          validator: (item) => item == null ? 'Activity is required' : null,
        ),
      ],
    );
  }

  Widget _buildSubActivityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sub activity',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DropdownSearch<ActivityModel>.multiSelection(
          popupProps: PopupPropsMultiSelection.modalBottomSheet(
            showSelectedItems: true,
            showSearchBox: true,
            title: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'Select sub activity',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            disabledItemFn: (ActivityModel s) => false,
            modalBottomSheetProps: ModalBottomSheetProps(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.md),
                  topRight: Radius.circular(AppBorderRadius.md),
                ),
              ),
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                enabledBorder: inputBorder,
                focusedBorder: inputBorderFocused,
                errorBorder: inputBorder,
                focusedErrorBorder: inputBorderFocused,
                filled: true,
                fillColor: AppColor.xLightBackground,
              ),
            ),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              enabledBorder: inputBorder,
              focusedBorder: inputBorderFocused,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorderFocused,
              filled: true,
              fillColor: AppColor.xLightBackground,
            ),
          ),
          asyncItems: (String filter) async {
            if (controller.activity == null) return [];
            return await controller.db
                .getSubActivityByMainActivity(controller.activity!);
          },
          itemAsString: (ActivityModel d) => d.subActivity.toString(),
          compareFn: (activity, filter) =>
              activity.subActivity == filter.subActivity,
          onChanged: (vals) {
            controller.subActivityList = vals ?? [];
            controller.update();
          },
          autoValidateMode: AutovalidateMode.always,
          validator: (items) => items == null || items.isEmpty
              ? 'Sub activity is required'
              : null,
        ),
      ],
    );
  }

  Widget _buildGroupActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Was The Activity Done By A Group',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        DropdownSearch<String>(
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            disabledItemFn: (String s) => false,
            fit: FlexFit.loose,
            menuProps: MenuProps(
              elevation: 6,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
          ),
          items: controller.yesNoItems,
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              enabledBorder: inputBorder,
              focusedBorder: inputBorderFocused,
              errorBorder: inputBorder,
              focusedErrorBorder: inputBorderFocused,
              filled: true,
              fillColor: AppColor.xLightBackground,
            ),
          ),
          autoValidateMode: AutovalidateMode.always,
          validator: (item) => item == null ? "Field is required" : null,
          onChanged: (val) {
            if (val != null) {
              controller.isCompletedByGroup.value = val;
              controller.areaCoveredRx.value = '';
              controller.clearRehabAssistantsToDefault();
              controller.numberInGroupTC!.clear();
              controller.update();
            }
          },
        ),
        GetBuilder<AddInitialTreatmentMonitoringRecordController>(
          builder: (ctx) {
            if (controller.isCompletedByGroup.value == YesNo.yes) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Number of People In Group',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: controller.numberInGroupTC,
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.next,
                    validator: (String? value) => value!.trim().isEmpty
                        ? "Number of People In Group is required"
                        : null,
                    onChanged: (value) {
                      controller.clearRehabAssistantsToDefault();
                      controller.updateAreaCovered();
                      controller.update();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Was The Activity Done Equally',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      disabledItemFn: (String s) => false,
                      fit: FlexFit.loose,
                      menuProps: MenuProps(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                    ),
                    items: controller.yesNoItems,
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
                    validator: (item) =>
                        item == null ? "Field is required" : null,
                    onChanged: (val) {
                      if(controller.farmSizeTC!.text.isEmpty) {
                        controller.globals.showSnackBar(
                          title: "Required action",
                          message:
                          "Please select the farm to continue.",
                        );
                        controller.numberInGroupTC!.text = "";
                        controller.isDoneEqually.value = YesNo.none;
                        return;
                      }
                      if (val != null) {
                        controller.isDoneEqually.value = val;

                        if (controller.numberInGroupTC!.text.isEmpty) {
                          controller.globals.showSnackBar(
                            title: "Required action",
                            message:
                                "Please input the number of people in the group to proceed",
                          );
                          return;
                        }

                        setState(() {
                          
                        });

                        if (controller.isDoneEqually.value == YesNo.yes) {
                          double area =
                              double.parse(controller.farmSizeTC!.text) /
                                  int.parse(controller.numberInGroupTC!.text);
                          controller.rehabAssistants.forEach((ra) {
                            ra.areaCovered!.text = area.toString();
                          });
                        }
                        controller.update();
                      }
                    },
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget _buildRehabAssistantsSection() {
    return GetBuilder<AddInitialTreatmentMonitoringRecordController>(
      builder: (ctx) {
        final groupHasNumber =
            int.tryParse(controller.numberInGroupTC!.text) != null;

        if (groupHasNumber || controller.isCompletedByGroup.value == YesNo.no) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'REHAB ASSISTANTS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
              Text(
                controller.isCompletedByGroup.value == YesNo.yes
                    ? 'Select rehab assistants and their respective area covered (if applicable)'
                    : 'Select rehab assistants and their respective area covered',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.black,
                ),
              ),
              if (controller.isCompletedByGroup.value == YesNo.yes)
                Column(
                  children: _buildGroupRehabAssistants(),
                )
              else
                controller.rehabAssistants.first,
              const SizedBox(height: 20),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  List<Widget> _buildGroupRehabAssistants() {
    final maxItems = int.tryParse(controller.numberInGroupTC!.text) ?? 1;

    // Sync rehab assistants count with group size
    if (maxItems != controller.rehabAssistants.length) {
      controller.clearRehabAssistantsToDefault();
      controller.rehabAssistants = List.generate(
          maxItems,
          (i) => InitialTreatmentRehabAssistantSelection(
                index: RxInt(i + 1),
              ));
    }

    return List<Widget>.generate(
      min(maxItems, controller.rehabAssistants.length),
      (i) => controller.rehabAssistants[i],
    );
  }

  Widget _buildRemarksField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'General Remarks',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller.remarksTC,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: inputBorder,
            focusedBorder: inputBorderFocused,
            errorBorder: inputBorder,
            focusedErrorBorder: inputBorderFocused,
            filled: true,
            fillColor: AppColor.xLightBackground,
          ),
          maxLines: null,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            isFullWidth: true,
            backgroundColor: AppColor.black,
            verticalPadding: 0.0,
            horizontalPadding: 8.0,
            onTap: () => _handleSaveAction(),
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
            onTap: () => _handleSubmitAction(),
            child: Text(
              'Submit',
              style: TextStyle(color: AppColor.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSaveAction() async {
    if (!_validateForm() || !_validateRehabAssistants()) return;

    if (controller.addMonitoringRecordFormKey.currentState!.validate()) {
      controller.handleSaveOfflineMonitoringRecord();
    } else {
      controller.globals.showSnackBar(
        title: 'Alert',
        message: 'Kindly provide all required information',
      );
    }
  }

  void _handleSubmitAction() async {
    if (!_validateForm() || !_validateRehabAssistants()) return;

    if (controller.addMonitoringRecordFormKey.currentState!.validate()) {
      controller.handleAddMonitoringRecord();
    } else {
      controller.globals.showSnackBar(
        title: 'Alert',
        message: 'Kindly provide all required information',
      );
    }
  }

  bool _validateForm() {
    return controller.addMonitoringRecordFormKey.currentState?.validate() ??
        false;
  }

  bool _validateRehabAssistants() {
    for (int i = 0; i < controller.rehabAssistants.length; i++) {
      for (int j = i + 1; j < controller.rehabAssistants.length; j++) {
        if (controller.rehabAssistants[i].rehabAssistant?.rehabName ==
            controller.rehabAssistants[j].rehabAssistant?.rehabName) {
          controller.globals.showSnackBar(
            title: 'Alert',
            message: 'Rehab assistants cannot be the same',
            duration: 5,
          );
          return false;
        }
      }
    }
    return true;
  }
}
