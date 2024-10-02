import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../global_components/text_input_decoration.dart';
import 'assigned_farms_map_controller.dart';

class AssignedFarmsMap extends StatefulWidget {
  const AssignedFarmsMap({Key? key}) : super(key: key);

  @override
  State<AssignedFarmsMap> createState() => _AssignedFarmsMapState();
}

class _AssignedFarmsMapState extends State<AssignedFarmsMap>
    with WidgetsBindingObserver {
  AssignedFarmsMapController assignedFarmsMapController =
      Get.put(AssignedFarmsMapController());

  GlobalController indexController = Get.find();

  Globals globals = Globals();

  String? _mapStyle;

  final double _initFabHeight = 190.0;
  late double _fabHeight;
  late double _panelHeightOpen;
  final double _panelHeightClosed = 180.0;
  PanelController panelController = PanelController();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style/silver.txt').then((string) {
      _mapStyle = string;
    });

    // assignedFarmsMapController.markers = Set.from([]);
    WidgetsBinding.instance.addObserver(this);
    _fabHeight = _initFabHeight;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initMapStyle();
    }
  }

  Future<void> _initMapStyle() async {
    await assignedFarmsMapController.mapController?.setMapStyle(_mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    assignedFarmsMapController.assignedFarmsMapScreenContext = context;
    _panelHeightOpen = MediaQuery.of(context).size.height * 0.55;

    return Material(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SlidingUpPanel(
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              controller: panelController,
              defaultPanelState: PanelState.CLOSED,
              body: _body(),
              panelBuilder: (sc) => _panel(sc),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              onPanelSlide: (double pos) => setState(() {
                _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                    _initFabHeight;
              }),
            ),

            Positioned(
              right: 10.0,
              bottom: _fabHeight,
              child: CircleIconButton(
                icon: appIconTarget(color: AppColor.black, size: 20),
                backgroundColor: Colors.white,
                hasShadow: true,
                size: 45,
                onTap: () => assignedFarmsMapController.goToUserLocation(),
              ),
            ),

            // Positioned(
            //   right: 10.0,
            //   bottom: _fabHeight + 60,
            //   child: CircleIconButton(
            //     icon: appIconZoomOut(color: AppColor.black, size: 20),
            //     backgroundColor: Colors.white,
            //     hasShadow: true,
            //     size: 45,
            //     onTap: () {},
            //   ),
            // ),
            //
            // Positioned(
            //   right: 10.0,
            //   bottom: _fabHeight + 120,
            //   child: CircleIconButton(
            //     icon: appIconZoomIn(color: AppColor.black, size: 20),
            //     backgroundColor: Colors.white,
            //     hasShadow: true,
            //     size: 45,
            //     onTap: () {},
            //   ),
            // ),

            Align(
              // top: 40.0,
              // left: 10.0,
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 45.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleIconButton(
                      icon: appIconBack(color: AppColor.black, size: 25),
                      backgroundColor: Colors.white,
                      hasShadow: true,
                      size: 45,
                      onTap: () => Get.back(),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text('Your Farms',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.black)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // body: Stack(
        //   children: [
        //
        //     GetBuilder(
        //         init: assignedFarmsMapController,
        //         builder: (controller) {
        //           return GoogleMap(
        //             initialCameraPosition: assignedFarmsMapController.initialCameraPosition,
        //             mapType: MapType.normal,
        //             compassEnabled: false,
        //             myLocationEnabled: false,
        //             myLocationButtonEnabled: false,
        //             zoomControlsEnabled: false,
        //             markers: assignedFarmsMapController.markers,
        //             polygons: assignedFarmsMapController.polygons,
        //             mapToolbarEnabled: false,
        //             onMapCreated: _onMapCreated,
        //             // onMapCreated: (GoogleMapController controller) {
        //             //   assignedFarmsMapController.mapController = controller;
        //             //   controller.setMapStyle(_mapStyle);
        //             //   // waiIndexController.getUserLocation(useUserCurrentLocation: true);
        //             // },
        //
        //           );
        //         }
        //     ),
        //
        //     Align(
        //       // top: 40.0,
        //       // left: 10.0,
        //       alignment: Alignment.topCenter,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 15),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //                 CircleIconButton(
        //                   icon: appIconBack(color: AppColor.black, size: 25),
        //                   backgroundColor: Colors.white,
        //                   hasShadow: true,
        //                   size: 45,
        //                   onTap: () => Get.back(),
        //                 ),
        //
        //             SizedBox(width: 12,),
        //
        //             Expanded(
        //               child: Text('Your Farms',
        //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
        //               ),
        //             ),
        //
        //           ],
        //         ),
        //       ),
        //     ),
        //
        //   ],
        // ),
      ),
    );
  }

  Widget _body() {
    return GetBuilder(
        init: assignedFarmsMapController,
        builder: (controller) {
          return GoogleMap(
            initialCameraPosition:
                assignedFarmsMapController.initialCameraPosition,
            mapType: MapType.normal,
            compassEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: assignedFarmsMapController.markers,
            polygons: assignedFarmsMapController.polygons,
            mapToolbarEnabled: false,
            onMapCreated: _onMapCreated,
            // onMapCreated: (GoogleMapController controller) {
            //   assignedFarmsMapController.mapController = controller;
            //   controller.setMapStyle(_mapStyle);
            //   // waiIndexController.getUserLocation(useUserCurrentLocation: true);
            // },
          );
        });
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: DropdownSearch<AssignedFarm>(
                popupProps: PopupProps.modalBottomSheet(
                    showSelectedItems: true,
                    showSearchBox: true,
                    itemBuilder: (context, item, selected) {
                      return ListTile(
                        title: Text(item.farmername.toString(),
                            style: selected
                                ? TextStyle(color: AppColor.primary)
                                : const TextStyle()),
                        subtitle: Text(
                          item.farmReference.toString(),
                        ),
                      );
                    },
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: Text(
                          'Select Farm',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    disabledItemFn: (AssignedFarm s) => false,
                    modalBottomSheetProps: ModalBottomSheetProps(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppBorderRadius.md),
                              topRight: Radius.circular(AppBorderRadius.md))),
                    ),
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 15),
                        enabledBorder: inputBorder,
                        focusedBorder: inputBorderFocused,
                        errorBorder: inputBorder,
                        focusedErrorBorder: inputBorderFocused,
                        filled: true,
                        fillColor: AppColor.xLightBackground,
                      ),
                    )),
                dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 15),
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorderFocused,
                      errorBorder: inputBorder,
                      focusedErrorBorder: inputBorderFocused,
                      filled: true,
                      fillColor: AppColor.xLightBackground,
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: AppColor.lightText, fontSize: 13),
                      hintMaxLines: 1,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child:
                            appIconSearch(color: AppColor.lightText, size: 15),
                      ),
                    ),
                    baseStyle: const TextStyle(color: Colors.red)),
                asyncItems: (String filter) async {
                  List<AssignedFarm> response = await assignedFarmsMapController
                      .globalController.database!.assignedFarmDao
                      .findAllAssignedFarms();
                  return await response;
                },
                itemAsString: (AssignedFarm d) => d.farmername ?? '',
                filterFn: (AssignedFarm d, filter) => d.farmername
                    .toString()
                    .toLowerCase()
                    .contains(filter.toLowerCase()),
                compareFn: (farm, filter) =>
                    farm.farmername == filter.farmername,
                selectedItem: assignedFarmsMapController.selectedFarm!.value,
                onChanged: (val) {
                  assignedFarmsMapController.selectedFarm!.value = val!;
                  assignedFarmsMapController.goToSelectedPolygon(val);
                  // addMonitoringRecordController.farm = val!;
                  // addMonitoringRecordController.farmSizeTC?.text = val.farmSize.toString();

                  setState(() {});
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    assignedFarmsMapController.isFirstPolygon.value == false
                        ? CustomButton(
                            isFullWidth: false,
                            backgroundColor: Colors.transparent,
                            verticalPadding: 0.0,
                            horizontalPadding: 8.0,
                            onTap: () => assignedFarmsMapController
                                .goToNextPolygon(false),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                appIconCircleLeft(
                                    color: AppColor.black, size: 20),
                                const SizedBox(width: 6),
                                Text(
                                  'Previous',
                                  style: TextStyle(
                                      color: AppColor.black, fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    assignedFarmsMapController.isLastPolygon.value == false
                        ? CustomButton(
                            isFullWidth: false,
                            backgroundColor: Colors.transparent,
                            verticalPadding: 0.0,
                            horizontalPadding: 8.0,
                            onTap: () => assignedFarmsMapController
                                .goToNextPolygon(true),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(
                                      color: AppColor.black, fontSize: 14),
                                ),
                                const SizedBox(width: 6),
                                appIconCircleRight(
                                    color: AppColor.black, size: 20),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),

            // SizedBox(height: 12.0,),
            GetBuilder(
                init: assignedFarmsMapController,
                builder: (ctx) {
                  return assignedFarmsMapController.emptyData.value != true
                      ? Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(
                                left: 24.0, right: 24.0, bottom: 20),
                            controller: sc,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Obx(
                                  () => assignedFarmsMapController.selectedFarm!
                                              .value.farmReference !=
                                          null
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Center(
                                            //   child: Container(
                                            //     padding: EdgeInsets.all(15),
                                            //     decoration: BoxDecoration(
                                            //       shape: BoxShape.circle,
                                            //       color: AppColor.lightText
                                            //     ),
                                            //     child: appIconTractor(color: AppColor.white, size: 40),
                                            //   ),
                                            // ),

                                            const SizedBox(height: 10),

                                            Text('Farm Details',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColor.black)),

                                            const SizedBox(height: 15),

                                            Text('Farmer Name',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColor.lightText)),
                                            const SizedBox(height: 5),
                                            Text(
                                                '${assignedFarmsMapController.selectedFarm!.value.farmername}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColor.black)),

                                            const SizedBox(height: 5),
                                            const Divider(),
                                            const SizedBox(height: 5),

                                            Text('Location',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColor.lightText)),
                                            const SizedBox(height: 5),
                                            Text(
                                                '${assignedFarmsMapController.selectedFarm!.value.location}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColor.black)),

                                            const SizedBox(height: 5),
                                            const Divider(),
                                            const SizedBox(height: 5),

                                            Text('Farm Reference',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColor.lightText)),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onLongPress: () {
                                                Clipboard.setData(ClipboardData(
                                                        text:
                                                            assignedFarmsMapController
                                                                .selectedFarm!
                                                                .value
                                                                .farmReference
                                                                .toString()))
                                                    .then((value) {
                                                  globals.showToast(
                                                      "Farm Reference ${assignedFarmsMapController.selectedFarm!.value.farmReference} copied to clipboard");
                                                });
                                              },
                                              child: Text(
                                                  '${assignedFarmsMapController.selectedFarm!.value.farmReference}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColor.black)),
                                            ),

                                            const SizedBox(height: 5),
                                            const Divider(),
                                            const SizedBox(height: 5),

                                            Text('Farm Size',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: AppColor.lightText)),
                                            const SizedBox(height: 5),
                                            Text(
                                                '${assignedFarmsMapController.selectedFarm!.value.farmSize}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColor.black)),

                                            const SizedBox(height: 15),

                                            Align(
                                              alignment: Alignment.topRight,
                                              child: CustomButton(
                                                isFullWidth: false,
                                                backgroundColor:
                                                    AppColor.primary,
                                                verticalPadding: 0.0,
                                                horizontalPadding: 8.0,
                                                onTap: () =>
                                                    assignedFarmsMapController
                                                        .navigateToLocation(),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      'Navigate Here',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    appIconNavigation(
                                                        color: Colors.white,
                                                        size: 20),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              Image.asset(
                                'assets/images/cocoa_monitor/empty-box.png',
                                width: 80,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "It appears no farm has been assigned to you",
                                style: TextStyle(
                                    color: AppColor.black, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                }),
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    assignedFarmsMapController.mapController = controller;
    controller.setMapStyle(_mapStyle);
    assignedFarmsMapController.loadFarms();
    // generalController.setUserCurrentLocation();
  }
}
