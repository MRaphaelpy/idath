import 'dart:convert';
import 'interface_http_service.dart';
import 'user_model.dart';

class Services {
  static const root = "http://192.168.1.10/flutter/users_actions.php";
  static const getAllAction = "GET_ALL";
  static const addUserAction = "ADD_USER";
  static const updateQrCodeAction = "UPDATE_QRCODE";
  static const getAutenticado = "GET_AUTENTICADO";
  static const updateAutenticado = "UPDATE_AUTENTICADO";
  static final IHttpService httpService = HttpServiceImpl();

  static Future<List<UserModel>> getUsers() async {
    try {
      var map = <String, dynamic>{};
      map['action'] = getAllAction;
      final response = await httpService.post(root, map);

      if (response.statusCode == 200) {
        List<UserModel> list = parseResponse(response.body);
        return list;
      } else {
        throw Exception("Erro ao obter usuários.");
      }
    } catch (e) {
      throw Exception("Erro ao obter usuários: $e");
    }
  }

  static List<UserModel> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  }

  static Future<String> updateQrCode({
    required String id,
    required String qrcode,
  }) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = updateQrCodeAction;
      map['id'] = id;
      map['qrcode'] = qrcode;
      final response = await httpService.post(root, map);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Erro ao atualizar código QR.");
      }
    } catch (e) {
      throw Exception("Erro ao atualizar código QR: $e");
    }
  }

  static Future<String> addUser({
    required String name,
    required String email,
    required String password,
    required String qrcode,
    required String cep,
    required String endereco,
    required String autenticado,
  }) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = addUserAction;
      map['name'] = name;
      map['email'] = email;
      map['password'] = password;
      map['qrcode'] = qrcode;
      map['cep'] = cep;
      map['endereco'] = endereco;
      map['autenticado'] = autenticado;
      final response = await httpService.post(root, map);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Erro ao adicionar usuário.");
      }
    } catch (e) {
      throw Exception("Erro ao adicionar usuário: $e");
    }
  }

  static Future<String> getAutenticadoId(String id) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = getAutenticado;
      map['id'] = id;
      final response = await httpService.post(root, map);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Erro ao obter valor autenticado.");
      }
    } catch (e) {
      throw Exception("Erro ao obter valor autenticado: $e");
    }
  }

  static Future<String> updateAutenticadoId(
      String id, String autenticado) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = updateAutenticado;
      map['id'] = id;
      map['autenticado'] = autenticado;
      final response = await httpService.post(root, map);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception("Erro ao atualizar autenticado.");
      }
    } catch (e) {
      throw Exception("Erro ao atualizar autenticado: $e");
    }
  }
}
