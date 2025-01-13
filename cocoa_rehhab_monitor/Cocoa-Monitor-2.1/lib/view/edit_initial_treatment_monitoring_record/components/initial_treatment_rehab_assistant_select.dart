// ignore_for_file: must_be_immutable

import 'package:cocoa_monitor/controller/db/rehab_assistant_db.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/model/rehab_assistant_model.dart';
import '../edit_initial_treatment_monitoring_record_controller.dart';

class InitialTreatmentRehabAssistantSelect extends StatelessWidget {
  RxInt? index = 0.obs;
  TextEditingController? areaCovered;
  RehabAssistantModel? rehabAssistant;
  String? areaHa;
  final bool? isViewMode;
  InitialTreatmentRehabAssistantSelect(
      {Key? key,
      this.index,
      this.areaCovered,
      this.rehabAssistant,
      this.areaHa,
      this.isViewMode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditInitialTreatmentMonitoringRecordController
        editInitialTreatmentMonitoringRecordController = Get.find();

    areaCovered = TextEditingController();

    editInitialTreatmentMonitoringRecordController.areaCoveredRx.isEmpty
        ? areaCovered
        : areaCovered?.text =
            editInitialTreatmentMonitoringRecordController.areaCoveredRx.value;

    if (areaHa != null) {
      areaCovered!.text = areaHa!;
    }

   
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: appColorInputBackgroundWhite.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppBorderRadius.xl)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  index.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (!isViewMode!)
                  Obx(
                    () => editInitialTreatmentMonitoringRecordController
                                .rehabAssistants.length >
                            1
                        ? CircleIconButton(
                            icon: Icon(
                              appIconTrashOld,
                              color: tmtColorSecondary,
                              size: 20,
                            ),
                            backgroundColor: Colors.white,
                            hasShadow: false,
                            onTap: () {
                              if (editInitialTreatmentMonitoringRecordController
                                  .numberInGroupTC!.text.isEmpty) {
                                editInitialTreatmentMonitoringRecordController
                                    .rehabAssistants
                                    .removeAt(index!.value - 1);

                                editInitialTreatmentMonitoringRecordController
                                    .rehabAssistants
                                    .asMap()
                                    .forEach((index, value) {
                                  editInitialTreatmentMonitoringRecordController
                                      .rehabAssistants[index]
                                      .index!
                                      .value = index + 1;
                                  editInitialTreatmentMonitoringRecordController
                                      .update();
                                });
                              }
                            },
                          )
                        : Container(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Rehab Assistant',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    DropdownSearch<RehabAssistantModel>(
                      popupProps: PopupProps.modalBottomSheet(
                          showSelectedItems: true,
                          showSearchBox: true,
                          itemBuilder: (context, item, selected) {
                            return ListTile(
                              title: Text(item.rehabName.toString(),
                                  style: selected
                                      ? TextStyle(color: AppColor.primary)
                                      : const TextStyle()),
                              subtitle: Text(
                                item.staffId.toString(),
                              ),
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
                          disabledItemFn: (RehabAssistantModel s) => false,
                          modalBottomSheetProps: ModalBottomSheetProps(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(AppBorderRadius.md),
                                    topRight:
                                        Radius.circular(AppBorderRadius.md))),
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
                        final db = RehabAssistantDatabaseHelper.instance;
                        var response =
                            await db.getAllData();
                        return response;
                      },
                      itemAsString: (RehabAssistantModel d) =>
                          d.rehabName.toString(),
                      // filterFn: (regionDistrict, filter) => RegionDistrict.userFilterByCreationDate(filter),
                      compareFn: (rehabAssistant, filter) =>
                          rehabAssistant.rehabName == filter.rehabName,
                      onChanged: (val) {
                        rehabAssistant = val;
                        editInitialTreatmentMonitoringRecordController.update();
                      },
                      // autoValidateMode: AutovalidateMode.always,
                      selectedItem: rehabAssistant,
                      validator: (item) {
                        if (item == null) {
                          return 'Select rehab assistant';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
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
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: areaCovered,
                      readOnly: editInitialTreatmentMonitoringRecordController
                              .areaCoveredRx.isEmpty
                          ? false
                          : true,
                      keyboardType: TextInputType.number,
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
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      validator: (String? value) =>
                          value!.trim().isEmpty ? "Required" : null,
                    ),
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
