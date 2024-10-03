// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/general_apis.dart';
import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/map_farms_api.dart';
import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/outbreak_farm_apis.dart';
import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/personnel_apis.dart';
import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/calculated_area.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/po_location.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_monitor/controller/utils/connection_verify.dart';
import 'package:cocoa_monitor/controller/utils/dio_singleton_instance.dart';
import 'package:cocoa_monitor/view/contractor_certificate_history/contractor_certificate_history.dart';
import 'package:cocoa_monitor/view/farm_history/farm_history.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/initial_treatment_monitoring_history/initial_treatment_monitoring_history.dart';
import 'package:cocoa_monitor/view/polygon_drawing_tool/polygon_drawing_tool.dart';
import 'package:cocoa_monitor/view/utils/double_value_trimmer.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:cocoa_monitor/view/utils/user_current_location.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:cocoa_monitor/view/workdone_verification_history/certificate_verification_history.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/entity/cocoa_rehub_monitor/map_farm.dart';
import '../../controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import '../add_initial_treatment_monitoring_record/add_initial_treatment_monitoring_record.dart';
import '../add_map_farm/map_farm.dart';
import '../add_personnel/add_personnel.dart';
import '../add_workdone_certificate_record/add_workdone_certificate_record.dart';
import '../add_workdone_certificate_verification_record/add_workdone_verification_certificate_record.dart';
import '../global_components/text_input_decoration.dart';
import '../personnel_history/personnel_history.dart';
import '../update_compulsion/mandatory_update.dart';
import 'components/workdone_certificate_options_bottomsheet.dart';

class HomeController extends GetxController {
  GlobalController globalController = Get.find();

  var activeButtonIndex = (-1).obs;

  Globals globals = Globals();

  Rx<int> check = 0.obs;

  Rx<String> title = ''.obs;

  late BuildContext homeScreenContext;

  var loadingInitialData = true.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  GeneralCocoaRehabApiInterface generalCocoaRehabApiInterface =
      GeneralCocoaRehabApiInterface();
  UserInfoApiInterface userInfoApiInterface = UserInfoApiInterface();

  final saveCalculatedAreaFormKey = GlobalKey<FormState>();
  TextEditingController? calculatedAreaTitleTC = TextEditingController();

  final debugModePasscodeFormKey = GlobalKey<FormState>();
  TextEditingController? debugModePasscodeTC = TextEditingController();

  final debugModeFormKey = GlobalKey<FormState>();
  TextEditingController? debugServerURLTC = TextEditingController();
  var isLoading = false.obs;
  var isLoadingRAs = false.obs;

  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await generalCocoaRehabApiInterface.syncUserLocation();
      await checkAppVersionBeforeSync();
      navigateToAlertScreen();
    });

    Timer.periodic(const Duration(minutes: 5), (timer) {
      generalCocoaRehabApiInterface.syncUserLocation();
    });
    Timer.periodic(const Duration(minutes: 5), (timer) {
      navigateToAlertScreen();
    });
  }

  setTitle() {
    switch (check.value) {
      case 0:
        title.value = 'Initial Treatment';
        break;
      case 1:
        title.value = 'Maintenance';
        break;
      case 2:
        title.value = 'Establishment';
        break;
      case 3:
        title.value = 'Contractor\'s Certificate';
        break;
      case 4:
        title.value = 'Farm Mapping';
        break;
      case 5:
        title.value = 'Verification Form';
        break;
      case 6:
        title.value = 'Rehab Assistant';
    }
  }

  navigateToPageForAddingData() {
    switch (check.value) {
        /// initial treatment
      case 0:
        Get.to(() => AddInitialTreatmentMonitoringRecord(
              allMonitorings: AllMonitorings.InitialTreatment,
            ));
        break;
        /// maintenance
      case 1:
        Get.to(() => AddInitialTreatmentMonitoringRecord(
              allMonitorings: AllMonitorings.Maintenance,
            ));
        break;
        /// Establishment
      case 2:
        Get.to(() => AddInitialTreatmentMonitoringRecord(
              allMonitorings: AllMonitorings.Establishment,
            ));
        break;
        /// contractor's certificate
      case 3:
        Get.to(() => AddContractorCertificateRecord(
        ));
        break;
        /// map farms
      case 4:
        Get.to(() => MapNewFarm(
        ));
        break;
        /// verification form
      case 5:
        Get.to(() => AddContratorCertificateVerificationRecord());
        break;
        /// rehab assistant
      case 6: Get.to(() => AddPersonnel());
        break;
    }
  }

  String getGreetings() {
    var hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  navigateToPageForHistory() {
    switch (check.value) {
    /// initial treatment
      case 0:
        Get.to(() => InitialTreatmentMonitoringHistory(
          allMonitorings: AllMonitorings.InitialTreatment,
        ));
        break;
    /// maintenance
      case 1:
        Get.to(() => InitialTreatmentMonitoringHistory(
          allMonitorings: AllMonitorings.Maintenance,
        ));
        break;
    /// Establishment
      case 2:
        Get.to(() => InitialTreatmentMonitoringHistory(
          allMonitorings: AllMonitorings.Establishment,
        ));
        break;
    /// contractor's certificate
      case 3:
        Get.to(() => ContractorCertificateHistory(
        ));
        break;
    /// map farms
      case 4:
        Get.to(() => MapFarmHistory(
        ));
        break;
    /// verification form
      case 5:
        Get.to(() => CertificateVerificationHistory());
        break;
    /// rehab assistant
      case 6: Get.to(() => PersonnelHistory());
      break;
    }
  }

  void navigateToAlertScreen() async {
    SharedPreferences? prefs = ShareP.preferences;
    String? storedTimestamp = prefs?.getString(SharedPref.activationTimestamp);
    if (storedTimestamp != null) {
      DateTime storedTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(storedTimestamp);

      Duration difference = DateTime.now().difference(storedTime);

      if (difference.inSeconds >= 259200) {
        Get.offAll(() => const MandatoryUpdateScreen());
      }
    }
  }

  // ==============================================================================
  // =========================== START GET APP VERSION  ========================
  // ==============================================================================

  Future checkAppVersionBeforeSync() async {
    // Dio? dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient dioClient) {
    //   dioClient.badCertificateCallback =
    //       ((X509Certificate cert, String host, int port) => true);
    //   return dioClient;
    // };

    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      SharedPreferences? prefs = ShareP.preferences;

      try {
        var response = await DioSingleton.instance.post(
            URLs.baseUrl + URLs.versionCheck,
            data: {'version': Build.buildNumber.toString()});
        if (response.data['status'] == 1) {
          print('VERSION CHECKING COMPLETE');

          prefs?.remove(SharedPref.activationTimestamp);
          await generalCocoaRehabApiInterface.loadAssignedOutbreaks();
          await generalCocoaRehabApiInterface.loadAssignedFarms();

          await loadPaginatedRehabAssistants();
          await syncData();
        } else {
          //version is wrong needs update
          //check to see if prefs already contains storedtimestamp dont update prefs with new timestamp but sync data
          //if prefs doesnt contain storedtimestamp create  one and sync data

          if (prefs!.containsKey(SharedPref.activationTimestamp)) {
            await generalCocoaRehabApiInterface.loadAssignedOutbreaks();
            await generalCocoaRehabApiInterface.loadAssignedFarms();

            await loadPaginatedRehabAssistants();
            await syncData();
          } else {
            await showDialog(
                context: homeScreenContext,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: AlertDialog(
                      title: const Text('Version Update Required'),
                      content: const Text(
                          'A new update is available. Please update this current version within three days time or risk losing access to the app features.'),
                      actions: [
                        TextButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppBorderRadius.sm),
                                        side: const BorderSide(
                                            color: Colors.red)))),
                            onPressed: () async {
                              await prefs.setString(
                                  SharedPref.activationTimestamp,
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(DateTime.now()));
                              Navigator.of(context).pop();
                              await generalCocoaRehabApiInterface
                                  .loadAssignedOutbreaks();
                              await generalCocoaRehabApiInterface
                                  .loadAssignedFarms();

                              await loadPaginatedRehabAssistants();
                              await syncData();
                            },
                            child: Text(
                              "OK".toUpperCase(),
                            )),
                      ],
                    ),
                  );
                });
          }
        }
      } catch (e, stackTrace) {
        print(e.toString());
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
        FirebaseCrashlytics.instance.log('checkAppVersionBeforeSync');

        if (homeScreenContext.mounted) {
          globals.endWait(homeScreenContext);
        }
      }
    }
  }

  // ==============================================================================
  // =========================== End GET APP VERSION  ========================
  // ==============================================================================

  syncData() async {
    // if (await ConnectionVerify.connectionIsAvailable()) {
    loadingInitialData.value = true;
    //if (homeScreenContext.mounted) {
    //  globals.startWait(homeScreenContext);
    //  }
    var futures = await Future.wait([
      // generalCocoaRehabApiInterface.loadPaginatedRehabAssistants(),
      generalCocoaRehabApiInterface.loadRegionContractors(),
      generalCocoaRehabApiInterface.loadActivities(),
      generalCocoaRehabApiInterface.loadFarms(),
      generalCocoaRehabApiInterface.loadRegionDistricts(),
      // generalCocoaRehabApiInterface.loadRehabAssistants(),
      // generalCocoaRehabApiInterface.loadFarmStatus(),
      // generalCocoaRehabApiInterface.loadAssignedFarms(),
      // generalCocoaRehabApiInterface.loadCocoaTypes(),
      // generalCocoaRehabApiInterface.loadCocoaAgeClass(),
      generalCocoaRehabApiInterface.loadCommunities(),
      // generalCocoaRehabApiInterface.loadAssignedOutbreaks(),
      // generalCocoaRehabApiInterface.loadOutbreakFarmsFromServer(),
      generalCocoaRehabApiInterface.loadEquipments(),
      userInfoApiInterface.setUserFirebaseNotificationToken()
    ]).catchError((error) {
      print('ERROR ERROR ERROR ::: $error');
      throw (error);
    });
    debugPrint(futures.toString());
    List<RegionDistrict> regionDistricts = await globalController
        .database!.regionDistrictDao
        .findAllRegionDistrict();
    globalController.userRegionDistrict =
        regionDistricts.isNotEmpty ? regionDistricts.first : RegionDistrict();
    if (homeScreenContext.mounted) {
      globals.endWait(homeScreenContext);
    }
    loadingInitialData.value = false;
    //}
  }

// TrueKing changed
// and replicated below

// Future loadPaginatedRehabAssistants() async {
//   try {
//     isLoadingRAs.value = true;
//     final rehabAssistantDao = globalController.database!.rehabAssistantDao;
//     var page = 1;
//     var userId = globalController.userInfo.value.userId;
//     bool hasMorePages = true;
//     List<RehabAssistant> allRehabAssistants = [];

//     while (hasMorePages) {
//       print('LOADING PAGINATED RA\'S');
//       print(userId);
//       final response = await DioSingleton.instance.get(
//         'https://cocoarehabmonitor.com/rehabassistantslist_drf/?page=$page&userid=$userId',
//       );

//       if (response.statusCode == 200) {
//         if (response.data['results'] != null) {
//           List resultList = response.data['results'];
//           List<RehabAssistant> farmList = resultList.map((e) {
//             return rehabAssistantFromJson(jsonEncode(e));
//           }).toList();
//           allRehabAssistants.addAll(farmList);
//           print('THIS IS THE LENGTH OF PAGE$page::: ${farmList.length}');
//         } else {
//           print(
//             'RESPONSE DATA FAILED IN LOAD REHAB ASSISTANTS ::: ${response.data?['status']}',
//           );
//           break;
//         }
//         hasMorePages = response.data['next'] != null;
//         page++;
//       } else {
//         print('HTTP ERROR ${response.statusCode}');
//         break;
//       }
//     }

//     await rehabAssistantDao.deleteAllRehabAssistants();
//     await rehabAssistantDao.bulkInsertRehabAssistants(allRehabAssistants);
//     print('TOTAL LENGTH OF RA::: ${allRehabAssistants.length}');
//     isLoadingRAs.value = false;
//   } catch (e, stackTrace) {
//     print('Error occurred in loadPaginatedRehabAssistants: $e');
//     print('Stack trace:\n$stackTrace');
//     FirebaseCrashlytics.instance.recordError(e, stackTrace);
//         FirebaseCrashlytics.instance.log('home C. loadPaginatedRehabAssistants');

//     // Handle the error further if needed
//   }
// }

// TrueKing changed end
// and replicated below

  Future loadPaginatedRehabAssistants() async {
    try {
      isLoadingRAs.value = true;
      final rehabAssistantDao = globalController.database!.rehabAssistantDao;
      var page = 1;
      var userId = globalController.userInfo.value.userId;
      bool hasMorePages = true;
      List<RehabAssistant> allRehabAssistants = [];

      while (hasMorePages) {
        print('LOADING PAGINATED RA\'S');
        print(userId);
        final response = await DioSingleton.instance.get(
          'https://cocoarehabmonitor.com/rehabassistantslist_drf/?page=$page&userid=$userId',
        );

        if (response.statusCode == 200) {
          if (response.data['results'] != null) {
            List resultList = response.data['results'];
            List<RehabAssistant> farmList = resultList.map((e) {
              return rehabAssistantFromJson(jsonEncode(e));
            }).toList();
            allRehabAssistants.addAll(farmList);
            print('THIS IS THE LENGTH OF PAGE$page::: ${farmList.length}');
          } else {
            print(
              'RESPONSE DATA FAILED IN LOAD REHAB ASSISTANTS ::: ${response.data?['status']}',
            );
            break;
          }

          hasMorePages = response.data['next'] != null;
          // hasMorePages = response.data == null;
          page++;
        } else {
          print('HTTP ERROR ${response.statusCode}');
          break;
        }
      }

      await rehabAssistantDao.deleteAllRehabAssistants();
      await rehabAssistantDao.bulkInsertRehabAssistants(allRehabAssistants);
      print('TOTAL LENGTH OF RA::: ${allRehabAssistants.length}');
      isLoadingRAs.value = false;
    } catch (e, stackTrace) {
      print('Error occurred in loadPaginatedRehabAssistants: $e');
      print('Stack trace:\n$stackTrace');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      FirebaseCrashlytics.instance.log('home C. loadPaginatedRehabAssistants');

      // Handle the error further if needed
    }
  }

// ===========================================
// START Show Menu Options
// ==========================================
  /*showMenuOptions(String title, String menuItem){
    showModalBottomSheet<void>(
      elevation: 5,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.md),
        ),
      ),
      context: homeScreenContext!,
      builder: (context) {
        // return MenuOptionsBottomSheet(title: title, menuItem: menuItem,);
        return OBMenuOptionsBottomSheet(title: title, menuItem: menuItem,);
      },
    );
  }*/
  showMenuOptions(Widget widget) {
    showModalBottomSheet<void>(
      elevation: 5,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.md),
        ),
      ),
      context: homeScreenContext,
      builder: (context) {
        // return MenuOptionsBottomSheet(title: title, menuItem: menuItem,);
        return widget;
      },
    );
  }
// ===========================================
// END Show Menu Options
// ==========================================

  syncRecordedLocations() async {
    GeneralCocoaRehabApiInterface generalCocoaRehabApiInterface =
        GeneralCocoaRehabApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await generalCocoaRehabApiInterface.syncUserLocation();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data submitted',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncPersonnelData() async {
    PersonnelApiInterface personnelApiInterface = PersonnelApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
        print('STARTING SYNC IN IF MOUNTED');
      }
      print('STARTING SYNC B4 API.SYNCPERSONNEL');

      await personnelApiInterface.syncPersonnel();

      print('END OF SYNC BUT B4 MOUNTED');

      if (homeScreenContext.mounted) {
        print('END OF SYNC BUT IN MOUNTED');

        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncPersonnelAssignmentData() async {
    PersonnelAssignmentApiInterface personnelAssignmentApiInterface =
        PersonnelAssignmentApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await personnelAssignmentApiInterface.syncPersonnelAssignment();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncOutbreakFarmData() async {
    OutbreakFarmApiInterface outbreakFarmApiInterface =
        OutbreakFarmApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await outbreakFarmApiInterface.syncOutbreakFarm();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncAllMonitorings() async {
    OutbreakFarmApiInterface outbreakFarmApiInterface =
        OutbreakFarmApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await outbreakFarmApiInterface.syncMonitoring();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncMapFarmData() async {
    MapFarmsApiInterface mapFarmsApiInterface = MapFarmsApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await mapFarmsApiInterface.syncFarm();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncAllWorkdoneCertificates() async {
    ContractorCertificateApiInterface contractorCertificateApiInterface =
        ContractorCertificateApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await contractorCertificateApiInterface.syncContractorCertificate();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncAllCertificateVerifications() async {
    ContractorCertificateApiInterface contractorCertificateApiInterface =
        ContractorCertificateApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await contractorCertificateApiInterface
          .syncContractorCertificateVerification();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  syncInitialTreatmentFuel() async {
    OutbreakFarmApiInterface outbreakFarmApiInterface =
        OutbreakFarmApiInterface();
    if (await ConnectionVerify.connectionIsAvailable()) {
      if (homeScreenContext.mounted) {
        globals.startWait(homeScreenContext);
      }
      await outbreakFarmApiInterface.syncFuel();
      if (homeScreenContext.mounted) {
        globals.endWait(homeScreenContext);
        globals.showSecondaryDialog(
            context: homeScreenContext,
            content: const Text(
              'Data synced',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
            status: AlertDialogStatus.success);
      }
    } else {
      globals.showSnackBar(
          title: 'Alert', message: 'Not connected to the internet');
    }
  }

  usePolygonDrawingTool() {
    Get.to(
        () => PolygonDrawingTool(
              layers: HashSet<Polygon>(),
              useBackgroundLayers: false,
              allowTappingInputMethod: false,
              allowTracingInputMethod: false,
              maxAccuracy: MaxLocationAccuracy.max,
              persistMaxAccuracy: true,
              onSave: (polygon, markers, area) {
                if (markers.isNotEmpty) {
                  globals.primaryConfirmDialog(
                      context: homeScreenContext,
                      title: 'Measurement Result',
                      image: 'assets/images/cocoa_monitor/ruler-combined.png',
                      content: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Demarcated area estimate in hectares',
                                style: TextStyle(color: AppColor.black),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 15),
                            Text(
                                '${area.truncateToDecimalPlaces(6).toString()} ha',
                                style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            Text('Would you like to save this measurement?',
                                style: TextStyle(color: AppColor.black),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      cancelTap: () {
                        Get.back();
                      },
                      okayTap: () {
                        Get.back();
                        showSaveMeasurementResultDialog(
                            '${area.truncateToDecimalPlaces(6).toString()} ha');
                      });

                  final poLocationDao =
                      globalController.database!.poLocationDao;
                  PoLocation poLocation = PoLocation(
                    lat: markers.first.position.latitude,
                    lng: markers.first.position.longitude,
                    accuracy: 0,
                    uid: const Uuid().v4(),
                    userid: int.parse(globalController.userInfo.value.userId!),
                    inspectionDate: DateTime.now(),
                  );
                  poLocationDao.insertPOLocation(poLocation);
                  // saveUserLocation();

                  /*globals.showOkayDialog(
              context: homeScreenContext,
              title: 'Measurement Result',
              image: 'assets/images/cocoa_monitor/ruler-combined.png',
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Demarcated area estimates in hectares',
                        style: TextStyle(color: AppColor.black),
                        textAlign: TextAlign.center
                    ),
                    SizedBox(height: 15),
                    Text('${area.truncateToDecimalPlaces(6).toString()} ha',
                        style: TextStyle(color: AppColor.black, fontSize: 20, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center
                    ),
                  ],
                ),
              ),
          );*/
                }
              },
            ),
        transition: Transition.fadeIn);
  }

  saveUserLocation() {
    isLoading.value = true;
    UserCurrentLocation? userCurrentLocation =
        UserCurrentLocation(context: homeScreenContext);
    userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) async {
          if (isEnabled == true) {
            final poLocationDao = globalController.database!.poLocationDao;
            PoLocation poLocation = PoLocation(
              lat: pos?.latitude ?? 0.0,
              lng: pos?.longitude ?? 0.0,
              accuracy: int.parse(pos?.accuracy?.toInt().toString() ?? '0'),
              uid: const Uuid().v4(),
              userid: int.parse(globalController.userInfo.value.userId!),
              inspectionDate: DateTime.now(),
            );
            await poLocationDao.insertPOLocation(poLocation);
            isLoading.value = false;
            globals.showSnackBar(title: 'Success', message: 'Location logged');
            generalCocoaRehabApiInterface.syncUserLocation();
          }
        });
  }

  showSaveMeasurementResultDialog(String result) {
    AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm))),
      content: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(homeScreenContext).viewInsets.bottom),
        padding: EdgeInsets.symmetric(
            vertical: 30, horizontal: AppPadding.horizontal),
        child: Form(
          key: saveCalculatedAreaFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                result,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              const SizedBox(height: 15),
              const Text(
                'Title of area calculated',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: calculatedAreaTitleTC,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorderFocused,
                  errorBorder: inputBorder,
                  focusedErrorBorder: inputBorderFocused,
                  filled: true,
                  fillColor: AppColor.xLightBackground,
                ),
                textInputAction: TextInputAction.next,
                validator: (String? value) =>
                    value!.trim().isEmpty ? "Title is required" : null,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    isFullWidth: false,
                    backgroundColor: AppColor.lightBackground,
                    verticalPadding: 0.0,
                    horizontalPadding: 8.0,
                    onTap: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColor.black, fontSize: 11),
                    ),
                  ),
                  CustomButton(
                    isFullWidth: false,
                    backgroundColor: AppColor.primary,
                    verticalPadding: 0.0,
                    horizontalPadding: 8.0,
                    onTap: () async {
                      if (saveCalculatedAreaFormKey.currentState!.validate()) {
                        CalculatedArea calculatedArea = CalculatedArea(
                            date: DateTime.now(),
                            title: calculatedAreaTitleTC!.text.trim(),
                            value: result);

                        final calculatedAreaDao =
                            globalController.database!.calculatedAreaDao;
                        await calculatedAreaDao
                            .insertCalculatedArea(calculatedArea);

                        Get.back();
                        if (homeScreenContext.mounted) {}
                        globals.showSecondaryDialog(
                          context: homeScreenContext,
                          content: const Text(
                            'Calculated area saved',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                          status: AlertDialogStatus.success,
                        );
                      } else {}
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).show(homeScreenContext,
        dialogTransitionType: DialogTransitionType.NONE,
        barrierDismissible: true,
        barrierColor: AppColor.black.withOpacity(0.8));
  }

  showEnterDebugScreenPasscode() {
    debugModePasscodeTC?.text = '';
    AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm))),
      content: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(homeScreenContext).viewInsets.bottom),
        padding: EdgeInsets.symmetric(
            vertical: 30, horizontal: AppPadding.horizontal),
        child: Form(
          key: debugModePasscodeFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Debug Mode',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              const SizedBox(height: 15),
              const Text(
                'Enter passcode to proceed',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: debugModePasscodeTC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorderFocused,
                  errorBorder: inputBorder,
                  focusedErrorBorder: inputBorderFocused,
                  filled: true,
                  fillColor: AppColor.xLightBackground,
                ),
                textInputAction: TextInputAction.next,
                validator: (String? value) =>
                    value!.trim().isEmpty ? "Code is required" : null,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    isFullWidth: false,
                    backgroundColor: AppColor.lightBackground,
                    verticalPadding: 0.0,
                    horizontalPadding: 8.0,
                    onTap: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColor.black, fontSize: 11),
                    ),
                  ),
                  CustomButton(
                    isFullWidth: false,
                    backgroundColor: AppColor.primary,
                    verticalPadding: 0.0,
                    horizontalPadding: 8.0,
                    onTap: () async {
                      if (debugModePasscodeFormKey.currentState!.validate()) {
                        // FocusScope.of(homeScreenContext!).unfocus();
                        if (debugModePasscodeTC?.text.trim() ==
                            debugModePasscode) {
                          Get.back();
                          Future.delayed(const Duration(seconds: 2), () {
                            showDebugSettings();
                          });
                        } else {
                          globals.showSnackBar(
                              title: 'Error', message: 'Wrong passcode');
                        }
                      }
                    },
                    child: const Text(
                      'Enter',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).show(homeScreenContext,
        dialogTransitionType: DialogTransitionType.NONE,
        barrierDismissible: true,
        barrierColor: AppColor.black.withOpacity(0.8));
  }

  showDebugSettings() {
    debugServerURLTC?.text = globalController.serverUrl;
    AlertDialog(
      elevation: 0,
      backgroundColor: Colors.white,
      scrollable: false,
      insetPadding: const EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm))),
      content: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(homeScreenContext).viewInsets.bottom),
        padding: EdgeInsets.symmetric(
            vertical: 30, horizontal: AppPadding.horizontal),
        child: Form(
          key: debugModeFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Server URL',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: debugServerURLTC,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorderFocused,
                  errorBorder: inputBorder,
                  focusedErrorBorder: inputBorderFocused,
                  filled: true,
                  fillColor: AppColor.xLightBackground,
                ),
                textInputAction: TextInputAction.next,
                validator: (String? value) =>
                    value!.trim().isEmpty ? "URL is required" : null,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    isFullWidth: false,
                    backgroundColor: AppColor.lightBackground,
                    verticalPadding: 0.0,
                    horizontalPadding: 8.0,
                    onTap: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColor.black, fontSize: 11),
                    ),
                  ),
                  CustomButton(
                    isFullWidth: false,
                    backgroundColor: AppColor.primary,
                    verticalPadding: 0.0,
                    horizontalPadding: 8.0,
                    onTap: () async {
                      if (debugModeFormKey.currentState!.validate()) {
                        userInfoApiInterface.setServerURL(
                            isDefault: false,
                            url: debugServerURLTC?.text.trim());
                        Get.back();
                        globals.showSnackBar(
                            title: 'Success', message: 'Server URL updated');
                      } else {}
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).show(homeScreenContext,
        dialogTransitionType: DialogTransitionType.NONE,
        barrierDismissible: true,
        barrierColor: AppColor.black.withOpacity(0.8));
  }
}
