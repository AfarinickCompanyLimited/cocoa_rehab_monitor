import 'package:cocoa_rehab_monitor/controller/db/activity_db.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/double_value_trimmer.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/contractor.dart';
import 'package:cocoa_rehab_monitor/controller/model/activity_model.dart';
import 'package:cocoa_rehab_monitor/controller/model/job_order_farms_model.dart';
import 'package:cocoa_rehab_monitor/view/global_components/image_field_card.dart';
import 'package:cocoa_rehab_monitor/view/utils/location_color.dart';
import 'add_workdone_verification_record_controller.dart';

class AddContractorCertificateVerificationRecord extends StatefulWidget {
  const AddContractorCertificateVerificationRecord({Key? key})
    : super(key: key);

  @override
  State<AddContractorCertificateVerificationRecord> createState() =>
      _AddContractorCertificateVerificationRecordState();
}

class _AddContractorCertificateVerificationRecordState
    extends State<AddContractorCertificateVerificationRecord> {
  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    int startingYear = 2022;
    List<int> yearList = List.generate((currentYear - startingYear) + 1, (
      index,
    ) {
      return startingYear + index;
    });
    // HomeController homeController = Get.find();
    AddContractorCertificateVerificationRecordController
    addContractorCertificateVerificationRecordController = Get.put(
      AddContractorCertificateVerificationRecordController(),
    );
    addContractorCertificateVerificationRecordController
        .addContractorCertificateVerificationRecordScreenContext = context;

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
                            'New Verification Form',
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
                        Form(
                          key:
                              addContractorCertificateVerificationRecordController
                                  .addContractorCertificateVerificationRecordFormKey,
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
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return "Current year is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addContractorCertificateVerificationRecordController
                                      .selectedYear
                                      .value = val!;
                                  addContractorCertificateVerificationRecordController
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
                                    addContractorCertificateVerificationRecordController
                                        .listOfMonths,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return "Current month is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addContractorCertificateVerificationRecordController
                                      .selectedMonth
                                      .value = val!;
                                  addContractorCertificateVerificationRecordController
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
                                    addContractorCertificateVerificationRecordController
                                        .listOfWeeks,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return "Current week is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addContractorCertificateVerificationRecordController
                                      .selectedWeek
                                      .value = val!;
                                  addContractorCertificateVerificationRecordController
                                      .update();
                                },
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
                                    padding: EdgeInsets.symmetric(vertical: 15),
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
                                  modalBottomSheetProps: ModalBottomSheetProps(
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
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                asyncItems: (String filter) async {
                                  // var response = await addInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findAllMainActivity();
                                  var response =
                                      await addContractorCertificateVerificationRecordController
                                          .jobDb
                                          .getAllFarms();
                                  return response;
                                },
                                itemAsString:
                                    (JobOrderFarmModel d) =>
                                        d.farmId.toString(),
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn:
                                    (activity, filter) => activity == filter,
                                onChanged: (val) {
                                  addContractorCertificateVerificationRecordController
                                      .farmReferenceNumberTC!
                                      .text = val!.farmId.toString();
                                  addContractorCertificateVerificationRecordController
                                      .farmerNameTC!
                                      .text = val.farmerName.toString();
                                  addContractorCertificateVerificationRecordController
                                      .farmSizeTC!
                                      .text = val.farmSize.toString();
                                  addContractorCertificateVerificationRecordController
                                      .communityNameTC!
                                      .text = val.location.toString();
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
                                  addContractorCertificateVerificationRecordController
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
                                'Farmer name',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller:
                                    addContractorCertificateVerificationRecordController
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
                                    addContractorCertificateVerificationRecordController
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
                                    addContractorCertificateVerificationRecordController
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
                              //         await addContractorCertificateVerificationRecordController
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
                              //     addContractorCertificateVerificationRecordController
                              //         .regionDistrict = val;
                              //   },
                              //   autoValidateMode: AutovalidateMode.always,
                              //   validator: (item) {
                              //     if (item == null) {
                              //       return 'District is required';
                              //     } else {
                              //       return null;
                              //     }
                              //   },
                              // ),

                              /* const Text(
                                'Community',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<Community>(
                                popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    itemBuilder: (context, item, selected) {
                                      return ListTile(
                                        title: Text(item.community.toString(),
                                            style: selected
                                                ? TextStyle(
                                                    color: AppColor.primary)
                                                : const TextStyle()),
                                        subtitle: Text(
                                          item.operationalArea.toString(),
                                        ),
                                      );
                                    },
                                    title: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select community',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    disabledItemFn: (Community s) => false,
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
                                  var response =
                                      await addContractorCertificateRecordController
                                          .globalController
                                          .database!
                                          .communityDao
                                          .findAllCommunity();
                                  return response;
                                },
                                itemAsString: (Community d) =>
                                    d.community ?? '',
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn: (d, filter) =>
                                    d.community == filter.community,
                                onChanged: (val) {
                                  addContractorCertificateRecordController
                                      .community = val;
                                },
                                selectedItem:
                                    addContractorCertificateRecordController
                                        .community,
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return 'Community is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),*/
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
                                    padding: EdgeInsets.symmetric(vertical: 15),
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
                                  modalBottomSheetProps: ModalBottomSheetProps(
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
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                items: [
                                  "Establishment",
                                  "Initial Treatment",
                                  "Maintenance",
                                ],
                                // asyncItems: (String filter) async {
                                //   ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
                                //   var response = await db.findAllActivityWithMainActivityList(
                                //   [
                                //       MainActivities.InitialTreatment,
                                //       MainActivities.Maintenance,
                                //       MainActivities.Establishment
                                //     ]
                                //   );
                                //
                                //   print("THE RESPONSE ::::::: ${response}");
                                //
                                //    // var response = await addContractorCertificateVerificationRecordController.globalController.database!.activityDao.findAllMainActivity();
                                //   // var response =
                                //   //     await addContractorCertificateVerificationRecordController
                                //   //         .globalController
                                //   //         .database!
                                //   //         .activityDao
                                //   //         .findAllActivityWithMainActivityList([
                                //   //   MainActivities.InitialTreatment,
                                //   //   MainActivities.Maintenance,
                                //   //   MainActivities.Establishment
                                //   // ]);
                                //   return response;
                                // },
                                itemAsString: (String d) => d,
                                //filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                // compareFn: (activity, filter) =>
                                //     activity.mainActivity ==
                                //     filter.mainActivity,
                                onChanged: (val) {
                                  print("YESSSSS");
                                  addContractorCertificateVerificationRecordController
                                      .activity = val!;
                                  // print("CODE ::::::::::: ${addContractorCertificateVerificationRecordController.activity.mainActivity}");
                                  // print("MAIN ACTIVITY :::::::::::::: ${addContractorCertificateVerificationRecordController.activity.code}");

                                  // addContractorCertificateRecordController
                                  //     .subActivity = Activity() as List<Activity>;
                                  addContractorCertificateVerificationRecordController
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
                                'Sub Activity',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5),
                              DropdownSearch<ActivityModel>.multiSelection(
                                popupProps:
                                    PopupPropsMultiSelection.modalBottomSheet(
                                      showSelectedItems: true,
                                      showSearchBox: true,
                                      title: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Select Sub Activity',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      disabledItemFn:
                                          (ActivityModel s) => false,
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
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                      ),
                                    ),
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                asyncItems: (String filter) async {
                                  ActivityDatabaseHelper db =
                                      ActivityDatabaseHelper.instance;
                                  var response = await db
                                      .getSubActivityByMainActivity(
                                        addContractorCertificateVerificationRecordController
                                                .activity ??
                                            "",
                                      );

                                  // var response =
                                  //     await addContractorCertificateVerificationRecordController
                                  //         .globalController
                                  //         .database!
                                  //         .activityDao
                                  //         .findSubActivities(
                                  //             addContractorCertificateVerificationRecordController
                                  //                     .activity ?? ""
                                  //                 );

                                  return response;
                                },
                                itemAsString:
                                    (ActivityModel d) =>
                                        d.subActivity!.toString(),
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn:
                                    (activity, filter) =>
                                        activity.subActivity ==
                                        filter.subActivity,
                                onChanged: (vals) {
                                  addContractorCertificateVerificationRecordController
                                      .subActivity = vals;
                                  addContractorCertificateVerificationRecordController
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
                              const Text(
                                'Completed By',
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
                                    addContractorCertificateVerificationRecordController
                                        .listOfStaff,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
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
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return "Field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  addContractorCertificateVerificationRecordController
                                      .isCompletedBy
                                      .value = val!;
                                  addContractorCertificateVerificationRecordController
                                      .update();
                                },
                              ),
                              const SizedBox(height: 20),
                              Obx(
                                () =>
                                    addContractorCertificateVerificationRecordController
                                                .isCompletedBy
                                                .value
                                                .toString() ==
                                            'Contractor'
                                        ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            const Text(
                                              'Contractor Name',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            DropdownSearch<Contractor>(
                                              popupProps: PopupProps.modalBottomSheet(
                                                showSelectedItems: true,
                                                showSearchBox: true,
                                                itemBuilder: (
                                                  context,
                                                  item,
                                                  selected,
                                                ) {
                                                  return ListTile(
                                                    title: Text(
                                                      item.contractorName
                                                          .toString(),
                                                      style:
                                                          selected
                                                              ? TextStyle(
                                                                color:
                                                                    AppColor
                                                                        .primary,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                disabledItemFn:
                                                    (Contractor s) => false,
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
                                                    enabledBorder: inputBorder,
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
                                              asyncItems: (
                                                String filter,
                                              ) async {
                                                var response =
                                                    await addContractorCertificateVerificationRecordController
                                                        .globalController
                                                        .database!
                                                        .contractorDao
                                                        .findAllContractors();
                                                return response;
                                              },
                                              itemAsString:
                                                  (Contractor d) =>
                                                      d.contractorName ?? '',
                                              // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                              compareFn:
                                                  (d, filter) =>
                                                      d.contractorName ==
                                                      filter.contractorName,
                                              onChanged: (val) {
                                                addContractorCertificateVerificationRecordController
                                                    .contractor = val;
                                                addContractorCertificateVerificationRecordController
                                                    .update();
                                              },

                                              autoValidateMode:
                                                  AutovalidateMode.always,
                                              validator: (item) {
                                                if (item == null) {
                                                  return 'Contractor name is required';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                        : Container(),
                              ),

                              const Text(
                                'Picture of Farm',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 5),
                              GetBuilder(
                                init:
                                    addContractorCertificateVerificationRecordController,
                                builder: (context) {
                                  return ImageFieldCard(
                                    // onTap: () => addInitialTreatmentMonitoringRecordController.chooseMediaSource(),
                                    // onTap: () => addInitialTreatmentMonitoringRecordController.pickMedia(source: 1, imageToSet: PersonnelImageData.personnelImage),
                                    onTap:
                                        () =>
                                            addContractorCertificateVerificationRecordController
                                                .pickMedia(source: 1),
                                    image:
                                        addContractorCertificateVerificationRecordController
                                            .farmPhoto
                                            ?.file,
                                  );
                                },
                              ),
                              GetBuilder(
                                init:
                                    addContractorCertificateVerificationRecordController,
                                builder: (ctx) {
                                  return addContractorCertificateVerificationRecordController
                                              .farmPhoto
                                              ?.file ==
                                          null
                                      ? Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 8),
                                            Text(
                                              'Picture of farm is required',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall!.copyWith(
                                                color: Colors.red[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : Container();
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GetBuilder(
                                    init:
                                        addContractorCertificateVerificationRecordController,
                                    builder: (context) {
                                      return addContractorCertificateVerificationRecordController
                                                  .locationData !=
                                              null
                                          ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: locationAccuracyColor(
                                                addContractorCertificateVerificationRecordController
                                                    .locationData
                                                    ?.accuracy,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Text(
                                                "Accuracy:  ${addContractorCertificateVerificationRecordController.locationData?.accuracy?.truncateToDecimalPlaces(2).toString() ?? 'null'}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                          : Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: locationAccuracyColor(
                                                addContractorCertificateVerificationRecordController
                                                    .locationData
                                                    ?.accuracy,
                                              ),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Location Data Empty",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  // fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                    },
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Obx(
                                      () => ElevatedButton(
                                        onPressed: () {
                                          addContractorCertificateVerificationRecordController
                                              .getUsersCurrentLocation();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),
                                        ),
                                        child:
                                            addContractorCertificateVerificationRecordController
                                                    .isLoadingLocation
                                                    .value
                                                ? const Text(
                                                  'Saving Location...',
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                                : const Text(
                                                  'Save Location',
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(),
                              GetBuilder(
                                init:
                                    addContractorCertificateVerificationRecordController,
                                builder: (context) {
                                  return addContractorCertificateVerificationRecordController
                                              .locationData !=
                                          null
                                      ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            'LOCATION',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Lat : ${addContractorCertificateVerificationRecordController.locationData!.latitude}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Lng : ${addContractorCertificateVerificationRecordController.locationData!.longitude}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Accuracy : ${addContractorCertificateVerificationRecordController.locationData!.accuracy!.truncateToDecimalPlaces(2).toString()}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Container();
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
                                        if (!addContractorCertificateVerificationRecordController
                                            .isSaveButtonDisabled
                                            .value) {
                                          if (addContractorCertificateVerificationRecordController
                                              .addContractorCertificateVerificationRecordFormKey
                                              .currentState!
                                              .validate()) {
                                            addContractorCertificateVerificationRecordController
                                                .handleSaveOfflineMonitoringRecord();
                                          } else {
                                            addContractorCertificateVerificationRecordController
                                                .globals
                                                .showSnackBar(
                                                  title: 'Alert',
                                                  message:
                                                      'Kindly provide all required information',
                                                );
                                          }
                                        }
                                      },
                                      child: Obx(
                                        () => Text(
                                          addContractorCertificateVerificationRecordController
                                                  .isSaveButtonDisabled
                                                  .value
                                              ? 'Please wait ...'
                                              : 'Save',
                                          style: TextStyle(
                                            color: AppColor.white,
                                            fontSize: 14,
                                          ),
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
                                        // if (!addContractorCertificateRecordController
                                        //     .isButtonDisabled.value) {
                                        if (addContractorCertificateVerificationRecordController
                                            .addContractorCertificateVerificationRecordFormKey
                                            .currentState!
                                            .validate()) {
                                          addContractorCertificateVerificationRecordController
                                              .handleAddMonitoringRecord();
                                        } else {
                                          addContractorCertificateVerificationRecordController
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
                                      // Obx(
                                      //   () =>
                                      Text(
                                        // addContractorCertificateRecordController
                                        //         .isButtonDisabled.value
                                        //     ? 'Please wait ...'
                                        //     :
                                        'Submit',
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      // ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
