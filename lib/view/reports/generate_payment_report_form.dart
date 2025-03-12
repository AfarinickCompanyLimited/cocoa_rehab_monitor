import 'package:cocoa_rehab_monitor/view/reports/payment_report_grid.dart';
import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'payment_report_controller.dart';

class GeneratePaymentReportForm extends StatefulWidget {
  const GeneratePaymentReportForm({Key? key}) : super(key: key);

  @override
  State<GeneratePaymentReportForm> createState() =>
      _GeneratePaymentReportFormState();
}

class _GeneratePaymentReportFormState extends State<GeneratePaymentReportForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController weekController = TextEditingController();

  String? _selectedWeek;
  String? _selectedMonth;
  String? _selectedYear;

  List<String> listOfWeeks = ['1', '2', '3', '4', '5'];
  List<String> listOfMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  _submit() {
    Get.to(() => const PaymentReportGridScreen(), arguments: [
      {"week": _selectedWeek},
      {"month": _selectedMonth},
      {"year": _selectedYear}
    ]);
  }

  @override
  Widget build(BuildContext context) {
    int currentYear = DateTime.now().year;
    int startingYear = 2023;
    List<int> yearList =
        List.generate((currentYear - startingYear) + 1, (index) {
      return startingYear + index;
    });

    PaymentReportController paymentReportController =
        Get.put(PaymentReportController());
    paymentReportController.paymentReportScreenContext = context;

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
          body: Column(
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
                        child: Text('Generate Report',
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
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 12, bottom: 8, right: 12),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  hintText: 'Select Week',
                                  hintStyle: TextStyle(color: AppColor.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: AppColor.black, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: AppColor.black, width: 1.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: AppColor.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  isDense: true,
                                  // filled: true,
                                  // fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0)),
                              value: _selectedWeek,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedWeek = value!;
                                });
                              },
                              items: listOfWeeks.map((String val) {
                                return DropdownMenuItem(
                                    value: val, child: Text(val));
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a week!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 12, bottom: 8, right: 12),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  hintText: 'Select Month',
                                  hintStyle: TextStyle(color: AppColor.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: AppColor.black, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: AppColor.black, width: 1.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: AppColor.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0)),
                              value: _selectedMonth,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedMonth = value!;
                                });
                              },
                              items: listOfMonths.map((String val) {
                                return DropdownMenuItem(
                                    value: val, child: Text(val));
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a month!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 12, bottom: 8, right: 12),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  hintText: 'Select Year',
                                  hintStyle: TextStyle(color: AppColor.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide(
                                        color: AppColor.black, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: AppColor.black, width: 1.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: AppColor.black,
                                      width: 1.5,
                                    ),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0)),
                              value: _selectedYear,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedYear = value!;
                                });
                              },
                              items: yearList.map((int year) {
                                return DropdownMenuItem<String>(
                                  value: year.toString(),
                                  child: Text(year.toString()),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a year!';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 12, bottom: 8, right: 12),
                            child: CustomButton(
                              isFullWidth: true,
                              backgroundColor: AppColor.primary,
                              verticalPadding: 0.0,
                              horizontalPadding: 8.0,
                              onTap: () async {
                                _submit();
                              },
                              child: Text(
                                'Generate',
                                style: TextStyle(
                                    color: AppColor.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ))),
              // Expanded(
              //   flex: 3,
              //   child: FinancialReport(),
              // ),

              // Expanded(
              //   child: SingleChildScrollView(
              //     padding: EdgeInsets.only(
              //         left: AppPadding.horizontal,
              //         right: AppPadding.horizontal,
              //         bottom: AppPadding.vertical,
              //         top: 10),
              //     child: Column(
              //       children: [
              //         Form(
              //           key: farmCSVController.farmCSVFormKey,
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               const Text(
              //                 'Start Date',
              //                 style: TextStyle(fontWeight: FontWeight.w500),
              //               ),
              //               const SizedBox(
              //                 height: 5,
              //               ),
              //               DateTimePicker(
              //                 controller: farmCSVController.startDateTC,
              //                 type: DateTimePickerType.date,
              //                 initialDate: DateTime.now(),
              //                 dateMask: 'yyyy-MM-dd',
              //                 firstDate: DateTime(1600),
              //                 lastDate: DateTime.now(),
              //                 decoration: InputDecoration(
              //                   contentPadding: const EdgeInsets.symmetric(
              //                       vertical: 15, horizontal: 15),
              //                   enabledBorder: inputBorder,
              //                   focusedBorder: inputBorderFocused,
              //                   errorBorder: inputBorder,
              //                   focusedErrorBorder: inputBorderFocused,
              //                   filled: true,
              //                   fillColor: AppColor.xLightBackground,
              //                 ),
              //                 onChanged: (val) =>
              //                     farmCSVController.startDateTC?.text = val,
              //                 validator: (String? value) =>
              //                     value!.trim().isEmpty
              //                         ? "Assignment date is required"
              //                         : null,
              //                 onSaved: (val) =>
              //                     farmCSVController.startDateTC?.text = val!,
              //               ),

              //               const SizedBox(height: 20),

              //               const Text(
              //                 'End Date',
              //                 style: TextStyle(fontWeight: FontWeight.w500),
              //               ),
              //               const SizedBox(
              //                 height: 5,
              //               ),
              //               DateTimePicker(
              //                 controller: farmCSVController.endDateTC,
              //                 type: DateTimePickerType.date,
              //                 // initialDate: DateTime.now(),
              //                 dateMask: 'yyyy-MM-dd',
              //                 firstDate: DateTime(1600),
              //                 lastDate: DateTime.now(),
              //                 decoration: InputDecoration(
              //                   contentPadding: const EdgeInsets.symmetric(
              //                       vertical: 15, horizontal: 15),
              //                   enabledBorder: inputBorder,
              //                   focusedBorder: inputBorderFocused,
              //                   errorBorder: inputBorder,
              //                   focusedErrorBorder: inputBorderFocused,
              //                   filled: true,
              //                   fillColor: AppColor.xLightBackground,
              //                 ),
              //                 onChanged: (val) =>
              //                     farmCSVController.endDateTC?.text = val,
              //                 validator: (String? value) =>
              //                     value!.trim().isEmpty
              //                         ? "End date is required"
              //                         : null,
              //                 onSaved: (val) =>
              //                     farmCSVController.endDateTC?.text = val!,
              //               ),

              //               const SizedBox(
              //                 height: 40,
              //               ),

              //               const SizedBox(
              //                 height: 40,
              //               ),

              //               CustomButton(
              //                 child: Text(
              //                   'Submit',
              //                   style: TextStyle(
              //                       color: AppColor.white, fontSize: 14),
              //                 ),
              //                 isFullWidth: true,
              //                 backgroundColor: AppColor.primary,
              //                 verticalPadding: 0.0,
              //                 horizontalPadding: 8.0,
              //                 onTap: () async {
              //                   if (!farmCSVController.isButtonDisabled.value) {
              //                     if (farmCSVController
              //                         .farmCSVFormKey.currentState!
              //                         .validate()) {
              //                       farmCSVController.handleLoadCSV();
              //                     } else {
              //                       farmCSVController.globals.showSnackBar(
              //                           title: 'Alert',
              //                           message:
              //                               'Kindly provide all required information');
              //                     }
              //                   }
              //                 },
              //               ),

              //               // CustomButton(
              //               //   child: Text(
              //               //     'Submit',
              //               //     style: TextStyle(color: AppColor.white, fontSize: 14),
              //               //   ),
              //               //   isFullWidth: true,
              //               //   backgroundColor: AppColor.primary,
              //               //   verticalPadding: 0.0,
              //               //   horizontalPadding: 8.0,
              //               //   onTap: () async{
              //               //       if (farmCSVController.farmCSVFormKey.currentState!.validate()) {
              //               //         farmCSVController.handleFarmCSV();
              //               //       } else {
              //               //         farmCSVController.globals.showSnackBar(
              //               //             title: 'Alert',
              //               //             message: 'Kindly provide all required information');
              //               //       }
              //               //   },
              //               // ),

              //               // const SizedBox(height: 30),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
