// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/model/activity_data_model.dart';
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
import 'package:cocoa_rehab_monitor/controller/model/rehab_assistant_model.dart';
import 'components/initial_treatment_rehab_assistant_select.dart';
import 'edit_initial_treatment_monitoring_record_controller.dart';

class EditInitialTreatmentMonitoringRecord extends StatefulWidget {
  //final String allMonitorings;
  const EditInitialTreatmentMonitoringRecord({
    Key? key,
    this.isViewMode = false,
    this.monitor,
    //required this.allMonitorings
  }) : super(key: key);

  final bool isViewMode;
  final InitialTreatmentMonitorModel? monitor;

  @override
  State<EditInitialTreatmentMonitoringRecord> createState() =>
      _EditInitialTreatmentMonitoringRecordState();
}

class _EditInitialTreatmentMonitoringRecordState
    extends State<EditInitialTreatmentMonitoringRecord> {
  EditInitialTreatmentMonitoringRecordController
  editInitialTreatmentMonitoringRecordController = Get.put(
    EditInitialTreatmentMonitoringRecordController(),
  );
  var names = [].obs;
  var areas = [].obs;
  var codes = [].obs;

  void splitCommunity() {
    // Clear existing data
    names.clear();
    areas.clear();
    codes.clear();

    // Split the community string at ',' and extract the required parts
    var communityParts = widget.monitor!.community!.split(',');
    var subActivitiesCodes =
        widget.monitor!.activity!
            .split(',')
            .where((e) => e.isNotEmpty)
            .toList();

    if (communityParts.isNotEmpty) {
      // Extract the main community text
      editInitialTreatmentMonitoringRecordController.communityTC?.text =
          communityParts[0];

      // Split the part containing names, codes, and areas
      var rawDetails =
          communityParts[2].split('-')[1]; // Extract the part after '-'
      var detailsList = rawDetails.split('%'); // Split by '%'

      for (var detail in detailsList) {
        // Remove any surrounding braces and split by '&'
        var cleanDetail = detail.replaceAll(RegExp(r'[{}]'), '').split('&');

        if (cleanDetail.length == 3) {
          names.add(cleanDetail[0].trim());
          codes.add(int.parse(cleanDetail[1].trim()));
          areas.add(double.parse(cleanDetail[2].trim()));
        }
      }

      // Populate subActivityList from communityParts[2]
      var c = communityParts[2].split("-")[0];
      var c2 =
          c
              .split(",")[0]
              .split("#")
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      // print("c2 :::::::::::: ${c2}");
      for (int i = 0; i < c2.length; i++) {
        editInitialTreatmentMonitoringRecordController.subActivityList.add(
          ActivityModel(
            code: int.tryParse(subActivitiesCodes[i]),
            mainActivity: "",
            subActivity: c2[i].trim(),
          ),
        );
      }

      // Populate rehab assistants dynamically
      for (int i = 0; i < names.length; i++) {
        editInitialTreatmentMonitoringRecordController.rehabAssistants.add(
          InitialTreatmentRehabAssistantSelect(
            index: RxInt(i + 1),
            rehabAssistant: RehabAssistantModel(
              rehabName: names[i],
              rehabCode: codes[i],
            ),
            areaHa: areas[i].toString(),
            isViewMode: widget.isViewMode,
          ),
        );
      }

      // Set `isDoneEqually` based on the number of names
      editInitialTreatmentMonitoringRecordController.isDoneEqually.value =
          names.length > 1 ? "Yes" : "No";
    }
  }

  @override
  void initState() {
    editInitialTreatmentMonitoringRecordController.monitor = widget.monitor!;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // HomeController homeController = Get.find();

    editInitialTreatmentMonitoringRecordController
        .editMonitoringRecordScreenContext = context;

    editInitialTreatmentMonitoringRecordController.monitoringDateTC =
        TextEditingController(text: widget.monitor!.completionDate);
    editInitialTreatmentMonitoringRecordController.reportingDateTC =
        TextEditingController(text: widget.monitor!.reportingDate);

    splitCommunity();

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
                            widget.isViewMode
                                ? "View activity reporting data"
                                : "Edit activity reporting data",
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
                                editInitialTreatmentMonitoringRecordController
                                    .editMonitoringRecordFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Completion Date',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                DateTimePicker(
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .monitoringDateTC,
                                  type: DateTimePickerType.date,
                                  initialDate: DateTime.tryParse(
                                    widget.monitor!.completionDate!,
                                  ),
                                  dateMask: 'yyyy-MM-dd',
                                  firstDate: DateTime(1600),
                                  lastDate: DateTime.now(),
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
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                  onChanged:
                                      (val) =>
                                          editInitialTreatmentMonitoringRecordController
                                              .monitoringDateTC
                                              ?.text = val,
                                  validator:
                                      (String? value) =>
                                          value!.trim().isEmpty
                                              ? "Monitoring date is required"
                                              : null,
                                  onSaved:
                                      (val) =>
                                          editInitialTreatmentMonitoringRecordController
                                              .monitoringDateTC
                                              ?.text = val!,
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  'Reporting Date',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                DateTimePicker(
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .reportingDateTC,
                                  type: DateTimePickerType.date,
                                  initialDate: DateTime.tryParse(
                                    widget.monitor!.reportingDate!,
                                  ),
                                  dateMask: 'yyyy-MM-dd',
                                  firstDate: DateTime(1600),
                                  lastDate: DateTime.now(),
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
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                  onChanged:
                                      (val) =>
                                          editInitialTreatmentMonitoringRecordController
                                              .reportingDateTC
                                              ?.text = val,
                                  validator:
                                      (String? value) =>
                                          value!.trim().isEmpty
                                              ? "Reporting date is required"
                                              : null,
                                  onSaved:
                                      (val) =>
                                          editInitialTreatmentMonitoringRecordController
                                              .reportingDateTC
                                              ?.text = val!,
                                ),

                                const SizedBox(height: 20),

                                // const Text('Phone Number',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(height: 5,),
                                // TextFormField(
                                //   controller: addInitialTreatmentMonitoringRecordController.phoneTC,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                //     enabledBorder: inputBorder,
                                //     focusedBorder: inputBorderFocused,
                                //     errorBorder: inputBorder,
                                //     focusedErrorBorder: inputBorderFocused,
                                //     filled: true,
                                //     fillColor: AppColor.xLightBackground,
                                //   ),
                                //   keyboardType: TextInputType.phone,
                                //   textInputAction: TextInputAction.next,
                                //   validator: (String? value) => value!.trim().isEmpty || value.trim().length < 9 || (value.trim().startsWith('0') && value.trim().length < 10)
                                //       ? "Enter a valid phone number"
                                //       : null,
                                // ),
                                // const SizedBox(height: 20),

                                // const Text(
                                //   'Farm',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // DropdownSearch<OutbreakFarmFromServer>(
                                //   popupProps: PopupProps.modalBottomSheet(
                                //       showSelectedItems: true,
                                //       showSearchBox: true,
                                //       itemBuilder: (context, item, selected) {
                                //         return ListTile(
                                //           title: Text(item.farmerName.toString(),
                                //               style: selected
                                //                   ? TextStyle(
                                //                       color: AppColor.primary)
                                //                   : const TextStyle()),
                                //           subtitle: Text(
                                //             item.outbreaksId.toString(),
                                //           ),
                                //         );
                                //       },
                                //       title: const Padding(
                                //         padding:
                                //             EdgeInsets.symmetric(vertical: 15),
                                //         child: Center(
                                //           child: Text(
                                //             'Select Farm',
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w500),
                                //           ),
                                //         ),
                                //       ),
                                //       disabledItemFn:
                                //           (OutbreakFarmFromServer s) => false,
                                //       modalBottomSheetProps:
                                //           ModalBottomSheetProps(
                                //         elevation: 6,
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.only(
                                //                 topLeft: Radius.circular(
                                //                     AppBorderRadius.md),
                                //                 topRight: Radius.circular(
                                //                     AppBorderRadius.md))),
                                //       ),
                                //       searchFieldProps: TextFieldProps(
                                //         decoration: InputDecoration(
                                //           contentPadding:
                                //               const EdgeInsets.symmetric(
                                //                   vertical: 4, horizontal: 15),
                                //           enabledBorder: inputBorder,
                                //           focusedBorder: inputBorderFocused,
                                //           errorBorder: inputBorder,
                                //           focusedErrorBorder: inputBorderFocused,
                                //           filled: true,
                                //           fillColor: AppColor.xLightBackground,
                                //         ),
                                //       )),
                                //   dropdownDecoratorProps: DropDownDecoratorProps(
                                //     dropdownSearchDecoration: InputDecoration(
                                //       contentPadding: const EdgeInsets.symmetric(
                                //           vertical: 4, horizontal: 15),
                                //       enabledBorder: inputBorder,
                                //       focusedBorder: inputBorderFocused,
                                //       errorBorder: inputBorder,
                                //       focusedErrorBorder: inputBorderFocused,
                                //       filled: true,
                                //       fillColor: AppColor.xLightBackground,
                                //     ),
                                //   ),
                                //   asyncItems: (String filter) async {
                                //     var response =
                                //         await addInitialTreatmentMonitoringRecordController
                                //             .globalController
                                //             .database!
                                //             .outbreakFarmFromServerDao
                                //             .findAllOutbreakFarmFromServer();
                                //     return response;
                                //   },
                                //   itemAsString: (OutbreakFarmFromServer d) =>
                                //       d.farmId!.toString(),
                                //   filterFn: (OutbreakFarmFromServer d, filter) =>
                                //       d.farmerName
                                //           .toString()
                                //           .toLowerCase()
                                //           .contains(filter.toLowerCase()),
                                //   compareFn: (farm, filter) =>
                                //       farm.farmId == filter.farmId,
                                //   onChanged: (val) {
                                //     addInitialTreatmentMonitoringRecordController
                                //         .farm = val!;
                                //     addInitialTreatmentMonitoringRecordController
                                //         .farmSizeTC
                                //         ?.text = val.farmArea.toString();
                                //   },
                                //   autoValidateMode: AutovalidateMode.always,
                                //   validator: (item) {
                                //     if (item == null) {
                                //       return 'Farm is required';
                                //     } else {
                                //       return null;
                                //     }
                                //   },
                                // ),
                                // const SizedBox(height: 20),
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
                                    farmId: widget.monitor!.farmRefNumber!,
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
                                    // var response = await addInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findAllMainActivity();
                                    var response =
                                        await editInitialTreatmentMonitoringRecordController
                                            .jobOrderDb
                                            .getAllFarms();
                                    print("THE RESPONSE ::::::::::: $response");
                                    return response;
                                  },
                                  itemAsString:
                                      (JobOrderFarmModel d) =>
                                          d.farmId.toString(),
                                  // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                  compareFn:
                                      (JobOrderFarmModel, filter) =>
                                          JobOrderFarmModel == filter,
                                  onChanged: (val) {
                                    editInitialTreatmentMonitoringRecordController
                                        .farmReferenceNumberTC!
                                        .text = val!.farmId.toString();
                                    //addInitialTreatmentMonitoringRecordController.farmerNameTC!.text = val.farmername.toString();
                                    editInitialTreatmentMonitoringRecordController
                                        .farmSizeTC!
                                        .text = val.farmSize.toString();
                                    editInitialTreatmentMonitoringRecordController
                                        .communityTC!
                                        .text = val.location.toString();

                                    if (editInitialTreatmentMonitoringRecordController
                                            .isDoneEqually
                                            .value
                                            .isNotEmpty &&
                                        editInitialTreatmentMonitoringRecordController
                                            .numberInGroupTC!
                                            .text
                                            .isNotEmpty) {
                                      double area =
                                          double.tryParse(
                                            editInitialTreatmentMonitoringRecordController
                                                .farmSizeTC!
                                                .text,
                                          )! /
                                          int.tryParse(
                                            editInitialTreatmentMonitoringRecordController
                                                .numberInGroupTC!
                                                .text,
                                          )!;
                                      editInitialTreatmentMonitoringRecordController
                                          .rehabAssistants
                                          .forEach((ra) {
                                            ra.areaCovered!.text =
                                                area.toString();
                                          });
                                    }
                                    // print(farmSizeTC
                                    //     "Activity ------------- ${addContractorCertificateRecordController.activity?.mainActivity}");
                                    //
                                    // if (addContractorCertificateRecordController
                                    //         .activity?.mainActivity ==
                                    //     MainActivities.Maintenance) {
                                    //   // addContractorCertificateRecordController
                                    //   //     .activityCheck.value = true;
                                    // }

                                    // addContractorCertificateRecordController
                                    //     .subActivity = Activity() as List<Activity>;
                                    editInitialTreatmentMonitoringRecordController
                                        .update();
                                    // print(
                                    //     ' SHOWWWW ${addContractorCertificateRecordController.activity?.code}');
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
                                  'Community',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  ///initialValue: widget.monitor!.community!.split(",")[0],
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .communityTC,
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
                                              ? "Community size is required"
                                              : null,
                                ),
                                const SizedBox(height: 20),

                                const Text(
                                  'Farm Size (in hectares)',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  ///initialValue: widget.monitor!.farmSizeHa!.toString(),
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
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
                                      widget.monitor!.community!.split(",")[1],
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
                                        await editInitialTreatmentMonitoringRecordController
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
                                  // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                  compareFn:
                                      (activity, filter) => activity == filter,
                                  onChanged: (val) {
                                    editInitialTreatmentMonitoringRecordController
                                        .activity = val!;

                                    editInitialTreatmentMonitoringRecordController
                                        .toggleClearIsActivitySelected();

                                    Timer(
                                      const Duration(milliseconds: 1000),
                                      () =>
                                          editInitialTreatmentMonitoringRecordController
                                              .toggleIsActivitySelected(),
                                    );

                                    editInitialTreatmentMonitoringRecordController
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
                                const SizedBox(height: 20),
                                Obx(
                                  () =>
                                      editInitialTreatmentMonitoringRecordController
                                              .isActivitySelected
                                              .value
                                          ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
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
                                                    editInitialTreatmentMonitoringRecordController
                                                        .subActivityList,
                                                asyncItems: (
                                                  String filter,
                                                ) async {
                                                  var response =
                                                      await editInitialTreatmentMonitoringRecordController
                                                          .db
                                                          .getSubActivityByMainActivity(
                                                            editInitialTreatmentMonitoringRecordController
                                                                .activity!,
                                                          );

                                                  return response;
                                                },
                                                itemAsString:
                                                    (ActivityModel d) =>
                                                        d.subActivity
                                                            .toString(),
                                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                                compareFn:
                                                    (activity, filter) =>
                                                        activity.subActivity ==
                                                        filter.subActivity,
                                                onChanged: (vals) {
                                                  editInitialTreatmentMonitoringRecordController
                                                      .subActivityList = vals;

                                                  editInitialTreatmentMonitoringRecordController
                                                      .update();
                                                },
                                                autoValidateMode:
                                                    AutovalidateMode.always,
                                                validator: (items) {
                                                  if (items == null ||
                                                      items.isEmpty) {
                                                    return 'Sub activity is required';
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
                                      borderRadius: BorderRadius.circular(
                                        AppBorderRadius.sm,
                                      ),
                                    ),
                                  ),
                                  items:
                                      editInitialTreatmentMonitoringRecordController
                                          .yesNoItems,
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
                                  selectedItem: widget.monitor!.groupWork,
                                  autoValidateMode: AutovalidateMode.always,
                                  validator: (item) {
                                    if (item == null) {
                                      return "field is required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (val) {
                                    editInitialTreatmentMonitoringRecordController
                                        .isCompletedByGroup
                                        .value = val!;
                                    editInitialTreatmentMonitoringRecordController
                                        .areaCoveredRx
                                        .value = '';
                                    editInitialTreatmentMonitoringRecordController
                                        .clearRehabAssistantsToDefault();
                                    editInitialTreatmentMonitoringRecordController
                                        .numberInGroupTC
                                        ?.clear();

                                    editInitialTreatmentMonitoringRecordController
                                        .update();
                                  },
                                ),

                                GetBuilder(
                                  init:
                                      editInitialTreatmentMonitoringRecordController,
                                  builder: (ctx) {
                                    if (editInitialTreatmentMonitoringRecordController
                                            .isCompletedByGroup
                                            .value ==
                                        YesNo.yes) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Number of People In Group',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          TextFormField(
                                            ///initialValue: widget.monitor!.numberOfPeopleInGroup.toString(),
                                            controller:
                                                editInitialTreatmentMonitoringRecordController
                                                    .numberInGroupTC,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 15,
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            validator:
                                                (String? value) =>
                                                    value!.trim().isEmpty
                                                        ? "Number of People In Group is required"
                                                        : null,
                                            onChanged: (value) {
                                              editInitialTreatmentMonitoringRecordController
                                                  .clearRehabAssistantsToDefault();

                                              editInitialTreatmentMonitoringRecordController
                                                  .updateAreaCovered();

                                              editInitialTreatmentMonitoringRecordController
                                                  .update();
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                          if (editInitialTreatmentMonitoringRecordController
                                              .numberInGroupTC!
                                              .text
                                              .isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20),
                                                const Text(
                                                  'Was The Activity Done Equally',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),

                                                DropdownSearch<String>(
                                                  popupProps: PopupProps.menu(
                                                    showSelectedItems: false,
                                                    disabledItemFn:
                                                        (String s) => false,
                                                    fit: FlexFit.loose,
                                                    menuProps: MenuProps(
                                                      elevation: 6,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppBorderRadius.sm,
                                                          ),
                                                    ),
                                                  ),
                                                  selectedItem:
                                                      editInitialTreatmentMonitoringRecordController
                                                          .isDoneEqually
                                                          .value,
                                                  items:
                                                      editInitialTreatmentMonitoringRecordController
                                                          .yesNoItems,
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 4,
                                                                horizontal: 15,
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
                                                    if (editInitialTreatmentMonitoringRecordController
                                                        .farmSizeTC!
                                                        .text
                                                        .isEmpty) {
                                                      editInitialTreatmentMonitoringRecordController
                                                          .globals
                                                          .showSnackBar(
                                                            title:
                                                                "Required action",
                                                            message:
                                                                "Please select farm to proceed",
                                                          );
                                                      editInitialTreatmentMonitoringRecordController
                                                          .numberInGroupTC!
                                                          .text = "";
                                                      return;
                                                    } else {
                                                      editInitialTreatmentMonitoringRecordController
                                                          .isDoneEqually
                                                          .value = val!;
                                                    }

                                                    if (editInitialTreatmentMonitoringRecordController
                                                        .numberInGroupTC!
                                                        .text
                                                        .isEmpty) {
                                                      editInitialTreatmentMonitoringRecordController
                                                          .globals
                                                          .showSnackBar(
                                                            title:
                                                                "Required action",
                                                            message:
                                                                "Please input the number of people in the group to proceed",
                                                          );
                                                      return;
                                                    }

                                                    if (editInitialTreatmentMonitoringRecordController
                                                            .isDoneEqually ==
                                                        YesNo.yes) {
                                                      double area =
                                                          double.tryParse(
                                                            editInitialTreatmentMonitoringRecordController
                                                                .farmSizeTC!
                                                                .text,
                                                          )! /
                                                          int.tryParse(
                                                            editInitialTreatmentMonitoringRecordController
                                                                .numberInGroupTC!
                                                                .text,
                                                          )!;
                                                      editInitialTreatmentMonitoringRecordController
                                                          .rehabAssistants
                                                          .forEach((ra) {
                                                            ra
                                                                .areaCovered!
                                                                .text = area
                                                                    .toString();
                                                          });
                                                    }
                                                    editInitialTreatmentMonitoringRecordController
                                                        .update();
                                                  },
                                                ),
                                              ],
                                            ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),

                                GetBuilder(
                                  init:
                                      editInitialTreatmentMonitoringRecordController,
                                  builder: (ctx) {
                                    bool groupHasNumber =
                                        int.tryParse(
                                          editInitialTreatmentMonitoringRecordController
                                              .numberInGroupTC!
                                              .text,
                                        ) !=
                                        null;
                                    if (groupHasNumber) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            'Select rehab assistants and their respective area covered (if applicable)',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          Obx(() {
                                            final maxItems =
                                                int.tryParse(
                                                  editInitialTreatmentMonitoringRecordController
                                                      .numberInGroupTC!
                                                      .text,
                                                ) ??
                                                1;
                                            final rehabAssistants =
                                                editInitialTreatmentMonitoringRecordController
                                                    .rehabAssistants;

                                            if (maxItems !=
                                                rehabAssistants.length) {
                                              editInitialTreatmentMonitoringRecordController
                                                  .clearRehabAssistantsToDefault();
                                              // You can also create new instances if needed
                                              editInitialTreatmentMonitoringRecordController
                                                      .rehabAssistants =
                                                  List.generate(
                                                    maxItems,
                                                    (
                                                      i,
                                                    ) => InitialTreatmentRehabAssistantSelect(
                                                      index: RxInt(i + 1),
                                                      rehabAssistant:
                                                          RehabAssistantModel(
                                                            rehabName: names[i],
                                                            rehabCode:
                                                                int.tryParse(
                                                                  codes[i]
                                                                      .toString(),
                                                                ),
                                                          ),
                                                      areaHa:
                                                          areas[i].toString(),
                                                      isViewMode:
                                                          widget.isViewMode,
                                                    ),
                                                  ).obs;
                                            }

                                            final generatedWidgets =
                                                List<Widget>.generate(
                                                  min(
                                                    maxItems,
                                                    rehabAssistants.length,
                                                  ),
                                                  (i) {
                                                    return rehabAssistants[i];
                                                  },
                                                );

                                            return Column(
                                              children: generatedWidgets,
                                            );
                                          }),
                                          const SizedBox(height: 20),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),

                                GetBuilder(
                                  init:
                                      editInitialTreatmentMonitoringRecordController,
                                  builder: (ctx) {
                                    if (editInitialTreatmentMonitoringRecordController
                                            .isCompletedByGroup
                                            .value ==
                                        YesNo.no) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            'Select rehab assistants and their respective area covered',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          Obx(
                                            () =>
                                                editInitialTreatmentMonitoringRecordController
                                                    .rehabAssistants
                                                    .first,
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),

                                SizedBox(height: 20),
                                const Text(
                                  'General Remarks',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .remarksTC,
                                  textCapitalization:
                                      TextCapitalization.sentences,
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
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                  maxLines: null,
                                  textInputAction: TextInputAction.done,
                                ),

                                const SizedBox(height: 20),

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
                                            // if (!addInitialTreatmentMonitoringRecordController
                                            //     .isSaveButtonDisabled.value) {
                                            if (editInitialTreatmentMonitoringRecordController
                                                .editMonitoringRecordFormKey
                                                .currentState!
                                                .validate()) {
                                              editInitialTreatmentMonitoringRecordController
                                                  .handleSaveOfflineMonitoringRecord();
                                            } else {
                                              editInitialTreatmentMonitoringRecordController
                                                  .globals
                                                  .showSnackBar(
                                                    title: 'Alert',
                                                    message:
                                                        'Kindly provide all required information',
                                                  );
                                            }
                                            // }
                                          },
                                          child:
                                          //  Obx(
                                          //   () =>
                                          Text(
                                            // addInitialTreatmentMonitoringRecordController
                                            //         .isSaveButtonDisabled.value
                                            //     ? 'Please wait ...'
                                            //     :
                                            'Save',
                                            style: TextStyle(
                                              color: AppColor.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          // ),
                                        ),
                                      ),

                                      Expanded(
                                        child: CustomButton(
                                          isFullWidth: true,
                                          backgroundColor: AppColor.primary,
                                          verticalPadding: 0.0,
                                          horizontalPadding: 8.0,
                                          onTap: () async {
                                            if (editInitialTreatmentMonitoringRecordController
                                                .editMonitoringRecordFormKey
                                                .currentState!
                                                .validate()) {
                                              editInitialTreatmentMonitoringRecordController
                                                  .handleAddMonitoringRecord();
                                            } else {
                                              editInitialTreatmentMonitoringRecordController
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
                                      // ),
                                    ],
                                  ),

                                const SizedBox(height: 20),
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
