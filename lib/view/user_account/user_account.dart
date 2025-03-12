import 'package:cocoa_rehab_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/photo_viewer/photo_viewer.dart';
import 'package:cocoa_rehab_monitor/view/user_account/user_account_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAccount extends StatelessWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UserAccountController userAccountController = Get.put(UserAccountController());

    userAccountController.userAccountScreenContext = context;

    GlobalController indexController = Get.find();

    return Material(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () =>  Navigator.of(context).pop(),
                child: Icon(appIconBackOld, color: appColorButtonTextBlack, size: 20,),
              ),

              TextButton(
                style: TextButton.styleFrom(
                  //foregroundColor: Colors.white, visualDensity: const VisualDensity(vertical: -1),
                  backgroundColor: Colors.red,
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.xl))
                  ),
                ),
                onPressed: () => userAccountController.logout(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
              // GestureDetector(
              //   onTap: () =>  Navigator.of(context).pop(),
              //   child: Text("Logout",
              //   style: TextStyle(fontSize: 12, color: Colors.black54),
              //   ),
              // ),
            ],
          ),
        ),
        body: GetBuilder(
            init: userAccountController,
            builder: (ctx) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: appMainHorizontalPadding),
                child: Column(
                  children: [

                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          if(userAccountController.updatedAvatar.value == false)
                            Container(
                              height: MediaQuery.of(context).size.width * .30,
                              width: MediaQuery.of(context).size.width * .30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/user_avatar_default.png',
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width * .30,
                                ),
                              ),
                            ),
                          if(userAccountController.updatedAvatar.value == true)
                            Container(
                              height: MediaQuery.of(context).size.width * .30,
                              width: MediaQuery.of(context).size.width * .30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(() => PhotoViewer(
                                    isFile: true,
                                    file: userAccountController.avatarFile,
                                    heroTag: "userImage${indexController.userInfo.value.userId!}",
                                  ), transition: Transition.fadeIn);
                                },
                                child: ClipOval(
                                  child: Hero(
                                    tag: "userImage${indexController.userInfo.value.userId!}",
                                    child: Image.file(
                                      userAccountController.avatarFile,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width * .30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleIconButton(
                              icon: Icon(appIconEditOld, color: Colors.black, size: 18,),
                              size: 35,
                              backgroundColor: appColorPrimary.shade100,
                              hasShadow: false,
                              onTap: () => userAccountController.chooseMediaSource(),
                            ),
                          )
                        ],
                      ),
                    ),


                    const SizedBox(height: 10,),

                    Text("${indexController.userInfo.value.firstName!} ${indexController.userInfo.value.lastName!}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),

                    // Text(indexController.userInfo.value.email ?? "Email not set",
                    //   style: TextStyle(
                    //       fontSize: 12
                    //   ),
                    // ),

                    const SizedBox(height: 35,),

                    Form(
                      key: userAccountController.accountFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextFormField(
                            controller: userAccountController.firstNameTextController,
                            readOnly: !userAccountController.editingEnabled.value,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorderFocused,
                              errorBorder: inputBorder,
                              focusedErrorBorder: inputBorderFocused,
                              filled: true,
                              fillColor: appColorTextInputLightBlue,
                              hintText: 'Enter your name',
                              hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
                              suffixIcon: userAccountController.editingEnabled.value ? Icon(appIconEditOld, size: 18,) : null,
                              label: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: appColorTextInputLightBlue,
                                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                      border: Border.all(color: Colors.white, width: 3)
                                  ),
                                  child: const Text("Name",
                                    style: TextStyle(fontSize: 13, color: Colors.black87),)
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.toString().trim() == "" || value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25,),

                          TextFormField(
                            controller: userAccountController.emailTextController,
                            readOnly: !userAccountController.editingEnabled.value,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorderFocused,
                              errorBorder: inputBorder,
                              focusedErrorBorder: inputBorderFocused,
                              filled: true,
                              fillColor: appColorTextInputLightBlue,
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
                              suffixIcon: userAccountController.editingEnabled.value ? Icon(appIconEditOld, size: 18,) : null,
                              label: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: appColorTextInputLightBlue,
                                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                      border: Border.all(color: Colors.white, width: 3)
                                  ),
                                  child: const Text("Email",
                                    style: TextStyle(fontSize: 13, color: Colors.black87),)
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.toString().trim() == "" || value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25,),

                          TextFormField(
                            controller: userAccountController.phoneTextController,
                            readOnly: true,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorderFocused,
                              errorBorder: inputBorder,
                              focusedErrorBorder: inputBorderFocused,
                              filled: true,
                              fillColor: appColorTextInputLightBlue,
                              hintText: 'Enter your phone number',
                              hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
                              label: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: appColorTextInputLightBlue,
                                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                                    border: Border.all(color: Colors.white, width: 3)
                                  ),
                                  child: const Text("Phone",
                                    style: TextStyle(fontSize: 13, color: Colors.black87),)
                              ),
                            ),
                            keyboardType: TextInputType.name,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.toString().trim() == "" || value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),

                          // TextFormField(
                          //   controller: userAccountController.phoneTextController,
                          //   decoration: InputDecoration(
                          //     contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          //     enabledBorder: inputBorder,
                          //     focusedBorder: inputBorderFocused,
                          //     errorBorder: inputBorder,
                          //     focusedErrorBorder: inputBorderFocused,
                          //     filled: true,
                          //     fillColor: appColorTextInputLightBlue,
                          //     hintText: 'Enter your phone number',
                          //     hintStyle: TextStyle(fontSize: 12, color: Colors.black54),
                          //     prefixIcon: _buildFlagsButton(
                          //         context,
                          //         userAccountController
                          //     ),
                          //   ),
                          //   keyboardType: TextInputType.phone,
                          //   validator: (String? value) => value!.trim().isEmpty || value.trim().length < 9 || (value.trim().startsWith('0') && value.trim().length < 10)
                          //       ? "Valid phone number required"
                          //       : null,
                          // ),

                          // SizedBox(height: 25,),
                          //
                          // Stack(
                          //   clipBehavior: Clip.none,
                          //   alignment: Alignment.topCenter,
                          //   children: [
                          //     AbsorbPointer(
                          //       absorbing: !userAccountController.editingEnabled.value,
                          //       child: ItemSwitch(
                          //         items: [{"Male": "Male"}, {"Female": "Female"}],
                          //         initialValue: indexController.userInfo.value.sex,
                          //         backgroundColor: appColorTextInputLightBlue,
                          //         activeColor: appColorTextInputLightBlue.shade600.withOpacity(0.7),
                          //         inActiveColor: appColorTextInputLightBlue,
                          //         onSelect: (val){
                          //           userAccountController.gender.value = "";
                          //           userAccountController.gender.value = val.toString();
                          //         },
                          //       ),
                          //     ),
                          //     Positioned(
                          //       top: 0,
                          //       right: 0,
                          //       child: userAccountController.editingEnabled.value ? Icon(appIconEdit, size: 18, color: Colors.black45,) : Container(),
                          //     )
                          //   ],
                          // ),

                          const SizedBox(height: 30,),

                          userAccountController.editingEnabled.value == false
                              ? CustomButton(
                            isFullWidth: true,
                            backgroundColor: appColorPrimary,
                            verticalPadding: 0.0,
                            horizontalPadding: 8.0,
                            onTap: () {
                              userAccountController.editingEnabled.value = true;
                              userAccountController.update();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(appIconEditOld, size: 20, color: Colors.white,),
                                const SizedBox(width: 5,),
                                const Text(
                                  'Edit info',
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          )
                              : CustomButton(
                            isFullWidth: true,
                            backgroundColor: appColorPrimary,
                            verticalPadding: 0.0,
                            horizontalPadding: 8.0,
                            onTap: (){
                              if (userAccountController.accountFormKey.currentState!.validate()) {
                                userAccountController.updateAccount();
                              }
                            },
                            child: const Text(
                              'Update info',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),

                        ],
                      ),
                    )

                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}



var inputBorder =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 0, color: appColorTextInputLightBlue)
);

var inputBorderFocused =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: appColorTextInputLightBlue)
);

var inputBorderError =  OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
    borderSide: BorderSide(width: 1, color: appColorTextInputLightBlue)
);



// DecoratedBox _buildFlagsButton(context, UserAccountController userAccountController) {
//   return DecoratedBox(
//     decoration: const BoxDecoration(),
//     child: InkWell(
//       // borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 20),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               CountryUtils.countryCodeToEmoji(userAccountController.selectedCountry['countryCode'].toString()),
//               style: const TextStyle(
//                 fontSize: 25,
//               ),
//             ),
//             const SizedBox(width: 8,),
//             FittedBox(
//               child: Text(
//                 '+${userAccountController.selectedCountry['phoneCode'].toString()}',
//                 // style: widget.dropdownTextStyle,
//               ),
//             ),
//             const SizedBox(width: 8),
//           ],
//         ),
//       ),
//       onTap: (){
//         showCountryPicker(
//             context: context,
//             countryListTheme: CountryListThemeData(
//               flagSize: 25,
//               backgroundColor: Colors.white,
//               textStyle: const TextStyle(fontSize: 13, color: Colors.black),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20.0),
//                 topRight: Radius.circular(20.0),
//               ),
//               //Optional. Styles the search field.
//               inputDecoration: InputDecoration(
//                 contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 enabledBorder: inputBorder,
//                 focusedBorder: inputBorderFocused,
//                 errorBorder: inputBorder,
//                 focusedErrorBorder: inputBorderFocused,
//                 filled: true,
//                 fillColor: Colors.white,
//                 prefixIcon: Icon(appIconSearchOld),
//                 hintText: 'Search for country',
//                 hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
//               ),
//             ),
//             onSelect: (Country country){
//               userAccountController.selectedCountry['phoneCode'] = country.phoneCode;
//               userAccountController.selectedCountry['countryCode'] = country.countryCode;
//               userAccountController.selectedCountry['name'] = country.name;
//             }
//         );
//       },
//     ),
//   );
// }