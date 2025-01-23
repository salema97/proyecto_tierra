import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local_auth/local_auth.dart';
import 'package:proyecto_tierra/src/models/user_info.dart';
import 'package:proyecto_tierra/src/services/account_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AccountService _accountService = AccountService();
  UserInfo? _userInfo;
  bool _isAuthenticated = false;
  String? _token;
  final LocalAuthentication localAuth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _selectedRole;

  bool get isAuthenticated => _isAuthenticated;
  UserInfo? get userInfo => _userInfo;
  String? get selectedRole => _selectedRole;

  set selectedRole(String? role) {
    _selectedRole = role;
    notifyListeners();
  }

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
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

  Future<void> signInWithGoogle(String device) async {
    try {
      final response = await _accountService.signInWithGoogle(device);

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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await _storage.write(key: "auth_token", value: _token);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> isBiometricAvailable() async {
    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      bool isDeviceSupport = await localAuth.isDeviceSupported();

      return canCheckBiometrics && isDeviceSupport;
    } catch (error) {
      return false;
    }
  }

  Future<bool> loginWithBiometric() async {
    try {
      final token = await _storage.read(key: "auth_token");
      if (token == null) {
        return false;
      }

      bool authenticated = await localAuth.authenticate(
        localizedReason: 'Por favor, inicia sesión para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!authenticated) {
        return false;
      }

      _token = token;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(_token as String);
      _userInfo = UserInfo(
        userName: decodedToken['userName'],
        email: decodedToken['email'],
        roles: List<String>.from(decodedToken['roles']),
      );

      _isAuthenticated = true;
      notifyListeners();

      return true;
    } catch (error) {
      return false;
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

    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      return false;
    }

    _token = token;
    _isAuthenticated = true;

    final userDataString = await _storage.read(key: "user_data");
    if (userDataString != null) {
      final userData = json.decode(userDataString);

      _userInfo = UserInfo(
        userName: userData['userName'],
        email: userData['email'],
        roles: List<String>.from(userData['roles']),
      );
    }

    notifyListeners();

    return true;
  }

  Future<bool> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
}
