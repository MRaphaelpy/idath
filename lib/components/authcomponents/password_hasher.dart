import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  final String _salt;

  PasswordHasher(this._salt);

  String hashPassword(String password) {
    final salt = _salt.codeUnits;
    final key = utf8.encode(password);
    final hmac = Hmac(sha256, salt);
    final digest = hmac.convert(key);
    return digest.toString();
  }
}
