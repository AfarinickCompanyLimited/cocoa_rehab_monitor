import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_rehab_monitor/view/utils/pattern_validator.dart';
import 'submit_issue_controller.dart';

class SubmitIssue extends StatefulWidget {
  const SubmitIssue({Key? key}) : super(key: key);

  @override
  State<SubmitIssue> createState() => _SubmitIssueState();
}

class _SubmitIssueState extends State<SubmitIssue> {
  @override
  Widget build(BuildContext context) {
    SubmitIssueController submitIssueController =
        Get.put(SubmitIssueController());
    submitIssueController.context = context;

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    key: submitIssueController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: submitIssueController.titleTC,
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
                          textInputAction: TextInputAction.next,
                          validator: (String? value) => value!.trim().isEmpty
                              ? "Title is Required"
                              : null,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Week',
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
                          items: submitIssueController.listOfWeeks,
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
                              return "Week is required";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) =>
                              submitIssueController.selectedWeek = val!,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Month',
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
                          items: submitIssueController.listOfMonths,
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
                              return "Month is required";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) =>
                              submitIssueController.selectedMonth = val!,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Activity',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropdownSearch<Activity>(
                          popupProps: PopupProps.modalBottomSheet(
                              showSelectedItems: true,
                              showSearchBox: true,
                              title: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                  child: Text(
                                    'Select Activity',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              disabledItemFn: (Activity s) => false,
                              modalBottomSheetProps: ModalBottomSheetProps(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(AppBorderRadius.md),
                                        topRight: Radius.circular(
                                            AppBorderRadius.md))),
                              ),
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
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
                            // var response = await addInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findAllMainActivity();
                            var response = await submitIssueController
                                .globalController.database!.activityDao
                                .findAllMainActivity();

                            // .findAllActivityWithMainActivityList(
                            //     [MainActivities.InitialTreatment]);
                            return response;
                          },
                          itemAsString: (Activity d) =>
                              d.mainActivity!.toString(),
                          // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                          compareFn: (activity, filter) =>
                              activity.mainActivity == filter.mainActivity,
                          onChanged: (val) {
                            submitIssueController.activity = val!;
                            submitIssueController.subActivity = Activity();
                            submitIssueController.update();
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
                        DropdownSearch<Activity>(
                          popupProps: PopupProps.modalBottomSheet(
                              showSelectedItems: true,
                              showSearchBox: true,
                              title: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Center(
                                  child: Text(
                                    'Select Sub Activity',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              disabledItemFn: (Activity s) => false,
                              modalBottomSheetProps: ModalBottomSheetProps(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(AppBorderRadius.md),
                                        topRight: Radius.circular(
                                            AppBorderRadius.md))),
                              ),
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
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
                            var response = await submitIssueController
                                .globalController.database!.activityDao
                                .findSubActivities(submitIssueController
                                        .activity.mainActivity ??
                                    '');
                            return response;
                          },
                          itemAsString: (Activity d) =>
                              d.subActivity!.toString(),
                          // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                          compareFn: (activity, filter) =>
                              activity.subActivity == filter.subActivity,
                          onChanged: (val) {
                            submitIssueController.subActivity = val!;
                            submitIssueController.update();
                          },
                          autoValidateMode: AutovalidateMode.always,
                          validator: (item) {
                            if (item == null) {
                              return 'Sub Activity is required';
                            } else {
                              return null;
                            }
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
                              submitIssueController.farmReferenceNumberTC,
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
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          validator: FarmReferencePatternValidator.validate,
                          // (String? value) => value!.trim().isEmpty
                          //     ? "Farm reference number is required"
                          //     : null,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'RA ID',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                            controller: submitIssueController.raIDTC,
                            textCapitalization: TextCapitalization.sentences,
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
                            maxLines: null,
                            validator: RaIdPatternValidator.validate,
                            //  (String? value) => value!.trim().isEmpty
                            //     ? "RA ID is required"
                            //     : null,
                            textInputAction: TextInputAction.done),
                        const SizedBox(height: 20),
                        const Text(
                          'Message',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                            controller: submitIssueController.messageTC,
                            textCapitalization: TextCapitalization.sentences,
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
                            maxLines: null,
                            minLines: 3,
                            validator: (String? value) => value!.trim().isEmpty
                                ? "Message is required"
                                : null,
                            textInputAction: TextInputAction.done),
                        const SizedBox(
                          height: 40,
                        ),
                        CustomButton(
                          isFullWidth: true,
                          backgroundColor: AppColor.primary,
                          verticalPadding: 0.0,
                          horizontalPadding: 8.0,
                          onTap: () async {
                            if (!submitIssueController.isButtonDisabled.value) {
                              if (submitIssueController.formKey.currentState!
                                  .validate()) {
                                submitIssueController.handleSubmit();
                              }
                            }
                          },
                          child: Text(
                            'Submit',
                            style:
                                TextStyle(color: AppColor.white, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
