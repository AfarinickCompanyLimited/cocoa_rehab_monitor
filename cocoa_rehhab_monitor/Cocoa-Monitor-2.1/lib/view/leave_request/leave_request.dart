import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../global_components/custom_button.dart';
import '../global_components/round_icon_button.dart';
import '../global_components/text_input_decoration.dart';
import '../utils/style.dart';
import 'leave_request_controller.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({Key? key}) : super(key: key);

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {

  LeaveRequestController leaveRequestController = Get.put(LeaveRequestController());

  var maxDays = 0;

  @override
  Widget build(BuildContext context) {
    leaveRequestController.LeaveRequestScreenContext = context;
    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColor.lightBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              children: [
                // Top navigation bar
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
                            'Leave Request',
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
                // Main form content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Leave Type',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Obx(() => DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              disabledItemFn: (String s) => false,
                              fit: FlexFit.loose,
                              menuProps: MenuProps(
                                elevation: 6,
                                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                              ),
                            ),
                            items: leaveRequestController.leaveList
                                .map((leave_type) => leave_type.toString())
                                .toList(),
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
                            autoValidateMode: AutovalidateMode.always,
                            validator: (item) {
                              if (item == null) {
                                return "Leave Type is required";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              leaveRequestController.selectedLeave.value = val!;
                              leaveRequestController.getMaximumLeaveDays();
                            },
                          )),
                          const SizedBox(height: 20),
                          const Text(
                            'Starting Date',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            controller: leaveRequestController.startDate,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Starting Date is required';
                              }
                              return null;
                            },
                            readOnly: true, // Prevent manual editing
                            onTap: () async {
                              // Show date picker for start date
                              DateTime? pickedStartDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                                selectableDayPredicate: (DateTime date) {
                                  // Return true if the day is not Saturday or Sunday
                                  return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
                                },
                              );


                              if (pickedStartDate != null) {
                                leaveRequestController.startDate.text = DateFormat('yyyy-MM-dd').format(pickedStartDate);
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range, color: AppColor.black),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorderFocused,
                              errorBorder: inputBorder,
                              focusedErrorBorder: inputBorderFocused,
                              filled: true,
                              fillColor: AppColor.xLightBackground,
                            ),
                            keyboardType: TextInputType.none,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Ending Date',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            controller: leaveRequestController.endDate,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ending Date is required';
                              }
                              return null;
                            },
                            readOnly: true, // Prevent manual editing
                            onTap: () async {
                              print("THR NUMBER OF DAYS: ${leaveRequestController.maxDays.value}");
                              // Ensure a start date is selected
                              if (leaveRequestController.startDate.text.isEmpty) {
                                leaveRequestController.globals.showSnackBar(
                                  title: 'Error',
                                  message: 'Please select a starting date first',
                                );
                                return;
                              }

                              DateTime pickedStartDate = DateTime.parse(leaveRequestController.startDate.text);

                              // Show date picker for end date starting from one day after start date
                              DateTime? pickedEndDate = await showDatePicker(
                                context: context,
                                initialDate: pickedStartDate.add(const Duration(days: 1)),
                                firstDate: pickedStartDate.add(const Duration(days: 1)),
                                lastDate: DateTime(2101),
                                selectableDayPredicate: (DateTime date) {
                                  // Return true if the day is not Saturday or Sunday
                                  return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
                                },
                              );


                              if (pickedEndDate != null) {
                                leaveRequestController.endDate.text = DateFormat('yyyy-MM-dd').format(pickedEndDate);
                                // final difference = pickedEndDate.difference(pickedStartDate).inDays + 1;
                                final difference = leaveRequestController.calculateWorkingDays(pickedStartDate, pickedEndDate);

                                if(leaveRequestController.maxDays.value > 0) {
                                  if (difference > leaveRequestController.maxDays.value) {
                                    leaveRequestController.globals.showSnackBar(
                                      title: 'Error',
                                      message: 'The number of days cannot exceed ${leaveRequestController.maxDays.value}',
                                    );
                                    leaveRequestController.endDate.clear();
                                    leaveRequestController.numberOfDays.text = "";
                                    return;
                                  }
                                }

                                leaveRequestController.numberOfDays.text = difference.toString();
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range, color: AppColor.black),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorderFocused,
                              errorBorder: inputBorder,
                              focusedErrorBorder: inputBorderFocused,
                              filled: true,
                              fillColor: AppColor.xLightBackground,
                            ),
                            keyboardType: TextInputType.none,
                            textCapitalization: TextCapitalization.none,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Number of days',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            controller: leaveRequestController.numberOfDays,
                            onTap: () => null,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              enabledBorder: inputBorder,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                                borderSide: BorderSide(width: 1, color: AppColor.lightText),
                              ),
                              errorBorder: inputBorder,
                              focusedErrorBorder: inputBorderFocused,
                              filled: true,
                              fillColor: AppColor.lightText,
                            ),
                            keyboardType: TextInputType.none,
                            cursorColor: AppColor.lightText
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            'Reason',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextFormField(
                            controller: leaveRequestController.leaveReason,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Reason is required';
                              }
                              return null;
                            },
                            maxLines: 5,
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
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            isFullWidth: true,
                            backgroundColor: AppColor.primary,
                            verticalPadding: 0.0,
                            horizontalPadding: 8.0,
                            onTap: () async {
                              leaveRequestController.submitLeaveRequest();
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
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
}
