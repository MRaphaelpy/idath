// ignore: library_prefixes
import "dart:math" as Math;
class GeolocationHelper {
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const int earthRadius = 6371000;

    double dLat = (endLatitude - startLatitude).toRadians();
    double dLon = (endLongitude - startLongitude).toRadians();

    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(startLatitude.toRadians()) *
            Math.cos(endLatitude.toRadians()) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);

    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return earthRadius * c;
  }
}

extension ToRadians on double {
  double toRadians() {
    return this * Math.pi / 180;
  }
}