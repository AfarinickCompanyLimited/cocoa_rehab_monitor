// import 'dart:convert';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/db/activity_db.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import '../../controller/entity/cocoa_rehub_monitor/region_district.dart';
import '../../controller/model/activity_model.dart';
import '../utils/pattern_validator.dart';
import 'edit_contractor_certificate_record_controller.dart';

class EditContractorCertificateRecord extends StatefulWidget {
  final ContractorCertificate contractorCertificate;
  final bool isViewMode;
  const EditContractorCertificateRecord(
      {Key? key, required this.contractorCertificate, required this.isViewMode})
      : super(key: key);

  @override
  State<EditContractorCertificateRecord> createState() =>
      _EditMonitoringRecordState();
}

class _EditMonitoringRecordState
    extends State<EditContractorCertificateRecord> {
  EditContractorCertificateRecordController
      editContractorCertificateRecordController =
      Get.put(EditContractorCertificateRecordController());
  GlobalController globalController = Get.find();
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();

    editContractorCertificateRecordController.contractorCertificate =
        widget.contractorCertificate;
    editContractorCertificateRecordController.isViewMode = widget.isViewMode;
  }

  @override
  Widget build(BuildContext context) {
    print("THE DATA :::::::::::;;;; ${widget.contractorCertificate.toJson()}");
    int currentYear = DateTime.now().year;
    int startingYear = 2022;
    List<int> yearList =
        List.generate((currentYear - startingYear) + 1, (index) {
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
                                  ? 'View WD By Contractor Certificate Record'
                                  : 'Edit WD By Contractor Certificate Record',
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
                          child: GetBuilder(
                              init: editContractorCertificateRecordController,
                              builder: (ctx) {
                                return Form(
                                  key: editContractorCertificateRecordController
                                      .editContractorCertificateRecordFormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Current Year',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppBorderRadius.sm))),
                                        items: yearList
                                            .map((year) => year.toString())
                                            .toList(),
                                        dropdownDecoratorProps:
                                            DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
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
                                        ),
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return "Current year is required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) {
                                          editContractorCertificateRecordController
                                              .selectedYear.value = val!;
                                          editContractorCertificateRecordController
                                              .update();
                                        },
                                        selectedItem: widget
                                            .contractorCertificate.currentYear,
                                      ),

                                      const SizedBox(height: 20),
                                      const Text(
                                        'Current Month',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppBorderRadius.sm))),
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
                                        ),
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return "Current month is required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) {
                                          editContractorCertificateRecordController
                                              .selectedMonth.value = val!;
                                          editContractorCertificateRecordController
                                              .update();
                                        },
                                        selectedItem: widget
                                            .contractorCertificate.currentMonth,
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Current Week',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppBorderRadius.sm))),
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
                                        ),
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return "Current week is required";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (val) {
                                          editContractorCertificateRecordController
                                              .selectedWeek.value = val!;
                                          editContractorCertificateRecordController
                                              .update();
                                        },
                                        selectedItem: widget
                                            .contractorCertificate.currrentWeek,
                                      ),
                                      const SizedBox(height: 20),

                                      const Text(
                                        'Farm Reference Number',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            editContractorCertificateRecordController
                                                .farmReferenceNumberTC,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                        keyboardType: TextInputType.url,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: FarmReferencePatternValidator
                                            .validate,
                                      ),

                                      const SizedBox(height: 20),

                                      const Text(
                                        'Farm Size (in hectares)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            editContractorCertificateRecordController
                                                .farmSizeTC,
                                        readOnly: false,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: (String? value) =>
                                            value!.trim().isEmpty
                                                ? "Farm size is required"
                                                : null,
                                      ),
                                      const SizedBox(height: 20),

                                      const Text(
                                        'Community',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller:
                                            editContractorCertificateRecordController
                                                .communityNameTC,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 15),
                                          enabledBorder: inputBorder,
                                          focusedBorder: inputBorderFocused,
                                          errorBorder: inputBorder,
                                          focusedErrorBorder:
                                              inputBorderFocused,
                                          filled: true,
                                          fillColor: AppColor.xLightBackground,
                                        ),
                                        keyboardType: TextInputType.text,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        validator: (String? value) =>
                                            value!.trim().isEmpty
                                                ? "Community is required"
                                                : null,
                                      ),

                                      const SizedBox(height: 20),

                                      const Text(
                                        'District',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      DropdownSearch<RegionDistrict>(
                                        popupProps: PopupProps.modalBottomSheet(
                                            showSelectedItems: true,
                                            showSearchBox: true,
                                            itemBuilder:
                                                (context, item, selected) {
                                              return ListTile(
                                                title: Text(
                                                    item.districtName
                                                        .toString(),
                                                    style: selected
                                                        ? TextStyle(
                                                        color: AppColor
                                                            .primary)
                                                        : const TextStyle()),
                                                subtitle: Text(
                                                  item.regionName.toString(),
                                                ),
                                              );
                                            },
                                            title: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Select district',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            disabledItemFn:
                                                (RegionDistrict s) => false,
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
                                                focusedBorder:
                                                inputBorderFocused,
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
                                          dropdownSearchDecoration:
                                          InputDecoration(
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
                                        ),
                                        asyncItems: (String filter) async {
                                          var response =
                                          await editContractorCertificateRecordController
                                              .globalController
                                              .database!
                                              .regionDistrictDao
                                              .findAllRegionDistrict();
                                          return response;
                                        },
                                        itemAsString: (RegionDistrict d) =>
                                        d.districtName ?? '',
                                        // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                        compareFn: (d, filter) =>
                                        d.districtName ==
                                            filter.districtName,
                                        onChanged: (val) {
                                          editContractorCertificateRecordController
                                              .regionDistrict = val;
                                        },
                                        selectedItem:
                                        editContractorCertificateRecordController
                                            .regionDistrict,
                                        autoValidateMode:
                                        AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return 'District is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),

                                      const SizedBox(height: 20),

                                      /* const Text(
                                        'Community',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      DropdownSearch<Community>(
                                        popupProps: PopupProps.modalBottomSheet(
                                            showSelectedItems: true,
                                            showSearchBox: true,
                                            itemBuilder:
                                                (context, item, selected) {
                                              return ListTile(
                                                title: Text(
                                                    item.community.toString(),
                                                    style: selected
                                                        ? TextStyle(
                                                            color: AppColor
                                                                .primary)
                                                        : const TextStyle()),
                                                subtitle: Text(
                                                  item.operationalArea
                                                      .toString(),
                                                ),
                                              );
                                            },
                                            title: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Select community',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            disabledItemFn: (Community s) =>
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
                                                focusedBorder:
                                                    inputBorderFocused,
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
                                          dropdownSearchDecoration:
                                              InputDecoration(
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
                                        ),
                                        asyncItems: (String filter) async {
                                          var response =
                                              await editContractorCertificateRecordController
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
                                          editContractorCertificateRecordController
                                              .community = val;
                                        },
                                        selectedItem:
                                            editContractorCertificateRecordController
                                                .community,
                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return 'Community is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20),*/

                                      const Text(
                                        'Activity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      GetBuilder(
                                          init:
                                          editContractorCertificateRecordController,
                                          builder: (ctx) {
                                            return
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
                                                items: [
                                                  "Establishment",
                                                  "Initial Treatment",
                                                  "Maintenance",
                                                ],
                                                selectedItem: editContractorCertificateRecordController.activity,
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
                                                itemAsString: (String d) =>
                                                d,
                                                //filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                                // compareFn: (activity, filter) =>
                                                //     activity.mainActivity ==
                                                //     filter.mainActivity,
                                                onChanged: (val) {

                                                  print("YESSSSS");
                                                  editContractorCertificateRecordController
                                                      .activity = val!;
                                                  // print("CODE ::::::::::: ${addContractorCertificateVerificationRecordController.activity.mainActivity}");
                                                  // print("MAIN ACTIVITY :::::::::::::: ${addContractorCertificateVerificationRecordController.activity.code}");

                                                  // addContractorCertificateRecordController
                                                  //     .subActivity = Activity() as List<Activity>;
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
                                              );
                                          }),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Sub Activity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      GetBuilder(
                                          init:
                                          editContractorCertificateRecordController,
                                          builder: (ctx) {
                                            return
                                              DropdownSearch<ActivityModel>.multiSelection(
                                                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                                                  showSelectedItems: true,
                                                  showSearchBox: true,
                                                  title: const Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 15),
                                                    child: Center(
                                                      child: Text(
                                                        'Select Sub Activity',
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
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
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
                                                  ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
                                                  var response = await db.getSubActivityByMainActivity(
                                                      editContractorCertificateRecordController.activity ?? ""
                                                  );

                                                  return response;
                                                },
                                                selectedItems: List<ActivityModel>.from(editContractorCertificateRecordController.subActivity),

                                                itemAsString: (ActivityModel d) => d.subActivity ?? '',
                                                compareFn: (activity, filter) => activity.subActivity == filter.subActivity, // Ensures proper matching
                                                onChanged: (vals) {
                                                  editContractorCertificateRecordController.subActivity = vals;
                                                  editContractorCertificateRecordController.update();
                                                },
                                                autoValidateMode: AutovalidateMode.always,
                                                validator: (items) {
                                                  if (items == null || items.isEmpty) {
                                                    return 'Sub activity is required';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              );

                                          }),

                                      const SizedBox(height: 20),

                                      /*         const Text(
                                'Contractor Name',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownSearch<Contractor>(
                                popupProps: PopupProps.modalBottomSheet(
                                    showSelectedItems: true,
                                    showSearchBox: true,
                                    itemBuilder: (context, item, selected) {
                                      return ListTile(
                                        title: Text(item.contractorName.toString(),
                                            style: selected
                                                ? TextStyle(
                                                    color: AppColor.primary)
                                                : const TextStyle()),
                                        
                                      );
                                    },
                                    title: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      child: Center(
                                        child: Text(
                                          'Select contractor',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
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
                                      await editContractorCertificateRecordController
                                          .globalController
                                          .database!
                                          .contractorDao
                                          .findAllContractors();
                                  return response;
                                },
                                itemAsString: (Contractor d) =>
                                    d.contractorName ?? '',
                                // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                compareFn: (d, filter) =>
                                    d.contractorName == filter.contractorName,
                                onChanged: (val) {
                                  editContractorCertificateRecordController
                                      .contractorName = val;
                                },
                                selectedItem:
                                    editContractorCertificateRecordController
                                        .contractorName,
                                autoValidateMode: AutovalidateMode.always,
                                validator: (item) {
                                  if (item == null) {
                                    return 'Contractor name is required';
                                  } else {
                                    return null;
                                  }
                                },
                              ),*/

                                      const Text(
                                        'Contractor Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      DropdownSearch<Contractor>(
                                        popupProps: PopupProps.modalBottomSheet(
                                            showSelectedItems: true,
                                            showSearchBox: true,
                                            title: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Select contractor',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            disabledItemFn: (Contractor s) =>
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
                                                focusedBorder:
                                                    inputBorderFocused,
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
                                          dropdownSearchDecoration:
                                              InputDecoration(
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
                                        ),
                                        asyncItems: (String filter) async {
                                          // var response = await addInitialTreatmentMonitoringRecordController.globalController.database!.activityDao.findAllMainActivity();
                                          var response =
                                              await editContractorCertificateRecordController
                                                  .globalController
                                                  .database!
                                                  .contractorDao
                                                  .findAllContractors();
                                          return response;
                                        },
                                        itemAsString: (Contractor d) =>
                                            d.contractorName ?? '',
                                        // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                        compareFn: (d, filter) =>
                                            d.contractorName ==
                                            filter.contractorName,
                                        onChanged: (val) {
                                          editContractorCertificateRecordController
                                              .contractor = val;
                                        },
                                        selectedItem:
                                            editContractorCertificateRecordController
                                                .contractor,
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

                                      // const SizedBox(height: 20),

                                      // const Divider(),

                                      // Column(
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.start,
                                      //   children: [
                                      //     const SizedBox(height: 20),
                                      //     Text(
                                      //       'LOCATION',
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.w700,
                                      //           fontSize: 16,
                                      //           color: AppColor.black),
                                      //     ),
                                      //     const SizedBox(height: 5),
                                      //     Text(
                                      //       'Lat : ${editContractorCertificateRecordController.locationData?.latitude}',
                                      //       style: const TextStyle(
                                      //           fontWeight: FontWeight.w500),
                                      //     ),
                                      //     Text(
                                      //       'Lng : ${editContractorCertificateRecordController.locationData?.longitude}',
                                      //       style: const TextStyle(
                                      //           fontWeight: FontWeight.w500),
                                      //     ),
                                      //     Text(
                                      //       'Accuracy : ${editContractorCertificateRecordController.locationData?.accuracy}',
                                      //       style: const TextStyle(
                                      //           fontWeight: FontWeight.w500),
                                      //     ),
                                      //   ],
                                      // ),

                                      if (!widget.isViewMode)
                                        const SizedBox(
                                          height: 40,
                                        ),

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
                                                  // if (!editContractorCertificateRecordController
                                                  //     .isSaveButtonDisabled
                                                  //     .value) {
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
                                                                'Kindly provide all required information');
                                                  }
                                                  // }
                                                },
                                                child:
                                                    // Obx(
                                                    //   () =>
                                                    Text(
                                                  // editContractorCertificateRecordController
                                                  //         .isSaveButtonDisabled
                                                  //         .value
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
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: CustomButton(
                                                isFullWidth: true,
                                                backgroundColor:
                                                    AppColor.primary,
                                                verticalPadding: 0.0,
                                                horizontalPadding: 8.0,
                                                onTap: () async {
                                                  // if (!editContractorCertificateRecordController
                                                  //     .isButtonDisabled.value) {
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
                                                                'Kindly provide all required information');
                                                  }
                                                  // }
                                                },
                                                child:
                                                    // Obx(
                                                    // () =>
                                                    Text(
                                                  // editContractorCertificateRecordController
                                                  //         .isButtonDisabled
                                                  //         .value
                                                  //     ? 'Please wait ...'
                                                  //     :
                                                  'Submit',
                                                  style: TextStyle(
                                                      color: AppColor.white,
                                                      fontSize: 14),
                                                ),
                                                // ),
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
                                      //     if (!editInitialTreatmentMonitoringRecordController.isButtonDisabled.value){
                                      //       if (editInitialTreatmentMonitoringRecordController.editMonitoringRecordFormKey.currentState!.validate()) {
                                      //         editInitialTreatmentMonitoringRecordController.handleAddMonitoringRecord();
                                      //       }else{
                                      //         editInitialTreatmentMonitoringRecordController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
                                      //       }
                                      //     }
                                      //   },
                                      // ),

                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                );
                              }),
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
