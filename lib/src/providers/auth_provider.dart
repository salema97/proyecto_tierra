import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class UserInfo {
  final String userName;
  final String email;
  final List<String> roles;

  UserInfo({
    required this.userName,
    required this.email,
    required this.roles,
  });
}

class AuthProvider with ChangeNotifier {
  UserInfo? _userInfo;
  bool _isAuthenticated = false;
  String? _token;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool get isAuthenticated => _isAuthenticated;
  UserInfo? get userInfo => _userInfo;

  Future<void> login(String email, String password, String? device) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/account/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password, "deviceId": device}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token as String);
        _userInfo = UserInfo(
          userName: data['userName'],
          email: data['email'],
          roles: List<String>.from(decodedToken['roles']),
        );

        _isAuthenticated = true;

        await _storage.write(key: "auth_token", value: _token);

        notifyListeners();
      } else {
        throw Exception('Ocurrió un error al iniciar sesión');
      }
    } catch (error) {
      throw Exception('Ocurrió un error al iniciar sesión: $error');
    }
  }

  Future<void> register(String usarName, String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/account/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userName': usarName, 'email': email, 'password': password}),
      );

      if (response.statusCode != 201) {
        throw Exception('Ocurrió un error al registrar el usuario');
      }
    } catch (error) {
      throw Exception('Ocurrió un error al registrar el usuario: $error');
    }
  }

  Future<void> resetPassword(String email) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/account/reset-password');
    try {
      final response = await http.post(
        url,
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

  Future<void> logout() async {
    _isAuthenticated = false;
    _userInfo = null;
    _token = null;

    await _storage.delete(key: "auth_token");

    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final token = await _storage.read(key: "auth_token");

    if (token == null) {
      return false;
    }

    _token = token;
    _isAuthenticated = true;

    notifyListeners();

    return true;
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: "auth_token");
  }
}
