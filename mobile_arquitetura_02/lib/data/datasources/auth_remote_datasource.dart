import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_01/data/models/user_model.dart';

class AuthRemoteDatasource {
  static const _baseUrl = 'https://dummyjson.com';
  final http.Client client;

  AuthRemoteDatasource(this.client);

  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      String message = 'Usuário ou senha inválidos';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['message'] != null) {
          message = body['message'].toString();
        }
      } catch (_) {}
      throw Exception(message);
    }

    return UserModel.fromJson(jsonDecode(response.body));
  }
}
