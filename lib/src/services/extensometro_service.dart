import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_tierra/src/models/extensometro.dart';

class ExtensometroService {
  static final String? baseUrl = dotenv.env['API_BASE_URL'];

  Future<List<Extensometro>> obtenerExtensometrosPorZonaId(int zonaId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/extensometro/obtener-extensometros-por-id-zona?zonaId=$zonaId'));
    if (response.statusCode == 200) {
      final List<dynamic> extensometros = json.decode(response.body);
      return extensometros.map((json) => Extensometro.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los extensometros por el ID de la zona');
    }
  }

  Future<List<Extensometro>> obtenerTodosExtensometros() async {
    final response = await http.get(Uri.parse('$baseUrl/extensometro/obtener-todos-extensometros'));
    if (response.statusCode == 200) {
      final List<dynamic> extensometros = json.decode(response.body);
      return extensometros.map((json) => Extensometro.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los extensometros por el ID de la zona');
    }
  }
}
