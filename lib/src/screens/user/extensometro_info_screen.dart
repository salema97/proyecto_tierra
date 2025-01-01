import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proyecto_tierra/src/models/info.dart';

class ExtensometroInfoScreen extends StatelessWidget {
  final List<InfoDetail> infoDetails;

  const ExtensometroInfoScreen({super.key, required this.infoDetails});

  @override
  Widget build(BuildContext context) {
    final List<InfoDetail> sortedDetails = List.from(infoDetails)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del extensometro', style: TextStyle(fontSize: 20.sp)),
      ),
      body: Padding(padding: EdgeInsets.all(16.w), child: _buildInfoDetails(sortedDetails)),
    );
  }

  Widget _buildInfoDetails(List<InfoDetail> sortedDetails) {
    return SingleChildScrollView(
        child: ExpansionPanelList.radio(
      initialOpenPanelValue: -1,
      children: sortedDetails.map<ExpansionPanelRadio>((info) {
        return ExpansionPanelRadio(
            highlightColor: Colors.blue[100],
            backgroundColor: Colors.white,
            value: info.id,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Text('ID: ${info.id}'),
              );
            },
            body: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildDetailRow('Extensometro ID', info.extensometroId.toString()),
                  _buildDetailRow('Temperatura MAX6675', info.temperaturaMAX6675),
                  _buildDetailRow('Temperatura LM35', info.temperaturaLM35),
                  _buildDetailRow('Humedad Relativa', info.humedadRelativa),
                  _buildDetailRow('Es de día', info.esDia ? 'Sí' : 'No'),
                  _buildDetailRow('Corriente CS712', info.corrienteCS712),
                  _buildDetailRow('Nivel de batería', info.nivelBateria),
                  _buildDetailRow('Desplazamiento lineal', info.desplazamientoLineal),
                  _buildDetailRow('Creado en', _formatDate(info.createdAt)),
                  _buildDetailRow('Actualizado en', _formatDate(info.updatedAt)),
                ],
              ),
            ));
      }).toList(),
    ));
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          Text(value, style: TextStyle(fontSize: 16.sp)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} ${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(date.second)}';
  }
}
