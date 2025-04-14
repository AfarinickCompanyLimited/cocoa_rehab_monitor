// ignore_for_file: must_be_immutable, avoid_print

import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/db/rehab_assistant_db.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/view/add_initial_treatment_monitoring_record/add_initial_treatment_monitoring_record_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/model/rehab_assistant_model.dart';

class InitialTreatmentRehabAssistantSelection extends StatelessWidget {
  RxInt? index;
  TextEditingController? areaCovered;
  RehabAssistantModel? rehabAssistant;

  InitialTreatmentRehabAssistantSelection({
    Key? key,
    this.index,
    this.areaCovered,
    this.rehabAssistant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddInitialTreatmentMonitoringRecordController>();
    final db = RehabAssistantDatabaseHelper.instance;

    // initialize text controller only if not passed
    areaCovered ??= TextEditingController();

    // fill text field conditionally
    if (controller.areaCoveredRx.isNotEmpty) {
      areaCovered!.text = controller.areaCoveredRx.value;
    }

    if (controller.isCompletedByGroup.value == YesNo.no) {
      areaCovered!.text = controller.farmSizeTC!.text;
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColorInputBackgroundWhite.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Index and delete button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${index?.value ?? ''}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),

                GetBuilder(
                    init: controller,
                    builder: (context) {
                  return controller.rehabAssistants.length > 1
                      ? CircleIconButton(
                    icon: Icon(appIconTrashOld, color: tmtColorSecondary, size: 20),
                    backgroundColor: Colors.white,
                    hasShadow: false,
                    onTap: () {
                      if (controller.numberInGroupTC!.text.isEmpty) {
                        controller.rehabAssistants.removeAt(index!.value - 1);

                        for (int i = 0; i < controller.rehabAssistants.length; i++) {
                          controller.rehabAssistants[i].index!.value = i + 1;
                        }

                        controller.update();
                      }
                    },
                  )
                      : const SizedBox();
                })
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// Rehab Assistant + Area Input Row
          Row(
            children: [
              /// Rehab Assistant Dropdown
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Rehab Assistant',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5),
                    DropdownSearch<RehabAssistantModel>(
                      popupProps: PopupProps.modalBottomSheet(
                        showSelectedItems: true,
                        showSearchBox: true,
                        itemBuilder: (context, item, selected) {
                          return ListTile(
                            title: Text(
                              item.rehabName ?? "",
                              style: selected ? TextStyle(color: AppColor.primary) : null,
                            ),
                            subtitle: Text(item.staffId ?? ""),
                          );
                        },
                        title: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Select Rehab Assistant',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        modalBottomSheetProps: ModalBottomSheetProps(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(AppBorderRadius.md)),
                          ),
                        ),
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                            enabledBorder: inputBorder,
                            focusedBorder: inputBorderFocused,
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
                          filled: true,
                          fillColor: AppColor.xLightBackground,
                        ),
                      ),
                      asyncItems: (String filter) async {
                        return await db.getAllData();
                      },
                      itemAsString: (item) => item.rehabName ?? "",
                      compareFn: (a, b) => a.rehabName == b.rehabName,
                      selectedItem: rehabAssistant,
                      onChanged: (val) {
                        rehabAssistant = val;
                        controller.update();
                      },
                      validator: (item) => item == null ? 'Select rehab assistant' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 15),

              /// Area Input
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Area (ha)',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Obx(() {
                      final isReadOnly = controller.isDoneEqually.value == YesNo.yes;
                      return TextFormField(
                        controller: areaCovered,
                        readOnly: isReadOnly,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorderFocused,
                          filled: true,
                          fillColor: isReadOnly ? AppColor.lightText : AppColor.xLightBackground,
                        ),
                        validator: (value) => value!.trim().isEmpty ? "Required" : null,
                        onTap: () {
                          print("Area Covered: ${controller.areaCoveredRx.value}");
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
