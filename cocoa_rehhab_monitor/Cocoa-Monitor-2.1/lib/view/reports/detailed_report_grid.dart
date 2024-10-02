// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cocoa_monitor/controller/utils/save_files_to_documents.dart';
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

import '../../controller/model/detailed_report_model.dart';
import '../global_components/custom_button.dart';
import '../global_components/globals.dart';
import '../utils/style.dart';

class DetailedReportGridScreen extends StatefulWidget {
  const DetailedReportGridScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailedReportGridScreen> createState() =>
      _DetailedReportGridScreenState();
}

class _DetailedReportGridScreenState extends State<DetailedReportGridScreen> {
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
    // bool isSearching = false;
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
                                  'No Detailed Reports Exist For This Period'));
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
                                    File('${args[1]['month']}_week${args[0]['week']}_${args[2]['year']}_detailed_report.xlsx')
                                        .writeAsBytes(bytes, flush: true);
                                    workbook.dispose();
                                    await FileStorage.saveExcelFile(bytes,
                                        '${args[1]['month']}_week${args[0]['week']}_${args[2]['year']}_detailed_report.xlsx');

                                    globals.showSnackBar(
                                        title: 'Success',
                                        message:
                                            'Excel file created in your downloads folder');
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
    var reportList = await loadDetailedReport();
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
          // width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('RA ID',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'poName',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text('PO NAME',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'poNumber',
          // width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('PO NUMBER',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'district',
          // width: 120,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('DISTRICT',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'farmHandsType',
          // width: 120,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('FARM HANDS TYPE',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'farmReference',
          // width: 120,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('FARM REFERENCE',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'numberInAGroup',
          // width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('NUMBER IN GROUP',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'activity',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('ACTIVITY'))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'achievement',
          // width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('ACHIEVEMENT',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'amount',
          // width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('AMOUNT',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'week',
          // width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('WEEK',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'month',
          // width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('MONTH',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'year',
          // width: 95,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('YEAR',
                  overflow: TextOverflow.clip, softWrap: true))),
      GridColumn(
          allowFiltering: false,
          columnWidthMode: ColumnWidthMode.auto,
          columnName: 'issue',
          width: 150,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('ISSUE',
                  overflow: TextOverflow.clip, softWrap: true))),
    ];
  }

  Future<List<DetailedReport>> loadDetailedReport() async {
    List<DetailedReport> mainReportList = [];

    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio
            .post(URLs.baseUrl + URLs.loadDetailedPaymentReport, data: {
          'userid': indexController.userInfo.value.userId,
          'month': args[1]['month'],
          'week': args[0]['week'],
          'year': args[2]['year'],
          'raid': '',
        });
        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<DetailedReport> reportList =
              resultList.map((e) => reportFromJson(jsonEncode(e))).toList();
          mainReportList = reportList;

          unavailable = false;
        } else {
          // return false;

          // mainReportList = [];
          unavailable = true;
          print(':::$unavailable.toString()');
        }
      } catch (e, stackTrace) {
        print(e);
    FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('loadDetailedReport');


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
  late List<DetailedReport> reportList;

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
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[13].value.toString(),
            overflow: TextOverflow.clip,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[14].value.toString(),
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
        DataGridCell<String>(columnName: 'poName', value: dataGridRow.poName),
        DataGridCell<String>(
            columnName: 'poNumber', value: dataGridRow.poNumber),
        DataGridCell<String>(
            columnName: 'district', value: dataGridRow.district),
        DataGridCell<String>(
            columnName: 'farmHandsType', value: dataGridRow.farmHandsType),
        DataGridCell<String>(
            columnName: 'farmReference', value: dataGridRow.farmReference),
        DataGridCell<String>(
            columnName: 'numberInAGroup', value: dataGridRow.numberInAGroup),
        DataGridCell<String>(
            columnName: 'activity', value: dataGridRow.activity),
        DataGridCell<String>(
            columnName: 'achievement', value: dataGridRow.achievement),
        DataGridCell<String>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<String>(columnName: 'week', value: dataGridRow.week),
        DataGridCell<String>(columnName: 'month', value: dataGridRow.month),
        DataGridCell<String>(columnName: 'year', value: dataGridRow.year),
        DataGridCell<String>(columnName: 'issue', value: dataGridRow.issue),
      ]);
    }).toList(growable: false);
  }
}
