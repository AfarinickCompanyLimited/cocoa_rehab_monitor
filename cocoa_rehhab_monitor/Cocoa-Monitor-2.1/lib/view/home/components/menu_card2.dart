import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class MenuCard2 extends StatelessWidget {
  final String image;
  final String label;
  final Function onTap;
  const MenuCard2(
      {Key? key, required this.image, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:100,
      width: 120,
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade100,
          borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(2, 41, 10, 0.08),
              blurRadius: 80,
              offset: Offset(0, -4),
            )
          ]),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.black, backgroundColor: Colors.blueGrey.shade100,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(AppButtonProps.borderRadius))),
          // splashFactory: NoSplash.splashFactory,
        ),
        onPressed: () => onTap(),
        child: Column(
          children: [
            Image.asset( image, height: 40),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColor.black),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
