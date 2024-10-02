// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, unnecessary_brace_in_string_interps, avoid_print

import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:cocoa_monitor/controller/api_interface/cocoa_rehab/personnel_apis.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/view/home/home_controller.dart';
import 'package:cocoa_monitor/controller/model/picked_media.dart';
// import 'package:cocoa_monitor/view/utils/double_value_trimmer.dart';
// import 'package:cocoa_monitor/view/utils/user_current_location.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:cocoa_monitor/view/widgets/_media_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uuid/uuid.dart';

class AddPersonnelController extends GetxController {
  late BuildContext addPersonnelControllerScreenContext;

  final addPersonnelFormKey = GlobalKey<FormState>();

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  PersonnelApiInterface personnelApiInterface = PersonnelApiInterface();

  final ImagePicker mediaPicker = ImagePicker();

  // var isButtonDisabled = false.obs;
  // var isSaveButtonDisabled = false.obs;

  LocationData? locationData;
  var designation = ''.obs;
  TextEditingController? nameTC = TextEditingController();
  // TextEditingController? lastNameTC = TextEditingController();
  // TextEditingController? middleNameTC = TextEditingController();
  var gender;
  var dateOfBirth;
  TextEditingController? phoneTC = TextEditingController();
  RegionDistrict? region = RegionDistrict();
  RegionDistrict? district = RegionDistrict();
  // TextEditingController? operationalAreaTC = TextEditingController();
  // var idType;
  // TextEditingController? idNumberTC = TextEditingController();
  TextEditingController? sSNITNumberTC = TextEditingController();
  TextEditingController? bankNameTC = TextEditingController();
  TextEditingController? momoOwnerNameTC = TextEditingController();
  TextEditingController? bankBranchTC = TextEditingController();
  TextEditingController? accountNumberTC = TextEditingController();
  TextEditingController? momoNumberTC = TextEditingController();

  // var maritalStatus;
  // var educationLevel;
  // TextEditingController? accountHolderNameTC = TextEditingController();
  var paymentMethod;
  // TextEditingController? momoNumberTC = TextEditingController();
  // var isCocoaBoardRehabAssistant;
  // TextEditingController? cocoaDistrictTC = TextEditingController();
  // TextEditingController? emailTC = TextEditingController();
  // TextEditingController? communityRespondentTC = TextEditingController();
  PickedMedia? personnelPhoto;
  PickedMedia? personnelIDImage;
  PickedMedia? sSNITCardImage;

  List<Activity> selectedFarmActivities = [];

  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  final List<String> idTypes = [
    'NHIS',
    'Passport',
    'Voters ID',
    'Ghana Card',
    'Drivers License',
  ];

  final List<String> maritalStatusItems = [
    MaritalStatus.single,
    MaritalStatus.married,
    MaritalStatus.divorced,
    MaritalStatus.separated,
    MaritalStatus.widowed,
  ];

  final List<String> educationLevelItems = [
    EducationLevel.primary,
    EducationLevel.juniorHigh,
    EducationLevel.seniorHigh,
    EducationLevel.tertiary,
    EducationLevel.none,
  ];

  final List<String> designationItems = [
    // PersonnelDesignation.projectOfficer,
    PersonnelDesignation.rehabAssistant,
    PersonnelDesignation.rehabTechnician,
    // PersonnelDesignation.districtManager,
  ];

  final List<String> paymentMethodItems = [
    PaymentMethod.bank,
    PaymentMethod.mobileMoney,
  ];

  final List<String> yesNoItems = [
    YesNo.yes,
    YesNo.no,
  ];
  var isMomoOWner = ''.obs;

  List<String> isMOmoOwnerOptions = [
    'Yes',
    'No',
  ];

  final List<String> farmActivitiesItems = [
    FarmActivities.weeding,
    FarmActivities.planting,
    FarmActivities.holing,
    FarmActivities.cutting,
    FarmActivities.hackingSlashing,
  ];

  // INITIALISE
  @override
  void onInit() async {
    super.onInit();

    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserCurrentLocation? userCurrentLocation =
          UserCurrentLocation(context: addPersonnelControllerScreenContext);
      userCurrentLocation.getUserLocation(
          forceEnableLocation: true,
          onLocationEnabled: (isEnabled, pos) {
            if (isEnabled == true) {
              locationData = pos!;
              update();
            }
          });
    });*/
  }

  // ==============================================================================
  // START ADD PERSONNEL
  // ==============================================================================
  handleAddPersonnel() async {
    // UserCurrentLocation? userCurrentLocation =
    //  UserCurrentLocation(context: addPersonnelControllerScreenContext);
    //isButtonDisabled.value = true;

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    // isButtonDisabled.value = false;

    var imageOfPersonnel = Uint8List.fromList([]);
    if (personnelPhoto?.file != null) {
      final bytes = await io.File(personnelPhoto!.path!).readAsBytes();
      // imageOfPersonnel = base64Encode(bytes);
      imageOfPersonnel = bytes;
    }

    // var imageOfPersonnelID = Uint8List.fromList([]);
    // if (personnelIDImage?.file != null){
    //   final bytes = await Io.File(personnelIDImage!.path!).readAsBytes();
    //   // imageOfPersonnelID = base64Encode(bytes);
    //   imageOfPersonnelID = bytes;
    // }

    // var imageOfSSNITCard = Uint8List.fromList([]);
    // if (SSNITCardImage?.file != null){
    //   final bytes = await Io.File(SSNITCardImage!.path!).readAsBytes();
    //   // imageOfSSNITCard = base64Encode(bytes);
    //   imageOfSSNITCard = bytes;
    // }

    globals.startWait(addPersonnelControllerScreenContext);
    Personnel personnel = Personnel(
      uid: const Uuid().v4(),
      agent: globalController.userInfo.value.userId,
      submissionDate: dateFormat.format(DateTime.now()),
      lat: 0.0,
      //  locationData!.latitude,
      lng: 0.0,
      // locationData!.longitude,
      accuracy: 0.0,
      //  double.parse(
      //     locationData!.accuracy!.truncateToDecimalPlaces(2).toString()),
      // email: emailTC!.text.trim(),
      designation: designation.value,
      name: nameTC!.text.trim(),
      // middleName: middleNameTC!.text.trim(),
      // lastName: lastNameTC!.text.trim(),
      gender: gender,
      dob: dateOfBirth,
      contact: phoneTC!.text.trim(),
      region: region?.regionId,
      district: district?.districtId,
      // operationalArea : operationalAreaTC!.text.trim(),
      // nationalIdType: idType ?? '',
      // nationalIdNumber: idNumberTC!.text.trim(),
      ssnitNumber: sSNITNumberTC!.text.trim(),
      salaryBankName: bankNameTC!.text.trim(),
      bankBranch: bankBranchTC!.text.trim(),
      bankAccountNumber: accountNumberTC!.text.trim(),
      // bankAccountName: accountHolderNameTC!.text.trim(),
      // maritalStatus: maritalStatus ?? '',
      // highestLevelEducation: educationLevel ?? '',
      paymentOption: paymentMethod ?? '',
      // momoNumber: momoNumberTC!.text.trim(),
      // cocoaBoardFarmHand: isCocoaBoardRehabAssistant ?? '',
      // communityRespondent: communityRespondentTC!.text.trim(),
      // activity: selectedFarmActivities.map((e) => e.mainActivity).join(', '),
      photoStaff: imageOfPersonnel,
      // photoId: imageOfPersonnelID,
      // photoSsnitCard: imageOfSSNITCard,
      status: SubmissionStatus.submitted,
      isOwnerOfMomo: isMomoOWner.value,
      momoAccountName: momoOwnerNameTC!.text.trim(),
      momoNumber: momoNumberTC!.text.trim(),
    );
    print('DATADATADATA ;;; ${personnel.toJson()}');

    var postResult = await personnelApiInterface.addPersonnel(personnel);
    globals.endWait(addPersonnelControllerScreenContext);

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
          context: addPersonnelControllerScreenContext,
          content: Text(
            postResult['msg'],
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          status: AlertDialogStatus.error);
    } else {}
    // } else {
    //   isButtonDisabled.value = false;
    //   globals.showSnackBar(
    //       title: 'Alert',
    //       message:
    //           'Operation could not be completed. Turn on your location and try again');
    // }
    //});
  }
  // ==============================================================================
  // END ADD PERSONNEL
  // ==============================================================================

  // ==============================================================================
  // START OFFLINE SAVE PERSONNEL
  // ==============================================================================
  handleSaveOfflinePersonnel() async {
    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: addPersonnelControllerScreenContext);
    // isSaveButtonDisabled.value = true;

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    //         isSaveButtonDisabled.value = false;

    Uint8List? imageOfPersonnel;
    if (personnelPhoto?.file != null) {
      final bytes = await io.File(personnelPhoto!.path!).readAsBytes();
      // imageOfPersonnel = base64Encode(bytes);
      imageOfPersonnel = bytes;
    }

    // var imageOfPersonnelID;
    // if (personnelIDImage?.file != null){
    //   final bytes = await Io.File(personnelIDImage!.path!).readAsBytes();
    //   // imageOfPersonnelID = base64Encode(bytes);
    //   imageOfPersonnelID = bytes;
    // }

    // var imageOfSSNITCard;
    // if (SSNITCardImage?.file != null){
    //   final bytes = await Io.File(SSNITCardImage!.path!).readAsBytes();
    //   // imageOfSSNITCard = base64Encode(bytes);
    //   imageOfSSNITCard = bytes;
    // }

    globals.startWait(addPersonnelControllerScreenContext);
    Personnel personnel = Personnel(
      uid: const Uuid().v4(),
      agent: globalController.userInfo.value.userId,
      submissionDate: dateFormat.format(DateTime.now()),
      lat: 0.0,
      // locationData!.latitude,
      lng: 0.0,
      // locationData!.longitude,
      accuracy: 0.0,
      // double.parse(
      // locationData!.accuracy!.truncateToDecimalPlaces(2).toString()),
      // email: emailTC!.text.trim(),
      designation: designation.value,
      name: nameTC!.text.trim(),
      // middleName: middleNameTC!.text.trim(),
      // lastName: lastNameTC!.text.trim(),
      gender: gender,
      dob: dateOfBirth,
      contact: phoneTC!.text.trim(),
      region: region?.regionId,
      district: district?.districtId,
      // operationalArea : operationalAreaTC!.text.trim(),
      // nationalIdType: idType ?? '',
      // nationalIdNumber: idNumberTC!.text.trim(),
      ssnitNumber: sSNITNumberTC!.text.trim(),
      salaryBankName: bankNameTC!.text.trim(),
      bankBranch: bankBranchTC!.text.trim(),
      bankAccountNumber: accountNumberTC!.text.trim(),
      // bankAccountName: accountHolderNameTC!.text.trim(),
      // maritalStatus: maritalStatus ?? '',
      // highestLevelEducation: educationLevel ?? '',
      paymentOption: paymentMethod ?? '',
      // momoNumber: momoNumberTC!.text.trim(),
      // cocoaBoardFarmHand: isCocoaBoardRehabAssistant ?? '',
      // communityRespondent: communityRespondentTC!.text.trim(),
      // activity: selectedFarmActivities.map((e) => e.mainActivity).join(', '),
      photoStaff: imageOfPersonnel,
      // photoId: imageOfPersonnelID,
      // photoSsnitCard: imageOfSSNITCard,
      status: SubmissionStatus.pending,

      isOwnerOfMomo: isMomoOWner.value,
      momoAccountName: momoOwnerNameTC!.text.trim(),
      momoNumber: momoNumberTC!.text.trim(),
    );

    final personnelDao = globalController.database!.personnelDao;
    await personnelDao.insertPersonnel(personnel);

    /// ============================
    // ============================
    // ============================
    // for (var i = 0; i < 80; i++) {
    //   Personnel newPersonnel = personnel;
    //   newPersonnel.uid = Uuid().v4();
    //   final personnelDao = globalController.database!.personnelDao;
    //   await  personnelDao.insertPersonnel(personnel);
    // }
    // ============================
    // ============================
    /// ============================
    print(
        'PERSONNEL NAME THAT HAS BEEN SENT TO LOCAL DB:::: ${personnel.name}');
    globals.endWait(addPersonnelControllerScreenContext);

    Get.back();
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
  // END OFFLINE SAVE PERSONNEL
  // ==============================================================================

// ===========================================
// START SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================
  chooseMediaSource(String imageToSet) {
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
        onCameraSourceTap: (source, mediaType) =>
            pickMedia(source: source, imageToSet: imageToSet),
        onGallerySourceTap: (source, mediaType) =>
            pickMedia(source: source, imageToSet: imageToSet),
      ),
    ).show(addPersonnelControllerScreenContext);
  }
// ===========================================
// END SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================

// ===========================================
// START PICK MEDIA
// ==========================================
  pickMedia({int? source, String? imageToSet}) async {
    final XFile? mediaFile;
    var fileType = FileType.image;
    if (source == 0) {
      mediaFile = await mediaPicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
    } else {
      mediaFile = await mediaPicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);
    }

    if (mediaFile != null) {
      var fileSize = await mediaFile.length();
      PickedMedia pickedMedia = PickedMedia(
        name: mediaFile.name,
        path: mediaFile.path,
        type: fileType,
        size: fileSize,
        file: File(mediaFile.path),
      );

      if (imageToSet == PersonnelImageData.personnelImage) {
        personnelPhoto = pickedMedia;
        update();
      } else if (imageToSet == PersonnelImageData.idImage) {
        personnelIDImage = pickedMedia;
        update();
      } else if (imageToSet == PersonnelImageData.sSNITCardImage) {
        sSNITCardImage = pickedMedia;
        update();
      }
    } else {
      return null;
    }
  }
// ===========================================
// END PICK MEDIA
// ==========================================
}
