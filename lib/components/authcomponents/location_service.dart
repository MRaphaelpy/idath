// ignore_for_file: empty_catches

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Map<String, double>?> getLatLongFromAddress(
      String address, String cep) async {
    try {
      List<Location> locations = await locationFromAddress(
        '$address, $cep',
      );

      if (locations.isNotEmpty) {
        return {
          'latitude': locations[0].latitude,
          'longitude': locations[0].longitude,
        };
      }
    // ignore: empty_catches
    } catch (e) {}

    return null;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      return position;
    } catch (e) {}

    return null;
  }
}
