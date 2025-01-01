import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_tierra/src/models/zona.dart';

class ZonaService {
  static final String? baseUrl = dotenv.env['API_BASE_URL'];

  Future<List<Zona>> obtenerTodasZonas() async {
    final response = await http.get(Uri.parse('$baseUrl/zona/obtener-todas-zonas'));
    if (response.statusCode == 200) {
      final List<dynamic> zonas = json.decode(response.body);
      return zonas.map((json) => Zona.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las zonas');
    }
  }
}
