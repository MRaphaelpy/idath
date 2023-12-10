import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? qrcode;
  String? cep;
  String? endereco;

  UserModel(
      {required this.id,
      this.name,
      this.email,
      this.password,
      this.qrcode,
      this.cep,
      this.endereco});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    qrcode = json['qrcode'];
    cep = json['cep'];
    endereco = json['endereco'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['qrcode'] = qrcode;
    data['cep'] = cep;
    data['endereco'] = endereco;
    return data;
  }

  void _updateQrcode() {
    final randomValue = DateTime.now().millisecondsSinceEpoch;
    final bytes = utf8.encode(randomValue.toString());
    final hash = sha256.convert(bytes);
    final hashHex = hash.toString();
    qrcode = "${id}_${hashHex.substring(0, 32)}";
  }

  String getUpdatedQrcode() {
    _updateQrcode();
    return qrcode!;
  }
}
