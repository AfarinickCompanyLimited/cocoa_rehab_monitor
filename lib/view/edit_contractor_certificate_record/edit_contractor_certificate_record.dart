import 'dart:async';

import 'package:cocoa_rehab_monitor/controller/model/contractor_certificate_of_workdone_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/contractor.dart';
import 'package:cocoa_rehab_monitor/controller/model/activity_model.dart';
import 'package:cocoa_rehab_monitor/controller/model/job_order_farms_model.dart';
import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'edit_contractor_certificate_record_controller.dart';

class EditContractorCertificateRecord extends StatefulWidget {
  const EditContractorCertificateRecord({
    super.key,
    required this.contractorCertificate,
    required this.isViewMode,
  });

  final ContractorCertificateModel contractorCertificate;
  final bool isViewMode;

  @override
  State<EditContractorCertificateRecord> createState() =>
      _EditContractorCertificateRecordState();
}

class _EditContractorCertificateRecordState
    extends State<EditContractorCertificateRecord> {
  EditContractorCertificateRecordController
  editContractorCertificateRecordController = Get.put(
    EditContractorCertificateRecordController(),
  );

  @override
  void initState() {
    super.initState();
    editContractorCertificateRecordController.contractorCertificate =
        widget.contractorCertificate;

    // Initialize subActivities in initState
    final communityParts = widget.contractorCertificate.community!.split('-');
    if (communityParts.length > 1) {
      editContractorCertificateRecordController.subActivity =
          communityParts[1]
              .split(',')
              .map(
                (activity) => ActivityModel(
                  code: 0,
                  subActivity: activity.trim(),
                  mainActivity: "",
                ),
              )
              .toList();
    }

    editContractorCertificateRecordController.assignValues();
  }

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    int startingYear = 2022;
    List<int> yearList = List.generate((currentYear - startingYear) + 1, (
      index,
    ) {
      return startingYear + index;
    });

    editContractorCertificateRecordController
        .editContractorCertificateRecordScreenContext = context;

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
                        color: AppColor.lightText.withOpacity(0.5),
                      ),
                    ),
                  ),
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
                            'Edit New WD By Contractor Certificate',
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
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: AppPadding.horizontal,
                      right: AppPadding.horizontal,
                      bottom: AppPadding.vertical,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        AbsorbPointer(
                          absorbing: widget.isViewMode,
                          child: Form(
                            key:
                                editContractorCertificateRecordController
                                    .editContractorCertificateRecordFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Current Year',
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
                                      borderRadius: BorderRadius.circular(
                                        AppBorderRadius.sm,
                                      ),
                                    ),
                                  ),
                                  items:
                                      yearList
                                          .map((year) => year.toString())
                                          .toList(),
                                  selectedItem:
                                      widget.contractorCertificate.currentYear,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 15,
                                                  ),
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
                                  autoValidateMode: AutovalidateMode.always,
                                  validator: (item) {
                                    if (item == null) {
                                      return "Current year is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    editContractorCertificateRecordController
                                        .selectedYear
                                        .value = val!;
                                    editContractorCertificateRecordController
                                        .update();
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Current Month',
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
                                      borderRadius: BorderRadius.circular(
                                        AppBorderRadius.sm,
                                      ),
                                    ),
                                  ),
                                  items:
                                      editContractorCertificateRecordController
                                          .listOfMonths,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 15,
                                                  ),
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
                                  selectedItem:
                                      widget.contractorCertificate.currentMonth,
                                  autoValidateMode: AutovalidateMode.always,
                                  validator: (item) {
                                    if (item == null) {
                                      return "Current month is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    editContractorCertificateRecordController
                                        .selectedMonth
                                        .value = val!;
                                    editContractorCertificateRecordController
                                        .update();
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Current Week',
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
                                      borderRadius: BorderRadius.circular(
                                        AppBorderRadius.sm,
                                      ),
                                    ),
                                  ),
                                  items:
                                      editContractorCertificateRecordController
                                          .listOfWeeks,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 15,
                                                  ),
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
                                  selectedItem:
                                      widget.contractorCertificate.currrentWeek
                                          .toString(),
                                  autoValidateMode: AutovalidateMode.always,
                                  validator: (item) {
                                    if (item == null) {
                                      return "Current week is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    editContractorCertificateRecordController
                                        .selectedWeek
                                        .value = val!;
                                    editContractorCertificateRecordController
                                        .update();
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Sector',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  readOnly: true,
                                  controller:
                                      editContractorCertificateRecordController
                                          .sectorTC,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.lightText,
                                  ),
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator:
                                      (String? value) =>
                                          value!.trim().isEmpty
                                              ? "Community is required"
                                              : null,
                                ),

                                const SizedBox(height: 20),
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
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Select farm reference number',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    disabledItemFn:
                                        (JobOrderFarmModel s) => false,
                                    modalBottomSheetProps:
                                        ModalBottomSheetProps(
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                AppBorderRadius.md,
                                              ),
                                              topRight: Radius.circular(
                                                AppBorderRadius.md,
                                              ),
                                            ),
                                          ),
                                        ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 15,
                                            ),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                    ),
                                  ),
                                  selectedItem: JobOrderFarmModel(
                                    farmId:
                                        widget
                                            .contractorCertificate
                                            .farmRefNumber!,
                                  ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 15,
                                                  ),
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
                                  asyncItems: (String filter) async {
                                    var response =
                                        await editContractorCertificateRecordController
                                            .jobDb
                                            .getAllFarms();
                                    return response;
                                  },
                                  itemAsString:
                                      (JobOrderFarmModel d) =>
                                          d.farmId.toString(),
                                  compareFn:
                                      (activity, filter) => activity == filter,
                                  onChanged: (val) {
                                    editContractorCertificateRecordController
                                        .farmReferenceNumberTC
                                        .text = val!.farmId.toString();
                                    editContractorCertificateRecordController
                                        .farmerNameTC
                                        .text = val.farmerName.toString();
                                    editContractorCertificateRecordController
                                        .communityNameTC
                                        .text = val.location.toString();
                                    editContractorCertificateRecordController
                                        .update();
                                  },
                                  autoValidateMode: AutovalidateMode.always,
                                  validator: (item) {
                                    if (item == null) {
                                      return 'Farm reference is required';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                                const SizedBox(height: 20),
                                const Text(
                                  'Farmer name',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller:
                                      editContractorCertificateRecordController
                                          .farmerNameTC,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.lightText,
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator:
                                      (String? value) =>
                                          value!.trim().isEmpty
                                              ? "Farmer name is required"
                                              : null,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Farm Size (in hectares)',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller:
                                      editContractorCertificateRecordController
                                          .farmSizeTC,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.lightText,
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator:
                                      (String? value) =>
                                          value!.trim().isEmpty
                                              ? "Farm size is required"
                                              : null,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Community',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  readOnly: true,
                                  controller:
                                      editContractorCertificateRecordController
                                          .communityNameTC,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.lightText,
                                  ),
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator:
                                      (String? value) =>
                                          value!.trim().isEmpty
                                              ? "Community is required"
                                              : null,
                                ),
                                const SizedBox(height: 20),

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
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Select Activity',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
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
                                                AppBorderRadius.md,
                                              ),
                                              topRight: Radius.circular(
                                                AppBorderRadius.md,
                                              ),
                                            ),
                                          ),
                                        ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 15,
                                            ),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                    ),
                                  ),
                                  selectedItem:
                                      ActivityModel(
                                        code: 0,
                                        mainActivity:
                                            widget
                                                .contractorCertificate
                                                .community!
                                                .split('-')[2],
                                        subActivity: "",
                                      ).mainActivity,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 15,
                                                  ),
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
                                  asyncItems: (String filter) async {
                                    List<ActivityModel> activities = [];
                                    List<String> act = [];

                                    activities =
                                        await editContractorCertificateRecordController
                                            .db
                                            .getAllActivityWithMainActivityList(
                                              [
                                                MainActivities.Maintenance,
                                                MainActivities.Establishment,
                                                MainActivities.InitialTreatment,
                                              ],
                                            );

                                    activities.forEach((activity) {
                                      if (!act.contains(
                                        activity.mainActivity,
                                      )) {
                                        act.add(activity.mainActivity!);
                                      }
                                    });

                                    return act;
                                  },
                                  itemAsString: (String d) => d,
                                  compareFn:
                                      (activity, filter) => activity == filter,
                                  onChanged: (val) {
                                    editContractorCertificateRecordController
                                        .activity = val!;
                                    editContractorCertificateRecordController
                                        .toggleClearIsActivitySelected();

                                    editContractorCertificateRecordController
                                        .subActivity
                                        .clear();

                                    Timer(
                                      const Duration(milliseconds: 1000),
                                      () =>
                                          editContractorCertificateRecordController
                                              .toggleIsActivitySelected(),
                                    );

                                    editContractorCertificateRecordController
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
                                Obx(
                                  () =>
                                      editContractorCertificateRecordController
                                              .isActivitySelected
                                              .value
                                          ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              const Text(
                                                'Sub activity',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              DropdownSearch<
                                                ActivityModel
                                              >.multiSelection(
                                                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                                                  showSelectedItems: true,
                                                  showSearchBox: true,
                                                  title: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 15,
                                                        ),
                                                    child: Center(
                                                      child: Text(
                                                        'Select sub activity',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  disabledItemFn:
                                                      (ActivityModel s) =>
                                                          false,
                                                  modalBottomSheetProps:
                                                      ModalBottomSheetProps(
                                                        elevation: 6,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  AppBorderRadius
                                                                      .md,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  AppBorderRadius
                                                                      .md,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                  searchFieldProps: TextFieldProps(
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 15,
                                                          ),
                                                      enabledBorder:
                                                          inputBorder,
                                                      focusedBorder:
                                                          inputBorderFocused,
                                                      errorBorder: inputBorder,
                                                      focusedErrorBorder:
                                                          inputBorderFocused,
                                                      filled: true,
                                                      fillColor:
                                                          AppColor
                                                              .xLightBackground,
                                                    ),
                                                  ),
                                                ),
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      15,
                                                                ),
                                                            enabledBorder:
                                                                inputBorder,
                                                            focusedBorder:
                                                                inputBorderFocused,
                                                            errorBorder:
                                                                inputBorder,
                                                            focusedErrorBorder:
                                                                inputBorderFocused,
                                                            filled: true,
                                                            fillColor:
                                                                AppColor
                                                                    .xLightBackground,
                                                          ),
                                                    ),
                                                selectedItems:
                                                    editContractorCertificateRecordController
                                                        .subActivity,
                                                asyncItems: (
                                                  String filter,
                                                ) async {
                                                  var response =
                                                      await editContractorCertificateRecordController
                                                          .db
                                                          .getAllData();
                                                  return response;
                                                },
                                                itemAsString:
                                                    (ActivityModel d) =>
                                                        d.subActivity
                                                            .toString(),
                                                compareFn:
                                                    (activity, filter) =>
                                                        activity.subActivity ==
                                                        filter.subActivity,
                                                onChanged: (vals) {
                                                  editContractorCertificateRecordController
                                                      .subActivity = vals;
                                                  editContractorCertificateRecordController
                                                      .update();
                                                },
                                                autoValidateMode:
                                                    AutovalidateMode.always,
                                                validator: (items) {
                                                  if (items == null ||
                                                      items.isEmpty) {
                                                    return 'Sub activities are required';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ],
                                          )
                                          : SizedBox.shrink(),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Rounds of weeding',
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
                                      borderRadius: BorderRadius.circular(
                                        AppBorderRadius.sm,
                                      ),
                                    ),
                                  ),
                                  selectedItem:
                                      widget.contractorCertificate.weedingRounds
                                          .toString(),
                                  items:
                                      editContractorCertificateRecordController
                                          .listOfRoundsOfWeeding,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 15,
                                                  ),
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
                                  autoValidateMode: AutovalidateMode.always,
                                  onChanged: (val) {
                                    editContractorCertificateRecordController
                                        .roundsOfWeeding = val!;
                                    editContractorCertificateRecordController
                                        .update();
                                  },
                                ),
                                const SizedBox(height: 20),

                                const Text(
                                  'Contractor Name',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                DropdownSearch<Contractor>(
                                  popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    itemBuilder: (context, item, selected) {
                                      return ListTile(
                                        title: Text(
                                          item.contractorName.toString(),
                                          style:
                                              selected
                                                  ? TextStyle(
                                                    color: AppColor.primary,
                                                  )
                                                  : const TextStyle(),
                                        ),
                                      );
                                    },
                                    title: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Select contractor',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
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
                                                AppBorderRadius.md,
                                              ),
                                              topRight: Radius.circular(
                                                AppBorderRadius.md,
                                              ),
                                            ),
                                          ),
                                        ),
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 15,
                                            ),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                    ),
                                  ),
                                  selectedItem: Contractor(
                                    contractorName:
                                        widget.contractorCertificate.community!
                                            .split('-')[3],
                                  ),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 15,
                                                  ),
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
                                  asyncItems: (String filter) async {
                                    var response =
                                        await editContractorCertificateRecordController
                                            .globalController
                                            .database!
                                            .contractorDao
                                            .findAllContractors();
                                    return response;
                                  },
                                  itemAsString:
                                      (Contractor d) => d.contractorName ?? '',
                                  compareFn:
                                      (d, filter) =>
                                          d.contractorName ==
                                          filter.contractorName,
                                  onChanged: (val) {
                                    editContractorCertificateRecordController
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
                                const SizedBox(height: 40),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        isFullWidth: true,
                                        backgroundColor: AppColor.black,
                                        verticalPadding: 0.0,
                                        horizontalPadding: 8.0,
                                        onTap: () async {
                                          if (editContractorCertificateRecordController
                                              .editContractorCertificateRecordFormKey
                                              .currentState!
                                              .validate()) {
                                            editContractorCertificateRecordController
                                                .handleSaveOfflineMonitoringRecord();
                                          } else {
                                            editContractorCertificateRecordController
                                                .globals
                                                .showSnackBar(
                                                  title: 'Alert',
                                                  message:
                                                      'Kindly provide all required information',
                                                );
                                          }
                                        },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 14,
                                          ),
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
                                        onTap: () async {
                                          if (editContractorCertificateRecordController
                                              .editContractorCertificateRecordFormKey
                                              .currentState!
                                              .validate()) {
                                            editContractorCertificateRecordController
                                                .handleAddMonitoringRecord();
                                          } else {
                                            editContractorCertificateRecordController
                                                .globals
                                                .showSnackBar(
                                                  title: 'Alert',
                                                  message:
                                                      'Kindly provide all required information',
                                                );
                                          }
                                        },
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ],
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
}
