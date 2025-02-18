// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/outbreak_farm_apis.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/assigned_outbreak.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/cocoa_age_class.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/cocoa_type.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/community.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/polygon_drawing_tool/polygon_drawing_tool.dart';
import 'package:cocoa_rehab_monitor/view/utils/double_value_trimmer.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:cocoa_rehab_monitor/view/utils/user_current_location.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class AddOutbreakFarmController extends GetxController{

  late BuildContext addOutbreakFarmScreenContext;

  final addOutbreakFarmFormKey = GlobalKey<FormState>();

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  OutbreakFarmApiInterface outbreakFarmApiInterface = OutbreakFarmApiInterface();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  var isButtonDisabled = false.obs;
  var isSaveButtonDisabled = false.obs;


  TextEditingController? inspectionDateTC = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  AssignedOutbreak? assignedOutbreak = AssignedOutbreak();
  CocoaType? cocoaType = CocoaType();
  CocoaAgeClass? cocoaAgeClass = CocoaAgeClass();
  Community? community = Community();
  TextEditingController? farmerNameTC = TextEditingController();
  TextEditingController? farmerAgeTC = TextEditingController();
  TextEditingController? farmerContactTC = TextEditingController();
  TextEditingController? idNumberTC = TextEditingController();
  /*TextEditingController? farmLocationTC = TextEditingController();*/
  TextEditingController? farmAreaTC = TextEditingController();
  var idType;

  LocationData? locationData;

  final List<String> idTypes = [
    'NHIS',
    'Passport',
    'Voters ID',
    'Ghana Card',
    'Drivers License',
  ];

  Set<Marker>? markers;
  Polygon? polygon;



  // INITIALISE
  @override
  void onInit() async {

    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      UserCurrentLocation? userCurrentLocation = UserCurrentLocation(context: addOutbreakFarmScreenContext);
      userCurrentLocation.getUserLocation(
          forceEnableLocation: true,
          onLocationEnabled: (isEnabled, pos) {
            if (isEnabled == true){
              locationData = pos!;
              update();
            }
          }
      );
    });

  }


  usePolygonDrawingTool(){
    Set<Polygon> polys = HashSet<Polygon>();
    if (polygon != null) polys.add(polygon!);
    Get.to(() => PolygonDrawingTool(
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
        if (mkr.isNotEmpty){
          polygon = poly;
          markers = mkr;
          farmAreaTC?.text = area.truncateToDecimalPlaces(6).toString();
          update();
          globals.showOkayDialog(
            context: addOutbreakFarmScreenContext,
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
                  const SizedBox(height: 15),
                  Text('${area.truncateToDecimalPlaces(6).toString()} ha',
                      style: TextStyle(color: AppColor.black, fontSize: 20, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center
                  ),
                ],
              ),
            ),
          );
        }
      },
    ), transition: Transition.fadeIn);
  }


  // ==============================================================================
  // START ADD PERSONNEL
  // ==============================================================================
  handleAddOutbreakFarm() async{

    UserCurrentLocation? userCurrentLocation = UserCurrentLocation(context: addOutbreakFarmScreenContext);
    isButtonDisabled.value = true;

    polygon!.points.add(polygon!.points.first);
    var boundaryCoordinates = polygon!.points.map((e) => {
      'latitude': e.latitude,
      'longitude': e.longitude
    }).toList();

    userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, position) async {
          if(isEnabled == true){
            locationData = position;

            isButtonDisabled.value = false;

            globals.startWait(addOutbreakFarmScreenContext);
            OutbreakFarm outbreakFarm = OutbreakFarm(
              uid: const Uuid().v4(),
              agent: int.parse(globalController.userInfo.value.userId!),
              inspectionDate: inspectionDateTC!.text.trim(),
              outbreaksForeignkey: assignedOutbreak!.obId,
              farmboundary: Uint8List.fromList(utf8.encode(jsonEncode(boundaryCoordinates))),
              /*farmLocation: farmLocationTC!.text.trim(),*/
              farmerName: farmerNameTC!.text.trim(),
              farmerAge: int.parse(farmerAgeTC!.text.trim()),
              idType: idType,
              idNumber: idNumberTC!.text.trim(),
              farmerContact: farmerContactTC!.text.trim(),
              cocoaType: cocoaType!.name,
              ageClass: cocoaAgeClass!.name,
              farmArea: double.parse(farmAreaTC!.text.trim()),
              communitytblForeignkey: community!.communityId,
              status: SubmissionStatus.submitted,
            );
            var postResult = await outbreakFarmApiInterface.saveOutbreakFarm(outbreakFarm);
            globals.endWait(addOutbreakFarmScreenContext);

            if (postResult['status'] == RequestStatus.True || postResult['status'] == RequestStatus.Exist || postResult['status'] == RequestStatus.NoInternet){
              Get.back();
              globals.showSecondaryDialog(
                  context : homeController.homeScreenContext,
                  content: Text(postResult['msg'],
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  status: AlertDialogStatus.success,
                  okayTap: () => Navigator.of(homeController.homeScreenContext).pop()
              );
            }else if(postResult['status'] == RequestStatus.False){
              globals.showSecondaryDialog(
                  context : addOutbreakFarmScreenContext,
                  content: Text(postResult['msg'],
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  status: AlertDialogStatus.error
              );
            }else{

            }

          }else{
            isButtonDisabled.value = false;
            globals.showSnackBar(title: 'Alert', message: 'Operation could not be completed. Turn on your location and try again');
          }
        });

  }
  // ==============================================================================
  // END ADD PERSONNEL
  // ==============================================================================



  // ==============================================================================
  // START OFFLINE SAVE OUTBREAK FARM
  // ==============================================================================
  handleSaveOfflineOutbreakFarm() async{

    UserCurrentLocation? userCurrentLocation = UserCurrentLocation(context: addOutbreakFarmScreenContext);
    isSaveButtonDisabled.value = true;

    polygon!.points.add(polygon!.points.first);
    var boundaryCoordinates = polygon!.points.map((e) => {
      'latitude': e.latitude,
      'longitude': e.longitude
    }).toList();

    userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, position) async {

          if(isEnabled == true){
            locationData = position;

            isSaveButtonDisabled.value = false;

            globals.startWait(addOutbreakFarmScreenContext);
            OutbreakFarm outbreakFarm = OutbreakFarm(
              uid: const Uuid().v4(),
              agent: int.parse(globalController.userInfo.value.userId!),
              inspectionDate: inspectionDateTC!.text.trim(),
              outbreaksForeignkey: assignedOutbreak!.obId,
              farmboundary: Uint8List.fromList(utf8.encode(jsonEncode(boundaryCoordinates))),
              /*farmLocation: farmLocationTC!.text.trim(),*/
              farmerName: farmerNameTC!.text.trim(),
              farmerAge: int.parse(farmerAgeTC!.text.trim()),
              idType: idType,
              idNumber: idNumberTC!.text.trim(),
              farmerContact: farmerContactTC!.text.trim(),
              cocoaType: cocoaType!.name,
              ageClass: cocoaAgeClass!.name,
              farmArea: double.parse(farmAreaTC!.text.trim()),
              communitytblForeignkey: community!.communityId,
              status: SubmissionStatus.pending,
            );

            final outbreakFarmDao = globalController.database!.outbreakFarmDao;
            await  outbreakFarmDao.insertOutbreakFarm(outbreakFarm);

            globals.endWait(addOutbreakFarmScreenContext);

            Get.back();
            globals.showSecondaryDialog(
                context : homeController.homeScreenContext,
                content: const Text('Record saved',
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                status: AlertDialogStatus.success,
                okayTap: () => Navigator.of(homeController.homeScreenContext).pop()
            );

          }else{
            isSaveButtonDisabled.value = false;
            globals.showSnackBar(title: 'Alert', message: 'Operation could not be completed. Turn on your location and try again');
          }
        });

  }
  // ==============================================================================
  // END OFFLINE SAVE OUTBREAK FARM
  // ==============================================================================


}

