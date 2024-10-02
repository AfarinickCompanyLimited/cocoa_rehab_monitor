import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Citizens App'),
      leading: const RotatedBox(
        quarterTurns: 2,
        child: IconButton(
          icon: Icon(
            Icons.details,
            color: Colors.white,
          ),
          onPressed: null,
        ),
      ), systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
