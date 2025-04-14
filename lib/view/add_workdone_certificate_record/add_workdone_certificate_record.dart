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
import 'add_workdone_record_controller.dart';

class AddContractorCertificateRecord extends StatefulWidget {
  const AddContractorCertificateRecord({Key? key}) : super(key: key);

  @override
  State<AddContractorCertificateRecord> createState() =>
      _AddContractorCertificateRecordState();
}

class _AddContractorCertificateRecordState
    extends State<AddContractorCertificateRecord> {
  final AddContractorCertificateRecordController controller =
  Get.put(AddContractorCertificateRecordController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  void _initializeForm() {
    controller.sectorTC!.text =
        controller.globalController.userInfo.value.sector.toString();
    controller.addContractorCertificateRecordScreenContext = context;
  }

  List<int> _generateYearList() {
    final currentYear = DateTime.now().year;
    const startingYear = 2022;
    return List.generate(
        (currentYear - startingYear) + 1, (index) => startingYear + index);
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
                      key: controller.addContractorCertificateRecordFormKey,
                      child: Column(
                        children: [
                          _buildYearDropdown(),
                          const SizedBox(height: 20),
                          _buildMonthDropdown(),
                          const SizedBox(height: 20),
                          _buildWeekDropdown(),
                          const SizedBox(height: 20),
                          _buildSectorField(),
                          const SizedBox(height: 20),
                          _buildFarmReferenceDropdown(),
                          const SizedBox(height: 20),
                          _buildFarmerNameField(),
                          const SizedBox(height: 20),
                          _buildFarmSizeField(),
                          const SizedBox(height: 20),
                          _buildCommunityField(),
                          const SizedBox(height: 20),
                          _buildActivityDropdown(),
                          const SizedBox(height: 20),
                          _buildSubActivityDropdown(),
                          const SizedBox(height: 20),
                          _buildRoundsOfWeedingDropdown(),
                          const SizedBox(height: 20),
                          _buildContractorDropdown(),
                          const SizedBox(height: 40),
                          _buildActionButtons(),
                          const SizedBox(height: 30),
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
                'New WD By Contractor Certificate',
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

  Widget _buildYearDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
          ),
          items: _generateYearList().map((year) => year.toString()).toList(),
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
          validator: (item) => item == null ? "Current year is required" : null,
          onChanged: (val) {
            controller.selectedYear = val!;
            controller.update();
          },
        ),
      ],
    );
  }

  Widget _buildMonthDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
          ),
          items: controller.listOfMonths,
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
          validator: (item) => item == null ? "Current month is required" : null,
          onChanged: (val) {
            controller.selectedMonth = val!;
            controller.update();
          },
        ),
      ],
    );
  }

  Widget _buildWeekDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
          ),
          items: controller.listOfWeeks,
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
          validator: (item) => item == null ? "Current week is required" : null,
          onChanged: (val) {
            controller.selectedWeek = val!;
            controller.update();
          },
        ),
      ],
    );
  }

  Widget _buildSectorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sector',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextFormField(
          readOnly: true,
          controller: controller.sectorTC,
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
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          validator: (value) =>
          value!.trim().isEmpty ? "Community is required" : null,
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
            final response = await controller.jobDb.getAllFarms();
            debugPrint("Farm Reference Response: $response");
            return response;
          },
          itemAsString: (JobOrderFarmModel d) => d.farmId.toString(),
          compareFn: (activity, filter) => activity == filter,
          onChanged: (val) {
            if (val != null) {
              controller.farmReferenceNumberTC!.text = val.farmId.toString();
              controller.farmerNameTC!.text = val.farmerName.toString();
              controller.farmSizeTC!.text = val.farmSize.toString();
              controller.communityTC!.text = val.location.toString();
              controller.update();
            }
          },
          autoValidateMode: AutovalidateMode.always,
          validator: (item) => item == null ? 'Farm reference is required' : null,
        ),
      ],
    );
  }

  Widget _buildFarmerNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Farmer name',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller.farmerNameTC,
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
          validator: (value) =>
          value!.trim().isEmpty ? "Farmer name is required" : null,
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
          validator: (value) =>
          value!.trim().isEmpty ? "Farm size is required" : null,
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
          readOnly: true,
          controller: controller.communityTC,
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
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          validator: (value) =>
          value!.trim().isEmpty ? "Community is required" : null,
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
            final activities = await controller.db.getAllActivityWithMainActivityList([
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
            return await controller.db.getSubActivityByMainActivity(
                controller.activity!);
          },
          itemAsString: (ActivityModel d) => d.subActivity.toString(),
          compareFn: (activity, filter) =>
          activity.subActivity == filter.subActivity,
          onChanged: (vals) {
            controller.subActivity = vals ?? [];
            controller.update();
          },
          autoValidateMode: AutovalidateMode.always,
          validator: (items) =>
          items == null || items.isEmpty ? 'Sub activity is required' : null,
        ),
      ],
    );
  }

  Widget _buildRoundsOfWeedingDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
          ),
          items: controller.listOfRoundsOfWeeding,
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
          onChanged: (val) {
            if (val != null) {
              controller.roundsOfWeeding = val;
              controller.update();
            }
          },
        ),
      ],
    );
  }

  Widget _buildContractorDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  style: selected
                      ? TextStyle(color: AppColor.primary)
                      : const TextStyle(),
                ),
              );
            },
            title: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Text(
                  'Select contractor',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            disabledItemFn: (Contractor s) => false,
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
            return await controller.globalController.database!.contractorDao
                .findAllContractors();
          },
          itemAsString: (Contractor d) => d.contractorName ?? '',
          compareFn: (d, filter) => d.contractorName == filter.contractorName,
          onChanged: (val) {
            controller.contractor = val;
          },
          autoValidateMode: AutovalidateMode.always,
          validator: (item) =>
          item == null ? 'Contractor name is required' : null,
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
            onTap: () {
              if (controller.addContractorCertificateRecordFormKey.currentState!
                  .validate()) {
                controller.handleSaveOfflineMonitoringRecord();
              } else {
                controller.globals.showSnackBar(
                  title: 'Alert',
                  message: 'Kindly provide all required information',
                );
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
            onTap: () {
              if (controller.addContractorCertificateRecordFormKey.currentState!
                  .validate()) {
                controller.handleAddMonitoringRecord();
              } else {
                controller.globals.showSnackBar(
                  title: 'Alert',
                  message: 'Kindly provide all required information',
                );
              }
            },
            child: Text(
              'Submit',
              style: TextStyle(color: AppColor.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}