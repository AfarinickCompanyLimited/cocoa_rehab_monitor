// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:cocoa_monitor/controller/db/activity_db.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/view/utils/double_value_trimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'dart:io' as io;

import '../../controller/api_interface/cocoa_rehab/contractor_certificate_apis.dart';
import '../../controller/constants.dart';
import '../../controller/db/contractor_certificate_of_workdone_db.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor.dart';
import '../../controller/entity/cocoa_rehub_monitor/contractor_certificate_verification.dart';
import '../../controller/entity/cocoa_rehub_monitor/region_district.dart';
// import '../utils/user_current_location.dart';
import '../../controller/model/activity_model.dart';
import '../../controller/model/contractor_certificate_of_workdone_model.dart';
import '../../controller/model/picked_media.dart';
import '../global_components/custom_button.dart';
import '../utils/bytes_to_size.dart';
import '../utils/location_color.dart';
import '../utils/style.dart';
import '../utils/user_current_location.dart';
import '../utils/view_constants.dart';import 'package:image/image.dart' as img;

class EditContractorCertificateVerificationRecordController
    extends GetxController {
  late BuildContext editCertificateVerificationRecordScreenContext;

  final editCertificateVerificationRecordFormKey = GlobalKey<FormState>();

  ContractorCertificateVerificationModel? contractorCertificateVerification;
  bool? isViewMode;

  HomeController homeController = Get.find();

  Globals globals = Globals();
  Contractor? contractor = Contractor();

  ContractorCertificateApiInterface contractorCertificateApiInterface =
      ContractorCertificateApiInterface();

  GlobalController globalController = Get.find();

  final ImagePicker mediaPicker = ImagePicker();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  var isButtonDisabled = false.obs;
  var isSaveButtonDisabled = false.obs;

  LocationData? locationData;

  var region;
  var district;
  TextEditingController? operationalAreaTC = TextEditingController();

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
  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
      //     context: editContractorCertificateRecordScreenContext);
      // userCurrentLocation.getUserLocation(
      //     forceEnableLocation: true,
      //     onLocationEnabled: (isEnabled, pos) {
      //       if (isEnabled == true) {
      //         locationData = pos!;
      //         update();
      //       }
      //     });

      print("THE RECEIVED DATA IS ${contractorCertificateVerification!.toJson()}");

      selectedWeek.value =
          contractorCertificateVerification!.currrentWeek ?? '';
      selectedMonth.value =
          contractorCertificateVerification!.currentMonth ?? '';
      selectedYear.value = contractorCertificateVerification!.currentYear ?? '';
      farmReferenceNumberTC?.text =
          contractorCertificateVerification!.farmRefNumber ?? '';
      farmSizeTC?.text =
          contractorCertificateVerification!.farmSizeHa.toString();
      communityNameTC?.text =
          contractorCertificateVerification!.community.toString();

      isCompletedBy.value =
          contractorCertificateVerification!.completedBy ?? '';

      // List activityDataList = await globalController.database!.activityDao
      //     .findActivityByCode(contractorCertificateVerification!.activity.first);
      // print('THIS IS ACTIVITY DATA LIST :::: ${activityDataList}');
      // activity = activityDataList.first;
      // update();

      // List<ActivityModel>? subActivityDataList = await globalController
      //     .database!.activityDao
      //     .findAllActivityWithCodeList(
      //         contractorCertificateVerification!.activity);
      // subActivity = subActivityDataList;

      for (int i = 0; i < contractorCertificateVerification!.activity.length; i++) {
        ActivityDatabaseHelper db = ActivityDatabaseHelper.instance;
        var s = await db.getSubActivityByCode(contractorCertificateVerification!.activity[i]);

        // print("THE DATA FROM THE DATABASE ::::::::::::::::: $s");

        subActivity.add(s.first);

        // print("THE DATA FROM THE DATABASE 2 ::::::::::::::::: $subActivity");

        s.clear();
      }

      activity = subActivity.first.mainActivity;

      update();

      List? regionDistrictList = await globalController
          .database!.regionDistrictDao
          .findRegionDistrictByDistrictId(
              contractorCertificateVerification!.district!);
      regionDistrict = regionDistrictList.first;
      update();

      if (contractorCertificateVerification!.contractor == null) {
        contractor = null;
        update();
      } else {
        List<Contractor> contractorDataList = await globalController
            .database!.contractorDao
            .findContractorById(contractorCertificateVerification!.contractor!);
        contractor = contractorDataList.first;
        update();
      }

      Future.delayed(const Duration(seconds: 3), () async {
        update();
      });
    });
  }

  /* getUsersCurrentLocation() {
    UserCurrentLocation? userCurrentLocation = UserCurrentLocation(
        context: editCertificateVerificationRecordScreenContext);
    userCurrentLocation.getUserLocation(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled == true) {
            locationData = pos!;
            update();
          }
        });
  }*/

  // ==============================================================================
  // START SHOW LOCATION STREAM DIALOG
  // ==============================================================================
  void showLocationDialog() {
    showDialog(
      context: editCertificateVerificationRecordScreenContext,
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
                                  Text('Improving Accuracy. Please wait.',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                ],
                              )
                            ],
                          ),
                          const Text(
                              'Farms location will be saved at 15m or below',
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
    // Uint8List?
    String? pictureOfFarm = contractorCertificateVerification!.currentFarmPic;
    if (farmPhoto?.file != null) {
      final bytes = await io.File(farmPhoto!.path!).readAsBytes();
      pictureOfFarm = base64Encode(bytes);
      // pictureOfFarm = bytes;
    }
    // else {
    //   pictureOfFarm =
    //       Uint8List(0); // Assign empty Uint8List when pictureOfFarm is null
    // }

    globals.startWait(editCertificateVerificationRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
        subActivity.map((activity) => activity.code).cast<int>().toList();

    ContractorCertificateVerificationModel contractorCertificateVerificationData =
        ContractorCertificateVerificationModel(
      uid: contractorCertificateVerification?.uid,
      userId: int.tryParse(
        globalController.userInfo.value.userId!,
      ),
      currentYear: selectedYear.value,
      currentMonth: selectedMonth.value,
      currrentWeek: selectedWeek.value,
      reportingDate: formattedReportingDate,
      lat: locationData?.latitude ?? contractorCertificateVerification?.lat,
      lng: locationData?.longitude ?? contractorCertificateVerification?.lng,
      accuracy: locationData?.accuracy != null
          ? double.tryParse(
              locationData!.accuracy!.truncateToDecimalPlaces(2).toString())
          : contractorCertificateVerification?.accuracy,
      mainActivity: subActivityList.first,
      activity: subActivityList,
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.parse(farmSizeTC!.text),
      community: communityNameTC!.text,
      currentFarmPic:
          // Uint8List(0),
          pictureOfFarm,
      district: regionDistrict?.districtId,
      status: SubmissionStatus.submitted,
      contractor: contractor?.contractorId,
      completedBy: isCompletedBy.value,
    );

    Map<String, dynamic> data = contractorCertificateVerificationData.toJson();
    data.remove('main_activity');
    data.remove('submission_status');

    print('THIS IS Contractor Certificate DETAILS:::: ${data}');

    var postResult = await contractorCertificateApiInterface
        .saveContractorCertificateVerification(
            contractorCertificateVerificationData, data);
    globals.endWait(editCertificateVerificationRecordScreenContext);

    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {

      /// initialise the database
      ContractorCertificateDatabaseHelper dbHelper = ContractorCertificateDatabaseHelper.instance;

      await dbHelper.deleteData(contractorCertificateVerification!.uid!);

      /// save the data offline
      await dbHelper.saveData(contractorCertificateVerificationData);

      Get.back(result: {
        'CertificateVerification': contractorCertificateVerificationData,
        'submitted': true
      });

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
          context: editCertificateVerificationRecordScreenContext,
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
    // if (farmPhoto == null) {
    //   globals.showSnackBar(
    //       title: 'Alert', message: 'Kindly add a picture of the farm');
    //   return;
    // }

    if (locationData == null &&
        contractorCertificateVerification?.accuracy == 0.0) {
      globals.showSnackBar(
          title: 'Alert', message: 'Kindly add the farm location');
      return;
    }

    isButtonDisabled.value = true;

    if (locationData != null &&
        locationData!.accuracy! <= MaxLocationAccuracy.max) {
      if (isDialogOpen) {
        Get.back();
        isDialogOpen = false;
      }
      onlineUpdate();
    } else if (contractorCertificateVerification?.accuracy != 0.0) {
      if (isDialogOpen) {
        Get.back();
        isDialogOpen = false;
      }
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
    // Uint8List?
    String? pictureOfFarm = contractorCertificateVerification!.currentFarmPic;
    if (farmPhoto?.file != null) {
      final bytes = await io.File(farmPhoto!.path!).readAsBytes();
      pictureOfFarm = base64Encode(bytes);

      // pictureOfFarm = bytes;
    }

    globals.startWait(editCertificateVerificationRecordScreenContext);
    DateTime now = DateTime.now();
    String formattedReportingDate = DateFormat('yyyy-MM-dd').format(now);

    List<int> subActivityList =
        subActivity.map((newActivity) => newActivity.code).cast<int>().toList();

    ContractorCertificateVerification contractorCertificateVerificationData =
        ContractorCertificateVerification(
      uid: contractorCertificateVerification?.uid,
      currentYear: selectedYear.value,
      currentMonth: selectedMonth.value,
      currrentWeek: selectedWeek.value,
      reportingDate: formattedReportingDate,
      lat: locationData?.latitude ??
          contractorCertificateVerification?.lat ??
          0.0,
      lng: locationData?.longitude ??
          contractorCertificateVerification?.lng ??
          0.0,
      accuracy: locationData?.accuracy != null
          ? double.tryParse(
              locationData!.accuracy!.truncateToDecimalPlaces(2).toString())
          : contractorCertificateVerification?.accuracy ?? 0.0,
      mainActivity: subActivityList.first,
      activity: subActivityList,
      status: SubmissionStatus.pending,
      farmRefNumber: farmReferenceNumberTC!.text,
      farmSizeHa: double.parse(farmSizeTC!.text),
      community: communityNameTC!.text,
      district: regionDistrict?.districtId,
      userId: int.tryParse(globalController.userInfo.value.userId!),
      currentFarmPic:
          //  Uint8List(0),
          pictureOfFarm,
      contractor: contractor?.contractorId,
      completedBy: isCompletedBy.value,
    );

    Map<String, dynamic> data = contractorCertificateVerificationData.toJson();
    data.remove('main_activity');
    data.remove('submission_status');

    print('THIS IS Contractor Certificate DETAILS:::: $data');

    final contractorCertificateVerificationDao =
        globalController.database!.contractorCertificateVerificationDao;
    await contractorCertificateVerificationDao
        .updateContractorCertificateVerification(
            contractorCertificateVerificationData);

    globals.endWait(editCertificateVerificationRecordScreenContext);

    // Get.back();
    Get.back(result: {
      'CertificateVerification': contractorCertificateVerificationData,
      'submitted': false
    });
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Certificate record saved',
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
    // if (farmPhoto == null) {
    //   globals.showSnackBar(
    //       title: 'Alert', message: 'Kindly add a picture of the farm');
    //   return;
    // }
    if (locationData == null &&
        contractorCertificateVerification?.accuracy == 0.0) {
      globals.newConfirmDialog(
          title: 'Farm Location Data',
          context: editCertificateVerificationRecordScreenContext,
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
    } else if (contractorCertificateVerification?.accuracy != 0.0 &&
        locationData == null) {
      isButtonDisabled.value = false;
      if (isDialogOpen) {
        Get.back();
        isDialogOpen = false;
      }

      offlineUpdate();
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
        context: editCertificateVerificationRecordScreenContext);
    userCurrentLocation.getUserLocation1(
        forceEnableLocation: true,
        onLocationEnabled: (isEnabled, pos) {
          if (isEnabled == true) {
            if (pos!.accuracy! <= 30) {
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
