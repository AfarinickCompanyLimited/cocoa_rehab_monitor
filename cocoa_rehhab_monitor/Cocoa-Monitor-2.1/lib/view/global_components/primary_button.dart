import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? label;
  final bool? isFullWidth;
  final Function? onTap;
  const PrimaryButton({Key? key, this.label, this.isFullWidth, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: isFullWidth! ? double.infinity : null,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: appColorPrimary,
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.xl))),
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: isFullWidth! ?  const EdgeInsets.symmetric(vertical: 7.0) :  const EdgeInsets.symmetric(horizontal: 20, vertical: 7.0),
            child: Text(
              label!,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}

