// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class MandatoryUpdateScreen extends StatelessWidget {
  const MandatoryUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Material(
          color: Colors.white,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: AlertDialog(
              title: Text('Version Update Required'),
              content: Text(
                  'A new update is available. Please update this current version'),
            ),
          )),
    );
  }
}
