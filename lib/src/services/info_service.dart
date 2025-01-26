import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:proyecto_tierra/src/models/info.dart';

class InfoService {
  static final String? baseUrl = dotenv.env['API_BASE_URL'];

  static Future<List<InfoDetail>> obtenerInfoPorExtensometroId(int extensometroId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/info/obtener-info-por-extensometro-id?extensometroId=$extensometroId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['info'] != null) {
        final List<dynamic> infos = data['info'];
        return infos.map((json) => InfoDetail.fromJson(json)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Error al obtener las Infos');
    }
  }

  static Future<Uint8List> generarReporte(
      {required int extensometroId,
      required DateTime fechaInicio,
      required DateTime fechaFin,
      required String email}) async {
    final dateFormat = DateFormat('dd/MM/yyyy');

    final response = await http.post(
      Uri.parse('$baseUrl/info/generar-reporte?extensometroId=$extensometroId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fechaInicio': dateFormat.format(fechaInicio),
        'fechaFin': dateFormat.format(fechaFin),
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error al generar el reporte PDF');
    }
  }
}
