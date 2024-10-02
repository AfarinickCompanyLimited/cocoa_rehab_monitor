// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/constants.dart';
import '../../controller/global_controller.dart';
import '../../controller/model/loaded_issue_model.dart';
import '../../controller/utils/connection_verify.dart';
import 'submit_issue_controller.dart';

class IssueHistory extends StatefulWidget {
  const IssueHistory({Key? key}) : super(key: key);

  @override
  State<IssueHistory> createState() => _IssueHistoryState();
}

class _IssueHistoryState extends State<IssueHistory> {
  GlobalController indexController = Get.find();
  var unavailable = false;
  var noConnection = false;

  late Future<List<LoadedIssue>> future;

  @override
  void initState() {
    super.initState();
    future = loadIssuesFromServer();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SubmitIssueController submitIssueController =
        Get.put(SubmitIssueController());
    submitIssueController.context = context;

    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: size.height * 0.80,
                    child: FutureBuilder<List<LoadedIssue>>(
                      future: future,
                      builder:
                          (context, AsyncSnapshot<List<LoadedIssue>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.done:
                            print(unavailable.toString());
                            if (unavailable == true) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.horizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 50),
                                      Image.asset(
                                        'assets/images/cocoa_monitor/empty-box.png',
                                        width: 60,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "No data found",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            if (noConnection == true) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppPadding.horizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 50),
                                      Image.asset(
                                        'assets/images/cocoa_monitor/empty-box.png',
                                        width: 60,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "You Are Not Connected To The Internet",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              print('Error: ${snapshot.error}');
                            }

                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final reportData = snapshot.data![index];

                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(3, 3),
                                                blurRadius: 10,
                                                blurStyle: BlurStyle.normal),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Align(
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Title :',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // const Padding(
                                              //   padding: EdgeInsets.all(8.0),
                                              //   child: Text(':'),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${reportData.title}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Farm reference :',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              // const Align(
                                              //   alignment:
                                              //       AlignmentDirectional.centerStart,
                                              //   child: Padding(
                                              //     padding: EdgeInsets.all(8.0),
                                              //     child: Text(':'),
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${reportData.farmReference}',
                                                    overflow: TextOverflow.clip,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Activity :',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              // const Padding(
                                              //   padding: EdgeInsets.all(8.0),
                                              //   child: Text(':'),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${reportData.activity}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'RA ID :',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              // const Padding(
                                              //   padding: EdgeInsets.all(8.0),
                                              //   child: Text(':'),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${reportData.raID}',
                                                    overflow: TextOverflow.clip,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Align(
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Issue :',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // const Padding(
                                              //   padding: EdgeInsets.all(8.0),
                                              //   child: Text(':'),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${reportData.feedback}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Status :',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              // const Padding(
                                              //   padding: EdgeInsets.all(8.0),
                                              //   child: Text(':'),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${reportData.status}',
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      color: reportData
                                                                  .status ==
                                                              'Open'
                                                          ? Colors.red
                                                          : reportData.status ==
                                                                  'In Progress'
                                                              ? Colors.orange
                                                              : Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });

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
        ],
      ),
    );
  }

  Future<List<LoadedIssue>> loadIssuesFromServer() async {
    List<LoadedIssue> mainLoadedIssueList = [];

    Dio? dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    if (await ConnectionVerify.connectionIsAvailable()) {
      try {
        var response = await dio.post(URLs.baseUrl + URLs.loadAllIssues,
            data: {'userid': indexController.userInfo.value.userId});

        if (response.data['status'] == true && response.data['data'] != null) {
          List resultList = response.data['data'];
          List<LoadedIssue> loadeIssueList =
              resultList.map((e) => reportFromJson(jsonEncode(e))).toList();
          mainLoadedIssueList = loadeIssueList;

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
        FirebaseCrashlytics.instance.log('loadIssuesFromServer');

    

      }
    } else {
      noConnection = true;
    }

    return mainLoadedIssueList;
  }
}
