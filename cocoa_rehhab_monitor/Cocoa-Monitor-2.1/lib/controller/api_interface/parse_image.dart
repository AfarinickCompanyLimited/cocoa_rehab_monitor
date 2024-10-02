import 'dart:convert';

///Checks if there is an image object and returns it appropriately
parseImage(image){
  if (image.toString() != "img" && image.toString() != "N/A"){
    var img = jsonDecode(image.toString());
    return img['path'];
  }else{
    return image;
  }
}