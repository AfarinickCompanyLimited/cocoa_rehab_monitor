import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';


typedef SourceTapCallback = Function(int source, String mediaType);

class MediaSourceDialog extends StatelessWidget {
  final String? mediaType;
  final SourceTapCallback? onCameraSourceTap;
  final SourceTapCallback? onGallerySourceTap;
  const MediaSourceDialog({Key? key, this.mediaType, this.onCameraSourceTap, this.onGallerySourceTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.symmetric(horizontal: appMainHorizontalPadding, vertical: appMainVerticalPadding),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        boxShadow:[
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), //color of shadow
            spreadRadius: 5, //spread radius
            blurRadius: 7, // blur radius
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(
            height: 15.0,
          ),

          Center(
            child: Text('Select $mediaType Source',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          const SizedBox(
            height: 20.0,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                  // postTreeController.pickMedia(source: 1, mediaType: mediaType);
                  onCameraSourceTap!(1, mediaType!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    mediaType == "Image" ?
                    appIconCamera(size: 40, color: AppColor.lightText) :
                    appIconVideoCamera(size: 40, color: AppColor.lightText),
                    const SizedBox(height: 5,),
                    const Text('Camera',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                  // postTreeController.pickMedia(source: 0, mediaType: mediaType);
                  onGallerySourceTap!(0, mediaType!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    mediaType == "Image" ?
                    appIconGallery(size: 40, color: AppColor.lightText) :
                    appIconGallery(size: 40, color: AppColor.lightText),
                    const SizedBox(height: 5,),
                    const Text('Gallery',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    )
                  ],
                ),
              )
            ],
          ),

          const SizedBox(
            height: 20.0,
          ),

        ],
      ),
    );
  }
}
