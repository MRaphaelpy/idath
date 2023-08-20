import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../service/services.dart';
// ignore: library_prefixes
import "dart:math" as Math;

class LoginControllerUser {
  static Future<Map<String, dynamic>> authenticate(
      String email, String password) async {
    try {
      var users = await Services.getUsers();

      for (var user in users) {
        if (user.email == email && user.password == password) {
          // Obtém a latitude e longitude do endereço fornecido
          Map<String, double>? addressCoordinates =
              await getLatLongFromAddress(user.endereco, user.cep);

          if (addressCoordinates != null) {
            // Obtém a localização atual do dispositivo
            Position? currentPosition = await getCurrentLocation();

            if (currentPosition != null) {
              var latetude = -7.831475156132133;
              var longitude = -39.07324720913727;
              double distance = calculateDistance(
                currentPosition.latitude,
                currentPosition.longitude,

                // addressCoordinates['latitude']!,
                latetude,
                // addressCoordinates['longitude']!,
                longitude,
              );
              print(distance);
              print("Sua posicao é:${currentPosition.latitude}}");
              print("Sua posicao é:${currentPosition.longitude}}");

              if (distance < 5) {
                return {'authenticated': true, 'user': user};
              } else {
                return {
                  'authenticated': false,
                  'user': null,
                  'error': 'Usuário fora do local correto'
                };
              }
            }
          }
        }
      }

      return {'authenticated': false, 'user': null};
    } catch (e) {
      return {'authenticated': false, 'user': null};
    }
  }

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
    } catch (e) {
      print('Erro ao obter coordenadas do endereço: $e');
    }

    return null;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      return position;
    } catch (e) {
      print('Erro ao obter localização atual: $e');
    }

    return null;
  }

  static double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
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
