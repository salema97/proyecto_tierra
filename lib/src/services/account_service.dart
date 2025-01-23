import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AccountService {
  static final String? baseUrl = dotenv.env['API_BASE_URL'];

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
        return {'error': json.decode(response.body)['message']};
      }
    } catch (error) {
      return {'error': error.toString()};
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
        return {'error': json.decode(response.body)['message']};
      }
    } catch (error) {
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/account/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return {'message': 'Correo enviado para restablecer la contraseña'};
      } else {
        return {'error': json.decode(response.body)['message']};
      }
    } catch (error) {
      return {'error': error.toString()};
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle(String? device) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return {'error': 'Inicio de sesión cancelado'};
      }

      final profile = {
        '_json': {'email': googleUser.email, 'name': googleUser.displayName}
      };

      final response = await http.post(
        Uri.parse('$baseUrl/account/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'profile': profile, 'deviceId': device}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorData = json.decode(response.body);
        return {'error': errorData['message'] ?? 'Error en el inicio de sesión'};
      }

      return json.decode(response.body);
    } catch (error) {
      log(error.toString());
      return {'error': 'Error en el inicio de sesión con Google'};
    }
  }
}
