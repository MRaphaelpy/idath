import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String password;
  String qrcode;
  final String cep;
  final String endereco;
  final String autenticado;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.qrcode,
    required this.cep,
    required this.endereco,
    required this.autenticado,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      qrcode: json['qrcode'],
      cep: json['cep'],
      endereco: json['endereco'],
      autenticado: json['autenticado'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'qrcode': qrcode,
        'cep': cep,
        'endereco': endereco,
        'autenticado': autenticado,
      };

  void updateQrcode() {
    final randomValue = DateTime.now().millisecondsSinceEpoch;
    final bytes = utf8.encode(randomValue.toString());
    final hash = sha256.convert(bytes);
    final hashHex = hash.toString();
    qrcode = "${id}_${hashHex.substring(0, 32)}";
  }

  String getUpdatedQrcode() {
    updateQrcode();
    return this.qrcode;
  }
}
