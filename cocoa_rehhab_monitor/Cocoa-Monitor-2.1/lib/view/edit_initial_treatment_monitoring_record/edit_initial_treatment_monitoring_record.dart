// ignore_for_file: avoid_print

import 'dart:math';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/model/activity_data_model.dart';
import 'package:cocoa_monitor/controller/model/job_order_farms_model.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/model/activity_model.dart';
import '../../controller/model/rehab_assistant_model.dart';
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
      editInitialTreatmentMonitoringRecordController =
      Get.put(EditInitialTreatmentMonitoringRecordController());
  var names = [].obs;
  var areas = [].obs;
  var codes = [].obs;

  void splitCommunity() {
    //print("DATATATATTATTATA=====${widget.monitor!.toJsonOnline()}");
    // Clear existing data
    names.clear();
    areas.clear();
    codes.clear();

    // Split the community string at ',' and extract the required parts
    var communityParts = widget.monitor!.community!.split(',');
    var subActivitiesCodes = widget.monitor!.activity!
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
      var c2 = c
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
              subActivity: c2[i].trim()),
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

      // Print debug information
      // print("Names :::::::::::: $names");
      // print("Codes :::::::::::: $codes");
      // print("Areas :::::::::::: $areas");
      // print(
      //     "COMMUNITY TEXT :::::::::::: ${editInitialTreatmentMonitoringRecordController.communityTC?.text}");
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
                          child: Text(
                              widget.isViewMode
                                  ? "View activity reporting data"
                                  : "Edit activity reporting data",
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
                        AbsorbPointer(
                          absorbing: widget.isViewMode,
                          child: Form(
                            key: editInitialTreatmentMonitoringRecordController
                                .editMonitoringRecordFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Completion Date',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DateTimePicker(
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .monitoringDateTC,
                                  type: DateTimePickerType.date,
                                  initialDate: DateTime.tryParse(
                                      widget.monitor!.completionDate!),
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
                                      editInitialTreatmentMonitoringRecordController
                                          .monitoringDateTC?.text = val,
                                  validator: (String? value) =>
                                      value!.trim().isEmpty
                                          ? "Monitoring date is required"
                                          : null,
                                  onSaved: (val) =>
                                      editInitialTreatmentMonitoringRecordController
                                          .monitoringDateTC?.text = val!,
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  'Reporting Date',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DateTimePicker(
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .reportingDateTC,
                                  type: DateTimePickerType.date,
                                  initialDate: DateTime.tryParse(
                                      widget.monitor!.reportingDate!),
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
                                      editInitialTreatmentMonitoringRecordController
                                          .reportingDateTC?.text = val,
                                  validator: (String? value) =>
                                      value!.trim().isEmpty
                                          ? "Reporting date is required"
                                          : null,
                                  onSaved: (val) =>
                                      editInitialTreatmentMonitoringRecordController
                                          .reportingDateTC?.text = val!,
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
                                const SizedBox(
                                  height: 5,
                                ),
                                DropdownSearch<JobOrderFarmModel>(
                                  popupProps: PopupProps.modalBottomSheet(
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                      title: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Center(
                                          child: Text(
                                            'Select farm reference number',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      disabledItemFn: (JobOrderFarmModel s) =>
                                          false,
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
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                      )),
                                  selectedItem: JobOrderFarmModel(
                                      farmId: widget.monitor!.farmRefNumber!),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
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
                                  itemAsString: (JobOrderFarmModel d) =>
                                      d.farmId.toString(),
                                  // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                  compareFn: (activity, filter) =>
                                      activity == filter,
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
                                            .isDoneEqually.value.isNotEmpty &&
                                        editInitialTreatmentMonitoringRecordController
                                            .numberInGroupTC!.text.isNotEmpty) {
                                      double area = double.tryParse(
                                              editInitialTreatmentMonitoringRecordController
                                                  .farmSizeTC!.text)! /
                                          int.tryParse(
                                              editInitialTreatmentMonitoringRecordController
                                                  .numberInGroupTC!.text)!;
                                      editInitialTreatmentMonitoringRecordController
                                          .rehabAssistants
                                          .forEach((ra) {
                                        ra.areaCovered!.text = area.toString();
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
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  ///initialValue: widget.monitor!.community!.split(",")[0],
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .communityTC,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.lightText,
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (String? value) =>
                                      value!.trim().isEmpty
                                          ? "Community size is required"
                                          : null,
                                ),
                                const SizedBox(height: 20),

                                const Text(
                                  'Farm Size (in hectares)',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  ///initialValue: widget.monitor!.farmSizeHa!.toString(),
                                  controller:
                                      editInitialTreatmentMonitoringRecordController
                                          .farmSizeTC,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.lightText,
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode: AutovalidateMode.always,
                                  validator: (String? value) =>
                                      value!.trim().isEmpty
                                          ? "Farm size is required"
                                          : null,
                                ),

                                // const Text(
                                //   'Area Covered (in hectares)',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //   controller:
                                //       addInitialTreatmentMonitoringRecordController
                                //           .areaCoveredTC,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         vertical: 15, horizontal: 15),
                                //     enabledBorder: inputBorder,
                                //     focusedBorder: inputBorderFocused,
                                //     errorBorder: inputBorder,
                                //     focusedErrorBorder: inputBorderFocused,
                                //     filled: true,
                                //     fillColor: AppColor.xLightBackground,
                                //   ),
                                //   keyboardType: TextInputType.number,
                                //   textInputAction: TextInputAction.next,
                                //   autovalidateMode: AutovalidateMode.always,
                                //   onChanged: (value) {
                                //     // addInitialTreatmentMonitoringRecordController
                                //     //     .areaCoveredTC?.text = value;
                                //     addInitialTreatmentMonitoringRecordController
                                //         .numberInGroupTC
                                //         ?.clear();
                                //     addInitialTreatmentMonitoringRecordController
                                //         .clearRehabAssistantsToDefault();
                                //     addInitialTreatmentMonitoringRecordController
                                //         .updateAreaCovered();
                                //     addInitialTreatmentMonitoringRecordController
                                //         .update();
                                //   },
                                //   validator: (String? value) =>
                                //       value!.trim().isEmpty
                                //           ? "Area covered is required"
                                //           : null,
                                // ),
                                // const SizedBox(height: 20),

                                // const Text(
                                //   'Farm Location',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //   controller:
                                //       addInitialTreatmentMonitoringRecordController
                                //           .farmLocationTC,
                                //   readOnly: true,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         vertical: 15, horizontal: 15),
                                //     enabledBorder: inputBorder,
                                //     focusedBorder: inputBorderFocused,
                                //     errorBorder: inputBorder,
                                //     focusedErrorBorder: inputBorderFocused,
                                //     filled: true,
                                //     fillColor: AppColor.xLightBackground,
                                //   ),
                                //   keyboardType: TextInputType.number,
                                //   textInputAction: TextInputAction.next,
                                //   validator: (String? value) =>
                                //       value!.trim().isEmpty
                                //           ? "Farm location is required"
                                //           : null,
                                // ),

                                // const SizedBox(height: 20),

                                // const Text(
                                //   'Number of Cocoa Seedlings Alive ',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //     controller:
                                //         addInitialTreatmentMonitoringRecordController
                                //             .cocoaSeedlingsAliveTC,
                                //     decoration: InputDecoration(
                                //       contentPadding: const EdgeInsets.symmetric(
                                //           vertical: 15, horizontal: 15),
                                //       enabledBorder: inputBorder,
                                //       focusedBorder: inputBorderFocused,
                                //       errorBorder: inputBorder,
                                //       focusedErrorBorder: inputBorderFocused,
                                //       filled: true,
                                //       fillColor: AppColor.xLightBackground,
                                //     ),
                                //     keyboardType: TextInputType.number,
                                //     inputFormatters: [
                                //       FilteringTextInputFormatter.digitsOnly
                                //     ],
                                //     textInputAction: TextInputAction.next,
                                //     autovalidateMode: AutovalidateMode.always,
                                //     validator: (String? value) {
                                //       if (value!.isEmpty) {
                                //         return "Number of cocoa seedlings alive is required";
                                //       }
                                //       int? intValue = int.tryParse(value);
                                //       if (intValue == null) {
                                //         return "$value is not a valid number";
                                //       }
                                //       return null;
                                //     }),
                                //
                                // const SizedBox(height: 20),
                                //
                                // const Text(
                                //   'Number of Plantain Seedlings Alive ',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //     controller:
                                //         addInitialTreatmentMonitoringRecordController
                                //             .plantainSeedlingsAliveTC,
                                //     decoration: InputDecoration(
                                //       contentPadding: const EdgeInsets.symmetric(
                                //           vertical: 15, horizontal: 15),
                                //       enabledBorder: inputBorder,
                                //       focusedBorder: inputBorderFocused,
                                //       errorBorder: inputBorder,
                                //       focusedErrorBorder: inputBorderFocused,
                                //       filled: true,
                                //       fillColor: AppColor.xLightBackground,
                                //     ),
                                //     keyboardType: TextInputType.number,
                                //     inputFormatters: [
                                //       FilteringTextInputFormatter.digitsOnly
                                //     ],
                                //     textInputAction: TextInputAction.next,
                                //     autovalidateMode: AutovalidateMode.always,
                                //     validator: (String? value) {
                                //       if (value!.isEmpty) {
                                //         return "Number of plantain seedlings alive is required";
                                //       }
                                //       int? intValue = int.tryParse(value);
                                //       if (intValue == null) {
                                //         return "$value is not a valid number";
                                //       }
                                //       return null;
                                //     }),

                                //const SizedBox(height: 20),

                                // const Text(
                                //   'Name of CHED TA',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //   controller:
                                //       addInitialTreatmentMonitoringRecordController
                                //           .cHEDTATC,
                                //   textCapitalization: TextCapitalization.words,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         vertical: 15, horizontal: 15),
                                //     enabledBorder: inputBorder,
                                //     focusedBorder: inputBorderFocused,
                                //     errorBorder: inputBorder,
                                //     focusedErrorBorder: inputBorderFocused,
                                //     filled: true,
                                //     fillColor: AppColor.xLightBackground,
                                //   ),
                                //   maxLines: null,
                                //   keyboardType: TextInputType.name,
                                //   textInputAction: TextInputAction.next,
                                //   autovalidateMode: AutovalidateMode.always,
                                //   validator: (String? value) =>
                                //       value!.trim().isEmpty
                                //           ? "CHED TA name is required"
                                //           : null,
                                // ),
                                // const SizedBox(height: 20),
                                //
                                // const Text(
                                //   'CHED TA Contact Number',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //   controller:
                                //       addInitialTreatmentMonitoringRecordController
                                //           .cHEDTAContactTC,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         vertical: 15, horizontal: 15),
                                //     enabledBorder: inputBorder,
                                //     focusedBorder: inputBorderFocused,
                                //     errorBorder: inputBorder,
                                //     focusedErrorBorder: inputBorderFocused,
                                //     filled: true,
                                //     fillColor: AppColor.xLightBackground,
                                //   ),
                                //   textInputAction: TextInputAction.next,
                                //   textCapitalization: TextCapitalization.words,
                                //   keyboardType: TextInputType.phone,
                                //   autovalidateMode: AutovalidateMode.always,
                                //   validator: (String? value) =>
                                //       value!.trim().isEmpty ||
                                //               value.trim().length != 10
                                //           ? "Enter a valid phone number"
                                //           : null,
                                // ),
                                // const SizedBox(height: 20),

                                // const Text(
                                //   'Community',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //   controller:
                                //       addInitialTreatmentMonitoringRecordController
                                //           .communityNameTC,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         vertical: 15, horizontal: 15),
                                //     enabledBorder: inputBorder,
                                //     focusedBorder: inputBorderFocused,
                                //     errorBorder: inputBorder,
                                //     focusedErrorBorder: inputBorderFocused,
                                //     filled: true,
                                //     fillColor: AppColor.xLightBackground,
                                //   ),
                                //   keyboardType: TextInputType.text,
                                //   textCapitalization: TextCapitalization.words,
                                //   textInputAction: TextInputAction.next,
                                //   validator: (String? value) =>
                                //       value!.trim().isEmpty
                                //           ? "Community is required"
                                //           : null,
                                // ),
                                // const SizedBox(height: 20),

                                // const Text(
                                //   'District',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // DropdownSearch<RegionDistrict>(
                                //   popupProps: PopupProps.modalBottomSheet(
                                //       showSelectedItems: true,
                                //       showSearchBox: true,
                                //       itemBuilder: (context, item, selected) {
                                //         return ListTile(
                                //           title: Text(
                                //               item.districtName.toString(),
                                //               style: selected
                                //                   ? TextStyle(
                                //                       color: AppColor.primary)
                                //                   : const TextStyle()),
                                //           subtitle: Text(
                                //             item.regionName.toString(),
                                //           ),
                                //         );
                                //       },
                                //       title: const Padding(
                                //         padding:
                                //             EdgeInsets.symmetric(vertical: 15),
                                //         child: Center(
                                //           child: Text(
                                //             'Select district',
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w500),
                                //           ),
                                //         ),
                                //       ),
                                //       disabledItemFn: (RegionDistrict s) => false,
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
                                //             .regionDistrictDao
                                //             .findAllRegionDistrict();
                                //     return response;
                                //   },
                                //   itemAsString: (RegionDistrict d) =>
                                //       d.districtName ?? '',
                                //   // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                //   compareFn: (d, filter) =>
                                //       d.districtName == filter.districtName,
                                //   onChanged: (val) {
                                //     addInitialTreatmentMonitoringRecordController
                                //         .regionDistrict = val;
                                //   },
                                //   // selectedItem:
                                //   //     addInitialTreatmentMonitoringRecordController
                                //   //         .regionDistrict,
                                //   autoValidateMode: AutovalidateMode.always,
                                //   validator: (item) {
                                //     if (item == null) {
                                //       return 'District is required';
                                //     } else {
                                //       return null;
                                //     }
                                //   },
                                // ),

                                // const Text(
                                //   'Community',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // DropdownSearch<Community>(
                                //   popupProps: PopupProps.modalBottomSheet(
                                //       showSelectedItems: true,
                                //       showSearchBox: true,
                                //       itemBuilder: (context, item, selected) {
                                //         return ListTile(
                                //           title: Text(item.community.toString(),
                                //               style: selected
                                //                   ? TextStyle(
                                //                       color: AppColor.primary)
                                //                   : const TextStyle()),
                                //           subtitle: Text(
                                //             item.operationalArea.toString(),
                                //           ),
                                //         );
                                //       },
                                //       title: const Padding(
                                //         padding:
                                //             EdgeInsets.symmetric(vertical: 15),
                                //         child: Center(
                                //           child: Text(
                                //             'Select community',
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.w500),
                                //           ),
                                //         ),
                                //       ),
                                //       disabledItemFn: (Community s) => false,
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
                                //             .communityDao
                                //             .findAllCommunity();
                                //     return response;
                                //   },
                                //   itemAsString: (Community d) =>
                                //       d.community ?? '',
                                //   // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                //   compareFn: (d, filter) =>
                                //       d.community == filter.community,
                                //   onChanged: (val) {
                                //     addInitialTreatmentMonitoringRecordController
                                //         .community = val;
                                //   },
                                //
                                //   autoValidateMode: AutovalidateMode.always,
                                //   validator: (item) {
                                //     if (item == null) {
                                //       return 'Community is required';
                                //     } else {
                                //       return null;
                                //     }
                                //   },
                                // ),

                                const SizedBox(height: 20),

                                // const Text(
                                //   'Operational Area',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // TextFormField(
                                //   controller:
                                //       addInitialTreatmentMonitoringRecordController
                                //           .operationalAreaTC,
                                //   textCapitalization: TextCapitalization.words,
                                //   decoration: InputDecoration(
                                //     contentPadding: const EdgeInsets.symmetric(
                                //         vertical: 15, horizontal: 15),
                                //     enabledBorder: inputBorder,
                                //     focusedBorder: inputBorderFocused,
                                //     errorBorder: inputBorder,
                                //     focusedErrorBorder: inputBorderFocused,
                                //     filled: true,
                                //     fillColor: AppColor.xLightBackground,
                                //   ),
                                //   maxLines: null,
                                //   keyboardType: TextInputType.text,
                                //   textInputAction: TextInputAction.next,
                                //   autovalidateMode: AutovalidateMode.always,
                                //   validator: (String? value) =>
                                //       value!.trim().isEmpty
                                //           ? "Operational area is required"
                                //           : null,
                                // ),
                                // const SizedBox(height: 20),

                                const Text(
                                  'Activity',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DropdownSearch<String>(
                                  popupProps: PopupProps.modalBottomSheet(
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                      title: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        child: Center(
                                          child: Text(
                                            'Select Activity',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
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
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                      )),
                                  selectedItem:
                                      widget.monitor!.community!.split(",")[1],
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
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
                                  ),
                                  asyncItems: (String filter) async {
                                    List<ActivityModel> activities = [];
                                    List<String> act = [];

                                    activities =
                                        await editInitialTreatmentMonitoringRecordController
                                            .db
                                            .getAllActivityWithMainActivityList([
                                      MainActivities.Maintenance,
                                      MainActivities.Establishment,
                                      MainActivities.InitialTreatment,
                                    ]);

                                    activities.forEach((activity) {
                                      if (!act
                                          .contains(activity.mainActivity)) {
                                        act.add(activity.mainActivity!);
                                      }
                                    });

                                    return act;
                                  },
                                  itemAsString: (String d) => d,
                                  // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                  compareFn: (activity, filter) =>
                                      activity == filter,
                                  onChanged: (val) {
                                    editInitialTreatmentMonitoringRecordController
                                        .activity = val!;
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

                                const Text(
                                  'Sub activity',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DropdownSearch<ActivityModel>.multiSelection(
                                  popupProps:
                                      PopupPropsMultiSelection.modalBottomSheet(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                          title: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Center(
                                              child: Text(
                                                'Select sub activity',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          disabledItemFn: (ActivityModel s) =>
                                              false,
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
                                                      vertical: 4,
                                                      horizontal: 15),
                                              enabledBorder: inputBorder,
                                              focusedBorder: inputBorderFocused,
                                              errorBorder: inputBorder,
                                              focusedErrorBorder:
                                                  inputBorderFocused,
                                              filled: true,
                                              fillColor:
                                                  AppColor.xLightBackground,
                                            ),
                                          )),
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
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
                                  ),
                                  selectedItems:
                                      editInitialTreatmentMonitoringRecordController
                                          .subActivityList,
                                  asyncItems: (String filter) async {
                                    var response =
                                        await editInitialTreatmentMonitoringRecordController
                                            .db
                                            .getSubActivityByMainActivity(
                                                editInitialTreatmentMonitoringRecordController
                                                    .activity!);

                                    return response;
                                  },
                                  itemAsString: (ActivityModel d) =>
                                      d.subActivity.toString(),
                                  // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                  compareFn: (activity, filter) =>
                                      activity.subActivity ==
                                      filter.subActivity,
                                  onChanged: (vals) {
                                    editInitialTreatmentMonitoringRecordController
                                        .subActivityList = vals;

                                    // if (addContractorCertificateRecordController
                                    //             .subActivity.length ==
                                    //         1 &&
                                    //     addContractorCertificateRecordController
                                    //             .subActivity[0].subActivity
                                    //             .toString()
                                    //             .toUpperCase() ==
                                    //         "weeding of replanted farms"
                                    //             .toUpperCase()) {
                                    //
                                    //   // addContractorCertificateRecordController
                                    //   //     .subActivityCheck.value = true;
                                    // }

                                    editInitialTreatmentMonitoringRecordController
                                        .update();
                                  },
                                  autoValidateMode: AutovalidateMode.always,
                                  validator: (items) {
                                    if (items == null || items.isEmpty) {
                                      return 'Sub activity is required';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),

                                /**
                                 * GetBuilder(
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
                                 */

                                // const SizedBox(height: 20),
                                //
                                // const Text(
                                //   'Picture of Farm',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // GetBuilder(
                                //     init:
                                //         addInitialTreatmentMonitoringRecordController,
                                //     builder: (context) {
                                //       return ImageFieldCard(
                                //         // onTap: () => addInitialTreatmentMonitoringRecordController.chooseMediaSource(),
                                //         // onTap: () => addInitialTreatmentMonitoringRecordController.pickMedia(source: 1, imageToSet: PersonnelImageData.personnelImage),
                                //         onTap: () =>
                                //             addInitialTreatmentMonitoringRecordController
                                //                 .pickMedia(source: 1),
                                //         image:
                                //             addInitialTreatmentMonitoringRecordController
                                //                 .farmPhoto?.file,
                                //       );
                                //     }),

                                // GetBuilder(
                                //     init:
                                //         addInitialTreatmentMonitoringRecordController,
                                //     builder: (ctx) {
                                //       return addInitialTreatmentMonitoringRecordController
                                //                   .farmPhoto?.file ==
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
                                //                     'Picture of farm is required',
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

                                const Text(
                                  'Was The Activity Done By A Group',
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
                                      editInitialTreatmentMonitoringRecordController
                                          .yesNoItems,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
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
                                        .isCompletedByGroup.value = val!;
                                    editInitialTreatmentMonitoringRecordController
                                        .areaCoveredRx.value = '';
                                    editInitialTreatmentMonitoringRecordController
                                        .clearRehabAssistantsToDefault();
                                    editInitialTreatmentMonitoringRecordController
                                        .numberInGroupTC
                                        ?.clear();

                                    editInitialTreatmentMonitoringRecordController
                                        .update();
                                  },
                                ),

                                // GetBuilder(
                                //   init:
                                //       addInitialTreatmentMonitoringRecordController,
                                //   builder: (ctx) {
                                //     return addInitialTreatmentMonitoringRecordController
                                //                 .isContractor.value ==
                                //             YesNo.yes
                                //         ? Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               const SizedBox(
                                //                 height: 20,
                                //               ),
                                //               const Text(
                                //                 'Name of Contractor',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.w500),
                                //               ),
                                //               const SizedBox(
                                //                 height: 5,
                                //               ),
                                //               TextFormField(
                                //                 controller:
                                //                     addInitialTreatmentMonitoringRecordController
                                //                         .contractorNameTC,
                                //                 textCapitalization:
                                //                     TextCapitalization.words,
                                //                 decoration: InputDecoration(
                                //                   contentPadding:
                                //                       const EdgeInsets.symmetric(
                                //                           vertical: 15,
                                //                           horizontal: 15),
                                //                   enabledBorder: inputBorder,
                                //                   focusedBorder:
                                //                       inputBorderFocused,
                                //                   errorBorder: inputBorder,
                                //                   focusedErrorBorder:
                                //                       inputBorderFocused,
                                //                   filled: true,
                                //                   fillColor:
                                //                       AppColor.xLightBackground,
                                //                 ),
                                //                 maxLines: null,
                                //                 keyboardType: TextInputType.name,
                                //                 textInputAction:
                                //                     TextInputAction.next,
                                //                 autovalidateMode:
                                //                     AutovalidateMode.always,
                                //                 validator: (String? value) => value!
                                //                         .trim()
                                //                         .isEmpty
                                //                     ? "Contractor name is required"
                                //                     : null,
                                //               ),
                                //             ],
                                //           )
                                //         : Container();
                                //   },
                                // ),
                                // const SizedBox(height: 20),

                                // const Text(
                                //   'Task Status',
                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                // ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // DropdownSearch<String>(
                                //   popupProps: PopupProps.menu(
                                //       showSelectedItems: true,
                                //       disabledItemFn: (String s) => false,
                                //       fit: FlexFit.loose,
                                //       menuProps: MenuProps(
                                //           elevation: 6,
                                //           borderRadius: BorderRadius.circular(
                                //               AppBorderRadius.sm))),
                                //   items:
                                //       addInitialTreatmentMonitoringRecordController
                                //           .taskStatusItems,
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
                                //   autoValidateMode: AutovalidateMode.always,
                                //   validator: (item) {
                                //     if (item == null) {
                                //       return "Task status is required";
                                //     } else {
                                //       return null;
                                //     }
                                //   },
                                //   onChanged: (val) {
                                //     addInitialTreatmentMonitoringRecordController
                                //         .taskStatus = val!;
                                //   },
                                // ),

                                // const SizedBox(height: 20),

                                // GetBuilder(
                                //   init:
                                //       addInitialTreatmentMonitoringRecordController,
                                //   builder: (ctx) {
                                //     return addInitialTreatmentMonitoringRecordController
                                //                 .isContractor.value ==
                                //             YesNo.no
                                //         ? Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               const SizedBox(
                                //                 height: 20,
                                //               ),
                                //               const Text(
                                //                 'Was The Activity Done By A Group',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.w500),
                                //               ),
                                //               const SizedBox(
                                //                 height: 5,
                                //               ),
                                //               DropdownSearch<String>(
                                //                 popupProps: PopupProps.menu(
                                //                     showSelectedItems: true,
                                //                     disabledItemFn: (String s) =>
                                //                         false,
                                //                     fit: FlexFit.loose,
                                //                     menuProps: MenuProps(
                                //                         elevation: 6,
                                //                         borderRadius:
                                //                             BorderRadius.circular(
                                //                                 AppBorderRadius
                                //                                     .sm))),
                                //                 items:
                                //                     addInitialTreatmentMonitoringRecordController
                                //                         .yesNoItems,
                                //                 dropdownDecoratorProps:
                                //                     DropDownDecoratorProps(
                                //                   dropdownSearchDecoration:
                                //                       InputDecoration(
                                //                     contentPadding:
                                //                         const EdgeInsets
                                //                                 .symmetric(
                                //                             vertical: 4,
                                //                             horizontal: 15),
                                //                     enabledBorder: inputBorder,
                                //                     focusedBorder:
                                //                         inputBorderFocused,
                                //                     errorBorder: inputBorder,
                                //                     focusedErrorBorder:
                                //                         inputBorderFocused,
                                //                     filled: true,
                                //                     fillColor:
                                //                         AppColor.xLightBackground,
                                //                   ),
                                //                 ),
                                //                 autoValidateMode:
                                //                     AutovalidateMode.always,
                                //                 validator: (item) {
                                //                   if (item == null) {
                                //                     return "field is required";
                                //                   } else {
                                //                     return null;
                                //                   }
                                //                 },
                                //                 onChanged: (val) {
                                //                   addInitialTreatmentMonitoringRecordController
                                //                       .isCompletedByGroup
                                //                       .value = val!;
                                //                   addInitialTreatmentMonitoringRecordController
                                //                       .areaCoveredRx.value = '';
                                //                   addInitialTreatmentMonitoringRecordController
                                //                       .clearRehabAssistantsToDefault();
                                //                   addInitialTreatmentMonitoringRecordController
                                //                       .numberInGroupTC
                                //                       ?.clear();
                                //                   addInitialTreatmentMonitoringRecordController
                                //                       .update();
                                //                 },
                                //               ),
                                //             ],
                                //           )
                                //         : Container();
                                //   },
                                // ),

                                GetBuilder(
                                  init:
                                      editInitialTreatmentMonitoringRecordController,
                                  builder: (ctx) {
                                    if (editInitialTreatmentMonitoringRecordController
                                            .isCompletedByGroup.value ==
                                        YesNo.yes) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Number of People In Group',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextFormField(

                                              ///initialValue: widget.monitor!.numberOfPeopleInGroup.toString(),
                                              controller:
                                                  editInitialTreatmentMonitoringRecordController
                                                      .numberInGroupTC,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
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
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              textInputAction:
                                                  TextInputAction.next,
                                              validator: (String? value) => value!
                                                      .trim()
                                                      .isEmpty
                                                  ? "Number of People In Group is required"
                                                  : null,
                                              onChanged: (value) {
                                                editInitialTreatmentMonitoringRecordController
                                                    .clearRehabAssistantsToDefault();

                                                editInitialTreatmentMonitoringRecordController
                                                    .updateAreaCovered();

                                                editInitialTreatmentMonitoringRecordController
                                                    .update();
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Was The Activity Done Equally',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          DropdownSearch<String>(
                                            popupProps: PopupProps.menu(
                                                showSelectedItems: true,
                                                disabledItemFn: (String s) =>
                                                    false,
                                                fit: FlexFit.loose,
                                                menuProps: MenuProps(
                                                    elevation: 6,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppBorderRadius
                                                                .sm))),
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
                                            ),
                                            selectedItem:
                                                names.length > 1 ? "Yes" : "No",
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
                                              editInitialTreatmentMonitoringRecordController
                                                  .isDoneEqually.value = val!;
                                              print(
                                                  editInitialTreatmentMonitoringRecordController
                                                      .isDoneEqually.value);

                                              if (editInitialTreatmentMonitoringRecordController
                                                  .numberInGroupTC!
                                                  .text
                                                  .isEmpty) {
                                                editInitialTreatmentMonitoringRecordController
                                                    .globals
                                                    .showSnackBar(
                                                  title: "Required action",
                                                  message:
                                                      "Please input the number of people in the group to proceed",
                                                );
                                                return;
                                              }

                                              if (editInitialTreatmentMonitoringRecordController
                                                      .isDoneEqually ==
                                                  YesNo.yes) {
                                                double area = double.tryParse(
                                                        editInitialTreatmentMonitoringRecordController
                                                            .farmSizeTC!
                                                            .text)! /
                                                    int.tryParse(
                                                        editInitialTreatmentMonitoringRecordController
                                                            .numberInGroupTC!
                                                            .text)!;
                                                editInitialTreatmentMonitoringRecordController
                                                    .rehabAssistants
                                                    .forEach((ra) {
                                                  ra.areaCovered!.text =
                                                      area.toString();
                                                });
                                              }
                                              editInitialTreatmentMonitoringRecordController
                                                  .update();
                                            },
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
                                    bool groupHasNumber = int.tryParse(
                                            editInitialTreatmentMonitoringRecordController
                                                .numberInGroupTC!.text) !=
                                        null;
                                    // final isCompletedByGroup =
                                    //     addInitialTreatmentMonitoringRecordController
                                    //         .isCompletedByGroup;
                                    if (groupHasNumber) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text('REHAB ASSISTANTS',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.black)),
                                          Text(
                                              'Select rehab assistants and their respective area covered (if applicable)',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColor.black)),
                                          Obx(
                                            () {
                                              final maxItems = int.tryParse(
                                                      editInitialTreatmentMonitoringRecordController
                                                          .numberInGroupTC!
                                                          .text) ??
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
                                                  (i) =>
                                                      InitialTreatmentRehabAssistantSelect(
                                                    index: RxInt(i + 1),
                                                    rehabAssistant:
                                                        RehabAssistantModel(
                                                            rehabName: names[i],
                                                            rehabCode: int
                                                                .tryParse(codes[
                                                                        i]
                                                                    .toString())),
                                                    areaHa: areas[i].toString(),
                                                    isViewMode:
                                                        widget.isViewMode,
                                                  ),
                                                ).obs;
                                              }

                                              final generatedWidgets =
                                                  List<Widget>.generate(
                                                      min(
                                                          maxItems,
                                                          rehabAssistants
                                                              .length), (i) {
                                                return rehabAssistants[i];
                                              });

                                              return Column(
                                                children: generatedWidgets,
                                                //  List.generate(
                                                //   min(
                                                //       maxItems,
                                                //       rehabAssistants
                                                //           .length), // Use min to limit the count
                                                //   (i) {
                                                //     return rehabAssistants[i];
                                                //   },
                                                // ),
                                              );
                                            },
                                          ),
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
                                    // if(addInitialTreatmentMonitoringRecordController.isCompletedByGroup.value == YesNo.no){
                                    //   print("LENGTH ${addInitialTreatmentMonitoringRecordController.rehabAssistants.first.areaCovered?.text}");
                                    //   /// activate the readonly property of the textfield
                                    //   addInitialTreatmentMonitoringRecordController.isDoneEqually.value = YesNo.yes;
                                    //   addInitialTreatmentMonitoringRecordController
                                    //       .rehabAssistants
                                    //       .first.areaCovered!.text =
                                    //       addInitialTreatmentMonitoringRecordController
                                    //           .farmSizeTC!.text;
                                    // }
                                    if (editInitialTreatmentMonitoringRecordController
                                            .isCompletedByGroup.value ==
                                        YesNo.no) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text('REHAB ASSISTANTS',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.black)),
                                          Text(
                                              'Select rehab assistants and their respective area covered',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColor.black)),
                                          Obx(() =>
                                              editInitialTreatmentMonitoringRecordController
                                                  .rehabAssistants.first),
                                          const SizedBox(height: 30),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     InkWell(
                                          //       highlightColor: Colors.green,
                                          //       // customBorder: ,
                                          //       borderRadius:
                                          //           BorderRadius.circular(20),
                                          //
                                          //       onTap: () {
                                          //         addInitialTreatmentMonitoringRecordController
                                          //             .rehabAssistants
                                          //             .add(InitialTreatmentRehabAssistantSelection(
                                          //                 index: RxInt(
                                          //                     addInitialTreatmentMonitoringRecordController
                                          //                             .rehabAssistants
                                          //                             .length +
                                          //                         1)));
                                          //       },
                                          //       // behavior: HitTestBehavior.opaque,
                                          //       child: Align(
                                          //         alignment:
                                          //             Alignment.bottomRight,
                                          //         child: Padding(
                                          //           padding: const EdgeInsets
                                          //               .symmetric(
                                          //               horizontal: 10.0),
                                          //           child: Padding(
                                          //             padding: const EdgeInsets
                                          //                 .symmetric(
                                          //                 vertical: 12),
                                          //             child: Text(
                                          //               'Tap to add another rehab assistant',
                                          //               overflow:
                                          //                   TextOverflow.clip,
                                          //               style: TextStyle(
                                          //                   color:
                                          //                       tmtColorPrimary,
                                          //                   fontWeight:
                                          //                       FontWeight.bold),
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     // GestureDetector(
                                          //     //   onTap: () {
                                          //     //     homeController
                                          //     //         .usePolygonDrawingTool();
                                          //     //   },
                                          //     //   behavior:
                                          //     //       HitTestBehavior.opaque,
                                          //     //   child: Align(
                                          //     //     alignment:
                                          //     //         Alignment.bottomRight,
                                          //     //     child: Padding(
                                          //     //       padding:
                                          //     //           const EdgeInsets
                                          //     //                   .symmetric(
                                          //     //               horizontal:
                                          //     //                   10.0),
                                          //     //       child: Text(
                                          //     //         'Area Tool',
                                          //     //         style: TextStyle(
                                          //     //             color:
                                          //     //                 tmtColorPrimary,
                                          //     //             fontWeight:
                                          //     //                 FontWeight
                                          //     //                     .bold),
                                          //     //       ),
                                          //     //     ),
                                          //     //   ),
                                          //     // ),
                                          //   ],
                                          // ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),

                                /*
                                const SizedBox(
                                  height: 30,
                                ),

                                GetBuilder(
                                    init:
                                        addInitialTreatmentMonitoringRecordController,
                                    builder: (context) {
                                      return addInitialTreatmentMonitoringRecordController
                                                  .subActivity
                                                  .requiredEquipment ??
                                              false
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20),

                                                const Divider(),

                                                const SizedBox(height: 10),

                                                Text('FUEL DETAILS',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColor.black)),

                                                const SizedBox(height: 20),
                                                const Text(
                                                  'Date Purchased',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                DateTimePicker(
                                                  controller:
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelPurchasedDateTC,
                                                  type: DateTimePickerType.date,
                                                  initialDate: DateTime.now(),
                                                  dateMask: 'yyyy-MM-dd',
                                                  firstDate: DateTime(1600),
                                                  lastDate: DateTime.now(),
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
                                                  onChanged: (val) =>
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelPurchasedDateTC
                                                          ?.text = val,
                                                  validator: (String? value) =>
                                                      value!.trim().isEmpty
                                                          ? "Date purchased is required"
                                                          : null,
                                                  onSaved: (val) =>
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelPurchasedDateTC
                                                          ?.text = val!,
                                                ),

                                                const SizedBox(height: 20),
                                                const Text(
                                                  'Date',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                DateTimePicker(
                                                  controller:
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelDateTC,
                                                  type: DateTimePickerType.date,
                                                  initialDate: DateTime.now(),
                                                  dateMask: 'yyyy-MM-dd',
                                                  firstDate: DateTime(1600),
                                                  lastDate: DateTime.now(),
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
                                                  onChanged: (val) =>
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelDateTC?.text = val,
                                                  validator: (String? value) =>
                                                      value!.trim().isEmpty
                                                          ? "Date is required"
                                                          : null,
                                                  onSaved: (val) =>
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelDateTC
                                                          ?.text = val!,
                                                ),

                                                const SizedBox(height: 20),

                                                const Text(
                                                  'Quantity Purchased',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelQuantityPurchasedTC,
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
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  validator: (String? value) =>
                                                      value!.trim().isEmpty
                                                          ? "Quantity is required"
                                                          : null,
                                                ),

                                                const SizedBox(height: 20),

                                                const Text(
                                                  'Name of Receiving Operator',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelReceivingOperatorTC,
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
                                                          ? "Operator name is required"
                                                          : null,
                                                ),

                                                const SizedBox(height: 20),

                                                const Text(
                                                  'Quantity (Ltr)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelQuantityLtrTC,
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
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  validator: (String? value) =>
                                                      value!.trim().isEmpty
                                                          ? "Quantity is required"
                                                          : null,
                                                ),

                                                const SizedBox(height: 20),

                                                const Text(
                                                  'Red Oil (Ltr)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelRedOilLtrTC,
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
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  validator: (String? value) =>
                                                      value!.trim().isEmpty
                                                          ? "Quantity is required"
                                                          : null,
                                                ),

                                                const SizedBox(height: 20),

                                                const Text(
                                                  'Engine Oil (Ltr)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      addInitialTreatmentMonitoringRecordController
                                                          .fuelEngineOilLtrTC,
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
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  validator: (String? value) =>
                                                      value!.trim().isEmpty
                                                          ? "Engine is required"
                                                          : null,
                                                ),

                                                // const SizedBox(height: 20),
                                                // const Text('Area',
                                                //   style: TextStyle(fontWeight: FontWeight.w500),
                                                // ),
                                                // const SizedBox(height: 5,),
                                                // TextFormField(
                                                //   controller: addInitialTreatmentMonitoringRecordController.fuelAreaTC,
                                                //   decoration: InputDecoration(
                                                //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                                //     enabledBorder: inputBorder,
                                                //     focusedBorder: inputBorderFocused,
                                                //     errorBorder: inputBorder,
                                                //     focusedErrorBorder: inputBorderFocused,
                                                //     filled: true,
                                                //     fillColor: AppColor.xLightBackground,
                                                //   ),
                                                //   keyboardType: TextInputType.number,
                                                //   textInputAction: TextInputAction.next,
                                                //   validator: (String? value) => value!.trim().isEmpty
                                                //       ? "Area is required"
                                                //       : null,
                                                // ),

                                                const SizedBox(height: 20),

                                                const Text(
                                                  'Remarks on Fuel',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                TextFormField(
                                                    controller:
                                                        addInitialTreatmentMonitoringRecordController
                                                            .fuelRemarksTC,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
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
                                                      fillColor: AppColor
                                                          .xLightBackground,
                                                    ),
                                                    maxLines: null,
                                                    textInputAction:
                                                        TextInputAction.done),
                                              ],
                                            )
                                          : Container();
                                    }),
                                    */

                                // GetBuilder(
                                //     init:
                                //         addInitialTreatmentMonitoringRecordController,
                                //     builder: (context) {
                                //       return addInitialTreatmentMonitoringRecordController
                                //                   .locationData !=
                                //               null
                                //           ? Column(
                                //               mainAxisSize: MainAxisSize.min,
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 const SizedBox(height: 20),
                                //                 Text(
                                //                   'LOCATION',
                                //                   style: TextStyle(
                                //                       fontWeight: FontWeight.w700,
                                //                       fontSize: 16,
                                //                       color: AppColor.black),
                                //                 ),
                                //                 const SizedBox(height: 5),
                                //                 Text(
                                //                   'Lat : ${addInitialTreatmentMonitoringRecordController.locationData!.latitude}',
                                //                   style: const TextStyle(
                                //                       fontWeight:
                                //                           FontWeight.w500),
                                //                 ),
                                //                 Text(
                                //                   'Lng : ${addInitialTreatmentMonitoringRecordController.locationData!.longitude}',
                                //                   style: const TextStyle(
                                //                       fontWeight:
                                //                           FontWeight.w500),
                                //                 ),
                                //                 Text(
                                //                   'Accuracy : ${addInitialTreatmentMonitoringRecordController.locationData!.accuracy!.truncateToDecimalPlaces(2).toString()}',
                                //                   style: const TextStyle(
                                //                       fontWeight:
                                //                           FontWeight.w500),
                                //                 ),
                                //               ],
                                //             )
                                //           : Container();
                                //     }),
                                SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'General Remarks',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                    controller:
                                        editInitialTreatmentMonitoringRecordController
                                            .remarksTC,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 15),
                                      enabledBorder: inputBorder,
                                      focusedBorder: inputBorderFocused,
                                      errorBorder: inputBorder,
                                      focusedErrorBorder: inputBorderFocused,
                                      filled: true,
                                      fillColor: AppColor.xLightBackground,
                                    ),
                                    maxLines: null,
                                    textInputAction: TextInputAction.done),

                                const SizedBox(
                                  height: 20,
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
                                                        'Kindly provide all required information');
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
                                              fontSize: 14),
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
                                          // if (!addInitialTreatmentMonitoringRecordController
                                          //     .isButtonDisabled.value) {
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
                                                        'Kindly provide all required information');
                                          }
                                          // }
                                        },
                                        child:
                                            //  Obx(
                                            //   () =>
                                            Text(
                                          // addInitialTreatmentMonitoringRecordController
                                          //         .isButtonDisabled.value
                                          //     ? 'Please wait ...'
                                          //     :
                                          'Submit',
                                          style: TextStyle(
                                              color: AppColor.white,
                                              fontSize: 14),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // import 'dart:convert';
//
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:cocoa_monitor/controller/constants.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
// import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
// // import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
// // import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/monitor.dart';
// import 'package:cocoa_monitor/controller/global_controller.dart';
// import 'package:cocoa_monitor/view/global_components/custom_button.dart';
// // import 'package:cocoa_monitor/view/global_components/image_field_card.dart';
// import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
// import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
// import 'package:cocoa_monitor/view/home/home_controller.dart';
// import 'package:cocoa_monitor/view/utils/style.dart';
// import 'package:date_time_picker/date_time_picker.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import '../../controller/entity/cocoa_rehub_monitor/community.dart';
// import '../global_components/image_field_card.dart';
// import '../utils/pattern_validator.dart';
// import 'components/initial_treatment_rehab_assistant_select.dart';
// import 'edit_initial_treatment_monitoring_record_controller.dart';
//
// class EditInitialTreatmentMonitoringRecord extends StatefulWidget {
//   final InitialTreatmentMonitor monitor;
//   final bool isViewMode;
//   //final String allMonitorings;
//
//   const EditInitialTreatmentMonitoringRecord(
//       {Key? key,
//       required this.monitor,
//       required this.isViewMode,
//       // required this.allMonitorings
//       })
//       : super(key: key);
//
//   @override
//   State<EditInitialTreatmentMonitoringRecord> createState() =>
//       _EditMonitoringRecordState();
// }
//
// class _EditMonitoringRecordState
//     extends State<EditInitialTreatmentMonitoringRecord> {
//   EditInitialTreatmentMonitoringRecordController
//       editInitialTreatmentMonitoringRecordController =
//       Get.put(EditInitialTreatmentMonitoringRecordController());
//   GlobalController globalController = Get.find();
//   HomeController homeController = Get.find();
//
//   @override
//   void initState() {
//     super.initState();
//
//     editInitialTreatmentMonitoringRecordController.monitor = widget.monitor;
//     editInitialTreatmentMonitoringRecordController.isViewMode =
//         widget.isViewMode;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     editInitialTreatmentMonitoringRecordController
//         .editMonitoringRecordScreenContext = context;
//
//     return Material(
//       child: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle(
//           statusBarColor: AppColor.lightBackground,
//           statusBarIconBrightness: Brightness.dark,
//           systemNavigationBarColor: Colors.white,
//           systemNavigationBarIconBrightness: Brightness.dark,
//         ),
//         child: Scaffold(
//           backgroundColor: AppColor.lightBackground,
//           body: GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(
//                               color: AppColor.lightText.withOpacity(0.5)))),
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).padding.top + 15,
//                         bottom: 10,
//                         left: AppPadding.horizontal,
//                         right: AppPadding.horizontal),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         RoundedIconButton(
//                           icon: appIconBack(color: AppColor.black, size: 25),
//                           size: 45,
//                           backgroundColor: Colors.transparent,
//                           onTap: () => Get.back(),
//                         ),
//                         const SizedBox(
//                           width: 12,
//                         ),
//                         Expanded(
//                           child: Text(widget.isViewMode
//                                       ? "Edit activity reporting record": "View activity reporting record",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: AppColor.black)),
//                           // child: Text(
//                           //     widget.isViewMode
//                           //         ? widget.allMonitorings ==
//                           //                 AllMonitorings.InitialTreatment
//                           //             ? 'Edit IT Monitoring Record'
//                           //             : widget.allMonitorings ==
//                           //                     AllMonitorings.Establishment
//                           //                 ? 'Edit Establishment Record'
//                           //                 : widget.allMonitorings ==
//                           //                         AllMonitorings.Maintenance
//                           //                     ? 'Edit Maintenance Record'
//                           //                     : ''
//                           //         : widget.allMonitorings ==
//                           //                 AllMonitorings.InitialTreatment
//                           //             ? 'Edit IT Monitoring Record'
//                           //             : widget.allMonitorings ==
//                           //                     AllMonitorings.Establishment
//                           //                 ? 'Edit Establishment Record'
//                           //                 : widget.allMonitorings ==
//                           //                         AllMonitorings.Maintenance
//                           //                     ? 'Edit Maintenance Record'
//                           //                     : '',
//                           //     style: TextStyle(
//                           //         fontSize: 16,
//                           //         fontWeight: FontWeight.w600,
//                           //         color: AppColor.black)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(
//                         left: AppPadding.horizontal,
//                         right: AppPadding.horizontal,
//                         bottom: AppPadding.vertical,
//                         top: 10),
//                     child: Column(
//                       children: [
//                         AbsorbPointer(
//                           absorbing: widget.isViewMode,
//                           child: GetBuilder(
//                               init:
//                                   editInitialTreatmentMonitoringRecordController,
//                               builder: (ctx) {
//                                 return Form(
//                                   key:
//                                       editInitialTreatmentMonitoringRecordController
//                                           .editMonitoringRecordFormKey,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       const Text(
//                                         'Monitoring Date',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       DateTimePicker(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .monitoringDateTC,
//                                         type: DateTimePickerType.date,
//                                         initialDate: DateTime.now(),
//                                         dateMask: 'yyyy-MM-dd',
//                                         firstDate: DateTime(1600),
//                                         lastDate: DateTime.now(),
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         onChanged: (val) =>
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .monitoringDateTC?.text = val,
//                                         validator: (String? value) =>
//                                             value!.trim().isEmpty
//                                                 ? "Monitoring date is required"
//                                                 : null,
//                                         onSaved: (val) =>
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .monitoringDateTC?.text = val!,
//                                       ),
//
//                                       const SizedBox(height: 20),
//
//                                       // const Text('Farm',
//                                       //   style: TextStyle(fontWeight: FontWeight.w500),
//                                       // ),
//                                       // const SizedBox(height: 5,),
//                                       // FutureBuilder(
//                                       //   builder: (ctx, snapshot) {
//                                       //     // Checking if future is resolved or not
//                                       //     if (snapshot.connectionState == ConnectionState.done) {
//
//                                       //       if (snapshot.hasError) {
//                                       //         return Center(
//                                       //           child: Text(
//                                       //             '${snapshot.error} occurred',
//                                       //             style: const TextStyle(fontSize: 18),
//                                       //           ),
//                                       //         );
//
//                                       //       } else if (snapshot.hasData) {
//
//                                       //         List? dataList = snapshot.data as List;
//                                       //         OutbreakFarmFromServer? data = dataList.isNotEmpty ? dataList.first as OutbreakFarmFromServer? : OutbreakFarmFromServer();
//                                       //         editInitialTreatmentMonitoringRecordController.farm = data!;
//
//                                       //         return  DropdownSearch<OutbreakFarmFromServer>(
//                                       //           popupProps: PopupProps.modalBottomSheet(
//                                       //               showSelectedItems: true,
//                                       //               showSearchBox: true,
//                                       //               itemBuilder: (context, item, selected){
//                                       //                 return ListTile(
//                                       //                   title: Text(item.farmerName.toString(),
//                                       //                       style: selected ? TextStyle(color: AppColor.primary) : const TextStyle()),
//                                       //                   subtitle: Text(item.outbreaksId.toString(),
//                                       //                   ),
//                                       //                 );
//                                       //               },
//                                       //               title: const Padding(
//                                       //                 padding: EdgeInsets.symmetric(vertical: 15),
//                                       //                 child: Center(
//                                       //                   child: Text('Select Farm',
//                                       //                     style: TextStyle(fontWeight: FontWeight.w500),),
//                                       //                 ),
//                                       //               ),
//                                       //               disabledItemFn: (OutbreakFarmFromServer s) => false,
//                                       //               modalBottomSheetProps: ModalBottomSheetProps(
//                                       //                 elevation: 6,
//                                       //                 shape: RoundedRectangleBorder(
//                                       //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
//                                       //                 ),
//                                       //               ),
//                                       //               searchFieldProps: TextFieldProps(
//                                       //                 decoration: InputDecoration(
//                                       //                   contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//                                       //                   enabledBorder: inputBorder,
//                                       //                   focusedBorder: inputBorderFocused,
//                                       //                   errorBorder: inputBorder,
//                                       //                   focusedErrorBorder: inputBorderFocused,
//                                       //                   filled: true,
//                                       //                   fillColor: AppColor.xLightBackground,
//                                       //                 ),
//                                       //               )
//                                       //           ),
//                                       //           dropdownDecoratorProps: DropDownDecoratorProps(
//                                       //             dropdownSearchDecoration: InputDecoration(
//                                       //               contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//                                       //               enabledBorder: inputBorder,
//                                       //               focusedBorder: inputBorderFocused,
//                                       //               errorBorder: inputBorder,
//                                       //               focusedErrorBorder: inputBorderFocused,
//                                       //               filled: true,
//                                       //               fillColor: AppColor.xLightBackground,
//                                       //             ),
//                                       //           ),
//                                       //           asyncItems: (String filter) async {
//                                       //             var response = await editInitialTreatmentMonitoringRecordController.globalController.database!.outbreakFarmFromServerDao.findAllOutbreakFarmFromServer();
//                                       //             return response;
//                                       //           },
//                                       //           itemAsString: (OutbreakFarmFromServer d) => d.farmId?.toString() ?? '',
//                                       //           filterFn: (OutbreakFarmFromServer d, filter) => d.farmerName.toString().toLowerCase().contains(filter.toLowerCase()),
//                                       //           compareFn: (farm, filter) => farm.farmId == filter.farmId,
//                                       //           onChanged: (val) {
//                                       //             editInitialTreatmentMonitoringRecordController.farm = val!;
//                                       //             editInitialTreatmentMonitoringRecordController.farmSizeTC?.text = val.farmArea.toString();
//                                       //           },
//                                       //           autoValidateMode: AutovalidateMode.always,
//                                       //           selectedItem: data,
//                                       //           validator: (item) {
//                                       //             if (item == null) {
//                                       //               return 'Farm is required';
//                                       //             } else {
//                                       //               return null;
//                                       //             }
//                                       //           },
//                                       //         );
//                                       //       }
//                                       //     }
//
//                                       //     // Displaying LoadingSpinner to indicate waiting state
//                                       //     return const Center(
//                                       //       child: CircularProgressIndicator(),
//                                       //     );
//                                       //   },
//
//                                       //   // Future that needs to be resolved
//                                       //   // inorder to display something on the Canvas
//                                       //   future: globalController.database!.outbreakFarmFromServerDao.findOutbreakFarmFromServerByFarmId(widget.monitor.farmTblForeignkey.toString()),
//                                       // ),
//                                       // const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Farm Reference Number',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .farmReferenceNumberTC,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         keyboardType: TextInputType.url,
//                                         textCapitalization:
//                                             TextCapitalization.characters,
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         validator: FarmReferencePatternValidator
//                                             .validate,
//                                       ),
//
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Farm Size (in hectares)',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .farmSizeTC,
//                                         readOnly: false,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         keyboardType:
//                                             TextInputType.numberWithOptions(
//                                                 decimal: true),
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (String? value) =>
//                                             value!.trim().isEmpty
//                                                 ? "Farm size is required"
//                                                 : null,
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Area Covered (in hectares)',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .areaCoveredTC,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         keyboardType: TextInputType.number,
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         onChanged: (value) {
//                                           // editInitialTreatmentMonitoringRecordController
//                                           //     .areaCoveredTC?.text = value;
//                                           editInitialTreatmentMonitoringRecordController
//                                               .numberInGroupTC
//                                               ?.clear();
//                                           editInitialTreatmentMonitoringRecordController
//                                               .clearRehabAssistantsToDefault();
//                                           editInitialTreatmentMonitoringRecordController
//                                               .updateAreaCovered();
//                                           editInitialTreatmentMonitoringRecordController
//                                               .update();
//                                         },
//                                         validator: (String? value) =>
//                                             value!.trim().isEmpty
//                                                 ? "Area covered is required"
//                                                 : null,
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Number of Cocoa Seedlings Alive ',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .cocoaSeedlingsAliveTC,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         keyboardType: TextInputType.number,
//                                         inputFormatters: [
//                                           FilteringTextInputFormatter.digitsOnly
//                                         ],
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (String? value) => value!
//                                                 .trim()
//                                                 .isEmpty
//                                             ? "Number of cocoa seedlings alive is required"
//                                             : null,
//                                       ),
//
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Number of Plantain Seedlings Alive ',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .plantainSeedlingsAliveTC,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         keyboardType: TextInputType.number,
//                                         inputFormatters: [
//                                           FilteringTextInputFormatter.digitsOnly
//                                         ],
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (String? value) => value!
//                                                 .trim()
//                                                 .isEmpty
//                                             ? "Number of plantain seedlings alive is required"
//                                             : null,
//                                       ),
//
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Name of CHED TA',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .cHEDTATC,
//                                         textCapitalization:
//                                             TextCapitalization.words,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         maxLines: null,
//                                         keyboardType: TextInputType.name,
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (String? value) =>
//                                             value!.trim().isEmpty
//                                                 ? "CHED TA name is required"
//                                                 : null,
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'CHED TA Contact Number',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .cHEDTAContactTC,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         textInputAction: TextInputAction.next,
//                                         keyboardType: TextInputType.phone,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (String? value) =>
//                                             value!.trim().isEmpty ||
//                                                     value.trim().length != 10
//                                                 ? "Enter a valid phone number"
//                                                 : null,
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       /*  const Text(
//                                         'Community',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .communityNameTC,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         keyboardType: TextInputType.text,
//                                         textInputAction: TextInputAction.next,
//                                         validator: (String? value) =>
//                                             value!.trim().isEmpty
//                                                 ? "Community is required"
//                                                 : null,
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'District',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       DropdownSearch<RegionDistrict>(
//                                         popupProps: PopupProps.modalBottomSheet(
//                                             showSelectedItems: true,
//                                             showSearchBox: true,
//                                             itemBuilder:
//                                                 (context, item, selected) {
//                                               return ListTile(
//                                                 title: Text(
//                                                     item.districtName
//                                                         .toString(),
//                                                     style: selected
//                                                         ? TextStyle(
//                                                             color: AppColor
//                                                                 .primary)
//                                                         : const TextStyle()),
//                                                 subtitle: Text(
//                                                   item.regionName.toString(),
//                                                 ),
//                                               );
//                                             },
//                                             title: const Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   vertical: 15),
//                                               child: Center(
//                                                 child: Text(
//                                                   'Select district',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 ),
//                                               ),
//                                             ),
//                                             disabledItemFn:
//                                                 (RegionDistrict s) => false,
//                                             modalBottomSheetProps:
//                                                 ModalBottomSheetProps(
//                                               elevation: 6,
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.only(
//                                                       topLeft: Radius.circular(
//                                                           AppBorderRadius.md),
//                                                       topRight: Radius.circular(
//                                                           AppBorderRadius.md))),
//                                             ),
//                                             searchFieldProps: TextFieldProps(
//                                               decoration: InputDecoration(
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 4,
//                                                         horizontal: 15),
//                                                 enabledBorder: inputBorder,
//                                                 focusedBorder:
//                                                     inputBorderFocused,
//                                                 errorBorder: inputBorder,
//                                                 focusedErrorBorder:
//                                                     inputBorderFocused,
//                                                 filled: true,
//                                                 fillColor:
//                                                     AppColor.xLightBackground,
//                                               ),
//                                             )),
//                                         dropdownDecoratorProps:
//                                             DropDownDecoratorProps(
//                                           dropdownSearchDecoration:
//                                               InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 4,
//                                                     horizontal: 15),
//                                             enabledBorder: inputBorder,
//                                             focusedBorder: inputBorderFocused,
//                                             errorBorder: inputBorder,
//                                             focusedErrorBorder:
//                                                 inputBorderFocused,
//                                             filled: true,
//                                             fillColor:
//                                                 AppColor.xLightBackground,
//                                           ),
//                                         ),
//                                         asyncItems: (String filter) async {
//                                           var response =
//                                               await editInitialTreatmentMonitoringRecordController
//                                                   .globalController
//                                                   .database!
//                                                   .regionDistrictDao
//                                                   .findAllRegionDistrict();
//                                           return response;
//                                         },
//                                         itemAsString: (RegionDistrict d) =>
//                                             d.districtName ?? '',
//                                         // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                         compareFn: (d, filter) =>
//                                             d.districtName ==
//                                             filter.districtName,
//                                         onChanged: (val) {
//                                           editInitialTreatmentMonitoringRecordController
//                                               .regionDistrict = val;
//                                         },
//                                         selectedItem:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .regionDistrict,
//                                         autoValidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (item) {
//                                           if (item == null) {
//                                             return 'District is required';
//                                           } else {
//                                             return null;
//                                           }
//                                         },
//                                       ),*/
//
//                                       const Text(
//                                         'Community',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       DropdownSearch<Community>(
//                                         popupProps: PopupProps.modalBottomSheet(
//                                             showSelectedItems: true,
//                                             showSearchBox: true,
//                                             itemBuilder:
//                                                 (context, item, selected) {
//                                               return ListTile(
//                                                 title: Text(
//                                                     item.community.toString(),
//                                                     style: selected
//                                                         ? TextStyle(
//                                                             color: AppColor
//                                                                 .primary)
//                                                         : const TextStyle()),
//                                                 subtitle: Text(
//                                                   item.operationalArea
//                                                       .toString(),
//                                                 ),
//                                               );
//                                             },
//                                             title: const Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   vertical: 15),
//                                               child: Center(
//                                                 child: Text(
//                                                   'Select community',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 ),
//                                               ),
//                                             ),
//                                             disabledItemFn: (Community s) =>
//                                                 false,
//                                             modalBottomSheetProps:
//                                                 ModalBottomSheetProps(
//                                               elevation: 6,
//                                               shape: RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.only(
//                                                       topLeft: Radius.circular(
//                                                           AppBorderRadius.md),
//                                                       topRight: Radius.circular(
//                                                           AppBorderRadius.md))),
//                                             ),
//                                             searchFieldProps: TextFieldProps(
//                                               decoration: InputDecoration(
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 4,
//                                                         horizontal: 15),
//                                                 enabledBorder: inputBorder,
//                                                 focusedBorder:
//                                                     inputBorderFocused,
//                                                 errorBorder: inputBorder,
//                                                 focusedErrorBorder:
//                                                     inputBorderFocused,
//                                                 filled: true,
//                                                 fillColor:
//                                                     AppColor.xLightBackground,
//                                               ),
//                                             )),
//                                         dropdownDecoratorProps:
//                                             DropDownDecoratorProps(
//                                           dropdownSearchDecoration:
//                                               InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 4,
//                                                     horizontal: 15),
//                                             enabledBorder: inputBorder,
//                                             focusedBorder: inputBorderFocused,
//                                             errorBorder: inputBorder,
//                                             focusedErrorBorder:
//                                                 inputBorderFocused,
//                                             filled: true,
//                                             fillColor:
//                                                 AppColor.xLightBackground,
//                                           ),
//                                         ),
//                                         asyncItems: (String filter) async {
//                                           var response =
//                                               await editInitialTreatmentMonitoringRecordController
//                                                   .globalController
//                                                   .database!
//                                                   .communityDao
//                                                   .findAllCommunity();
//                                           return response;
//                                         },
//                                         itemAsString: (Community d) =>
//                                             d.community ?? '',
//                                         // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                         compareFn: (d, filter) =>
//                                             d.community == filter.community,
//                                         onChanged: (val) {
//                                           editInitialTreatmentMonitoringRecordController
//                                               .community = val;
//                                         },
//                                         selectedItem:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .community,
//                                         autoValidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (item) {
//                                           if (item == null) {
//                                             return 'Community is required';
//                                           } else {
//                                             return null;
//                                           }
//                                         },
//                                       ),
//
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Operational Area',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                         controller:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .operationalAreaTC,
//                                         textCapitalization:
//                                             TextCapitalization.words,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 15, horizontal: 15),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                               inputBorderFocused,
//                                           filled: true,
//                                           fillColor: AppColor.xLightBackground,
//                                         ),
//                                         maxLines: null,
//                                         keyboardType: TextInputType.name,
//                                         textInputAction: TextInputAction.next,
//                                         autovalidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (String? value) =>
//                                             value!.trim().isEmpty
//                                                 ? "Operational area is required"
//                                                 : null,
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Activity',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       GetBuilder(
//                                           init:
//                                               editInitialTreatmentMonitoringRecordController,
//                                           builder: (ctx) {
//                                             return DropdownSearch<Activity>(
//                                               popupProps:
//                                                   PopupProps.modalBottomSheet(
//                                                       showSelectedItems: true,
//                                                       showSearchBox: true,
//                                                       title: const Padding(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 vertical: 15),
//                                                         child: Center(
//                                                           child: Text(
//                                                             'Select Activity',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       disabledItemFn:
//                                                           (Activity s) => false,
//                                                       modalBottomSheetProps:
//                                                           ModalBottomSheetProps(
//                                                         elevation: 6,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.only(
//                                                                 topLeft: Radius
//                                                                     .circular(
//                                                                         AppBorderRadius
//                                                                             .md),
//                                                                 topRight: Radius
//                                                                     .circular(
//                                                                         AppBorderRadius
//                                                                             .md))),
//                                                       ),
//                                                       searchFieldProps:
//                                                           TextFieldProps(
//                                                         decoration:
//                                                             InputDecoration(
//                                                           contentPadding:
//                                                               const EdgeInsets
//                                                                       .symmetric(
//                                                                   vertical: 4,
//                                                                   horizontal:
//                                                                       15),
//                                                           enabledBorder:
//                                                               inputBorder,
//                                                           focusedBorder:
//                                                               inputBorderFocused,
//                                                           errorBorder:
//                                                               inputBorder,
//                                                           focusedErrorBorder:
//                                                               inputBorderFocused,
//                                                           filled: true,
//                                                           fillColor: AppColor
//                                                               .xLightBackground,
//                                                         ),
//                                                       )),
//                                               dropdownDecoratorProps:
//                                                   DropDownDecoratorProps(
//                                                 dropdownSearchDecoration:
//                                                     InputDecoration(
//                                                   contentPadding:
//                                                       const EdgeInsets
//                                                               .symmetric(
//                                                           vertical: 4,
//                                                           horizontal: 15),
//                                                   enabledBorder: inputBorder,
//                                                   focusedBorder:
//                                                       inputBorderFocused,
//                                                   errorBorder: inputBorder,
//                                                   focusedErrorBorder:
//                                                       inputBorderFocused,
//                                                   filled: true,
//                                                   fillColor:
//                                                       AppColor.xLightBackground,
//                                                 ),
//                                               ),
//                                               asyncItems:
//                                                   (String filter) async {
//                                                 // var response = await editInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findAllMainActivity();
//                                                 var response =
//                                                     await editInitialTreatmentMonitoringRecordController
//                                                         .globalController
//                                                         .database!
//                                                         .activityDao
//                                                         .findAllActivityWithMainActivityList([
//                                                   MainActivities
//                                                       .InitialTreatment
//                                                 ]);
//                                                 return response;
//                                               },
//                                               itemAsString: (Activity d) =>
//                                                   d.mainActivity?.toString() ??
//                                                   '',
//                                               // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                               compareFn: (activity, filter) =>
//                                                   activity.mainActivity
//                                                   filter.mainActivity,
//                                               onChanged: (val) {
//                                                 editInitialTreatmentMonitoringRecordController
//                                                     .activity = val!;
//                                                 editInitialTreatmentMonitoringRecordController
//                                                     .subActivity = Activity();
//                                                 editInitialTreatmentMonitoringRecordController
//                                                     .update();
//                                               },
//                                               autoValidateMode:
//                                                   AutovalidateMode.always,
//                                               selectedItem:
//                                                   editInitialTreatmentMonitoringRecordController
//                                                       .activity,
//                                               validator: (item) {
//                                                 if (item == null) {
//                                                   return 'Activity is required';
//                                                 } else {
//                                                   return null;
//                                                 }
//                                               },
//                                             );
//                                           }),
//                                       // FutureBuilder(
//                                       //   builder: (ctx, snapshot) {
//                                       //     // Checking if future is resolved or not
//                                       //     if (snapshot.connectionState == ConnectionState.done) {
//                                       //
//                                       //       if (snapshot.hasError) {
//                                       //         return Center(
//                                       //           child: Text(
//                                       //             '${snapshot.error} occurred',
//                                       //             style: TextStyle(fontSize: 18),
//                                       //           ),
//                                       //         );
//                                       //
//                                       //
//                                       //       } else if (snapshot.hasData) {
//                                       //
//                                       //         List? dataList = snapshot.data as List;
//                                       //         Activity? data = dataList.first as Activity?;
//                                       //         editInitialTreatmentMonitoringRecordController.activity = data!;
//                                       //
//                                       //         return  DropdownSearch<Activity>(
//                                       //           popupProps: PopupProps.modalBottomSheet(
//                                       //               showSelectedItems: true,
//                                       //               showSearchBox: true,
//                                       //               title: Padding(
//                                       //                 padding: const EdgeInsets.symmetric(vertical: 15),
//                                       //                 child: Center(
//                                       //                   child: Text('Select Activity',
//                                       //                     style: const TextStyle(fontWeight: FontWeight.w500),),
//                                       //                 ),
//                                       //               ),
//                                       //               disabledItemFn: (Activity s) => false,
//                                       //               modalBottomSheetProps: ModalBottomSheetProps(
//                                       //                 elevation: 6,
//                                       //                 shape: RoundedRectangleBorder(
//                                       //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
//                                       //                 ),
//                                       //               ),
//                                       //               searchFieldProps: TextFieldProps(
//                                       //                 decoration: InputDecoration(
//                                       //                   contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//                                       //                   enabledBorder: inputBorder,
//                                       //                   focusedBorder: inputBorderFocused,
//                                       //                   errorBorder: inputBorder,
//                                       //                   focusedErrorBorder: inputBorderFocused,
//                                       //                   filled: true,
//                                       //                   fillColor: AppColor.xLightBackground,
//                                       //                 ),
//                                       //               )
//                                       //           ),
//                                       //           dropdownDecoratorProps: DropDownDecoratorProps(
//                                       //             dropdownSearchDecoration: InputDecoration(
//                                       //               contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//                                       //               enabledBorder: inputBorder,
//                                       //               focusedBorder: inputBorderFocused,
//                                       //               errorBorder: inputBorder,
//                                       //               focusedErrorBorder: inputBorderFocused,
//                                       //               filled: true,
//                                       //               fillColor: AppColor.xLightBackground,
//                                       //             ),
//                                       //           ),
//                                       //           asyncItems: (String filter) async {
//                                       //             var response = await editInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findAllMainActivity();
//                                       //             return response;
//                                       //           },
//                                       //           itemAsString: (Activity d) => d.mainActivity!.toString(),
//                                       //           // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                       //           compareFn: (activity, filter) => activity.mainActivity == filter.mainActivity,
//                                       //           onChanged: (val) {
//                                       //             editInitialTreatmentMonitoringRecordController.activity = val!;
//                                       //             editInitialTreatmentMonitoringRecordController.subActivity = Activity();
//                                       //             editInitialTreatmentMonitoringRecordController.update();
//                                       //           },
//                                       //           autoValidateMode: AutovalidateMode.always,
//                                       //           selectedItem: editInitialTreatmentMonitoringRecordController.activity,
//                                       //           validator: (item) {
//                                       //             if (item == null) {
//                                       //               return 'Activity is required';
//                                       //             } else {
//                                       //               return null;
//                                       //             }
//                                       //           },
//                                       //         );
//                                       //       }
//                                       //     }
//                                       //
//                                       //     // Displaying LoadingSpinner to indicate waiting state
//                                       //     return Center(
//                                       //       child: CircularProgressIndicator(),
//                                       //     );
//                                       //   },
//                                       //
//                                       //   // Future that needs to be resolved
//                                       //   // inorder to display something on the Canvas
//                                       //   future: globalController.database!.activityDao.findActivityByCode(widget.monitor.activity!),
//                                       // ),
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Sub Activity',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       GetBuilder(
//                                           init:
//                                               editInitialTreatmentMonitoringRecordController,
//                                           builder: (ctx) {
//                                             return DropdownSearch<Activity>(
//                                               popupProps:
//                                                   PopupProps.modalBottomSheet(
//                                                       showSelectedItems: true,
//                                                       showSearchBox: true,
//                                                       title: const Padding(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 vertical: 15),
//                                                         child: Center(
//                                                           child: Text(
//                                                             'Select Sub Activity',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       disabledItemFn:
//                                                           (Activity s) => false,
//                                                       modalBottomSheetProps:
//                                                           ModalBottomSheetProps(
//                                                         elevation: 6,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.only(
//                                                                 topLeft: Radius
//                                                                     .circular(
//                                                                         AppBorderRadius
//                                                                             .md),
//                                                                 topRight: Radius
//                                                                     .circular(
//                                                                         AppBorderRadius
//                                                                             .md))),
//                                                       ),
//                                                       searchFieldProps:
//                                                           TextFieldProps(
//                                                         decoration:
//                                                             InputDecoration(
//                                                           contentPadding:
//                                                               const EdgeInsets
//                                                                       .symmetric(
//                                                                   vertical: 4,
//                                                                   horizontal:
//                                                                       15),
//                                                           enabledBorder:
//                                                               inputBorder,
//                                                           focusedBorder:
//                                                               inputBorderFocused,
//                                                           errorBorder:
//                                                               inputBorder,
//                                                           focusedErrorBorder:
//                                                               inputBorderFocused,
//                                                           filled: true,
//                                                           fillColor: AppColor
//                                                               .xLightBackground,
//                                                         ),
//                                                       )),
//                                               dropdownDecoratorProps:
//                                                   DropDownDecoratorProps(
//                                                 dropdownSearchDecoration:
//                                                     InputDecoration(
//                                                   contentPadding:
//                                                       const EdgeInsets
//                                                               .symmetric(
//                                                           vertical: 4,
//                                                           horizontal: 15),
//                                                   enabledBorder: inputBorder,
//                                                   focusedBorder:
//                                                       inputBorderFocused,
//                                                   errorBorder: inputBorder,
//                                                   focusedErrorBorder:
//                                                       inputBorderFocused,
//                                                   filled: true,
//                                                   fillColor:
//                                                       AppColor.xLightBackground,
//                                                 ),
//                                               ),
//                                               asyncItems:
//                                                   (String filter) async {
//                                                 var response =
//                                                     await editInitialTreatmentMonitoringRecordController
//                                                         .globalController
//                                                         .database!
//                                                         .activityDao
//                                                         .findSubActivities(
//                                                             editInitialTreatmentMonitoringRecordController
//                                                                     .activity
//                                                                     .mainActivity ??
//                                                                 '');
//                                                 return response;
//                                               },
//                                               itemAsString: (Activity d) =>
//                                                   d.subActivity?.toString() ??
//                                                   '',
//                                               // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                               compareFn: (activity, filter) =>
//                                                   activity.subActivity ==
//                                                   filter.subActivity,
//                                               onChanged: (val) {
//                                                 editInitialTreatmentMonitoringRecordController
//                                                     .subActivity = val!;
//                                                 editInitialTreatmentMonitoringRecordController
//                                                     .update();
//                                               },
//                                               autoValidateMode:
//                                                   AutovalidateMode.always,
//                                               selectedItem:
//                                                   editInitialTreatmentMonitoringRecordController
//                                                       .subActivity,
//                                               validator: (item) {
//                                                 if (item == null) {
//                                                   return 'Sub activity is required';
//                                                 } else {
//                                                   return null;
//                                                 }
//                                               },
//                                             );
//                                           }),
//
//                                       // FutureBuilder(
//                                       //   builder: (ctx, snapshot) {
//                                       //     // Checking if future is resolved or not
//                                       //     if (snapshot.connectionState == ConnectionState.done) {
//                                       //
//                                       //       if (snapshot.hasError) {
//                                       //         return Center(
//                                       //           child: Text(
//                                       //             '${snapshot.error} occurred',
//                                       //             style: TextStyle(fontSize: 18),
//                                       //           ),
//                                       //         );
//                                       //
//                                       //
//                                       //       } else if (snapshot.hasData) {
//                                       //
//                                       //         List? dataList = snapshot.data as List;
//                                       //         Activity? data = dataList.first as Activity?;
//                                       //         editInitialTreatmentMonitoringRecordController.subActivity = data!;
//                                       //
//                                       //         // Future.delayed(Duration.zero, () async {
//                                       //         //   editInitialTreatmentMonitoringRecordController.update();
//                                       //         // });
//                                       //
//                                       //         return  DropdownSearch<Activity>(
//                                       //           popupProps: PopupProps.modalBottomSheet(
//                                       //               showSelectedItems: true,
//                                       //               showSearchBox: true,
//                                       //               title: Padding(
//                                       //                 padding: const EdgeInsets.symmetric(vertical: 15),
//                                       //                 child: Center(
//                                       //                   child: Text('Select Sub Activity',
//                                       //                     style: const TextStyle(fontWeight: FontWeight.w500),),
//                                       //                 ),
//                                       //               ),
//                                       //               disabledItemFn: (Activity s) => false,
//                                       //               modalBottomSheetProps: ModalBottomSheetProps(
//                                       //                 elevation: 6,
//                                       //                 shape: RoundedRectangleBorder(
//                                       //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md))
//                                       //                 ),
//                                       //               ),
//                                       //               searchFieldProps: TextFieldProps(
//                                       //                 decoration: InputDecoration(
//                                       //                   contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//                                       //                   enabledBorder: inputBorder,
//                                       //                   focusedBorder: inputBorderFocused,
//                                       //                   errorBorder: inputBorder,
//                                       //                   focusedErrorBorder: inputBorderFocused,
//                                       //                   filled: true,
//                                       //                   fillColor: AppColor.xLightBackground,
//                                       //                 ),
//                                       //               )
//                                       //           ),
//                                       //           dropdownDecoratorProps: DropDownDecoratorProps(
//                                       //             dropdownSearchDecoration: InputDecoration(
//                                       //               contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//                                       //               enabledBorder: inputBorder,
//                                       //               focusedBorder: inputBorderFocused,
//                                       //               errorBorder: inputBorder,
//                                       //               focusedErrorBorder: inputBorderFocused,
//                                       //               filled: true,
//                                       //               fillColor: AppColor.xLightBackground,
//                                       //             ),
//                                       //           ),
//                                       //           asyncItems: (String filter) async {
//                                       //             var response = await editInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findSubActivities(editInitialTreatmentMonitoringRecordController.activity.mainActivity ?? '');
//                                       //             return response;
//                                       //           },
//                                       //           itemAsString: (Activity d) => d.subActivity!.toString(),
//                                       //           // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
//                                       //           compareFn: (activity, filter) => activity.subActivity == filter.subActivity,
//                                       //           onChanged: (val) {
//                                       //             editInitialTreatmentMonitoringRecordController.subActivity = val!;
//                                       //             editInitialTreatmentMonitoringRecordController.update();
//                                       //           },
//                                       //           autoValidateMode: AutovalidateMode.always,
//                                       //           selectedItem: data,
//                                       //           validator: (item) {
//                                       //             if (item == null) {
//                                       //               return 'Sub activity is required';
//                                       //             } else {
//                                       //               return null;
//                                       //             }
//                                       //           },
//                                       //         );
//                                       //       }
//                                       //     }
//                                       //
//                                       //     // Displaying LoadingSpinner to indicate waiting state
//                                       //     return Center(
//                                       //       child: CircularProgressIndicator(),
//                                       //     );
//                                       //   },
//                                       //
//                                       //   // Future that needs to be resolved
//                                       //   // inorder to display something on the Canvas
//                                       //   future: globalController.database!.activityDao.findActivityByCode(widget.monitor.activity!),
//                                       // ),
//
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'General Remarks',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       TextFormField(
//                                           controller:
//                                               editInitialTreatmentMonitoringRecordController
//                                                   .remarksTC,
//                                           textCapitalization:
//                                               TextCapitalization.sentences,
//                                           decoration: InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 15,
//                                                     horizontal: 15),
//                                             enabledBorder: inputBorder,
//                                             focusedBorder: inputBorderFocused,
//                                             errorBorder: inputBorder,
//                                             focusedErrorBorder:
//                                                 inputBorderFocused,
//                                             filled: true,
//                                             fillColor:
//                                                 AppColor.xLightBackground,
//                                           ),
//                                           maxLines: null,
//                                           textInputAction:
//                                               TextInputAction.done),
//
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Picture of Farm',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       GetBuilder(
//                                           init:
//                                               editInitialTreatmentMonitoringRecordController,
//                                           builder: (context) {
//                                             return ImageFieldCard(
//                                               onTap: () =>
//                                                   editInitialTreatmentMonitoringRecordController
//                                                       .chooseMediaSource(),
//                                               image:
//                                                   editInitialTreatmentMonitoringRecordController
//                                                       .farmPhoto?.file,
//                                               base64Image: base64Encode(widget
//                                                       .monitor.currentFarmPic ??
//                                                   []),
//                                             );
//                                           }),
//
//                                       // if (!widget.isViewMode)
//                                       // GetBuilder(
//                                       //     init: editInitialTreatmentMonitoringRecordController,
//                                       //     builder: (ctx) {
//                                       //       return editInitialTreatmentMonitoringRecordController.farmPhoto?.file == null
//                                       //           ? Padding(
//                                       //         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                                       //         child: Column(
//                                       //           crossAxisAlignment: CrossAxisAlignment.start,
//                                       //           mainAxisSize: MainAxisSize.min,
//                                       //           children: [
//                                       //             const SizedBox(height: 8),
//                                       //             Text('Picture of farm is required',
//                                       //               style: Theme.of(context).textTheme.caption!.copyWith(
//                                       //                   color: Colors.red[700]
//                                       //               ),
//                                       //             ),
//                                       //           ],
//                                       //         ),
//                                       //       )
//                                       //           : Container();
//                                       //     }
//                                       // ),
//
//                                       const SizedBox(height: 20),
//
//                                       const Text(
//                                         'Was The Activity Done By A Contractor',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       DropdownSearch<String>(
//                                         popupProps: PopupProps.menu(
//                                             showSelectedItems: true,
//                                             disabledItemFn: (String s) => false,
//                                             fit: FlexFit.loose,
//                                             menuProps: MenuProps(
//                                                 elevation: 6,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         AppBorderRadius.sm))),
//                                         items:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .yesNoItems,
//                                         dropdownDecoratorProps:
//                                             DropDownDecoratorProps(
//                                           dropdownSearchDecoration:
//                                               InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 4,
//                                                     horizontal: 15),
//                                             enabledBorder: inputBorder,
//                                             focusedBorder: inputBorderFocused,
//                                             errorBorder: inputBorder,
//                                             focusedErrorBorder:
//                                                 inputBorderFocused,
//                                             filled: true,
//                                             fillColor:
//                                                 AppColor.xLightBackground,
//                                           ),
//                                         ),
//                                         autoValidateMode:
//                                             AutovalidateMode.always,
//                                         validator: (item) {
//                                           if (item == null) {
//                                             return "field is required";
//                                           } else {
//                                             return null;
//                                           }
//                                         },
//                                         onChanged: (val) {
//                                           editInitialTreatmentMonitoringRecordController
//                                               .isContractor.value = val!;
//                                           editInitialTreatmentMonitoringRecordController
//                                               .isCompletedByGroup.value = '';
//
//                                           editInitialTreatmentMonitoringRecordController
//                                               .clearAllRehabAssistants();
//
//                                           editInitialTreatmentMonitoringRecordController
//                                               .numberInGroupTC
//                                               ?.clear();
//                                           editInitialTreatmentMonitoringRecordController
//                                               .contractorNameTC
//                                               ?.clear();
//                                           // editInitialTreatmentMonitoringRecordController.areaCoveredRx.value = '';
//                                           editInitialTreatmentMonitoringRecordController
//                                               .update();
//                                         },
//                                         selectedItem: widget
//                                             .monitor.completedByContractor,
//                                       ),
//
//                                       GetBuilder(
//                                         init:
//                                             editInitialTreatmentMonitoringRecordController,
//                                         builder: (ctx) {
//                                           return editInitialTreatmentMonitoringRecordController
//                                                       .isContractor.value ==
//                                                   YesNo.yes
//                                               ? Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const SizedBox(
//                                                       height: 20,
//                                                     ),
//                                                     const Text(
//                                                       'Name of Contractor',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w500),
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     TextFormField(
//                                                       controller:
//                                                           editInitialTreatmentMonitoringRecordController
//                                                               .contractorNameTC,
//                                                       textCapitalization:
//                                                           TextCapitalization
//                                                               .words,
//                                                       decoration:
//                                                           InputDecoration(
//                                                         contentPadding:
//                                                             const EdgeInsets
//                                                                     .symmetric(
//                                                                 vertical: 15,
//                                                                 horizontal: 15),
//                                                         enabledBorder:
//                                                             inputBorder,
//                                                         focusedBorder:
//                                                             inputBorderFocused,
//                                                         errorBorder:
//                                                             inputBorder,
//                                                         focusedErrorBorder:
//                                                             inputBorderFocused,
//                                                         filled: true,
//                                                         fillColor: AppColor
//                                                             .xLightBackground,
//                                                       ),
//                                                       maxLines: null,
//                                                       keyboardType:
//                                                           TextInputType.name,
//                                                       textInputAction:
//                                                           TextInputAction.next,
//                                                       validator: (String?
//                                                               value) =>
//                                                           value!.trim().isEmpty
//                                                               ? "Contractor name is required"
//                                                               : null,
//                                                     ),
//                                                   ],
//                                                 )
//                                               : Container();
//                                         },
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       /*  const Text(
//                                         'Task Status',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         height: 5,
//                                       ),
//                                       DropdownSearch<String>(
//                                         popupProps: PopupProps.menu(
//                                             showSelectedItems: true,
//                                             disabledItemFn: (String s) => false,
//                                             fit: FlexFit.loose,
//                                             menuProps: MenuProps(
//                                                 elevation: 6,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         AppBorderRadius.sm))),
//                                         items:
//                                             editInitialTreatmentMonitoringRecordController
//                                                 .taskStatusItems,
//                                         dropdownDecoratorProps:
//                                             DropDownDecoratorProps(
//                                           dropdownSearchDecoration:
//                                               InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 4,
//                                                     horizontal: 15),
//                                             enabledBorder: inputBorder,
//                                             focusedBorder: inputBorderFocused,
//                                             errorBorder: inputBorder,
//                                             focusedErrorBorder:
//                                                 inputBorderFocused,
//                                             filled: true,
//                                             fillColor:
//                                                 AppColor.xLightBackground,
//                                           ),
//                                         ),
//                                         autoValidateMode:
//                                             AutovalidateMode.always,
//                                         selectedItem: widget.monitor.remark,
//                                         validator: (item) {
//                                           if (item == null) {
//                                             return "Task status is required";
//                                           } else {
//                                             return null;
//                                           }
//                                         },
//                                         onChanged: (val) {
//                                           editInitialTreatmentMonitoringRecordController
//                                               .taskStatus = val!;
//                                         },
//                                       ),
//
//                                       const SizedBox(height: 20),*/
//
//                                       GetBuilder(
//                                         init:
//                                             editInitialTreatmentMonitoringRecordController,
//                                         builder: (ctx) {
//                                           return editInitialTreatmentMonitoringRecordController
//                                                       .isContractor.value ==
//                                                   YesNo.no
//                                               ? Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const SizedBox(
//                                                       height: 20,
//                                                     ),
//                                                     const Text(
//                                                       'Was The Activity Done By A Group',
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.w500),
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 5,
//                                                     ),
//                                                     DropdownSearch<String>(
//                                                       popupProps: PopupProps.menu(
//                                                           showSelectedItems:
//                                                               true,
//                                                           disabledItemFn:
//                                                               (String s) =>
//                                                                   false,
//                                                           fit: FlexFit.loose,
//                                                           menuProps: MenuProps(
//                                                               elevation: 6,
//                                                               borderRadius:
//                                                                   BorderRadius.circular(
//                                                                       AppBorderRadius
//                                                                           .sm))),
//                                                       items:
//                                                           editInitialTreatmentMonitoringRecordController
//                                                               .yesNoItems,
//                                                       dropdownDecoratorProps:
//                                                           DropDownDecoratorProps(
//                                                         dropdownSearchDecoration:
//                                                             InputDecoration(
//                                                           contentPadding:
//                                                               const EdgeInsets
//                                                                       .symmetric(
//                                                                   vertical: 4,
//                                                                   horizontal:
//                                                                       15),
//                                                           enabledBorder:
//                                                               inputBorder,
//                                                           focusedBorder:
//                                                               inputBorderFocused,
//                                                           errorBorder:
//                                                               inputBorder,
//                                                           focusedErrorBorder:
//                                                               inputBorderFocused,
//                                                           filled: true,
//                                                           fillColor: AppColor
//                                                               .xLightBackground,
//                                                         ),
//                                                       ),
//                                                       autoValidateMode:
//                                                           AutovalidateMode
//                                                               .always,
//                                                       validator: (item) {
//                                                         if (item == null) {
//                                                           return "field is required";
//                                                         } else {
//                                                           return null;
//                                                         }
//                                                       },
//                                                       onChanged: (val) {
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .isCompletedByGroup
//                                                             .value = val!;
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .areaCoveredRx
//                                                             .value = '';
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .clearRehabAssistantsToDefault();
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .numberInGroupTC
//                                                             ?.clear();
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .update();
//                                                       },
//                                                       selectedItem: widget
//                                                           .monitor.groupWork,
//                                                     ),
//                                                   ],
//                                                 )
//                                               : Container();
//                                         },
//                                       ),
//                                       const SizedBox(height: 20),
//
//                                       GetBuilder(
//                                         init:
//                                             editInitialTreatmentMonitoringRecordController,
//                                         builder: (ctx) {
//                                           if (editInitialTreatmentMonitoringRecordController
//                                                       .isContractor.value ==
//                                                   YesNo.no &&
//                                               editInitialTreatmentMonitoringRecordController
//                                                       .isCompletedByGroup
//                                                       .value ==
//                                                   YesNo.yes) {
//                                             return Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 const Text(
//                                                   'Number of People In Group',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 TextFormField(
//                                                     controller:
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .numberInGroupTC,
//                                                     decoration: InputDecoration(
//                                                       contentPadding:
//                                                           const EdgeInsets
//                                                                   .symmetric(
//                                                               vertical: 15,
//                                                               horizontal: 15),
//                                                       enabledBorder:
//                                                           inputBorder,
//                                                       focusedBorder:
//                                                           inputBorderFocused,
//                                                       errorBorder: inputBorder,
//                                                       focusedErrorBorder:
//                                                           inputBorderFocused,
//                                                       filled: true,
//                                                       fillColor: AppColor
//                                                           .xLightBackground,
//                                                     ),
//                                                     keyboardType:
//                                                         TextInputType.number,
//                                                     inputFormatters: [
//                                                       FilteringTextInputFormatter
//                                                           .digitsOnly
//                                                     ],
//                                                     // const TextInputType
//                                                     //         .numberWithOptions(
//                                                     //     signed: true, decimal: false),
//                                                     // inputFormatters: <
//                                                     //     TextInputFormatter>[
//                                                     //   FilteringTextInputFormatter
//                                                     //       .digitsOnly
//                                                     // ],
//                                                     textInputAction:
//                                                         TextInputAction.next,
//                                                     validator: (String?
//                                                             value) =>
//                                                         value!.trim().isEmpty
//                                                             ? "Number of People In Group is required"
//                                                             : null,
//                                                     onChanged: (value) {
//                                                       editInitialTreatmentMonitoringRecordController
//                                                           .clearRehabAssistantsToDefault();
//
//                                                       editInitialTreatmentMonitoringRecordController
//                                                           .updateAreaCovered();
//
//                                                       editInitialTreatmentMonitoringRecordController
//                                                           .update();
//                                                       FocusScope.of(context)
//                                                           .unfocus();
//                                                     }
//                                                     // (String? value) {
//                                                     //   if (value == null ||
//                                                     //       value.isEmpty) {
//                                                     //     return "Number of people in the group required";
//                                                     //   }
//                                                     //   int? intValue =
//                                                     //       int.tryParse(value);
//                                                     //   if (intValue == null) {
//                                                     //     return "$value is not a valid number";
//                                                     //   }
//                                                     //   return null;
//                                                     // }
//                                                     ),
//                                               ],
//                                             );
//                                           } else {
//                                             return Container();
//                                           }
//                                         },
//                                       ),
//
//                                       GetBuilder(
//                                         init:
//                                             editInitialTreatmentMonitoringRecordController,
//                                         builder: (ctx) {
//                                           bool groupHasNumber = int.tryParse(
//                                                   editInitialTreatmentMonitoringRecordController
//                                                       .numberInGroupTC!.text) !=
//                                               null;
//                                           // final isCompletedByGroup =
//                                           //     addInitialTreatmentMonitoringRecordController
//                                           //         .isCompletedByGroup;
//                                           if (groupHasNumber) {
//                                             return Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 Text('REHAB ASSISTANTS',
//                                                     style: TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: AppColor.black)),
//                                                 if (!widget.isViewMode)
//                                                   Text(
//                                                       'Select rehab assistants and their respective area covered',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           color:
//                                                               AppColor.black)),
//                                                 /*  Obx(
//                                                   () {
//                                                     final maxItems = int.tryParse(
//                                                             editInitialTreatmentMonitoringRecordController
//                                                                 .numberInGroupTC!
//                                                                 .text) ??
//                                                         0;
//                                                     final rehabAssistants =
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .rehabAssistants;
//
//                                                     print(
//                                                         rehabAssistants.length);
//
//                                                     if (maxItems !=
//                                                         rehabAssistants
//                                                             .length) {
//                                                       print('NOT TO EXECUTE');
//                                                       editInitialTreatmentMonitoringRecordController
//                                                           .clearRehabAssistantsToDefault();
//                                                       // You can also create new instances if needed
//                                                       editInitialTreatmentMonitoringRecordController
//                                                               .rehabAssistants =
//                                                           List.generate(
//                                                               maxItems,
//                                                               (i) => InitialTreatmentRehabAssistantSelect(
//                                                                   index: RxInt(i +
//                                                                       1))).obs;
//                                                     }
//
//                                                     final generatedWidgets =
//                                                         List<Widget>.generate(
//                                                             min(
//                                                                 maxItems,
//                                                                 rehabAssistants
//                                                                     .length),
//                                                             (i) {
//                                                       return rehabAssistants[i];
//                                                     });
//
//                                                     return Column(
//                                                       children:
//                                                           generatedWidgets,
//                                                       //  List.generate(
//                                                       //   min(
//                                                       //       maxItems,
//                                                       //       rehabAssistants
//                                                       //           .length), // Use min to limit the count
//                                                       //   (i) {
//                                                       //     return rehabAssistants[i];
//                                                       //   },
//                                                       // ),
//                                                     );
//                                                   },
//                                                 ),*/
//
//                                                 Obx(
//                                                   () {
//                                                     final rehabAssistants =
//                                                         editInitialTreatmentMonitoringRecordController
//                                                             .rehabAssistants;
//
//                                                     if (editInitialTreatmentMonitoringRecordController
//                                                             .isInitComplete
//                                                             .value !=
//                                                         true) {
//                                                       return const CircularProgressIndicator(); // Or any other loading indicator
//                                                     }
//
//                                                     final maxItems = int.tryParse(
//                                                             editInitialTreatmentMonitoringRecordController
//                                                                 .numberInGroupTC!
//                                                                 .text) ??
//                                                         0;
//
//                                                     if (maxItems !=
//                                                         rehabAssistants
//                                                             .length) {
//                                                       editInitialTreatmentMonitoringRecordController
//                                                           .clearRehabAssistantsToDefault();
//                                                       // You can also create new instances if needed
//                                                       editInitialTreatmentMonitoringRecordController
//                                                               .rehabAssistants =
//                                                           List.generate(
//                                                               maxItems,
//                                                               (i) => InitialTreatmentRehabAssistantSelect(
//                                                                   index: RxInt(i +
//                                                                       1))).obs;
//                                                     }
//
//                                                     final generatedWidgets =
//                                                         List<Widget>.generate(
//                                                             min(
//                                                                 maxItems,
//                                                                 rehabAssistants
//                                                                     .length),
//                                                             (i) {
//                                                       return rehabAssistants[i];
//                                                     });
//
//                                                     return Column(
//                                                       children:
//                                                           generatedWidgets,
//                                                       //  List.generate(
//                                                       //   min(
//                                                       //       maxItems,
//                                                       //       rehabAssistants
//                                                       //           .length), // Use min to limit the count
//                                                       //   (i) {
//                                                       //     return rehabAssistants[i];
//                                                       //   },
//                                                       // ),
//                                                     );
//                                                   },
//                                                 ),
//                                                 const SizedBox(height: 20),
//                                                 /*  Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             GestureDetector(
//                                               onTap: () {
//                                                 addInitialTreatmentMonitoringRecordController
//                                                     .rehabAssistants
//                                                     .add(InitialTreatmentRehabAssistantSelection(
//                                                         index: RxInt(
//                                                             addInitialTreatmentMonitoringRecordController
//                                                                     .rehabAssistants
//                                                                     .length +
//                                                                 1)));
//                                               },
//                                               behavior: HitTestBehavior.opaque,
//                                               child: Align(
//                                                 alignment:
//                                                     Alignment.bottomRight,
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                           .symmetric(
//                                                       horizontal: 10.0),
//                                                   child: Text(
//                                                     'Tap To Add Another Rehab Assistants',
//                                                     overflow: TextOverflow.clip,
//                                                     style: TextStyle(
//                                                         color: tmtColorPrimary,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             // GestureDetector(
//                                             //   onTap: () {
//                                             //     homeController
//                                             //         .usePolygonDrawingTool();
//                                             //   },
//                                             //   behavior:
//                                             //       HitTestBehavior.opaque,
//                                             //   child: Align(
//                                             //     alignment:
//                                             //         Alignment.bottomRight,
//                                             //     child: Padding(
//                                             //       padding:
//                                             //           const EdgeInsets
//                                             //                   .symmetric(
//                                             //               horizontal:
//                                             //                   10.0),
//                                             //       child: Text(
//                                             //         'Area Tool',
//                                             //         style: TextStyle(
//                                             //             color:
//                                             //                 tmtColorPrimary,
//                                             //             fontWeight:
//                                             //                 FontWeight
//                                             //                     .bold),
//                                             //       ),
//                                             //     ),
//                                             //   ),
//                                             // ),
//                                           ],
//                                         ),*/
//                                               ],
//                                             );
//                                           } else {
//                                             return Container();
//                                           }
//                                         },
//                                       ),
//
//                                       const SizedBox(height: 20),
//
//                                       const Divider(),
//
//                                       GetBuilder(
//                                         init:
//                                             editInitialTreatmentMonitoringRecordController,
//                                         builder: (ctx) {
//                                           final isCompletedByGroup =
//                                               editInitialTreatmentMonitoringRecordController
//                                                   .isCompletedByGroup;
//                                           if (isCompletedByGroup.value ==
//                                                   YesNo.no &&
//                                               editInitialTreatmentMonitoringRecordController
//                                                       .isContractor.value ==
//                                                   YesNo.no) {
//                                             // editInitialTreatmentMonitoringRecordController
//                                             //     .clearRehabAssistants();
//                                             return Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const SizedBox(
//                                                   height: 20,
//                                                 ),
//                                                 Text('REHAB ASSISTANTS',
//                                                     style: TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.w600,
//                                                         color: AppColor.black)),
//                                                 if (!widget.isViewMode)
//                                                   Text(
//                                                       'Select rehab assistants and their respective area covered',
//                                                       style: TextStyle(
//                                                           fontSize: 13,
//                                                           color:
//                                                               AppColor.black)),
//                                                 Obx(
//                                                   () => Column(
//                                                       children: List.generate(
//                                                           editInitialTreatmentMonitoringRecordController
//                                                               .rehabAssistants
//                                                               .length, (i) {
//                                                     return editInitialTreatmentMonitoringRecordController
//                                                         .rehabAssistants[i];
//                                                   })),
//                                                 ),
//                                                 if (!widget.isViewMode)
//                                                   const SizedBox(height: 30),
//                                                 if (!widget.isViewMode)
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       InkWell(
//                                                         highlightColor:
//                                                             Colors.green,
//                                                         // customBorder: ,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20),
//
//                                                         onTap: () {
//                                                           editInitialTreatmentMonitoringRecordController
//                                                               .rehabAssistants
//                                                               .add(InitialTreatmentRehabAssistantSelect(
//                                                                   index: RxInt(
//                                                                       editInitialTreatmentMonitoringRecordController
//                                                                               .rehabAssistants
//                                                                               .length +
//                                                                           1)));
//                                                         },
//                                                         // behavior: HitTestBehavior.opaque,
//                                                         child: Align(
//                                                           alignment: Alignment
//                                                               .bottomRight,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .symmetric(
//                                                                     vertical:
//                                                                         12,
//                                                                     horizontal:
//                                                                         10.0),
//                                                             child: Text(
//                                                               'Tap To Add Another Rehab Assistants',
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .clip,
//                                                               style: TextStyle(
//                                                                   color:
//                                                                       tmtColorPrimary,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       // GestureDetector(
//                                                       //   onTap: () {
//                                                       //     homeController
//                                                       //         .usePolygonDrawingTool();
//                                                       //   },
//                                                       //   behavior:
//                                                       //       HitTestBehavior.opaque,
//                                                       //   child: Align(
//                                                       //     alignment:
//                                                       //         Alignment.bottomRight,
//                                                       //     child: Padding(
//                                                       //       padding:
//                                                       //           const EdgeInsets
//                                                       //                   .symmetric(
//                                                       //               horizontal:
//                                                       //                   10.0),
//                                                       //       child: Text(
//                                                       //         'Area Tool',
//                                                       //         style: TextStyle(
//                                                       //             color:
//                                                       //                 tmtColorPrimary,
//                                                       //             fontWeight:
//                                                       //                 FontWeight
//                                                       //                     .bold),
//                                                       //       ),
//                                                       //     ),
//                                                       //   ),
//                                                       // ),
//                                                     ],
//                                                   ),
//                                               ],
//                                             );
//                                           } else {
//                                             return Container();
//                                           }
//                                         },
//                                       ),
//
//                                       // const SizedBox(height: 20),
//
//                                       // const SizedBox(height: 30,),
//
//                                       // GetBuilder(
//                                       //   init: editInitialTreatmentMonitoringRecordController,
//                                       //   builder: (context) {
//                                       //     return editInitialTreatmentMonitoringRecordController.subActivity.requiredEquipment ?? false
//                                       //     ? Column(
//                                       //       mainAxisSize: MainAxisSize.min,
//                                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                                       //       children: [
//
//                                       //         const SizedBox(height: 20),
//
//                                       //         const Divider(),
//
//                                       //         const SizedBox(height: 10),
//
//                                       //         Text('FUEL DETAILS',
//                                       //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColor.black)
//                                       //         ),
//
//                                       //         const SizedBox(height: 20),
//                                       //         const Text('Date Purchased',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         DateTimePicker(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelPurchasedDateTC,
//                                       //           type: DateTimePickerType.date,
//                                       //           initialDate: DateTime.now(),
//                                       //           dateMask: 'yyyy-MM-dd',
//                                       //           firstDate: DateTime(1600),
//                                       //           lastDate: DateTime.now(),
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //           onChanged: (val) => editInitialTreatmentMonitoringRecordController.fuelPurchasedDateTC?.text = val,
//                                       //           validator: (String? value) => value!.trim().isEmpty
//                                       //               ? "Date purchased is required"
//                                       //               : null,
//                                       //           onSaved: (val) => editInitialTreatmentMonitoringRecordController.fuelPurchasedDateTC?.text = val!,
//                                       //         ),
//
//                                       //         const SizedBox(height: 20),
//                                       //         const Text('Date',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         DateTimePicker(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelDateTC,
//                                       //           type: DateTimePickerType.date,
//                                       //           initialDate: DateTime.now(),
//                                       //           dateMask: 'yyyy-MM-dd',
//                                       //           firstDate: DateTime(1600),
//                                       //           lastDate: DateTime.now(),
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //           onChanged: (val) => editInitialTreatmentMonitoringRecordController.fuelDateTC?.text = val,
//                                       //           validator: (String? value) => value!.trim().isEmpty
//                                       //               ? "Date is required"
//                                       //               : null,
//                                       //           onSaved: (val) => editInitialTreatmentMonitoringRecordController.fuelDateTC?.text = val!,
//                                       //         ),
//
//                                       //         const SizedBox(height: 20),
//
//                                       //         const Text('Quantity Purchased',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         TextFormField(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelQuantityPurchasedTC,
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //           keyboardType: TextInputType.number,
//                                       //           textInputAction: TextInputAction.next,
//                                       //           validator: (String? value) => value!.trim().isEmpty
//                                       //               ? "Quantity is required"
//                                       //               : null,
//                                       //         ),
//
//                                       //         const SizedBox(height: 20),
//
//                                       //         const Text('Name of Receiving Operator',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         TextFormField(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelReceivingOperatorTC,
//                                       //           textCapitalization: TextCapitalization.words,
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //           textInputAction: TextInputAction.next,
//                                       //           validator: (String? value) => value!.trim().isEmpty
//                                       //               ? "Operator name is required"
//                                       //               : null,
//                                       //         ),
//
//                                       //         const SizedBox(height: 20),
//
//                                       //         const Text('Quantity (Ltr)',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         TextFormField(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelQuantityLtrTC,
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //           keyboardType: TextInputType.number,
//                                       //           textInputAction: TextInputAction.next,
//                                       //           validator: (String? value) => value!.trim().isEmpty
//                                       //               ? "Quantity is required"
//                                       //               : null,
//                                       //         ),
//
//                                       //         const SizedBox(height: 20),
//
//                                       //         const Text('Red Oil (Ltr)',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         TextFormField(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelRedOilLtrTC,
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //           keyboardType: TextInputType.number,
//                                       //           textInputAction: TextInputAction.next,
//                                       //           validator: (String? value) => value!.trim().isEmpty
//                                       //               ? "Quantity is required"
//                                       //               : null,
//                                       //         ),
//
//                                       //         const SizedBox(height: 20),
//
//                                       //         const Text('Engine Oil (Ltr)',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         TextFormField(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelEngineOilLtrTC,
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //           keyboardType: TextInputType.number,
//                                       //           textInputAction: TextInputAction.next,
//                                       //           validator: (String? value) => value!.trim().isEmpty
//                                       //               ? "Engine is required"
//                                       //               : null,
//                                       //         ),
//
//                                       //         // const SizedBox(height: 20),
//                                       //         // const Text('Area',
//                                       //         //   style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         // ),
//                                       //         // const SizedBox(height: 5,),
//                                       //         // TextFormField(
//                                       //         //   controller: editInitialTreatmentMonitoringRecordController.fuelAreaTC,
//                                       //         //   decoration: InputDecoration(
//                                       //         //     contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //         //     enabledBorder: inputBorder,
//                                       //         //     focusedBorder: inputBorderFocused,
//                                       //         //     errorBorder: inputBorder,
//                                       //         //     focusedErrorBorder: inputBorderFocused,
//                                       //         //     filled: true,
//                                       //         //     fillColor: AppColor.xLightBackground,
//                                       //         //   ),
//                                       //         //   keyboardType: TextInputType.number,
//                                       //         //   textInputAction: TextInputAction.next,
//                                       //         //   validator: (String? value) => value!.trim().isEmpty
//                                       //         //       ? "Area is required"
//                                       //         //       : null,
//                                       //         // ),
//
//                                       //         const SizedBox(height: 20),
//
//                                       //         const Text('Remarks',
//                                       //           style: TextStyle(fontWeight: FontWeight.w500),
//                                       //         ),
//                                       //         const SizedBox(height: 5,),
//                                       //         TextFormField(
//                                       //           controller: editInitialTreatmentMonitoringRecordController.fuelRemarksTC,
//                                       //           textCapitalization: TextCapitalization.sentences,
//                                       //           decoration: InputDecoration(
//                                       //             contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //             enabledBorder: inputBorder,
//                                       //             focusedBorder: inputBorderFocused,
//                                       //             errorBorder: inputBorder,
//                                       //             focusedErrorBorder: inputBorderFocused,
//                                       //             filled: true,
//                                       //             fillColor: AppColor.xLightBackground,
//                                       //           ),
//                                       //             maxLines: null,
//                                       //           textInputAction: TextInputAction.done
//                                       //         ),
//
//                                       //       ],
//                                       //     )
//                                       //     : Container();
//                                       //   }
//                                       // ),
//
//                                       // Column(
//                                       //   mainAxisSize: MainAxisSize.min,
//                                       //   crossAxisAlignment:
//                                       //       CrossAxisAlignment.start,
//                                       //   children: [
//                                       //     const SizedBox(height: 20),
//                                       //     Text(
//                                       //       'LOCATION',
//                                       //       style: TextStyle(
//                                       //           fontWeight: FontWeight.w700,
//                                       //           fontSize: 16,
//                                       //           color: AppColor.black),
//                                       //     ),
//                                       //     const SizedBox(height: 5),
//                                       //     Text(
//                                       //       'Lat : ${widget.monitor.lat}',
//                                       //       style: const TextStyle(
//                                       //           fontWeight: FontWeight.w500),
//                                       //     ),
//                                       //     Text(
//                                       //       'Lng : ${widget.monitor.lng}',
//                                       //       style: const TextStyle(
//                                       //           fontWeight: FontWeight.w500),
//                                       //     ),
//                                       //     Text(
//                                       //       'Accuracy : ${widget.monitor.accuracy}',
//                                       //       style: const TextStyle(
//                                       //           fontWeight: FontWeight.w500),
//                                       //     ),
//                                       //   ],
//                                       // ),
//
//                                       if (!widget.isViewMode)
//                                         const SizedBox(
//                                           height: 40,
//                                         ),
//
//                                       if (!widget.isViewMode)
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               child: CustomButton(
//                                                 isFullWidth: true,
//                                                 backgroundColor: AppColor.black,
//                                                 verticalPadding: 0.0,
//                                                 horizontalPadding: 8.0,
//                                                 onTap: () async {
//                                                   // if (!editInitialTreatmentMonitoringRecordController
//                                                   //     .isSaveButtonDisabled
//                                                   //     .value) {
//                                                   if (editInitialTreatmentMonitoringRecordController
//                                                       .editMonitoringRecordFormKey
//                                                       .currentState!
//                                                       .validate()) {
//                                                     editInitialTreatmentMonitoringRecordController
//                                                         .handleSaveOfflineMonitoringRecord();
//                                                   } else {
//                                                     editInitialTreatmentMonitoringRecordController
//                                                         .globals
//                                                         .showSnackBar(
//                                                             title: 'Alert',
//                                                             message:
//                                                                 'Kindly provide all required information');
//                                                   }
//                                                   // }
//                                                 },
//                                                 child:
//                                                     // Obx(
//                                                     //   () =>
//                                                     Text(
//                                                   // editInitialTreatmentMonitoringRecordController
//                                                   //         .isSaveButtonDisabled
//                                                   //         .value
//                                                   //     ? 'Please wait ...'
//                                                   //     :
//                                                   'Save',
//                                                   style: TextStyle(
//                                                       color: AppColor.white,
//                                                       fontSize: 14),
//                                                 ),
//                                                 // ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 20),
//                                             Expanded(
//                                               child: CustomButton(
//                                                 isFullWidth: true,
//                                                 backgroundColor:
//                                                     AppColor.primary,
//                                                 verticalPadding: 0.0,
//                                                 horizontalPadding: 8.0,
//                                                 onTap: () async {
//                                                   // if (!editInitialTreatmentMonitoringRecordController
//                                                   //     .isButtonDisabled.value) {
//                                                   if (editInitialTreatmentMonitoringRecordController
//                                                       .editMonitoringRecordFormKey
//                                                       .currentState!
//                                                       .validate()) {
//                                                     editInitialTreatmentMonitoringRecordController
//                                                         .handleAddMonitoringRecord();
//                                                   } else {
//                                                     editInitialTreatmentMonitoringRecordController
//                                                         .globals
//                                                         .showSnackBar(
//                                                             title: 'Alert',
//                                                             message:
//                                                                 'Kindly provide all required information');
//                                                   }
//                                                   // }
//                                                 },
//                                                 child:
//                                                     // Obx(
//                                                     //   () =>
//                                                     Text(
//                                                   // editInitialTreatmentMonitoringRecordController
//                                                   //         .isButtonDisabled
//                                                   //         .value
//                                                   //     ? 'Please wait ...'
//                                                   //     :
//                                                   'Submit',
//                                                   style: TextStyle(
//                                                       color: AppColor.white,
//                                                       fontSize: 14),
//                                                 ),
//                                                 // ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       // CustomButton(
//                                       //   child: Text(
//                                       //     'Submit',
//                                       //     style: TextStyle(color: AppColor.white, fontSize: 14),
//                                       //   ),
//                                       //   isFullWidth: true,
//                                       //   backgroundColor: AppColor.primary,
//                                       //   verticalPadding: 0.0,
//                                       //   horizontalPadding: 8.0,
//                                       //   onTap: () async{
//                                       //     if (!editInitialTreatmentMonitoringRecordController.isButtonDisabled.value){
//                                       //       if (editInitialTreatmentMonitoringRecordController.editMonitoringRecordFormKey.currentState!.validate()) {
//                                       //         editInitialTreatmentMonitoringRecordController.handleAddMonitoringRecord();
//                                       //       }else{
//                                       //         editInitialTreatmentMonitoringRecordController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
//                                       //       }
//                                       //     }
//                                       //   },
//                                       // ),
//
//                                       const SizedBox(height: 30),
//                                     ],
//                                   ),
//                                 );
//                               }),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
