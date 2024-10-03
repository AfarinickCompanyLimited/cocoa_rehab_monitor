
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class TileButton extends StatelessWidget {
  final String? label;
  final Widget icon;
  final Color? backgroundColor;
  final Color? foreColor;
  final double? width;
  final double? height;
  final Function? onTap;
  const TileButton(
      {Key? key,
        required this.label,
        required this.icon,
        this.backgroundColor,
        this.foreColor,
        required this.onTap,
        this.width,
        this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: backgroundColor ?? AppColor.primary,
        elevation: 0.5,
        // minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(AppBorderRadius.sm))),
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: () => onTap!(),
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              // const SizedBox(height: 8),
              Text(
                label!,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: foreColor ?? Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TileButtonDetached extends StatelessWidget {
  final String? label;
  final Widget child;
  final Color? backgroundColor;
  final Color? foreColor;
  final Function? onTap;
  const TileButtonDetached({Key? key, required this.label, required this.child, this.backgroundColor, this.foreColor,  required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
        ],
      ),
    );
  }
}