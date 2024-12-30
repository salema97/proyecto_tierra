import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:proyecto_tierra/src/models/user_info.dart';
import 'package:proyecto_tierra/src/services/account_service.dart';

class AuthProvider with ChangeNotifier {
  final AccountService _accountService = AccountService();
  UserInfo? _userInfo;
  bool _isAuthenticated = false;
  String? _token;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool get isAuthenticated => _isAuthenticated;
  UserInfo? get userInfo => _userInfo;

  Future<void> login(String email, String password, String? device) async {
    try {
      final response = await _accountService.login(email, password, device);

      if (response.containsKey('error')) {
        throw Exception(response['error']);
      }

      _token = response['token'];
      Map<String, dynamic> decodedToken = JwtDecoder.decode(_token as String);
      _userInfo = UserInfo(
        userName: response['userName'],
        email: response['email'],
        roles: List<String>.from(decodedToken['roles']),
      );

      _isAuthenticated = true;

      await _storage.write(key: "auth_token", value: _token);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> register(String usarName, String email, String password) async {
    try {
      final response = await _accountService.register(usarName, email, password);

      if (response.containsKey('error')) {
        throw Exception(response['error']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await _accountService.resetPassword(email);

      if (response.containsKey('error')) {
        throw Exception(response['error']);
      }
    } catch (error) {
      rethrow;
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
