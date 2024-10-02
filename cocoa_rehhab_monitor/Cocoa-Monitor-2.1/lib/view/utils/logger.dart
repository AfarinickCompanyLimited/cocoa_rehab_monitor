// // import 'package:flutter/material.dart';
// // import 'package:location/location.dart';

// // Location location =  Location(); 

// // Stream<LocationData> locationStream = location.onLocationChanged;

// // class LocationDialog extends StatefulWidget {
// //   const LocationDialog({Key? key}) : super(key: key);

// //   @override
// //   State<LocationDialog> createState() => _LocationDialogState();
// // }

// // class _LocationDialogState extends State<LocationDialog> {
// //   Stream<LocationData>? locationStream;
  
// //   @override
// //   void initState() {
// //     super.initState();
// //     locationStream = location.onLocationChanged;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       content: StreamBuilder<LocationData?>(
// //         stream: locationStream,
// //         builder: (context, snapshot) {
// //           if (snapshot.hasData) {
// //             LocationData? loc = snapshot.data;
// //             return Text(
// //               "Latitude: ${loc?.latitude}, Longitude: ${loc?.longitude}"
// //             );
// //           } else {
// //             return const CircularProgressIndicator();
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }

// // // showDialog(
// // //   context: context, 
// // //   builder: (_) => LocationDialog()
// // // );






// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';
// import 'package:location/location.dart';

// class LocationDialog extends StatefulWidget {
//   const LocationDialog({Key? key}) : super(key: key);

//   @override
//   State<LocationDialog> createState() => _LocationDialogState();
// }

// class _LocationDialogState extends State<LocationDialog> {
//   Stream<LocationData>? locationStream;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the location stream when the widget is created.
//     locationStream = getCurrentLocationStream();
//   }

//   Stream<LocationData>? getCurrentLocationStream() {
//   // Start listening to location updates.
//   return onLocationChanged().where((locationData) {
//       print('LONGITUDE: ${locationData.longitude}, LATITUDE: ${locationData.latitude}, ACCURACY: ${locationData.accuracy}');
//       return locationData.accuracy != null;
//     });
// }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: StreamBuilder<LocationData>(
//           stream: locationStream,
//           builder: (BuildContext streamContext, AsyncSnapshot<LocationData> snapshot) {
//             if (snapshot.hasData && snapshot.data != null) {
//               final position = snapshot.data!;
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text('Current Location:'),
//                   Text('Latitude: ${position.latitude}'),
//                   Text('Longitude: ${position.longitude}'),
//                   Text('Accuracy: ${position.accuracy}'),
//                 ],
//               );
//             } else {
//               return const Text('Loading location...');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// void showLocationDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return const LocationDialog();
//     },
//   );
// }
