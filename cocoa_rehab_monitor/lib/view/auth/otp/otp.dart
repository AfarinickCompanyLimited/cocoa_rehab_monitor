// import 'package:cocoa_rehab_monitor/view/global_components/primary_button.dart';
// import 'package:cocoa_rehab_monitor/view/utils/style.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
//
//
// import 'otp_controller.dart';
//
// class OTP extends StatefulWidget {
//   final String phone;
//   final bool loginIsSuccessful;
//   const OTP({Key? key, required this.phone, required this.loginIsSuccessful}) : super(key: key);
//
//   @override
//   State<OTP> createState() => _OTPState();
// }
//
// class _OTPState extends State<OTP> {
//
//   OTPController otpController = Get.put(OTPController());
//   final TextEditingController _pinPutController = TextEditingController();
//   final FocusNode _pinPutFocusNode = FocusNode();
//
//   // BoxDecoration get _pinPutDecoration {
//   //   return BoxDecoration(
//   //     border: Border.all(color: appColorPrimary),
//   //     borderRadius: BorderRadius.circular(15.0),
//   //   );
//   // }
//
//   final pinTheme = PinTheme(
//     width: 47,
//     height: 66,
//     textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColor.black),
//     decoration: BoxDecoration(
//       color: AppColor.xLightBackground,
//       borderRadius: BorderRadius.circular(AppBorderRadius.sm),
//       border: Border.all(color: Colors.transparent),
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//
//     otpController.otpScreenContext = context;
//
//     otpController.loginIsSuccessful = widget.loginIsSuccessful;
//
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Builder(
//           builder: (context) {
//             return Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: appMainHorizontalPadding, vertical: appMainVerticalPadding),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       const Text("Verification",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//                       ),
//                       const SizedBox(height: 15.0),
//                       const Text("Enter the OTP sent to the number",
//                         textAlign: TextAlign.center,
//                         // style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 5.0),
//                       Text(widget.phone,
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       const SizedBox(height: 30.0),
//                       Container(
//                         color: Colors.white,
//                         // margin: EdgeInsets.all(appHorizontalPadding),
//                         // padding: const EdgeInsets.all(20.0),
//                         child: Pinput(
//                           length: 6,
//                           controller: _pinPutController,
//                           focusNode: _pinPutFocusNode,
//                           defaultPinTheme: pinTheme,
//                           onCompleted: (pin) {
//                             otpController.verifyOTPCode(pin);
//                           },
//                           focusedPinTheme: pinTheme.copyWith(
//                             height: 66,
//                             width: 47,
//                             decoration: pinTheme.decoration!.copyWith(
//                               border: Border.all(color: Colors.transparent),
//                             ),
//                           ),
//                           errorPinTheme: pinTheme.copyWith(
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(AppBorderRadius.sm),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 40.0),
//
//                       PrimaryButton(
//                         label: 'Verify',
//                         isFullWidth: true,
//                         onTap: (){
//                           otpController.verifyOTPCode(_pinPutController.text);
//                         },
//                       ),
//
//
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//   }
// }
//
// // void _showSnackBar(String pin, BuildContext context) {
// //   final snackBar = SnackBar(
// //     duration: const Duration(seconds: 3),
// //     content: SizedBox(
// //       height: 60.0,
// //       child: Center(
// //         child: Text(
// //           'Pin Submitted. Value: $pin',
// //           style: const TextStyle(fontSize: 25.0),
// //         ),
// //       ),
// //     ),
// //     backgroundColor: Colors.deepPurpleAccent,
// //   );
// //   Scaffold.of(context)
// //     ..hideCurrentSnackBar()
// //     ..showSnackBar(snackBar);
// // }
