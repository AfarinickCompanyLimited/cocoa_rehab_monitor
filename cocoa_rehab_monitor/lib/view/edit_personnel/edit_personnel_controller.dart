// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:io' as io;
import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/personnel_apis.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/controller/model/picked_media.dart';
import 'package:cocoa_rehab_monitor/view/utils/view_constants.dart';
import 'package:cocoa_rehab_monitor/view/widgets/_media_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ndialog/ndialog.dart';

class EditPersonnelController extends GetxController {
  late BuildContext editPersonnelControllerScreenContext;

  final editPersonnelFormKey = GlobalKey<FormState>();

  Personnel? personnel;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  PersonnelApiInterface personnelApiInterface = PersonnelApiInterface();

  final ImagePicker mediaPicker = ImagePicker();

  var isButtonDisabled = false.obs;
  var isSaveButtonDisabled = false.obs;

  LocationData? locationData;
  var designation = ''.obs;
  var isMomoOWner = ''.obs;

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // UserCurrentLocation? userCurrentLocation = await UserCurrentLocation(context: editPersonnelControllerScreenContext);
      // userCurrentLocation.getUserLocation(
      //     forceEnableLocation: true,
      //     onLocationEnabled: (isEnabled, pos) {
      //       if (isEnabled == true){
      //         locationData = pos!;
      //         update();
      //       }
      //     }
      // );

      designation.value = personnel!.designation!;
      nameTC?.text = personnel!.name!;
      // lastNameTC?.text = personnel!.lastName!;
      // middleNameTC?.text = personnel?.middleName ?? '';
      gender = personnel!.gender;
      dateOfBirth = personnel!.dob;
      phoneTC?.text = personnel?.contact ?? '';
      // region = personnel!.region;
      // district = personnel!.district;
      // operationalAreaTC?.text = personnel?.operationalArea ?? '';
      // idType = personnel!.nationalIdType;
      // idNumberTC?.text = personnel?.nationalIdNumber ?? '';
      sSNITNumberTC?.text = personnel?.ssnitNumber ?? '';
      bankNameTC?.text = personnel?.salaryBankName ?? '';
      bankBranchTC?.text = personnel?.bankBranch ?? '';
      accountNumberTC?.text = personnel?.bankAccountNumber ?? '';
      // maritalStatus = personnel!.maritalStatus;
      // educationLevel = personnel!.highestLevelEducation;
      // accountHolderNameTC?.text = personnel?.bankAccountName ?? '';
      paymentMethod = personnel!.paymentOption;
      // momoNumberTC?.text = personnel?.momoNumber ?? '';
      // isCocoaBoardRehabAssistant = personnel?.cocoaBoardFarmHand;
      // emailTC?.text = personnel?.email ?? '';
      // communityRespondentTC?.text = personnel?.communityRespondent ?? '';
      isMomoOWner.value = personnel!.isOwnerOfMomo!;
      momoOwnerNameTC?.text = personnel?.momoAccountName ?? '';
      momoNumberTC?.text = personnel?.momoNumber ?? '';

      update();
    });
  }

  // ==============================================================================
  // START ADD PERSONNEL
  // ==============================================================================
  handleAddPersonnel() async {
    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: editPersonnelControllerScreenContext);
    // isButtonDisabled.value = true;

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    //         isButtonDisabled.value = false;

    var imageOfPersonnel = personnel!.photoStaff;
    if (personnelPhoto?.file != null) {
      final bytes = await io.File(personnelPhoto!.path!).readAsBytes();
      // imageOfPersonnel = base64Encode(bytes);
      imageOfPersonnel = bytes;
    }

    // var imageOfPersonnelID = personnel!.photoId;
    // if (personnelIDImage?.file != null){
    //   final bytes = await Io.File(personnelIDImage!.path!).readAsBytes();
    //   // imageOfPersonnelID = base64Encode(bytes);
    //   imageOfPersonnelID = bytes;
    // }
    //
    // var imageOfSSNITCard = personnel!.photoSsnitCard;
    // if (SSNITCardImage?.file != null){
    //   final bytes = await Io.File(SSNITCardImage!.path!).readAsBytes();
    //   // imageOfSSNITCard = base64Encode(bytes);
    //   imageOfSSNITCard = bytes;
    // }

    globals.startWait(editPersonnelControllerScreenContext);
    Personnel personnelToUpdate = Personnel(
      uid: personnel!.uid,
      agent: globalController.userInfo.value.userId,
      submissionDate: dateFormat.format(DateTime.now()),
      lat: 0.0,
      // personnel!.lat,
      lng: 0.0,
      // personnel!.lng,
      accuracy: 0.0,
      // personnel!.accuracy,
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

    print('THIS IS RA DETAILS:::: ${personnelToUpdate.toJson()}');

    var postResult =
        await personnelApiInterface.updatePersonnel(personnelToUpdate);
    globals.endWait(editPersonnelControllerScreenContext);
    if (postResult['status'] == RequestStatus.True ||
        postResult['status'] == RequestStatus.Exist ||
        postResult['status'] == RequestStatus.NoInternet) {
      // Get.back();
      Get.back(result: {'personnel': personnelToUpdate, 'submitted': true});
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
          context: editPersonnelControllerScreenContext,
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
  // START OFFLINE SAVE PERSONNEL
  // ==============================================================================
  handleSaveOfflinePersonnel() async {
    // UserCurrentLocation? userCurrentLocation =
    //     UserCurrentLocation(context: editPersonnelControllerScreenContext);
    // isSaveButtonDisabled.value = true;

    // userCurrentLocation.getUserLocation(
    //     forceEnableLocation: true,
    //     onLocationEnabled: (isEnabled, position) async {
    //       if (isEnabled == true) {
    //         locationData = position;

    //         isSaveButtonDisabled.value = false;

    var imageOfPersonnel = personnel!.photoStaff;
    if (personnelPhoto?.file != null) {
      final bytes = await io.File(personnelPhoto!.path!).readAsBytes();
      // imageOfPersonnel = base64Encode(bytes);
      imageOfPersonnel = bytes;
    }

    // var imageOfPersonnelID = personnel!.photoId;
    // if (personnelIDImage?.file != null){
    //   final bytes = await Io.File(personnelIDImage!.path!).readAsBytes();
    //   // imageOfPersonnelID = base64Encode(bytes);
    //   imageOfPersonnelID = bytes;
    // }
    //
    // var imageOfSSNITCard = personnel!.photoSsnitCard;
    // if (SSNITCardImage?.file != null){
    //   final bytes = await Io.File(SSNITCardImage!.path!).readAsBytes();
    //   // imageOfSSNITCard = base64Encode(bytes);
    //   imageOfSSNITCard = bytes;
    // }

    globals.startWait(editPersonnelControllerScreenContext);
    Personnel personnelData = Personnel(
      uid: personnel?.uid,
      agent: globalController.userInfo.value.userId,
      submissionDate: dateFormat.format(DateTime.now()),
      lat: 0.0,
      // personnel?.lat,
      lng: 0.0,
      // personnel?.lng,
      accuracy: 0.0,
      // personnel?.accuracy,
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
    await personnelDao.updatePersonnel(personnelData);

    globals.endWait(editPersonnelControllerScreenContext);

    // Get.back(result: personnelData);
    Get.back(result: {'personnel': personnelData, 'submitted': false});
    globals.showSecondaryDialog(
        context: homeController.homeScreenContext,
        content: const Text(
          'Record saved',
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        status: AlertDialogStatus.success,
        okayTap: () => Get.back()
        // okayTap: () => Navigator.of(homeController.homeScreenContext!).pop()
        );
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
    ).show(editPersonnelControllerScreenContext);
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
