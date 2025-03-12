// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/controller/model/detailed_report_model.dart';
import 'package:cocoa_rehab_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';

class DetailedInfoScreen extends StatefulWidget {
  const DetailedInfoScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailedInfoScreen> createState() => _DetailedInfoScreenState();
}

class _DetailedInfoScreenState extends State<DetailedInfoScreen> {
  final args = Get.arguments;
  Globals globals = Globals();
  var unavailable = false;
  late Future<List<DetailedReport>> future;

  GlobalController indexController = Get.find();

  @override
  void initState() {
    super.initState();
    future = loadDetailedReport();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Report'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.90,
                child: FutureBuilder<List<DetailedReport>>(
                  future: future,
                  builder:
                      (context, AsyncSnapshot<List<DetailedReport>> snapshot) {
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
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Farm reference :'),
                                          ),
                                          // const Align(
                                          //   alignment:
                                          //       AlignmentDirectional.centerStart,
                                          //   child: Padding(
                                          //     padding: EdgeInsets.all(8.0),
                                          //     child: Text(':'),
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${reportData.farmReference}',
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  color: Colors.black54),
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
                                              child: Text('Achievement :'),
                                            ),
                                          ),
                                          // const Padding(
                                          //   padding: EdgeInsets.all(8.0),
                                          //   child: Text(':'),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${reportData.achievement}',
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Number in Group :'),
                                          ),
                                          // const Padding(
                                          //   padding: EdgeInsets.all(8.0),
                                          //   child: Text(':'),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${reportData.numberInAGroup}',
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Amount :'),
                                          ),
                                          // const Padding(
                                          //   padding: EdgeInsets.all(8.0),
                                          //   child: Text(':'),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${reportData.amount}',
                                              overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Issue :'),
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
                                                '${reportData.issue}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black54),
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
    );
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
          'raid': args[3]['raid'],
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

// showNewModalSheet(BuildContext context) {
//   showModalBottomSheet(
//       backgroundColor: Colors.grey[400],
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//         top: Radius.circular(20),
//       )),
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//                 child: Center(
//                   child: Text(
//                     'Detailed Report',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: AppColor.black),
//                   ),
//                 ),
//               ),
//               ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: 1,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       height: 200,
//                       decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(20))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Farm reference:'),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Activity'),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Achievement'),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Number in Group'),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Amount'),
//                           ),
//                         ],
//                       ),
//                     );
//                   }),
//             ],
//           ),
//         );
//       });
// }
// HomeController homeController = Get.find();

// return Material(
//   child: Container(
//     clipBehavior: Clip.antiAlias,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(AppBorderRadius.md),
//           topRight: Radius.circular(AppBorderRadius.md)),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5), //color of shadow
//           spreadRadius: 5, //spread radius
//           blurRadius: 7, // blur radius
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 12,
//         ),
//         Center(
//           child: Container(

//             width: MediaQuery.of(context).size.width * 0.15,
//             height: 4,
//             decoration: const BoxDecoration(
//                 color: Colors.black12,
//                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
//           ),
//         ),
//         const SizedBox(
//           height: 15.0,
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//           child: Center(
//             child: Text(
//               'Detailed Report',
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: AppColor.black),
//             ),
//           ),
//         ),
//         // FutureBuilder(
//         // builder: (context, snapshot) {
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
//           child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: 1,
//               itemBuilder: (context, index) {
//                 return Container(
//                   // decoration: ,
//                   color: Colors.green,
//                   child: const Text('data'),
//                 );
//               }),
//         ),
//         // },
//         // ),
//         const SizedBox(
//           height: 20.0,
//         ),
//       ],
//     ),
//   ),
// );


