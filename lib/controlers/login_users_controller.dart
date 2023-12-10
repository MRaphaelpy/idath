import 'package:geolocator/geolocator.dart';
import 'package:idauth/components/authcomponents/geolocator_helper.dart';
import 'package:idauth/components/authcomponents/location_service.dart';
import 'package:idauth/components/authcomponents/password_hasher.dart';
import 'package:idauth/global_values.dart';
import '../service/services.dart';

class AuthenticationController {
  static Future<Map<String, dynamic>> authenticate(
      String email, String password) async {
    try {
      PasswordHasher passwordHasher =
          PasswordHasher(GlobalValues.authHashToken);

      var users = await Services.getUsers();
      
      var passwordHashed = passwordHasher.hashPassword(password);

      for (var user in users) {
        if (user.email == email && user.password == passwordHashed) {
          Map<String, double>? addressCoordinates =
              await LocationService.getLatLongFromAddress(
            user.endereco!,
            user.cep!,
          );

          if (addressCoordinates != null) {
            Position? currentPosition =
                await LocationService.getCurrentLocation();

            if (currentPosition != null) {
              double distance = GeolocationHelper.calculateDistance(
                currentPosition.latitude,
                currentPosition.longitude,
                addressCoordinates['latitude']!,
                addressCoordinates['longitude']!,
              );
// -7.7728548629903225, -39.05023314011071
              if (true) {
                return {'authenticated': true, 'user': user};
              } else {
                return {
                  'authenticated': false,
                  'user': null,
                  'error': 'Usuário fora do local correto',
                };
              }
            }
          }
        }
      }

      return {
        'authenticated': false,
        'user': null,
      };
    } catch (e) {
      return {
        'authenticated': false,
        'user': null,
      };
    }
  }
}
