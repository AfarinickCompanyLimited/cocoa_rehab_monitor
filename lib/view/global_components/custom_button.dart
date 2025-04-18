import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth, width;
  final bool? isFullWidth;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Function? onTap;
  const CustomButton(
      {Key? key,
      this.child,
      this.backgroundColor,
      this.borderColor = Colors.transparent,
      this.isFullWidth,
      this.verticalPadding,
      @required this.horizontalPadding,
      this.onTap,
      this.borderWidth,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: isFullWidth! ? double.infinity : width,
        child: TextButton(
          style: TextButton.styleFrom(
            //foregroundColor: Colors.white,
            backgroundColor: backgroundColor,
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(AppBorderRadius.xl)),
                side: BorderSide(
                    color: borderColor!,
                    width: borderColor?.value == 0
                        ? 0
                        : borderWidth == null
                            ? 1
                            : borderWidth!)),
          ),
          onPressed: () => onTap!(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding!, vertical: 7),
            child: child,
          ),
        ));
  }
}
