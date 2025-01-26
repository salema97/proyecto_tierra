import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tierra/src/models/info.dart';
import 'package:proyecto_tierra/src/providers/auth_provider.dart';
import 'package:proyecto_tierra/src/screens/pdf_viewer_screen.dart';
import 'package:proyecto_tierra/src/services/info_service.dart';
import 'package:proyecto_tierra/src/utils/calculations.dart';

import 'package:path_provider/path_provider.dart';

class ExtensometroReport extends StatelessWidget {
  final List<InfoDetail> infoDetails;
  final DateTime startDate;
  final DateTime endDate;
  const ExtensometroReport(
      {super.key, required this.infoDetails, required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    final filteredInfoDetails = infoDetails
        .where((info) =>
            info.createdAt.isAfter(startDate) &&
            info.createdAt.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    if (filteredInfoDetails.length < 2) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Reporte del extensometro'),
        ),
        body: const Center(
          child: Text('No hay suficientes datos para generar un reporte.'),
        ),
      );
    }

    final previousInfo = filteredInfoDetails.first;
    final currentInfo = filteredInfoDetails.last;
    final intervalDays = currentInfo.createdAt.difference(previousInfo.createdAt).inDays;
    final displacement = double.parse(previousInfo.desplazamientoLineal) -
        double.parse(currentInfo.desplazamientoLineal);
    final velocity = displacement / intervalDays;
    final velocityDescription = getVelocityDescription(velocity);
    final velocityLimit = getVelocityLimit(velocity);
    final soilMoistureDescription = getSoilMoistureDescription(currentInfo.humedadRelativa);
    final weatherDescription =
        getWeatherDescription(currentInfo.esDia, currentInfo.temperaturaMAX6675);

    final email = Provider.of<AuthProvider>(context, listen: false).userInfo?.email;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Reporte del extensometro'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Fecha Anterior'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(previousInfo.createdAt)),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Fecha Actual'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(currentInfo.createdAt)),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Intervalo de Días'),
                      subtitle: Text(intervalDays.toString()),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Lectura Extensómetro'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Anterior: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(previousInfo.desplazamientoLineal),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Actual: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(currentInfo.desplazamientoLineal),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Desplazamiento: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            displacement.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Humedad del Suelo'),
                      subtitle: Text(soilMoistureDescription),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Clima'),
                      subtitle: Text(weatherDescription),
                    ),
                    const Divider(height: 0),
                    const ListTile(
                      title: Text('Tipo de Material'),
                      subtitle: Text('Matriz Compuesta'),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Velocidad (mm/día)'),
                      subtitle: Text(velocity.toStringAsFixed(2)),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Descripción de Velocidad'),
                      subtitle: Text(velocityDescription),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Límite de Velocidad'),
                      subtitle: Text(velocityLimit),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  foregroundColor: Colors.white,
                  overlayColor: Colors.grey,
                ),
                onPressed: () async {
                  try {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    final pdfBytes = await InfoService.generarReporte(
                      extensometroId: infoDetails.first.extensometroId,
                      fechaInicio: startDate,
                      fechaFin: endDate,
                      email: email.toString(),
                    );

                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/reporte.pdf');
                    await file.writeAsBytes(pdfBytes);

                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PDFViewerScreen(path: file.path),
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text('Error al generar el reporte: ${e.toString()}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Text('Generar reporte', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ));
  }
}
