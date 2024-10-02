import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> showLocationOnMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }


  // https://medium.com/@shivani.patel18/google-maps-url-launcher-in-flutter-54cf6388b381
  static Future<void> showDirections(startLat, startLng, endLat, endLng) async {
    final url = 'https://www.google.com/maps/dir/$startLat,+$startLng/$endLat,+$endLng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }


}