import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
  final bool? isFile;
  final File? file;
  final String? path;
  final String? heroTag;
  const PhotoViewer({Key? key, this.isFile, this.path, this.file, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isFile!
          ? PhotoView(
            heroAttributes: PhotoViewHeroAttributes(tag: heroTag!),
            imageProvider: FileImage(file!),
          )
          : PhotoView(
            heroAttributes: PhotoViewHeroAttributes(tag: heroTag!),
            imageProvider: NetworkImage(path!),
          ) ,
    );
  }
}
