
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<String?> buildVideoThumbnail({required bool isFile, required String path}) async {
  Future<String?> thumbnail;
  if(isFile == true){
    thumbnail = (await VideoThumbnail.thumbnailFile(
      video: path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 250,
      quality: 75,
    )) as Future<String?>;
  }else{
    thumbnail = (await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxWidth: 250,
      quality: 75,
    )) as Future<String?>;
  }
  return thumbnail;
}