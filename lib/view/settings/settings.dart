// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// class QRCodeScannerScreen extends StatefulWidget {
//   @override
//   _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
// }
//
// class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   String? scannedData;
//
//   // @override
//   // void reassemble() {
//   //   super.reassemble();
//   //   if (Platform.isAndroid) {
//   //     controller?.pauseCamera();
//   //   }
//   //   controller?.resumeCamera();
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Scanner'),
//       ),
//       body: MobileScanner(
//         controller: MobileScannerController(
//           detectionSpeed: DetectionSpeed.noDuplicates,
//           returnImage: true
//         ),
//         onDetect: (capture) {
//           print("capture: ${capture.barcodes}");
//           final List<Barcode> barcodes = capture.barcodes;
//           if (barcodes.isNotEmpty) {
//             setState(() {
//               scannedData = barcodes[0].rawValue;
//             });
//           }
//         },
//       ),
//     );
//   }
//
//   // void _onQRViewCreated(QRViewController controller) {
//   //   setState(() {
//   //     this.controller = controller;
//   //   });
//   //   controller.scannedDataStream.listen((scanData) {
//   //     setState(() {
//   //       scannedData = scanData.code;
//   //     });
//   //   });
//   // }
//   //
//   // @override
//   // void dispose() {
//   //   controller?.dispose();
//   //   super.dispose();
//   // }
// }
