import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String label;
  final String image;
  final Function onTap;
  const OptionCard({Key? key, required this.label, required this.image, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    var size = (width * 0.50) - (AppPadding.horizontal + (AppPadding.horizontal / 2));

    return SizedBox(
        // width: size,
        // height: size,
        child: TextButton(
          style: TextButton.styleFrom(
            //foregroundColor: AppColor.lightBackground,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppButtonProps.borderRadius))
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () => onTap(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [

                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(image,
                      height: size * 0.4
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size * 0.5, width: double.infinity,),
                    Text(label,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
