import 'dart:convert';

import 'package:http/http.dart' as http;

class AccountService {
  static const String baseUrl = "http://10.0.2.2:3000/api";

  Future<Map<String, dynamic>> login(String email, String password, String? device) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/account/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password, "deviceId": device}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Ocurrió un error al iniciar sesión');
      }
    } catch (error) {
      throw Exception('Ocurrió un error al iniciar sesión: $error');
    }
  }

  Future<Map<String, dynamic>> register(String userName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/account/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userName': userName, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Ocurrió un error al registrar el usuario');
      }
    } catch (error) {
      throw Exception('Ocurrió un error al registrar el usuario: $error');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/account/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception('Ocurrió un error al restablecer la contraseña');
      }
    } catch (error) {
      throw Exception('Ocurrió un error al restablecer la contraseña: $error');
    }
  }
}
