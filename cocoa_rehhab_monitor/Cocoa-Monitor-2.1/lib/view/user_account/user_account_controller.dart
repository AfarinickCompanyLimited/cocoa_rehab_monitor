// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:cocoa_monitor/controller/api_interface/user_info_apis.dart';
import 'package:cocoa_monitor/controller/constants.dart';
import 'package:cocoa_monitor/controller/model/cm_user.dart';
import 'package:cocoa_monitor/view/auth/login/login.dart';
import 'package:cocoa_monitor/view/global_components/globals.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/utils/view_constants.dart';
import 'package:cocoa_monitor/view/widgets/_media_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cocoa_monitor/view/routes.dart' as route;
import 'package:dio/dio.dart' as dio_http;
// import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
// import 'package:ndialog/src/dialogExtension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountController extends GetxController{

  GlobalController indexController = Get.find();

  UserInfoApiInterface userInfoApiInterface = UserInfoApiInterface();

  late BuildContext userAccountScreenContext;

  Globals globals = Globals();

  final accountFormKey = GlobalKey<FormState>();

  var firstNameTextController = TextEditingController();
  var lastNameTextController = TextEditingController();

  var emailTextController = TextEditingController();

  var phoneTextController = TextEditingController();

  var gender = Gender.none.obs;

  var selectedCountry = {
    "phoneCode": "233",
    "countryCode": "GH",
    "name": "Ghana",
  };

  final ImagePicker mediaPicker = ImagePicker();

  var updatedAvatar = false.obs;

  late File avatarFile = File('');
  String avatarFileName = "";

  var editingEnabled = false.obs;


  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      setUserDetails();
    });
    super.onInit();

    

  }



  setUserDetails(){
    firstNameTextController.text = indexController.userInfo.value.firstName!;
    lastNameTextController.text = indexController.userInfo.value.lastName!;
    // emailTextController.text = indexController.userInfo.value.email!;
    // phoneTextController.text = indexController.userInfo.value.phone!;
    // gender.value = indexController.userInfo.value.sex!;
    update();
  }




  changeUserAvatar() async{
    final XFile? image = await mediaPicker.pickImage(source: ImageSource.gallery);
    if (image != null){
      avatarFile = File(image.path);
      updatedAvatar.value = true;
      update();
    }
  }




// ===========================================
// START SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================
  chooseMediaSource(){

    AlertDialog(
      scrollable: true,
      // insetPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(10.0),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))
      ),
      content: MediaSourceDialog(
        mediaType: FileType.image,
        onCameraSourceTap: (source, mediaType) => pickImage(source: source),
        onGallerySourceTap: (source, mediaType) => pickImage(source: source),
      ),
    );

  }
// ===========================================
// END SHOW MEDIA SOURCE BOTTOM SHEET
// ==========================================



// ===========================================
// START PICK MEDIA
// ==========================================
  pickImage({int? source}) async {
    final XFile? mediaFile;

    if (source == 0){
      mediaFile = await mediaPicker.pickImage(source: ImageSource.gallery);
    }else{
      mediaFile = await mediaPicker.pickImage(source: ImageSource.camera);
    }

    if(mediaFile != null){
      avatarFile = File(mediaFile.path);
      updatedAvatar.value = true;
      avatarFileName = mediaFile.name;
      update();

      updateProfilePhoto();

    }

  }
// ===========================================
// END PICK MEDIA
// ==========================================



// ==============================================================================
// START UPDATE PROFILE PHOTO
// ==============================================================================
  updateProfilePhoto() async{

    String? mimeType = mime(avatarFileName);
    String mimee = mimeType!.split('/')[0];
    String type = mimeType.split('/')[1];

    var requestResult = await userInfoApiInterface.updateProfilePhoto(dio_http.FormData.fromMap({
      // 'token': indexController.userInfo.value.token,
      'image': await dio_http.MultipartFile.fromFile(avatarFile.path.toString(), filename: avatarFileName, contentType: MediaType(mimee, type))
      // 'image': await dioHttp.MultipartFile.fromFile(avatarFile.path)
    }),
        indexController.userInfo.value.userId
    );

    if (requestResult['status'] == true){
      update();
      // globals.showToast(requestResult['msg']);
    }else if (requestResult['connectionAvailable'] == true){
      globals.showToast(requestResult['msg']);
    }else{
      globals.showToast('Could not update profile photo');
    }

  }
// ==============================================================================
// END UPDATE PROFILE PHOTO
// ==============================================================================


/// ==============================================================================
/// START UPDATE USER ACCOUNT
/// ==============================================================================
  updateAccount() async{

    globals.startWait(userAccountScreenContext);
    var registrationStatus = await userInfoApiInterface.updateAccountDetails(
        {
          // 'token': indexController.userInfo.value.token,
          // 'name': nameTextController.text.trim(),
          'email': emailTextController.text.trim(),
          'sex': gender.value,
        },
        indexController.userInfo.value.userId);

    globals.endWait(userAccountScreenContext);

    if(registrationStatus['connectionAvailable'] == true){
      if (registrationStatus['status'] == true){

        editingEnabled.value = false;
        globals.showToast("Updated");
        update();

        setUserDetails();

      }else{
        globals.showToast(registrationStatus['message']);
      }
    }else{
      globals.showToast("Check your internet connection");
    }
  }
// ==============================================================================
// END UPDATE USER ACCOUNT
// ==============================================================================


  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool(SharedPref.loggedIn, false);
    indexController.userInfo.value = CmUser();
    indexController.userIsLoggedIn.value = false;

    Navigator.of(userAccountScreenContext).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(builder: (BuildContext context) => const Login()
      ),
      ModalRoute.withName(route.trackMyTreeIndex),
    );
  }



}