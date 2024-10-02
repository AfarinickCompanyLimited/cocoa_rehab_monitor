import 'dart:convert';
import 'dart:io';

import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class ImageFieldCard extends StatelessWidget {
  final Function? onTap;
  final File? image;
  final String? base64Image;
  const ImageFieldCard({Key? key, this.onTap, this.image, this.base64Image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, padding: EdgeInsets.zero,
        backgroundColor: AppColor.xLightBackground,
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm))
        ),
      ),
      onPressed: () => onTap!(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: double.infinity,
        decoration: boxDecoration(),
        // decoration: image != null
        //   ? BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm)),
        //   image: DecorationImage(
        //       image: FileImage(image!),
        //     fit: BoxFit.cover
        //   )
        // )
        // : BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm))),
        child: (image == null && (base64Image == null || base64Image!.isEmpty))
        ? Center(
          child: appIconCamera(size: 60, color: AppColor.lightText),
        )
        : Container(),
      ),
    );
  }

  BoxDecoration boxDecoration(){
    if (image != null){
      return BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm)),
          image: DecorationImage(
              image: FileImage(image!),
              fit: BoxFit.cover
          )
      );
    }else if(base64Image != null && base64Image!.isNotEmpty){
      try{
        return BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm)),
            image: DecorationImage(
                image: MemoryImage(base64Decode(base64Image!)),
                fit: BoxFit.cover
            )
        );
      }catch (e){
        return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm)));
      }
    }else{
      return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppBorderRadius.sm)));
    }
  }

}
