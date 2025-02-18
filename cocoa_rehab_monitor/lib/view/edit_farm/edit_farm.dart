import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/map_farm.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'edit_farm_controller.dart';

class EditMapFarm extends StatefulWidget {
  final MapFarm mapFarm;
  final bool isViewMode;
  const EditMapFarm({Key? key, required this.mapFarm, required this.isViewMode})
      : super(key: key);

  @override
  State<EditMapFarm> createState() => _EditMapFarmState();
}

class _EditMapFarmState extends State<EditMapFarm> {
  EditMapFarmController editMapFarmController =
      Get.put(EditMapFarmController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    editMapFarmController.mapfarm = widget.mapFarm;
  }

  @override
  Widget build(BuildContext context) {
    editMapFarmController.editMapFarmScreenContext = context;

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
                                  ? 'View Mapped Farm'
                                  : 'Edit Mapped Farm',
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
                              init: editMapFarmController,
                              builder: (ctx) {
                                return Form(
                                  key: editMapFarmController.formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Farm Reference',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // DropdownSearch<Society>(
                                      //   popupProps: PopupProps.modalBottomSheet(
                                      //       showSelectedItems: true,
                                      //       showSearchBox: true,
                                      //       itemBuilder: (context, item, selected) {
                                      //         return ListTile(
                                      //           title: Text(item.societyName.toString(),
                                      //               style: selected
                                      //                   ? TextStyle(
                                      //                       color: AppColor.primary)
                                      //                   : const TextStyle()),
                                      //           subtitle: Text(
                                      //             item.societyCode.toString(),
                                      //           ),
                                      //         );
                                      //       },
                                      //       title: const Padding(
                                      //         padding:
                                      //             EdgeInsets.symmetric(vertical: 15),
                                      //         child: Center(
                                      //           child: Text(
                                      //             'Select Society',
                                      //             style: TextStyle(
                                      //                 fontWeight: FontWeight.w500),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       disabledItemFn: (Society s) => false,
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
                                      //   // items: ['Greater Accra', 'Volta', 'Western'],
                                      //   asyncItems: (String filter) async {
                                      //     var response = await mapFarmController
                                      //         .globalController.database!.societyDao
                                      //         .findAllSociety();
                                      //     return response;
                                      //   },
                                      //   itemAsString: (Society d) =>
                                      //       d.societyName ?? '',
                                      //   // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                      //   compareFn: (d, filter) =>
                                      //       d.societyName == filter.societyName,
                                      //   onChanged: (val) {
                                      //     mapFarmController.society = val;
                                      //     mapFarmController.update();
                                      //   },

                                      //   // autoValidateMode: AutovalidateMode.always,
                                      //   // validator: (item) {
                                      //   //   if (item == null) {
                                      //   //     return 'Society is required';
                                      //   //   } else {
                                      //   //     return null;
                                      //   //   }
                                      //   // },
                                      // ),
                                      DropdownSearch<Farm>(
                                        popupProps: PopupProps.modalBottomSheet(
                                            showSelectedItems: true,
                                            showSearchBox: true,
                                            itemBuilder:
                                                (context, item, selected) {
                                              return ListTile(
                                                title: Text(
                                                    item.farmId.toString(),
                                                    style: selected
                                                        ? TextStyle(
                                                            color: AppColor
                                                                .primary)
                                                        : const TextStyle()),
                                                subtitle: Text(
                                                  "${item.districtName.toString()} - ${item.regionName.toString()}",
                                                ),
                                              );
                                            },
                                            title: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15),
                                              child: Center(
                                                child: Text(
                                                  'Select Farm Reference',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            disabledItemFn: (Farm s) => false,
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
                                              await editMapFarmController
                                                  .globalController
                                                  .database!
                                                  .farmDao
                                                  .findAllFarm();

                                          editMapFarmController.farmerNameTC
                                              ?.text = editMapFarmController
                                                  .farm?.farmerNam ??
                                              "";

                                          editMapFarmController.districtNameTC
                                              ?.text = editMapFarmController
                                                  .farm?.districtName ??
                                              "";
                                          editMapFarmController.regionNameTC
                                              ?.text = editMapFarmController
                                                  .farm?.regionName ??
                                              "";

                                          editMapFarmController.farmIdTC?.text =
                                              editMapFarmController
                                                      .farm?.farmId ??
                                                  "";
                                          return response;
                                        },
                                        itemAsString: (Farm d) =>
                                            d.farmId ?? '',
                                        // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                        compareFn: (d, filter) =>
                                            d.farmId == filter.farmId,
                                        onChanged: (val) {
                                          editMapFarmController.farm = val;
                                          editMapFarmController.update();

                                          editMapFarmController.farmerNameTC
                                              ?.text = editMapFarmController
                                                  .farm?.farmerNam ??
                                              "";

                                          editMapFarmController.districtNameTC
                                              ?.text = editMapFarmController
                                                  .farm?.districtName ??
                                              "";
                                          editMapFarmController.regionNameTC
                                              ?.text = editMapFarmController
                                                  .farm?.regionName ??
                                              "";

                                          editMapFarmController.farmIdTC?.text =
                                              editMapFarmController
                                                      .farm?.farmId ??
                                                  "";
                                        },
                                        selectedItem:
                                            editMapFarmController.farm,

                                        autoValidateMode:
                                            AutovalidateMode.always,
                                        validator: (item) {
                                          if (item == null) {
                                            return 'Farm reference is required';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      GetBuilder(
                                        init: editMapFarmController,
                                        builder: (ctx) {
                                          return editMapFarmController.farm !=
                                                  null
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    const Text(
                                                      'Name of Farmer',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editMapFarmController
                                                              .farmerNameTC,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15),
                                                        enabledBorder:
                                                            inputBorder,
                                                        focusedBorder:
                                                            inputBorderFocused,
                                                        errorBorder:
                                                            inputBorder,
                                                        focusedErrorBorder:
                                                            inputBorderFocused,
                                                        filled: true,
                                                        fillColor: AppColor
                                                            .xLightBackground,
                                                      ),
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      validator: (String?
                                                              value) =>
                                                          value!.trim().isEmpty
                                                              ? "Farmer name is required"
                                                              : null,
                                                    ),
                                                    const SizedBox(height: 20),
                                                    // if (!widget.isViewMode)
                                                    const Text(
                                                      'Contact of Farmer',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editMapFarmController
                                                              .farmerContactTC,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15),
                                                        enabledBorder:
                                                            inputBorder,
                                                        focusedBorder:
                                                            inputBorderFocused,
                                                        errorBorder:
                                                            inputBorder,
                                                        focusedErrorBorder:
                                                            inputBorderFocused,
                                                        filled: true,
                                                        fillColor: AppColor
                                                            .xLightBackground,
                                                      ),
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      validator: (String?
                                                              value) =>
                                                          value!.trim().isEmpty
                                                              ? "Farmer contact is required"
                                                              : null,
                                                    ),
                                                    // if (!widget.isViewMode)
                                                    const SizedBox(height: 20),
                                                    const Text(
                                                      'District',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editMapFarmController
                                                              .districtNameTC,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15),
                                                        enabledBorder:
                                                            inputBorder,
                                                        focusedBorder:
                                                            inputBorderFocused,
                                                        errorBorder:
                                                            inputBorder,
                                                        focusedErrorBorder:
                                                            inputBorderFocused,
                                                        filled: true,
                                                        fillColor: AppColor
                                                            .xLightBackground,
                                                      ),
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      validator: (String?
                                                              value) =>
                                                          value!.trim().isEmpty
                                                              ? "District is required"
                                                              : null,
                                                    ),
                                                    // if (!widget.isViewMode)
                                                    const SizedBox(height: 20),
                                                    const Text(
                                                      'Region',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editMapFarmController
                                                              .regionNameTC,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15),
                                                        enabledBorder:
                                                            inputBorder,
                                                        focusedBorder:
                                                            inputBorderFocused,
                                                        errorBorder:
                                                            inputBorder,
                                                        focusedErrorBorder:
                                                            inputBorderFocused,
                                                        filled: true,
                                                        fillColor: AppColor
                                                            .xLightBackground,
                                                      ),
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      validator: (String?
                                                              value) =>
                                                          value!.trim().isEmpty
                                                              ? "Region is required"
                                                              : null,
                                                    ),
                                                    // if (!widget.isViewMode)
                                                    const SizedBox(height: 20),
                                                    // const Text(
                                                    //   'Farm Size',
                                                    //   style: TextStyle(
                                                    //       fontWeight:
                                                    //           FontWeight.w500),
                                                    // ),
                                                    // const SizedBox(
                                                    //   height: 5,
                                                    // ),
                                                    // TextFormField(
                                                    //   controller:
                                                    //       editMapFarmController
                                                    //           .farmSizeTC,
                                                    //   textCapitalization:
                                                    //       TextCapitalization
                                                    //           .words,
                                                    //   decoration:
                                                    //       InputDecoration(
                                                    //     contentPadding:
                                                    //         const EdgeInsets
                                                    //             .symmetric(
                                                    //             vertical: 15,
                                                    //             horizontal: 15),
                                                    //     enabledBorder:
                                                    //         inputBorder,
                                                    //     focusedBorder:
                                                    //         inputBorderFocused,
                                                    //     errorBorder:
                                                    //         inputBorder,
                                                    //     focusedErrorBorder:
                                                    //         inputBorderFocused,
                                                    //     filled: true,
                                                    //     fillColor: AppColor
                                                    //         .xLightBackground,
                                                    //   ),
                                                    //   maxLines: null,
                                                    //   keyboardType:
                                                    //       TextInputType.number,
                                                    //   textInputAction:
                                                    //       TextInputAction.next,
                                                    //   autovalidateMode:
                                                    //       AutovalidateMode
                                                    //           .always,
                                                    //   validator: (String?
                                                    //           value) =>
                                                    //       value!.trim().isEmpty
                                                    //           ? "Farm size is required"
                                                    //           : null,
                                                    // ),
                                                    // const SizedBox(height: 20),
                                                    if (!widget.isViewMode)
                                                      Row(
                                                        children: [
                                                          CustomButton(
                                                            isFullWidth: false,
                                                            backgroundColor:
                                                                AppColor
                                                                    .xLightBackground,
                                                            borderColor:
                                                                AppColor.black,
                                                            borderWidth: 0.5,
                                                            verticalPadding:
                                                                0.0,
                                                            horizontalPadding:
                                                                8.0,
                                                            onTap: () async {
                                                              editMapFarmController
                                                                  .usePolygonDrawingTool();
                                                            },
                                                            child: Text(
                                                              'Demarcate farm boundary',
                                                              style: TextStyle(
                                                                  color: AppColor
                                                                      .black,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          GetBuilder(
                                                              init:
                                                                  editMapFarmController,
                                                              builder:
                                                                  (context) {
                                                                return editMapFarmController
                                                                            .polygon !=
                                                                        null
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15.0),
                                                                        child: appIconBadgeCheck(
                                                                            color:
                                                                                AppColor.primary,
                                                                            size: 35),
                                                                      )
                                                                    : Container();
                                                              }),
                                                        ],
                                                      ),
                                                    if (!widget.isViewMode)
                                                      const SizedBox(
                                                          height: 20),
                                                    const Text(
                                                      'Farm Area in Hectares',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          editMapFarmController
                                                              .farmAreaTC,
                                                      readOnly: true,
                                                      onTap: () =>
                                                          editMapFarmController
                                                              .globals
                                                              .showSnackBar(
                                                                  title:
                                                                      'Alert',
                                                                  message:
                                                                      'Kindly tap Demarcate farm boundary to compute area'),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15),
                                                        enabledBorder:
                                                            inputBorder,
                                                        focusedBorder:
                                                            inputBorderFocused,
                                                        errorBorder:
                                                            inputBorder,
                                                        focusedErrorBorder:
                                                            inputBorderFocused,
                                                        filled: true,
                                                        fillColor: AppColor
                                                            .xLightBackground,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      validator: (String?
                                                              value) =>
                                                          value!.trim().isEmpty
                                                              ? "Area is required"
                                                              : null,
                                                    ),
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
                                                              backgroundColor:
                                                                  AppColor
                                                                      .black,
                                                              verticalPadding:
                                                                  0.0,
                                                              horizontalPadding:
                                                                  8.0,
                                                              onTap: () async {
                                                                // if (!editMapFarmController
                                                                //     .isSaveButtonDisabled
                                                                //     .value) {
                                                                if (editMapFarmController
                                                                    .formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  editMapFarmController
                                                                      .handleSaveOfflineEditMapFarm();
                                                                } else {
                                                                  editMapFarmController
                                                                      .globals
                                                                      .showSnackBar(
                                                                          title:
                                                                              'Alert',
                                                                          message:
                                                                              'Kindly provide all required information');
                                                                }
                                                                // }
                                                              },
                                                              child:
                                                                  // Obx(
                                                                  //   () =>
                                                                  Text(
                                                                // editMapFarmController
                                                                //         .isSaveButtonDisabled
                                                                //         .value
                                                                //     ? 'Please wait ...'
                                                                //     :
                                                                'Save',
                                                                style: TextStyle(
                                                                    color: AppColor
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              // ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 20),
                                                          Expanded(
                                                            child: CustomButton(
                                                              isFullWidth: true,
                                                              backgroundColor:
                                                                  AppColor
                                                                      .primary,
                                                              verticalPadding:
                                                                  0.0,
                                                              horizontalPadding:
                                                                  8.0,
                                                              onTap: () async {
                                                                // if (!editMapFarmController
                                                                //     .isButtonDisabled.value) {
                                                                if (editMapFarmController
                                                                    .formKey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  editMapFarmController
                                                                      .handleEditMapFarm();
                                                                } else {
                                                                  editMapFarmController
                                                                      .globals
                                                                      .showSnackBar(
                                                                          title:
                                                                              'Alert',
                                                                          message:
                                                                              'Kindly provide all required information');
                                                                }
                                                                // }
                                                              },
                                                              child:
                                                                  // Obx(
                                                                  //   () =>
                                                                  Text(
                                                                // editMapFarmController
                                                                //         .isButtonDisabled
                                                                //         .value
                                                                //     ? 'Please wait ...'
                                                                //     :
                                                                'Submit',
                                                                style: TextStyle(
                                                                    color: AppColor
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                                // ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    const SizedBox(height: 30),
                                                  ],
                                                )
                                              : Container();
                                        },
                                      ),
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
