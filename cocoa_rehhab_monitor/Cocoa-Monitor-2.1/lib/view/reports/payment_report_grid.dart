// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cocoa_monitor/controller/utils/save_files_to_documents.dart';
import 'package:cocoa_monitor/view/home/components/detailed_info_of_payment_report_bottom_sheet.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/controller/utils/connection_verify.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

import '../global_components/custom_button.dart';
import '../global_components/globals.dart';
import '../utils/style.dart';

class PaymentReportGridScreen extends StatefulWidget {
  const PaymentReportGridScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentReportGridScreen> createState() =>
      _PaymentReportGridScreenState();
}

class _PaymentReportGridScreenState extends State<PaymentReportGridScreen> {
  late Future future;
  @override
  void initState() {
    super.initState();
    future = getReportDataSource();
  }

  GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  Globals globals = Globals();

  final args = Get.arguments;

  GlobalController indexController = Get.find();
  var unavailable = false;

  final DataGridController _dataGridController = DataGridController();

  @override
  Widget build(BuildContext context) {
    // bool isSearching = false;

    final appBar = AppBar(
      centerTitle: true,
      title: Text(
        '${args[1]['month']}, ${args[2]['year']}. Week ${args[0]['week']}',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
    var appBarHeight = appBar.preferredSize.height;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var screenSize = MediaQuery.of(context).size;
    var top = MediaQuery.of(context).padding.top;
    var sizedBoxHeight = (screenSize.height - appBarHeight - top);

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(left: 20, top: 8),
              //   child: Icon(Icons.arrow_back),
              // ),
              // IconButton(
              // onPressed: () => Get.back(),
              // icon: appIconBack(color: AppColor.black, size: 25)),
              // RoundedIconButton(
              //   icon: appIconBack(color: AppColor.black, size: 25),
              //   size: 45,
              //   backgroundColor: Colors.transparent,
              //   onTap: () => Get.back(),
              // ),
              SizedBox(
                height: sizedBoxHeight,
                child: FutureBuilder(
                  future: future,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.done:
                        print(unavailable.toString());
                        if (unavailable == true) {
                          return const Center(
                              child: Text(
                                  'No Payment Reports Exist For This Period'));
                        }

                        if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8, left: 8),
                          child: Column(
                            children: [
                              // TextButton(
                              //     child: const Text('Get Selection Information'),
                              //     onPressed: () {
                              //       //SelectedIndex
                              //       var _selectedIndex =
                              //           _dataGridController.selectedIndex;

                              //       //SelectedRow
                              //       var _selectedRow =
                              //           _dataGridController.selectedRow;

                              //       //SelectedRows
                              //       // var _selectedRows =
                              //       // _dataGridController.selectedRows;

                              //       print(_selectedIndex);
                              //       print(_selectedRow);
                              //       // print(_selectedRows);
                              //     }),
                              SizedBox(
                                  height: isPortrait
                                      ? sizedBoxHeight * 0.9
                                      : sizedBoxHeight * 0.8,
                                  child: SfDataGridTheme(
                                    data: SfDataGridThemeData(
                                      filterIcon: Builder(
                                        builder: (context) {
                                          Widget? icon;
                                          String columnName = '';
                                          context
                                              .visitAncestorElements((element) {
                                            if (element
                                                is GridHeaderCellElement) {
                                              columnName =
                                                  element.column.columnName;
                                            }
                                            return true;
                                          });
                                          var column = snapshot
                                              .data.filterConditions.keys
                                              .where((element) =>
                                                  element == columnName);
                                          if (column != null) {
                                            icon = const Icon(
                                              Icons.search,
                                              size: 30,
                                              color: Colors.grey,
                                            );
                                          }
                                          return icon ??
                                              const Icon(
                                                Icons.filter_alt_off_outlined,
                                                size: 20,
                                                color: Colors.deepOrange,
                                              );
                                        },
                                      ),
                                      frozenPaneLineWidth: 0,
                                      frozenPaneElevation: 0,
                                    ),
                                    child: SfDataGrid(
                                      selectionMode: SelectionMode.single,

                                      onCellTap: ((details) {
                                        if (details.rowColumnIndex.rowIndex !=
                                            0) {
                                          int selectedRowIndex =
                                              details.rowColumnIndex.rowIndex -
                                                  1;
                                          var row = snapshot.data.effectiveRows
                                              .elementAt(selectedRowIndex);
                                          print(row
                                              .getCells()[1]
                                              .value
                                              .toString());
                                          // showNewModalSheet(context);

                                          Get.to(
                                              () => const DetailedInfoScreen(),
                                              arguments: [
                                                {"week": args[0]['week']},
                                                {"month": args[1]['month']},
                                                {"year": args[2]['year']},
                                                {
                                                  "raid": row
                                                      .getCells()[1]
                                                      .value
                                                      .toString()
                                                },
                                              ]);

                                          // Get.to(() => DetailedInfoOfPayment(),
                                          //     arguments: [
                                          //       {
                                          //         'userid': indexController
                                          //             .userInfo.value.userId
                                          //       },
                                          //       {"week": args[0]['week']},
                                          //       {"month": args[1]['month']},
                                          //       {"year": args[2]['year']},
                                          //       {
                                          //         "raid": row
                                          //             .getCells()[1]
                                          //             .value
                                          //             .toString()
                                          //       }
                                          //     ]);

                                          // row.getCells()[1].value.toString()

                                          // showDialog(
                                          //     context: context,
                                          //     builder: (context) => AlertDialog(
                                          //         shape: const RoundedRectangleBorder(
                                          //             borderRadius: BorderRadius.all(
                                          //                 Radius.circular(32.0))),
                                          //         content: SizedBox(
                                          //           height: 300,
                                          //           width: 300,
                                          //           child: Column(
                                          //               mainAxisAlignment:
                                          //                   MainAxisAlignment
                                          //                       .spaceBetween,
                                          //               children: [
                                          //                 Row(children: [
                                          //                   const Text('Employee ID'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   25)),
                                          //                   const Text(':'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   10)),
                                          //                   Text(row
                                          //                       .getCells()[0]
                                          //                       .value
                                          //                       .toString()),
                                          //                 ]),
                                          //                 Row(children: [
                                          //                   const Text(
                                          //                       'Employee Name'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   10)),
                                          //                   const Text(':'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   10)),
                                          //                   Text(row
                                          //                       .getCells()[1]
                                          //                       .value
                                          //                       .toString()),
                                          //                 ]),
                                          //                 Row(children: [
                                          //                   const Text('Designation'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   25)),
                                          //                   const Text(':'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   10)),
                                          //                   Text(row
                                          //                       .getCells()[2]
                                          //                       .value
                                          //                       .toString()),
                                          //                 ]),
                                          //                 Row(children: [
                                          //                   const Text('Salary'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   45)),
                                          //                   const Text(':'),
                                          //                   const Padding(
                                          //                       padding: EdgeInsets
                                          //                           .symmetric(
                                          //                               horizontal:
                                          //                                   10)),
                                          //                   Text(row
                                          //                       .getCells()[3]
                                          //                       .value
                                          //                       .toString()),
                                          //                 ]),
                                          //                 SizedBox(
                                          //                   width: 300,
                                          //                   child: ElevatedButton(
                                          //                       onPressed: () {
                                          //                         Navigator.pop(
                                          //                             context);
                                          //                       },
                                          //                       child:
                                          //                           const Text("OK")),
                                          //                 )
                                          //               ]),
                                          //         )));
                                        }
                                      }),

                                      // onCellTap: (DataGridCellTapDetails details) {

                                      // print(details);
                                      // print('HELLOO WORLD');
                                      // var _selectedIndex =
                                      //     _dataGridController.selectedIndex;

                                      // var _selectedRow =
                                      //     _dataGridController.selectedRow;

                                      // var _info =
                                      //     _dataGridController;

                                      // print(_selectedIndex);
                                      // print(_selectedRow);
                                      // print(_info);
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) =>
                                      //         AlertDialog(
                                      //             title:
                                      //                 const Text('Tapped Content'),
                                      //             actions: <Widget>[
                                      //               TextButton(
                                      //                   onPressed: () =>
                                      //                       Navigator.pop(context),
                                      //                   child: const Text('OK'))
                                      //             ],
                                      //             content: Text(snapshot
                                      //                 .data
                                      //                 .effectiveRows[details
                                      //                         .rowColumnIndex
                                      //                         .rowIndex -
                                      //                     1]
                                      //                 .getCells()[details
                                      //                     .rowColumnIndex
                                      //                     .columnIndex]
                                      //                 .value
                                      //                 .toString())));
                                      // },
                                      allowFiltering: true,
                                      key: key,
                                      frozenColumnsCount: 1,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      rowHeight: 65,
                                      source: snapshot.data,
                                      columns: getColumns(),
                                      controller: _dataGridController,
                                      // selectionMode: SelectionMode.multiple
                                    ),
                                  )),
                              SizedBox(
                                height: sizedBoxHeight * 0.01,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CustomButton(
                                  isFullWidth: true,
                                  backgroundColor: AppColor.primary,
                                  verticalPadding: 0.0,
                                  horizontalPadding: 8.0,
                                  onTap: () async {
                                    final Workbook workbook = key.currentState!
                                        .exportToExcelWorkbook();
                                    final List<int> bytes =
                                        workbook.saveAsStream();
                                    File('${args[1]['month']}_week${args[0]['week']}_${args[2]['year']}.xlsx')
                                        .writeAsBytes(bytes, flush: true);
                                    workbook.dispose();
                                    await FileStorage.saveExcelFile(bytes,
                                        'payroll_${args[1]['month']}_week${args[0]['week']}_${args[2]['year']}.xlsx');

                                    globals.showSnackBar(
                                        duration: Platform.isIOS ? 10 : 4,
                                        title: 'Success',
                                        message: Platform.isIOS
                                            ? 'Saved. Open the files app, tap on "On My iPhone". You will find your saved excel file inside the Cocoa Rehab Monitor folder'
                                            : 'Excel file created in your downloads folder');
                                  },
                                  child: const Text(
                                    'Export to Excel',
                                    style:
                                        TextStyle(overflow: TextOverflow.clip),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        );
                      default:
                        return const Text('No data found');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ReportDataGridSource> getReportDataSource() async {
    var reportList = await loadFinacialReport();
    return ReportDataGridSource(reportList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'raName',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('RA NAME',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'raID',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('RA ID',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'district',
          width: 120,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('DISTRICT',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'bankName',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('BANK NAME',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'bankBranch',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('BANK BRANCH'))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'snnitNumber',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('SSNIT NUMBER',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'salary',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('SALARY',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'year',
          width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('YEAR',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'poNumber',
          width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('PO NUMBER',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'month',
          width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('MONTH',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'week',
          width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('WEEK',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'paymentOption',
          width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('PAYMENT OPTION',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'momoAccount',
          width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('MOMO ACCOUNT',
                  overflow: TextOverflow.clip, softWrap: true))),
    ];
  }

  Future<List<Report>> loadFinacialReport() async {
    List<Report> mainReportList = [];

    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.loadPayments, data: {
          'userid': indexController.userInfo.value.userId,
          'month': args[1]['month'],
          'week': args[0]['week'],
          'year': args[2]['year'],
        });

        print("THE PAYMENT REPORT: ${response.data['data']}");

        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<Report> reportList =
              resultList.map((e) => reportFromJson(jsonEncode(e))).toList();
          mainReportList = reportList;

          unavailable = false;
        } else {
          // return false;

          // mainReportList = [];
          unavailable = true;

        }
      } catch (e, stackTrace) {
        print(e);
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadFinacialReport');
      }
    }

    return mainReportList;
  }
}

class ReportDataGridSource extends DataGridSource {
  ReportDataGridSource(this.reportList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Report> reportList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[0].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              row.getCells()[4].value.toString(),
              overflow: TextOverflow.clip,
            )),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[6].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[7].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[8].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[9].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[10].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[11].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[12].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = reportList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'raName', value: dataGridRow.raName),
        DataGridCell(columnName: 'raID', value: dataGridRow.raID),
        DataGridCell<String>(
            columnName: 'district', value: dataGridRow.district),
        DataGridCell<String>(
            columnName: 'bankName', value: dataGridRow.bankName),
        DataGridCell<String>(
            columnName: 'bankBranch', value: dataGridRow.bankBranch),
        DataGridCell<String>(
            columnName: 'snnitNumber', value: dataGridRow.snnitNumber),
        DataGridCell<String>(columnName: 'salary', value: dataGridRow.salary),
        DataGridCell<String>(columnName: 'year', value: dataGridRow.year),
        DataGridCell<String>(
            columnName: 'poNumber', value: dataGridRow.poNumber),
        DataGridCell<String>(columnName: 'month', value: dataGridRow.month),
        DataGridCell<String>(columnName: 'week', value: dataGridRow.week),
        DataGridCell<String>(
            columnName: 'paymentOption', value: dataGridRow.paymentOption),
        DataGridCell<String>(
            columnName: 'momoAccount', value: dataGridRow.momoAccount),
      ]);
    }).toList(growable: false);
  }
}

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

class Report {
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      raID: json['ra_id'],
      raName: json['ra_name'],
      district: json['district'],
      bankName: json['bank_name'],
      bankBranch: json['bank_branch'],
      snnitNumber: json['snnit_no'],
      salary: json['salary'],
      year: json['year'],
      poNumber: json['po_number'],
      month: json['month'],
      week: json['week'],
      paymentOption: json['payment_option'],
      momoAccount: json['momo_acc'],
    );
  }
  Report({
    required this.raID,
    required this.raName,
    required this.district,
    required this.bankName,
    required this.bankBranch,
    required this.snnitNumber,
    required this.salary,
    required this.year,
    required this.poNumber,
    required this.month,
    required this.week,
    required this.paymentOption,
    required this.momoAccount,
  });
  final String? raID;
  final String? raName;
  final String? district;
  final String? bankName;
  final String? bankBranch;
  final String? snnitNumber;
  final String? salary;
  final String? year;
  final String? poNumber;
  final String? month;
  final String? week;
  final String? paymentOption;
  final String? momoAccount;
}
