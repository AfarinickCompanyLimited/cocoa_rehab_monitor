import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../auth/login/login.dart';
import '../global_components/custom_button.dart';
import '../global_components/round_icon_button.dart';
import '../utils/style.dart';
import 'leave_request_controller.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({Key? key}) : super(key: key);

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {

  LeaveRequestController leaveRequestController = Get.put(LeaveRequestController());
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
                            items: leaveRequestController.leaveList
                                .map((year) => year.toString())
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
                              leaveRequestController.update();
                            },
                          ),
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
                            onTap: () async {
                              // Show date picker for start date
                              DateTime? pickedStartDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );

                              if (pickedStartDate != null) {
                                leaveRequestController.startDate.text = pickedStartDate.toString();
                                leaveRequestController.update();
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
                            textCapitalization: TextCapitalization.characters,
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
                            onTap: () async {
                              // Ensure a start date is selected
                              if (leaveRequestController.startDate.text.isEmpty) {
                                Get.snackbar('Error', 'Please select a starting date first');
                                return;
                              }

                              DateTime pickedStartDate = DateTime.parse(leaveRequestController.startDate.text);

                              // Show date picker for end date starting from one day after start date
                              DateTime? pickedEndDate = await showDatePicker(
                                context: context,
                                initialDate: pickedStartDate.add(Duration(days: 1)),
                                firstDate: pickedStartDate.add(Duration(days: 1)),
                                lastDate: DateTime(2101),
                              );

                              if (pickedEndDate != null) {
                                leaveRequestController.endDate.text = pickedEndDate.toString();
                                // Calculate the number of days between start and end dates
                                final difference = pickedEndDate.difference(pickedStartDate).inDays;
                                leaveRequestController.numberOfDays.text = difference.toString();
                                leaveRequestController.update();
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
                            textCapitalization: TextCapitalization.characters,
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
                              // Add your submission logic here
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
