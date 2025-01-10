import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tierra/src/models/info.dart';
import 'package:proyecto_tierra/src/utils/calculations.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte del extensometro'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
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
          )),
    );
  }
}
