import 'package:idauth/controlers/login_users_controller.dart'; 

class LoginControllerFunc {
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    Map<String, dynamic> result = {
      'authenticated': false,
      'user': null,
    };

    Map<String, dynamic> authenticationResult =
        await LoginControllerUser.authenticate(email, password);

    if (authenticationResult['authenticated']) {
      result['authenticated'] = true;
      result['user'] = authenticationResult['user'];
    }

    return result;
  }
}
