// // ignore_for_file: avoid_print
//
// import 'package:cocoa_monitor/view/auth/login/login_controller.dart';
// import 'package:cocoa_monitor/view/auth/reset_password/reset_password.dart';
// import 'package:cocoa_monitor/view/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'dart:ui';
//
//
// class Login extends StatelessWidget {
//   const Login({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     LoginController loginController = Get.put(LoginController());
//     loginController.loginScreenContext = context;
//     // Size size = MediaQuery.of(context).size;
//
//     return Material(
//       child: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle(
//           statusBarColor: AppColor.lightBackground,
//           statusBarIconBrightness: Brightness.dark,
//           systemNavigationBarColor: Colors.white,
//           systemNavigationBarIconBrightness: Brightness.dark,
//         ),
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Container(
//             color: AppColor.lightBackground,
//             // height: size.height,
//             // height: size.height,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 // Container(
//                 //   width: double.infinity,
//                 //   height: size.height,
//                 //   decoration: BoxDecoration(
//                 //       image: DecorationImage(
//                 //         // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken),
//                 //         image: AssetImage('assets/images/track_my_tree/forest1.png'),
//                 //         fit: BoxFit.cover
//                 //       )
//                 //   ),
//                 // ),
//
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   left: 0,
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(
//                               'assets/images/cocoa_monitor/cacao_beans.jpg',
//                             ),
//                             fit: BoxFit.cover)),
//                   ),
//                 ),
//
//                 BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//                   child: Scaffold(
//                     backgroundColor: Colors.transparent,
//                     body: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         SingleChildScrollView(
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: appMainHorizontalPadding),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Center(
//                                   child: Text(
//                                     "Cocoa Rehab Monitor",
//                                     style: TextStyle(
//                                         color: AppColor.black,
//                                         fontWeight: FontWeight.w900,
//                                         fontSize: 25),
//                                   ),
//                                 ),
//
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 const Center(
//                                   child: Text(
//                                     'Login',
//                                     style: TextStyle(
//                                       // color: AppColor.primary,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 30,
//                                 ),
//                                 // Text('Phone Number',
//                                 //   style: TextStyle(fontWeight: FontWeight.w500),
//                                 // ),
//                                 // SizedBox(height: 5,),
//                                 Form(
//                                   key: loginController.loginFormKey,
//                                   child: Column(
//                                     children: [
//                                       TextFormField(
//                                         controller:
//                                         loginController.phoneTextController,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               vertical: 15, horizontal: 20),
//                                           enabledBorder: inputBorder,
//                                           focusedBorder: inputBorderFocused,
//                                           errorBorder: inputBorder,
//                                           focusedErrorBorder:
//                                           inputBorderFocused,
//                                           filled: true,
//                                           fillColor: Colors.white,
//                                           hintText: 'Enter your phone number',
//                                           hintStyle: const TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.black54),
//                                           // prefixIcon: _buildFlagsButton(
//                                           //   context,
//                                           //   loginController
//                                           // ),
//                                         ),
//                                         keyboardType: TextInputType.phone,
//                                         validator: (String? value) =>
//                                         value!.trim().isEmpty
//                                             ? "Phone number required"
//                                             : null,
//                                       ),
//
//                                       // TextFormField(
//                                       //   controller: loginController
//                                       //       .usernameTextController,
//                                       //   decoration: InputDecoration(
//                                       //     contentPadding:
//                                       //         const EdgeInsets.symmetric(
//                                       //             vertical: 15, horizontal: 20),
//                                       //     enabledBorder: inputBorder,
//                                       //     focusedBorder: inputBorderFocused,
//                                       //     errorBorder: inputBorder,
//                                       //     focusedErrorBorder:
//                                       //         inputBorderFocused,
//                                       //     filled: true,
//                                       //     fillColor: Colors.white,
//                                       //     hintText: 'Enter your username',
//                                       //     hintStyle: const TextStyle(
//                                       //         fontSize: 12,
//                                       //         color: Colors.black54),
//                                       //     // prefixIcon: _buildFlagsButton(
//                                       //     //   context,
//                                       //     //   loginController
//                                       //     // ),
//                                       //   ),
//                                       //   keyboardType: TextInputType.name,
//                                       //   validator: (String? value) =>
//                                       //       value!.trim().isEmpty
//                                       //           ? "Username required"
//                                       //           : null,
//                                       // ),
//
//                                       // const SizedBox(height: 20),
//
//                                       // TextFormField(
//                                       //   controller: loginController
//                                       //       .passwordTextController,
//                                       //   decoration: InputDecoration(
//                                       //     contentPadding:
//                                       //         const EdgeInsets.symmetric(
//                                       //             vertical: 15, horizontal: 20),
//                                       //     enabledBorder: inputBorder,
//                                       //     focusedBorder: inputBorderFocused,
//                                       //     errorBorder: inputBorder,
//                                       //     focusedErrorBorder:
//                                       //         inputBorderFocused,
//                                       //     filled: true,
//                                       //     fillColor: Colors.white,
//                                       //     hintText: 'Enter your password',
//                                       //     hintStyle: const TextStyle(
//                                       //         fontSize: 12,
//                                       //         color: Colors.black54),
//                                       //     // prefixIcon: _buildFlagsButton(
//                                       //     //   context,
//                                       //     //   loginController
//                                       //     // ),
//                                       //   ),
//                                       //   keyboardType:
//                                       //       TextInputType.visiblePassword,
//                                       //   validator: (String? value) => value!
//                                       //               .trim()
//                                       //               .isEmpty ||
//                                       //           value.trim().length < 5
//                                       //       ? "Password must be at least 5 characters long"
//                                       //       : null,
//                                       // ),
//
//                                       // IntlPhoneField(
//                                       //   controller: loginController.phoneTextController,
//                                       //   decoration: InputDecoration(
//                                       //       contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       //       enabledBorder: inputBorder,
//                                       //       focusedBorder: inputBorderFocused,
//                                       //       errorBorder: inputBorder,
//                                       //       focusedErrorBorder: inputBorderFocused,
//                                       //       filled: true,
//                                       //       fillColor: Colors.white,
//                                       //       hintText: 'Enter your phone number',
//                                       //       hintStyle: TextStyle(fontSize: 12, color: Colors.black54)
//                                       //   ),
//                                       //     validator: (String? value) => value!.trim().isEmpty || value.trim().length < 13 || (value.trim().startsWith('0') && value.trim().length < 14)
//                                       //         ? "Valid phone number required"
//                                       //         : null,
//                                       //   disableLengthCheck: true,
//                                       //   showDropdownIcon: false,
//                                       //   flagsButtonPadding: EdgeInsets.only(left: 20),
//                                       //   autovalidateMode: AutovalidateMode.onUserInteraction,
//                                       //   initialCountryCode: 'GH',
//                                       //   onChanged: (phone) {
//                                       //     loginController.phoneNumberWithCountryCode = phone.completeNumber;
//                                       //
//                                       //     // print(phone.completeNumber);
//                                       //   },
//                                       // )
//                                     ],
//                                   ),
//                                 ),
//
//                                 const SizedBox(
//                                   height: 30,
//                                 ),
//
//                                 SizedBox(
//                                     width: double.infinity,
//                                     child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         backgroundColor: AppColor.primary,
//                                         foregroundColor: Colors.white,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(
//                                                     AppBorderRadius.xl))),
//                                       ),
//                                       onPressed: () {
//                                         print(
//                                             'PHONE NUMBER::::: ${loginController.phoneTextController}');
//                                         if (loginController
//                                             .loginFormKey.currentState!
//                                             .validate()) {
//                                           print('PHONE VERIFICATION STARTED');
//                                           // loginController.sendOTP(loginController.phoneTextController.text.trim());
//                                           // loginController.sendOTP();
//                                           // loginController
//                                           //     .lookupUsernamePassword();
//                                           loginController.lookupPhoneNumber();
//                                           print('PHONE VERIFICATION HAS ENDED');
//                                         }
//                                       },
//                                       child: const Padding(
//                                         padding:
//                                         EdgeInsets.symmetric(vertical: 5.0),
//                                         child: Text(
//                                           "Login",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     )),
//
//                                 const SizedBox(
//                                   height: 30,
//                                 ),
//
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text("Forgot your password?"),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Get.to(() => const ResetPassword(),
//                                             transition: Transition.fadeIn);
//                                       },
//                                       child: Text(
//                                         "Reset Here.".toUpperCase(),
//                                         style: TextStyle(
//                                             color: AppColor.black,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container()
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 Align(
//                     alignment: FractionalOffset.bottomCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 0.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           const SizedBox(
//                             height: 6,
//                           ),
//                           const Text(
//                             'A PRODUCT OF',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                                 color: Colors.black54),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 "assets/images/cocoa_monitor/af_logo.png",
//                                 fit: BoxFit.contain,
//                                 height: MediaQuery.of(context).size.width * 0.2,
//                               ),
//                               const SizedBox(width: 10),
//                               Image.asset(
//                                 "assets/images/cocoa_monitor/k_logo.png",
//                                 fit: BoxFit.contain,
//                                 height: MediaQuery.of(context).size.width * 0.2,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                               height:
//                               MediaQuery.of(context).size.height * 0.07),
//                           // Text(
//                           //   'Copyright \u00a9 ${now.year}',
//                           //   style: TextStyle(
//                           //       fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black),
//                           // ),
//                         ],
//                       ),
//                     ))
//
//                 // Align(
//                 //   alignment: Alignment.bottomCenter,
//                 //   child: Padding(
//                 //     padding: const EdgeInsets.only(bottom: 50),
//                 //     child: Image.asset('assets/logo/green_ghana_logo.png', height: size.width * 0.13,),
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// var inputBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(AppBorderRadius.xl),
//     borderSide:
//     BorderSide(width: 0.2, color: AppColor.primary.withOpacity(0.5)));
//
// var inputBorderFocused = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(AppBorderRadius.xl),
//     borderSide: BorderSide(width: 1, color: AppColor.primary));
//
// var inputBorderError = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(AppBorderRadius.xl),
//     borderSide: BorderSide(width: 1, color: AppColor.primary));
//
//
//
// /*
// DecoratedBox _buildFlagsButton(context, LoginController loginController) {
//   return DecoratedBox(
//     decoration: const BoxDecoration(),
//     child: InkWell(
//       // borderRadius: widget.dropdownDecoration.borderRadius as BorderRadius?,
//       child: Padding(
//         padding: EdgeInsets.only(left: 20),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               CountryUtils.countryCodeToEmoji(loginController.selectedCountry['countryCode'].toString()),
//               style: TextStyle(
//                 fontSize: 25,
//               ),
//             ),
//             SizedBox(width: 8,),
//             FittedBox(
//               child: Text(
//                 '+${loginController.selectedCountry['phoneCode'].toString()}',
//                 // style: widget.dropdownTextStyle,
//               ),
//             ),
//             SizedBox(width: 8),
//           ],
//         ),
//       ),
//       onTap: (){
//         showCountryPicker(
//             context: context,
//             countryListTheme: CountryListThemeData(
//               flagSize: 25,
//               backgroundColor: Colors.white,
//               textStyle: TextStyle(fontSize: 13, color: Colors.black),
//               //Optional. Sets the border radius for the bottomsheet.
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(20.0),
//                 topRight: Radius.circular(20.0),
//               ),
//               //Optional. Styles the search field.
//               inputDecoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                 enabledBorder: inputBorder,
//                 focusedBorder: inputBorderFocused,
//                 errorBorder: inputBorder,
//                 focusedErrorBorder: inputBorderFocused,
//                 filled: true,
//                 fillColor: Colors.white,
//                 prefixIcon: Icon(appIconSearchOld),
//                 hintText: 'Search for country',
//                 hintStyle: TextStyle(fontSize: 12, color: Colors.black54),
//                 // border: OutlineInputBorder(
//                 //   borderSide: BorderSide(
//                 //     color: const Color(0xFF8C98A8).withOpacity(0.2),
//                 //   ),
//                 // ),
//               ),
//             ),
//             onSelect: (Country country){
//               loginController.selectedCountry['phoneCode'] = country.phoneCode;
//               loginController.selectedCountry['countryCode'] = country.countryCode;
//               loginController.selectedCountry['name'] = country.name;
//             }
//         );
//       },
//     ),
//   );
// }
// */


// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // enable Material 3
        useMaterial3: true,
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

// Implement a multi select on the Home screen
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _selectedItems = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      'Flutter',
      'Node.js',
      'React Native',
      'Java',
      'Docker',
      'MySQL'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dbestech'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // use this button to open the multi-select dialog
            ElevatedButton(
              onPressed: _showMultiSelect,
              child: const Text('Select Your Favorite Topics'),
            ),
            const Divider(
              height: 30,
            ),
            // display selected items
            Wrap(
              children: _selectedItems
                  .map((e) => Chip(
                label: Text(e),
              ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}