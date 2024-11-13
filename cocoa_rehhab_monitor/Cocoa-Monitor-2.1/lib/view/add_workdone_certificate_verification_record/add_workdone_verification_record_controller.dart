// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'dart:async';
import 'dart:convert';
// import 'dart:typed_data';
import 'dart:io' as io;

import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/db/contractor_certificate_of_workdone_db.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/contractor_certificate_verification.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/utils/double_value_trimmer.dart';
import 'package:cocoa_monitor/view/utils/user_current_location.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uuid/uuid.dart';

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
import '../../controller/model/activity_model.dart';
import '../../controller/model/contractor_certificate_of_workdone_model.dart';
import '../../controller/model/picked_media.dart';
import '../global_components/custom_button.dart';
import '../utils/bytes_to_size.dart';
import '../utils/location_color.dart';
import '../utils/style.dart';
import '../widgets/_media_source_dialog.dart';

import 'package:image/image.dart' as img;

class AddContractorCertificateVerificationRecordController
    extends GetxController {
  late BuildContext addContractorCertificateVerificationRecordScreenContext;

  final addContractorCertificateVerificationRecordFormKey =
      GlobalKey<FormState>();

  HomeController homeController = Get.find();

  Globals globals = Globals();

  GlobalController globalController = Get.find();

  ContractorCertificateApiInterface contractorCertificateApiInterface =
      ContractorCertificateApiInterface();

  final ImagePicker mediaPicker = ImagePicker();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  var isButtonDisabled = false.obs;
  var isSaveButtonDisabled = false.obs;
  Contractor? contractor = Contractor();

  LocationData? locationData;

  // Community? community = Community();

  RegionDistrict? regionDistrict = RegionDistrict();

  TextEditingController? farmSizeTC = TextEditingController();

  TextEditingController? farmReferenceNumberTC = TextEditingController();
  TextEditingController? communityNameTC = TextEditingController();

  String? activity;

  List<ActivityModel> subActivity = [];

  List<String> listOfWeeks = ['1', '2', '3', '4', '5'];

  List<String> listOfStaff = [
    'Rehab Assistant',
    'COHORT',
    'Contractor',
    'CHED'
  ];

  var isCompletedBy = ''.obs;

  List<String> listOfMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  var selectedWeek = ''.obs;
  var selectedMonth = ''.obs;
  var selectedYear = ''.obs;
  var isLoadingLocation = false.obs;

  PickedMedia? farmPhoto;

  // Completer<bool> isValidCompleter = Completer<bool>();
  Completer<bool>? isValidCompleter; //Declared as nullable

  bool? isValid = false;
  bool isDialogOpen = false; // Flag to track if the dialog is open
  bool cancelUpdate = false;

  // INITIALISE
  /* @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
          context: addContractorCertificateVerificationRecordScreenContext);
      userCurrentLocation.getUserLocation(
          forceEnableLocation: true,
          onLocationEnabled: (isEnabled, pos) {
            if (isEnabled == true) {
              // locationData = pos!;
              update();
            }
          });
    });
  }*/

// ==============================================================================
  // START SHOW LOCATION STREAM DIALOG
  // ==============================================================================
  void showLocationDialog() {
    showDialog(
      context: addContractorCertificateVerificationRecordScreenContext,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppBorderRadius.sm))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GetBuilder(
              init: this,
              builder: (context) {
                return locationData != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('GETTING FARM LOCATION',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.black)),
                              const SizedBox(height: 10),
                              Text(
                                  '${locationData?.accuracy?.truncateToDecimalPlaces(2).toString()}m',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: locationAccuracyColor(
                                          locationData?.accuracy))),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  CupertinoActivityIndicator(),
                                  Text(
                                    'Improving Accuracy. Please wait',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Text(
                              'Farms\' location will be saved at 15m or below',
                              style: TextStyle(
                                fontSize: 14,
                              )),
                          // const Text('Time elapsed: ')
                          const Divider(
                            height: 2,
                          ),
                          CustomButton(
                            isFullWidth: false,
                            backgroundColor: AppColor.primary,
                            verticalPadding: 0.0,
                            horizontalPadding: 8.0,
                            onTap: () {
                              cancelUpdate = true;
                              Get.back();
                            },
                            child: const Text(
                              'Cancel',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ],
                      )
                    : const Text('Loading farm location...');
              },
            ),
          ),
        );
      },
    );
  }
  // ==============================================================================
  // END LOCATION STREAM DIALOG
  // ==============================================================================

// ==============================================================================
  // START ADD MONITORING RECORD ONLINE UPDATE
  // ==============================================================================
  onlineUpdate() async {
    isButtonDisabled.value = false;
    // var pictureOfFarm = Uint8List.fromList([]);
    String? pictureOfFarm;
    // Uint8List? pictureOfFarm;
    if (farmPhoto?.file != null) {
      final bytes = await io.File(farmPhoto!.path!).readAsBytes();
      pictureOfFarm = base64Encode(bytes);
      // pictureOfFarm = bytes;
    }

    globals.startWait(addContractorCertificateVerificationRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
        subActivity.map((activity) => activity.code).cast<int>().toList();

    ContractorCertificateVerificationModel contractorCertificateVerification =
        ContractorCertificateVerificationModel(
      uid: const Uuid().v4(),
      userId: int.tryParse(
        globalController.userInfo.value.userId!,
      ),
      currentYear: selectedYear.value,
      currentMonth: selectedMonth.value,
      currentWeek: selectedWeek.value,
      reportingDate: formattedReportingDate,
      lat: locationData?.latitude,
      lng: locationData?.longitude,
      accuracy: double.tryParse(
              locationData!.accuracy!.truncateToDecimalPlaces(2).toString()) ??
          0.0,
      mainActivity: subActivityList.first,
      activity: subActivityList,
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.tryParse(farmSizeTC!.text),
      community: communityNameTC!.text,
      currentFarmPic:
          // Uint8List(0),
          pictureOfFarm,
      district: regionDistrict?.districtId,
      status: SubmissionStatus.submitted,
      contractor: contractor?.contractorId,
      completedBy: isCompletedBy.value,
    );

    Map<String, dynamic> data = contractorCertificateVerification.toJson();
    data.remove('main_activity');
    data.remove('submission_status');
    // print(
    // 'THIS IS Contractor CertificateONLINE UPDATE DETAILS::::${json.encode(data)}');
    print('THIS IS Contractor CertificateONLINE UPDATE DETAILS:::: $data');

    var postResult = await contractorCertificateApiInterface
        .saveContractorCertificateVerification(
            contractorCertificateVerification, data);
    globals.endWait(addContractorCertificateVerificationRecordScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      Get.back(result: {
        'CertificateVerification': contractorCertificateVerification,
        'submitted': true
      });
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
          context: addContractorCertificateVerificationRecordScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    }
  }
  // ==============================================================================
  // END ADD MONITORING RECORD ONLINE UPDATE
  // ==============================================================================

  // ==============================================================================
  // START ADD MONITORING RECORD
  // ==============================================================================
  handleAddMonitoringRecord() async {
    if (farmPhoto == null) {
      globals.showSnackBar(
          title: 'Alert', message: 'Kindly add a picture of the farm');
      return;
    }

    if (locationData == null) {
      globals.showSnackBar(
          title: 'Alert', message: 'Kindly add the farm location');
      return;
    }

    isButtonDisabled.value = true;

    if (locationData!.accuracy! <= MaxLocationAccuracy.max) {
      if (isDialogOpen) {
        print('INSIDE IS DIALOG OPEN WHICH IS INIT FALSE');
        Get.back();
        isDialogOpen = false;
      }
      print('SHOULD BE OUTSIDE IS DIALOG OPEN WHICH IS INIT FALSE');

      onlineUpdate();
    } else {
      if (!isDialogOpen) {
        showLocationDialog();
      }
      final isValid = await isValidCompleter?.future;

      if (isValid != null && isValid && cancelUpdate == false) {
        Get.back();
        onlineUpdate();
      }
    }
  }
  // ==============================================================================
  // END ADD MONITORING RECORD
  // ==============================================================================

  // ==============================================================================
  // START ADD MONITORING RECORD OFFLINE UPDATE
  // ==============================================================================
  offlineUpdate() async {

    // Uint8List? pictureOfFarm;
    String? pictureOfFarm;
    if (farmPhoto?.file != null) {
      final bytes = await io.File(farmPhoto!.path!).readAsBytes();
      pictureOfFarm = base64Encode(bytes);

      // pictureOfFarm = bytes;
    }
    globals.startWait(addContractorCertificateVerificationRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
        subActivity.map((newActivity) => newActivity.code).cast<int>().toList();

    ContractorCertificateVerificationModel contractorCertificateVerification =
    ContractorCertificateVerificationModel(
      uid: const Uuid().v4(),
      currentYear: selectedYear.value,
      currentMonth: selectedMonth.value,
      currentWeek: selectedWeek.value,
      reportingDate: formattedReportingDate,
      lat: locationData?.latitude ?? 0.0,
      lng: locationData?.longitude ?? 0.0,
      accuracy: locationData?.accuracy != null
          ? double.tryParse(
              locationData!.accuracy!.truncateToDecimalPlaces(2).toString())
          : 0.0,
      mainActivity: subActivityList.first,
      activity: subActivityList,
      status: SubmissionStatus.pending,
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.tryParse(farmSizeTC!.text),
      community: communityNameTC!.text,
      district: regionDistrict?.districtId,
      userId: int.tryParse(globalController.userInfo.value.userId!),
      currentFarmPic: pictureOfFarm,
      contractor: contractor?.contractorId,
      completedBy: isCompletedBy.value,
    );

    // Map<String, dynamic> data = contractorCertificateVerification.toJson();

    // data.remove('main_activity');
    // data.remove('submission_status');
    // data.remove('current_farm_pic');



    // final contractorCertificateVerificationDao =
    //     globalController.database!.contractorCertificateVerificationDao;
    // await contractorCertificateVerificationDao
    //     .insertContractorCertificateVerification(
    //         contractorCertificateVerification);

    /// initialise the database
    ContractorCertificateDatabaseHelper dbHelper = ContractorCertificateDatabaseHelper.instance;

    /// save the data offline
    await dbHelper.saveData(contractorCertificateVerification);

    globals.endWait(addContractorCertificateVerificationRecordScreenContext);
    Get.back();
    Get.back(result: {
      'contractorCertificateVerification': contractorCertificateVerification,
      'submitted': false
    });
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Certificate saved',
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        status: AlertDialogStatus.success,
        okayTap: () => Navigator.of(homeController.homeScreenContext).pop());
  }
  // ==============================================================================
  // END ADD MONITORING RECORD OFFLINE UPDATE
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE MONITORING RECORD
  // ==============================================================================
  handleSaveOfflineMonitoringRecord() async {

    if (farmPhoto == null) {
      globals.showSnackBar(
          title: 'Alert', message: 'Kindly add a picture of the farm');
      return;
    }

    if (locationData == null) {
      globals.newConfirmDialog(
          title: 'Farm Location Data',
          context: addContractorCertificateVerificationRecordScreenContext,
          content: const Text(
            'Are you sure you want to save this form without the farm location?',
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          okayTap: () async {
            offlineUpdate();
          },
          cancelTap: () {
            Get.back();
          });
    } else if (locationData != null &&
        locationData!.accuracy! <= MaxLocationAccuracy.max) {
      isButtonDisabled.value = false;
      if (isDialogOpen) {
        Get.back();
        isDialogOpen = false;
      }

      offlineUpdate();
    } else if (locationData != null &&
        locationData!.accuracy! > MaxLocationAccuracy.max) {
      if (!isDialogOpen) {
        showLocationDialog();
      }
      final isValid = await isValidCompleter?.future;

      if (isValid != null && isValid && cancelUpdate == false) {
        Get.back();
        offlineUpdate();
      }
    }
  }
  // ==============================================================================
  // END OFFLINE SAVE MONITORING RECORD
  // ==============================================================================

// ===========================================
// START SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================
  chooseMediaSource() {
    AlertDialog(
      scrollable: true,
      // insetPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(10.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      content: MediaSourceDialog(
        mediaType: FileType.image,
        onCameraSourceTap: (source, mediaType) => pickMedia(source: source),
        onGallerySourceTap: (source, mediaType) => pickMedia(source: source),
      ),
    ).show(addContractorCertificateVerificationRecordScreenContext);
  }
// ===========================================
// END SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================

// ===========================================
// START PICK MEDIA
// ==========================================

  pickMedia({int? source}) async {
    final XFile? mediaFile;
    var fileType = FileType.image;

    if (source == 0) {
      mediaFile = await mediaPicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
    } else {
      mediaFile = await mediaPicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
    }

    if (mediaFile != null) {
      var originalFile = io.File(mediaFile.path);
      var fileSize = await originalFile.length();

      // Load the original image
      final originalImageBytes = await originalFile.readAsBytes();
      img.Image? image = img.decodeImage(originalImageBytes);

      if (image != null) {
        // Resize the image to 30% of the original dimensions
        img.Image resizedImage = img.copyResize(image,
            width: (image.width * 0.3).toInt(),
            height: (image.height * 0.3).toInt());

        // Compress the resized image and save it to the same file path
        final compressedImageBytes = img.encodeJpg(resizedImage, quality: 70);
        await originalFile.writeAsBytes(compressedImageBytes);

        // Update the file size after compression
        fileSize = compressedImageBytes.length;
      }

      // Create and save the PickedMedia instance
      PickedMedia pickedMedia = PickedMedia(
        name: mediaFile.name,
        path: mediaFile.path,
        type: fileType,
        size: fileSize,
        file: originalFile,
      );

      farmPhoto = pickedMedia;
      update();

      print(bytesToSize(fileSize));
    } else {
      return null;
    }
  }


//   pickMedia({int? source}) async {
//     final XFile? mediaFile;
//     var fileType = FileType.image;
//     if (source == 0) {
//       mediaFile = await mediaPicker.pickImage(
//           source: ImageSource.gallery, imageQuality: 50);
//     } else {
//       mediaFile = await mediaPicker.pickImage(
//           source: ImageSource.camera, imageQuality: 50);
//     }
//
//     if (mediaFile != null) {
//       var fileSize = await mediaFile.length();
//       PickedMedia pickedMedia = PickedMedia(
//         name: mediaFile.name,
//         path: mediaFile.path,
//         type: fileType,
//         size: fileSize,
//         file: io.File(mediaFile.path),
//       );
//       // print('haaaaaaaaaaaaaaaa');
//       // print(bytesToSize(fileSize));
//       farmPhoto = pickedMedia;
//       update();
//       print(bytesToSize(fileSize));
//     } else {
//       return null;
//     }
//   }

// ===========================================
// END PICK MEDIA
// ==========================================

// ==============================================================================
// START GET USERS CURRENT LOCATION
// ==============================================================================

  getUsersCurrentLocation() {
    isLoadingLocation.value = true;

    if (isValidCompleter == null || isValidCompleter?.isCompleted == true) {
      isValidCompleter = Completer<bool>(); //Initialized only if not completed
      isValid = false;
    }

    UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
        context: addContractorCertificateVerificationRecordScreenContext);
    userCurrentLocation.getUserLocation1(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled == true) {
            if (pos!.accuracy! <= MaxLocationAccuracy.max) {
              isValid = true;

              if (!isValidCompleter!.isCompleted) {
                isValidCompleter!
                    .complete(true); //Complete only if not completed
              }

              locationData = pos;
              isLoadingLocation.value = false;

              print('UPDATE UPDATE UPDATE ${pos.accuracy}');

              update();
            } else {
              locationData = pos;

              update();
              print('ACC ACC ACC ${pos.accuracy}');
            }
          } else {
            isButtonDisabled.value = false;
            globals.showSnackBar(
                title: 'Alert',
                message:
                    'Operation could not be completed. Turn on your location and try again');
          }
        });
  }

// ==============================================================================
// END GET USERS CURRENT LOCATION
// ==============================================================================
}
