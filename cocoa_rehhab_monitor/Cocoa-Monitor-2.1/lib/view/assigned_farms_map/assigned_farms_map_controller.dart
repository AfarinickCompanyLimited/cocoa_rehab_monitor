import 'dart:collection';
import 'dart:convert';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:cocoa_monitor/view/utils/user_current_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';

class AssignedFarmsMapController extends GetxController {
  BuildContext? assignedFarmsMapScreenContext;

  GoogleMapController? mapController;

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(7.9527706, -1.0307118),
    zoom: 8.0,
    tilt: 30,
    // bearing: 270.0,
  );

  late String mapStyle;

  Set<Marker> markers = HashSet<Marker>();
  Set<Polygon> polygons = HashSet<Polygon>();

  BitmapDescriptor? mapMarker;

  Polygon? activePolygon;
  var isLastPolygon = false.obs;
  var isFirstPolygon = false.obs;
  var emptyData = false.obs;

  Rx<AssignedFarm>? selectedFarm = AssignedFarm().obs;

  @override
  void onInit() {
    //
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await createMarker();
      // loadFarms();
    });
  }

  // ============================================================
  // START CREATE MAP MARKER
  // ============================================================
  // createMarker() async {
  //   if (mapMarker == null) {
  //     ImageConfiguration configuration = createLocalImageConfiguration(tmtMapScreenContext!);
  //     BitmapDescriptor.fromAssetImage(configuration, 'assets/images/track_my_tree/tmt_marker.png')
  //         .then((icon) {
  //       mapMarker = icon;
  //     });
  //   }
  // }
// ============================================================
// END CREATE MAP MARKER
// ============================================================

  loadFarms() async {
    final assignedFarmDao = globalController.database!.assignedFarmDao;
    // List<AssignedFarm> listOfAssignedFarms = await assignedFarmDao.findAllAssignedFarms();

    List<AssignedFarm> listOfAssignedFarms = [];
    int limit = 50;
    int offset = 0;
    bool hasMoreRecords = true;

    while (hasMoreRecords) {
      List<AssignedFarm> records =
          await assignedFarmDao.findAssignedFarmWithLimit(limit, offset);
      if (records.isNotEmpty) {
        listOfAssignedFarms.addAll(records);
        offset += records.length;
      } else {
        hasMoreRecords = false;
      }
    }

    for (var element in listOfAssignedFarms) {
      var farmBoundaryString =
          const Utf8Decoder().convert(element.farmBoundary ?? []);
      var farmBoundary = jsonDecode(farmBoundaryString);
      var polyList = farmBoundary['coordinates'][0][0];
      // print(farmBoundary);
      List<LatLng> polygonLatLngs = [];
      for (var element in polyList) {
        polygonLatLngs.add(LatLng(element[1], element[0]));
      }

      polygons.add(Polygon(
          polygonId: PolygonId(element.farmReference.toString()),
          points: polygonLatLngs,
          strokeColor: Colors.red,
          consumeTapEvents: true,
          fillColor: AppColor.primary.withOpacity(0.2),
          strokeWidth: 2,
          onTap: () async {
            Polygon polygon = polygons.toList()[polygons.toList().indexWhere(
                (e) => e.polygonId.value == element.farmReference.toString())];
            activePolygon = polygon;
            mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(
                  boundsFromLatLngList(polygon.points), 140.0),
            );

            LatLng centerForMarker = getPolygonCenter(activePolygon!);

            markers.clear();

            markers.add(Marker(
                markerId: MarkerId(element.farmReference.toString()),
                position: centerForMarker));

            if (polygons.first == activePolygon &&
                polygons.last == activePolygon) {
              isFirstPolygon.value = true;
              isLastPolygon.value = true;
            }
            if (polygons.first == activePolygon) {
              isFirstPolygon.value = true;
            } else {
              isFirstPolygon.value = false;
            }
            if (polygons.last == activePolygon) {
              isLastPolygon.value = true;
            } else {
              isLastPolygon.value = false;
            }

            List<AssignedFarm> farms = await assignedFarmDao
                .findAssignedFarmsByFarmRef(polygon.polygonId.value);
            if (farms.isNotEmpty) selectedFarm!.value = farms.first;

            update();
          }));
    }
    update();

    if (polygons.isNotEmpty) {
      activePolygon = polygons.first;
      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList(polygons.first.points), 140.0),
      );

      if (polygons.first == activePolygon && polygons.last == activePolygon) {
        isFirstPolygon.value = true;
        isLastPolygon.value = true;
      }
      if (polygons.first == activePolygon) {
        isFirstPolygon.value = true;
      } else {
        isFirstPolygon.value = false;
      }
      if (polygons.last == activePolygon) {
        isLastPolygon.value = true;
      } else {
        isLastPolygon.value = false;
      }

      List<AssignedFarm> farms = await assignedFarmDao
          .findAssignedFarmsByFarmRef(polygons.first.polygonId.value);
      if (farms.isNotEmpty) selectedFarm!.value = farms.first;
    } else {
      emptyData.value = true;
    }

    update();
  }

  goToNextPolygon(bool next) async {
    int currentIndex =
        activePolygon != null ? polygons.toList().indexOf(activePolygon!) : 0;

    Polygon nextPolygon =
        polygons.toList()[next ? currentIndex + 1 : currentIndex - 1];
    activePolygon = nextPolygon;

    // TrueKing added
    LatLng centerForMarker = getPolygonCenter(activePolygon!);

    markers.clear();

    markers.add(Marker(
        markerId: MarkerId(activePolygon!.polygonId.value),
        position: centerForMarker));

    if (activePolygon != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList(activePolygon!.points), 140.0),
      );

      if (polygons.first == activePolygon && polygons.last == activePolygon) {
        isFirstPolygon.value = true;
        isLastPolygon.value = true;
      }
      if (polygons.first == activePolygon) {
        isFirstPolygon.value = true;
      } else {
        isFirstPolygon.value = false;
      }
      if (polygons.last == activePolygon) {
        isLastPolygon.value = true;
      } else {
        isLastPolygon.value = false;
      }
    }

    final assignedFarmDao = globalController.database!.assignedFarmDao;
    List<AssignedFarm> farms = await assignedFarmDao
        .findAssignedFarmsByFarmRef(activePolygon!.polygonId.value);

    if (farms.isNotEmpty) selectedFarm!.value = farms.first;
  }

  goToSelectedPolygon(AssignedFarm assignedFarm) async {
    // int currentIndex = polygons.toList().indexOf(activePolygon!);
    // Polygon nextPolygon = polygons.toList()[next ? currentIndex + 1 : currentIndex - 1];
    Polygon nextPolygon = polygons.toList().firstWhere((element) =>
        element.polygonId.value.toString() == assignedFarm.farmReference);
    activePolygon = nextPolygon;

    // TrueKing added
    LatLng centerForMarker = getPolygonCenter(activePolygon!);

    markers.clear();

    markers.add(Marker(
        markerId: MarkerId(activePolygon!.polygonId.value),
        position: centerForMarker));

    if (activePolygon != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
            boundsFromLatLngList(activePolygon!.points), 140.0),
      );

      if (polygons.first == activePolygon && polygons.last == activePolygon) {
        isFirstPolygon.value = true;
        isLastPolygon.value = true;
      }
      if (polygons.first == activePolygon) {
        isFirstPolygon.value = true;
      } else {
        isFirstPolygon.value = false;
      }
      if (polygons.last == activePolygon) {
        isLastPolygon.value = true;
      } else {
        isLastPolygon.value = false;
      }
    }
  }

  goToUserLocation() {
    UserCurrentLocation? userCurrentLocation =
        UserCurrentLocation(context: assignedFarmsMapScreenContext);
    userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled == true) {
            mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  // bearing: 270.0,
                  target: LatLng(pos!.latitude!, pos.longitude!),
                  tilt: 30.0,
                  // zoom: 18.0,
                  zoom: 16.0,
                ),
              ),
            );
          }
        });
  }

  Future<void> navigateToLocation() async {
    UserCurrentLocation? userCurrentLocation =
        UserCurrentLocation(context: assignedFarmsMapScreenContext);
    userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) async {
          if (isEnabled == true) {
            LatLng destination = getPolygonCenter(activePolygon!);
            final availableMaps = await MapLauncher.installedMaps;
            await availableMaps.first.showDirections(
              origin: Coords(pos!.latitude!, pos.longitude!),
              destinationTitle:
                  "${selectedFarm!.value.farmername}\n${selectedFarm!.value.farmReference}",
              destination: Coords(destination.latitude, destination.longitude),
            );

            //   final url = 'https://www.google.com/maps/dir/${pos!.latitude},+${pos.longitude}/${destination.latitude},+${destination.longitude}';
            //   if (await canLaunchUrl(Uri.parse(url))) {
            // await launchUrl(Uri.parse(url));
            // } else {
            // throw 'Could not launch $url';
            // }
          }
        });
  }

  // =================================================================================
  // =================== START CALCULATE BOUNDS FROM POLYGON LATLNG ================
  // =================================================================================
  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
// =================================================================================
// =================== END CALCULATE BOUNDS FROM POLYGON LATLNG ================
// =================================================================================

  getPolygonCenter(Polygon poly) {
    List<LatLng> vertices = poly.points;

    // put all latitudes and longitudes in arrays
    List<double> longitudes = vertices.map((e) => e.longitude).toList();
    List<double> latitudes = vertices.map((e) => e.latitude).toList();

    // sort the arrays low to high
    latitudes.sort();
    longitudes.sort();

    // get the min and max of each
    double lowX = latitudes[0];
    double highX = latitudes[latitudes.length - 1];
    double lowy = longitudes[0];
    double highy = longitudes[latitudes.length - 1];

    // center of the polygon is the starting point plus the midpoint
    double centerX = lowX + ((highX - lowX) / 2);
    double centerY = lowy + ((highy - lowy) / 2);

    return LatLng(centerX, centerY);
  }
}
