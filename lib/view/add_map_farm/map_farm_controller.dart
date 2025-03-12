// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/map_farms_api.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/community.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/map_farm.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/society.dart';
import 'package:cocoa_rehab_monitor/view/utils/double_value_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/polygon_drawing_tool/polygon_drawing_tool.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:cocoa_rehab_monitor/view/utils/user_current_location.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';

class MapFarmController extends GetxController {
  late BuildContext mapFarmScreenContext;

  final mapFarmFormKey = GlobalKey<FormState>();

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  MapFarmsApiInterface farmerApiInterface = MapFarmsApiInterface();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // var isButtonDisabled = false.obs;
  // var isSaveButtonDisabled = false.obs;

  TextEditingController? farmAreaTC = TextEditingController();
  TextEditingController? farmerNameTC = TextEditingController();
  TextEditingController? districtNameTC = TextEditingController();
  TextEditingController? regionNameTC = TextEditingController();
  TextEditingController? farmerContactTC = TextEditingController();
  // TextEditingController? farmSizeTC = TextEditingController();

  TextEditingController? farmIdTC = TextEditingController();

  var idType;

  LocationData? locationData;

  Community? community = Community();

  Farm? farm = Farm();

  Society? society = Society();
  // FarmerFromServer? farmerFromServer = FarmerFromServer();

  Set<Marker>? markers;
  Polygon? polygon;

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserCurrentLocation? userCurrentLocation =
          UserCurrentLocation(context: mapFarmScreenContext);
      userCurrentLocation.getUserLocation(
          forceEnableLocation: true,
          onLocationEnabled: (isEnabled, pos) {
            if (isEnabled == true) {
              locationData = pos!;
              update();
            }
          });
    });
  }

  usePolygonDrawingTool() {
    Set<Polygon> polys = HashSet<Polygon>();
    if (polygon != null) polys.add(polygon!);
    Get.to(
        () => PolygonDrawingTool(
              layers: polys,
              initialPolygon: polygon,
              viewInitialPolygon: polygon != null,
              // layers: HashSet<Polygon>(),
              useBackgroundLayers: false,
              allowTappingInputMethod: false,
              allowTracingInputMethod: false,
              maxAccuracy: MaxLocationAccuracy.max,
              persistMaxAccuracy: true,
              onSave: (poly, mkr, area) {
                if (mkr.isNotEmpty) {
                  polygon = poly;
                  markers = mkr;
                  farmAreaTC?.text = area.truncateToDecimalPlaces(6).toString();
                  update();
                  globals.showOkayDialog(
                    context: mapFarmScreenContext,
                    title: 'Measurement Result',
                    image: 'assets/images/cocoa_monitor/ruler-combined.png',
                    content: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('measured area estimates in hectares',
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
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
        transition: Transition.fadeIn);
  }

  // ==============================================================================
  // START ADD PERSONNEL
  // ==============================================================================
  handleMapFarm() async {
    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: mapFarmScreenContext);
    // isButtonDisabled.value = true;

    polygon!.points.add(polygon!.points.first);
    var boundaryCoordinates = polygon!.points
        .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
        .toList();

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    //         isButtonDisabled.value = false;

    globals.startWait(mapFarmScreenContext);

    // DateTime now = DateTime.now();
    // String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    MapFarm farmData = MapFarm(
      uid: const Uuid().v4(),
      userid: globalController.userInfo.value.userId!,
      farmboundary:
          Uint8List.fromList(utf8.encode(jsonEncode(boundaryCoordinates))),
      farmerName: farmerNameTC?.text.trim(),
      farmSize: double.parse(farmAreaTC!.text.trim()),
      district: districtNameTC!.text.trim(),
      region: regionNameTC?.text.trim(),
      farmerContact: farmerContactTC?.text.trim(),
      farmReference: farmIdTC?.text.trim(),
      status: SubmissionStatus.submitted,
    );

    Map<String, dynamic> data = farmData.toJson();
    data.remove('status');
    data.remove('location');

    var postResult = await farmerApiInterface.mapFarm(farmData, data);
    globals.endWait(mapFarmScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      Get.back();
      globals.showSecondaryDialog(
          context: homeController.homeScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.success,
          okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
    } else if (postResult['status'] == RequestStatus.False) {
      globals.showSecondaryDialog(
          context: mapFarmScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    } else {}
    //   } else {
    //     isButtonDisabled.value = false;
    //     globals.showSnackBar(
    //         title: 'Alert',
    //         message:
    //             'Operation could not be completed. Turn on your location and try again');
    //   }
    // });
  }
  // ==============================================================================
  // END ADD PERSONNEL
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE OUTBREAK FARM
  // ==============================================================================
  handleSaveOfflineMapFarm() async {
    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: mapFarmScreenContext);
    // isSaveButtonDisabled.value = true;

    polygon!.points.add(polygon!.points.first);
    var boundaryCoordinates = polygon!.points
        .map((e) => {'latitude': e.latitude, 'longitude': e.longitude})
        .toList();

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    //         isSaveButtonDisabled.value = false;

    globals.startWait(mapFarmScreenContext);

    // DateTime now = DateTime.now();
    // String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    MapFarm mapFarmData = MapFarm(
      uid: const Uuid().v4(),
      userid: globalController.userInfo.value.userId!,
      farmboundary:
          Uint8List.fromList(utf8.encode(jsonEncode(boundaryCoordinates))),
      farmerName: farmerNameTC?.text.trim(),
      farmSize: double.parse(farmAreaTC!.text.trim()),
      district: districtNameTC!.text.trim(),
      region: regionNameTC?.text.trim(),
      farmerContact: farmerContactTC?.text.trim(),
      farmReference: farmIdTC?.text.trim(),
      status: SubmissionStatus.pending,
    );
    Map<String, dynamic> data = mapFarmData.toJson();
    data.remove('status');
    // data.remove('location');

    print('THIS IS MapFarm DETAILS:::: $data');

    final mapFarmDao = globalController.database!.mapFarmDao;
    await mapFarmDao.insertMapFarm(mapFarmData);

    globals.endWait(mapFarmScreenContext);

    Get.back(result: {'farm': mapFarmData, 'submitted': false});
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Farm Mapping saved',
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        status: AlertDialogStatus.success,
        okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
    //   } else {
    //     isSaveButtonDisabled.value = false;
    //     globals.showSnackBar(
    //         title: 'Alert',
    //         message:
    //             'Operation could not be completed. Turn on your location and try again');
    //   }
    // });
  }
  // ==============================================================================
  // END OFFLINE SAVE OUTBREAK FARM
  // ==============================================================================
}
