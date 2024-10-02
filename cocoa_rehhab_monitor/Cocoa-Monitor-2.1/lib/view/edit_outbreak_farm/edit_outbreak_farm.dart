
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_outbreak.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/cocoa_age_class.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/cocoa_type.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/community.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm.dart';
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

import 'edit_outbreak_farm_controller.dart';


class EditOutbreakFarm extends StatefulWidget {
  final OutbreakFarm outbreakFarm;
  final bool isViewMode;
  const EditOutbreakFarm({Key? key, required this.outbreakFarm, required this.isViewMode}) : super(key: key);

  @override
  State<EditOutbreakFarm> createState() => _EditOutbreakFarmState();
}

class _EditOutbreakFarmState extends State<EditOutbreakFarm> {

  EditOutbreakFarmController editOutbreakFarmController = Get.put(EditOutbreakFarmController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    editOutbreakFarmController.outbreakFarm = widget.outbreakFarm;

  }

  @override
  Widget build(BuildContext context) {

    editOutbreakFarmController.editOutbreakFarmScreenContext = context;

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
                          child: Text(widget.isViewMode ? 'View Outbreak Farm' : 'Edit Outbreak Farm',
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
                            init: editOutbreakFarmController,
                            builder: (ctx) {
                              return Form(
                                key: editOutbreakFarmController.formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    const Text('Inspection Date',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    DateTimePicker(
                                      controller: editOutbreakFarmController.inspectionDateTC,
                                      type: DateTimePickerType.date,
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
                                      validator: (String? value) => value!.trim().isEmpty
                                          ? "Inspection date is required"
                                          : null,
                                    ),
                                    const SizedBox(height: 20),

                                    const Text('Outbreak Farm',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    DropdownSearch<AssignedOutbreak>(
                                      popupProps: PopupProps.modalBottomSheet(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                          itemBuilder: (context, item, selected){
                                            return ListTile(
                                              title: Text(item.obCode.toString(),
                                                  style: selected ? TextStyle(color: AppColor.primary) : const TextStyle()),
                                              subtitle: Text(item.districtName.toString(),
                                              ),
                                            );
                                          },
                                          title: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            child: Center(
                                              child: Text('Select Outbreak Farm',
                                                style: TextStyle(fontWeight: FontWeight.w500),),
                                            ),
                                          ),
                                          disabledItemFn: (AssignedOutbreak s) => false,
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
                                      // items: ['Greater Accra', 'Volta', 'Western'],
                                      asyncItems: (String filter) async {
                                        var response = await editOutbreakFarmController.globalController.database!.assignedOutbreakDao.findAllAssignedOutbreaks();
                                        return response;
                                      },
                                      itemAsString: (AssignedOutbreak d) => d.obCode ?? '',
                                      // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                      compareFn: (d, filter) => d.obCode == filter.obCode,
                                      onChanged: (val) {
                                        editOutbreakFarmController.assignedOutbreak = val;
                                      },
                                      selectedItem: editOutbreakFarmController.assignedOutbreak,
                                      // autoValidateMode: AutovalidateMode.always,
                                      validator: (item) {
                                        if (item == null) {
                                          return 'Outbreak farm is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    const Text('Farmer Name',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    TextFormField(
                                      controller: editOutbreakFarmController.farmerNameTC,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: (String? value) => value!.trim().isEmpty
                                          ? "Farmer name is required"
                                          : null,
                                    ),
                                    const SizedBox(height: 20),

                                    const Text('Farmer Contact Number',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    TextFormField(
                                      controller: editOutbreakFarmController.farmerContactTC,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.phone,
                                      validator: (String? value) => value!.trim().isEmpty || value.trim().length != 10
                                          ? "Enter a valid phone number"
                                          : null,
                                    ),
                                    const SizedBox(height: 20),

                                    const Text('Farmer Age',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    TextFormField(
                                      controller: editOutbreakFarmController.farmerAgeTC,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      validator: (String? value) => value!.trim().isEmpty
                                          ? "Farmer age is required"
                                          : null,
                                    ),
                                    const SizedBox(height: 20),


                                    const Text('Type of ID',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    DropdownSearch<String>(
                                      popupProps: PopupProps.menu(
                                          showSelectedItems: true,
                                          disabledItemFn: (String s) => false,
                                          fit: FlexFit.loose,
                                          menuProps: MenuProps(
                                              elevation: 6,
                                              borderRadius: BorderRadius.circular(AppBorderRadius.sm)
                                          )
                                      ),
                                      items: editOutbreakFarmController.idTypes,
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
                                      // autoValidateMode: AutovalidateMode.always,
                                      selectedItem: editOutbreakFarmController.idType,
                                      validator: (item) {
                                        if (item == null) {
                                          return "ID type is required";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onChanged: (val) => editOutbreakFarmController.idType = val!,
                                    ),
                                    const SizedBox(height: 20),

                                    const Text('ID Number',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    TextFormField(
                                      controller: editOutbreakFarmController.idNumberTC,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: (String? value) => value!.trim().isEmpty
                                          ? "ID number is required"
                                          : null,
                                    ),

                                    const SizedBox(height: 20),

                                    /*const Text('Farm Location',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    TextFormField(
                                      controller: editOutbreakFarmController.farmLocationTC,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                        enabledBorder: inputBorder,
                                        focusedBorder: inputBorderFocused,
                                        errorBorder: inputBorder,
                                        focusedErrorBorder: inputBorderFocused,
                                        filled: true,
                                        fillColor: AppColor.xLightBackground,
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: (String? value) => value!.trim().isEmpty
                                          ? "Farm location is required"
                                          : null,
                                    ),
                                    const SizedBox(height: 20),*/

                                    const Text('Community',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    DropdownSearch<Community>(
                                      popupProps: PopupProps.modalBottomSheet(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                          itemBuilder: (context, item, selected){
                                            return ListTile(
                                              title: Text(item.community.toString(),
                                                  style: selected ? TextStyle(color: AppColor.primary) : const TextStyle()),
                                              subtitle: Text(item.operationalArea.toString(),
                                              ),
                                            );
                                          },
                                          title: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            child: Center(
                                              child: Text('Select community',
                                                style: TextStyle(fontWeight: FontWeight.w500),),
                                            ),
                                          ),
                                          disabledItemFn: (Community s) => false,
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
                                        var response = await editOutbreakFarmController.globalController.database!.communityDao.findAllCommunity();
                                        return response;
                                      },
                                      itemAsString: (Community d) => d.community ?? '',
                                      // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                      compareFn: (d, filter) => d.community == filter.community,
                                      onChanged: (val) {
                                        editOutbreakFarmController.community = val;
                                      },
                                      selectedItem: editOutbreakFarmController.community,
                                      // autoValidateMode: AutovalidateMode.always,
                                      validator: (item) {
                                        if (item == null) {
                                          return 'Community is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    const SizedBox(height: 20),

                                    const Text('Cocoa Type',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    DropdownSearch<CocoaType>(
                                      popupProps: PopupProps.modalBottomSheet(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                          title: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            child: Center(
                                              child: Text('Select cocoa type',
                                                style: TextStyle(fontWeight: FontWeight.w500),),
                                            ),
                                          ),
                                          disabledItemFn: (CocoaType s) => false,
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
                                        var response = await editOutbreakFarmController.globalController.database!.cocoaTypeDao.findAllCocoaType();
                                        return response;
                                      },
                                      itemAsString: (CocoaType d) => d.name ?? '',
                                      // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                      compareFn: (d, filter) => d.name == filter.name,
                                      onChanged: (val) {
                                        editOutbreakFarmController.cocoaType = val;
                                      },
                                      selectedItem: editOutbreakFarmController.cocoaType,
                                      // autoValidateMode: AutovalidateMode.always,
                                      validator: (item) {
                                        if (item == null) {
                                          return 'Cocoa type is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    const Text('Cocoa Age Class',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    DropdownSearch<CocoaAgeClass>(
                                      popupProps: PopupProps.modalBottomSheet(
                                          showSelectedItems: true,
                                          showSearchBox: true,
                                          title: const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                            child: Center(
                                              child: Text('Select cocoa age class',
                                                style: TextStyle(fontWeight: FontWeight.w500),),
                                            ),
                                          ),
                                          disabledItemFn: (CocoaAgeClass s) => false,
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
                                        var response = await editOutbreakFarmController.globalController.database!.cocoaAgeClassDao.findAllCocoaAgeClass();
                                        return response;
                                      },
                                      itemAsString: (CocoaAgeClass d) => d.name ?? '',
                                      // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                                      compareFn: (d, filter) => d.name == filter.name,
                                      onChanged: (val) {
                                        editOutbreakFarmController.cocoaAgeClass = val;
                                      },
                                      selectedItem: editOutbreakFarmController.cocoaAgeClass,
                                      // autoValidateMode: AutovalidateMode.always,
                                      validator: (item) {
                                        if (item == null) {
                                          return 'Cocoa age class is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    const SizedBox(height: 20),

                                    if (!widget.isViewMode)
                                    Row(
                                      children: [
                                        CustomButton(
                                          isFullWidth: false,
                                          backgroundColor: AppColor.xLightBackground,
                                          borderColor: AppColor.black,
                                          borderWidth: 0.5,
                                          verticalPadding: 0.0,
                                          horizontalPadding: 8.0,
                                          onTap: () async{
                                            editOutbreakFarmController.usePolygonDrawingTool();
                                          },
                                          child: Text(
                                            'Demarcate farm boundary',
                                            style: TextStyle(color: AppColor.black, fontSize: 14),
                                          ),
                                        ),

                                        GetBuilder(
                                            init: editOutbreakFarmController,
                                            builder: (context) {
                                              return editOutbreakFarmController.polygon != null
                                                  ? Padding(
                                                padding: const EdgeInsets.only(left: 15.0),
                                                child: appIconBadgeCheck(color: AppColor.primary, size: 35),
                                              )
                                                  : Container();
                                            }
                                        ),

                                      ],
                                    ),

                                    if (!widget.isViewMode)
                                    const SizedBox(height: 20),

                                    const Text('Farm Area in Hectares',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    TextFormField(
                                      controller: editOutbreakFarmController.farmAreaTC,
                                      readOnly: true,
                                      onTap: () => editOutbreakFarmController.globals.showSnackBar(title: 'Alert', message: 'Kindly tap Demarcate farm boundary to compute area'),
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
                                          ? "Area is required"
                                          : null,
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
                                                if (!editOutbreakFarmController.isSaveButtonDisabled.value){
                                                  if (editOutbreakFarmController.formKey.currentState!.validate()) {
                                                    editOutbreakFarmController.handleSaveOfflineOutbreakFarm();
                                                  }else{
                                                    editOutbreakFarmController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
                                                  }
                                                }
                                              },
                                              child: Obx(() =>
                                                  Text(
                                                    editOutbreakFarmController.isSaveButtonDisabled.value ? 'Please wait ...' : 'Save',
                                                    style: TextStyle(color: AppColor.white, fontSize: 14),
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
                                              onTap: () async{
                                                if (!editOutbreakFarmController.isButtonDisabled.value){
                                                  if (editOutbreakFarmController.formKey.currentState!.validate()) {
                                                    editOutbreakFarmController.handleAddOutbreakFarm();
                                                  }else{
                                                    editOutbreakFarmController.globals.showSnackBar(title: 'Alert', message: 'Kindly provide all required information');
                                                  }
                                                }
                                              },
                                              child: Obx(() =>
                                                  Text(
                                                    editOutbreakFarmController.isButtonDisabled.value ? 'Please wait ...' : 'Submit',
                                                    style: TextStyle(color: AppColor.white, fontSize: 14),
                                                  ),
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
      ),
    );
  }
}
