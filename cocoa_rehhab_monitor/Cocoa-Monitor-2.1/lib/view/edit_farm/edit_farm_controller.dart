// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/map_farms_api.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farmer_from_server.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/map_farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/society.dart';
import 'package:cocoa_monitor/view/utils/double_value_trimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

import '../../controller/global_controller.dart';
import '../global_components/globals.dart';
import '../home/home_controller.dart';
import '../polygon_drawing_tool/polygon_drawing_tool.dart';
import '../utils/style.dart';
import '../utils/view_constants.dart';

class EditMapFarmController extends GetxController {
  late BuildContext editMapFarmScreenContext;

  final formKey = GlobalKey<FormState>();

  Farm? farm;
  MapFarm? mapfarm;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  MapFarmsApiInterface mapFarmsApiInterface = MapFarmsApiInterface();

  final ImagePicker mediaPicker = ImagePicker();

  // var isButtonDisabled = false.obs;
  // var isSaveButtonDisabled = false.obs;

  TextEditingController? farmAreaTC = TextEditingController();
  TextEditingController? farmerNameTC = TextEditingController();
  TextEditingController? districtNameTC = TextEditingController();
  TextEditingController? regionNameTC = TextEditingController();
  TextEditingController? farmerContactTC = TextEditingController();
  // TextEditingController? farmSizeTC = TextEditingController();

  TextEditingController? farmIdTC = TextEditingController();

  LocationData? locationData;

  // Society? society = Society();
  // Society? society = Society();
  // FarmerFromServer? farmerFromServer = FarmerFromServer();

  Set<Marker>? markers;
  Polygon? polygon;

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      farmAreaTC?.text = mapfarm!.farmSize.toString();
      farmerNameTC?.text = mapfarm!.farmerName.toString();
      districtNameTC?.text = mapfarm!.district.toString();
      regionNameTC?.text = mapfarm!.region.toString();
      farmerContactTC?.text = mapfarm!.farmerContact.toString();
      // farmSizeTC?.text = mapfarm!.farmSize.toString();

      farmIdTC?.text = mapfarm!.farmReference.toString();

      List? farmList = await globalController.database!.farmDao
          .findFarmByFarmId(mapfarm!.farmReference!);
      farm = farmList.first;
      update();

      // debugPrint("Here here here ${farmList.first}");

      var polygonPointsString =
          const Utf8Decoder().convert(mapfarm!.farmboundary ?? []);
      List polygonPoints = jsonDecode(polygonPointsString) as List;

      if (polygonPoints.isNotEmpty) {
        polygonPoints.removeLast();
      }

      if (polygonPoints.isNotEmpty) {
        polygon = Polygon(
          polygonId: const PolygonId('001'),
          points: polygonPoints
              .map((e) => LatLng(e['latitude'], e['longitude']))
              .toList(),
        );
      }

      update();

      // List? farmerFromServerDataList = await globalController
      //     .database!.farmerFromServerDao
      //     .findFarmerFromServerByFarmerId(farm!.farmer!);
      // farmerFromServer = farmerFromServerDataList.first;
      // update();
    });
  }

  // ==============================================================================
  // START ADD OUTBREAK FARM
  // ==============================================================================
  handleEditMapFarm() async {
    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: editMapFarmScreenContext);
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

    globals.startWait(editMapFarmScreenContext);

    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    MapFarm editMapFarmData = MapFarm(
      uid: mapfarm?.uid,
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

    Map<String, dynamic> data = editMapFarmData.toJson();
    data.remove('status');
    data.remove('societyCode');

    var postResult = await mapFarmsApiInterface.mapFarm(editMapFarmData, data);
    globals.endWait(editMapFarmScreenContext);
    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      // Get.back();
      Get.back(result: {'farm': editMapFarmData, 'submitted': true});
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
          context: editMapFarmScreenContext,
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
  // END ADD OUTBREAK FARM
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE OUTBREAK FARM
  // ==============================================================================
  handleSaveOfflineEditMapFarm() async {
    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: editMapFarmScreenContext);
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

    globals.startWait(editMapFarmScreenContext);

    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    MapFarm editMapFarmData = MapFarm(
      uid: mapfarm?.uid,
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

    Map<String, dynamic> data = editMapFarmData.toJson();
    data.remove('status');
    // data.remove('societyCode');

    print('THIS IS EDIT Farm DETAILS:::: $data');

    final mapFarmDao = globalController.database!.mapFarmDao;
    await mapFarmDao.updateMapFarm(editMapFarmData);

    globals.endWait(editMapFarmScreenContext);

    // Get.back();
    Get.back(result: {'farm': editMapFarmData, 'submitted': false});
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Record saved',
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

  usePolygonDrawingTool() {
    Set<Polygon> polys = HashSet<Polygon>();
    if (polygon != null) polys.add(polygon!);
    Get.to(
        () => PolygonDrawingTool(
              layers: polys,
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
                    context: editMapFarmScreenContext,
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
}
