import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tierra/src/models/info.dart';
import 'package:proyecto_tierra/src/screens/extensometro_report.dart';
import 'package:proyecto_tierra/src/widgets/battery_level_indicator.dart';

class ExtensometroChart extends StatefulWidget {
  final List<InfoDetail> infoDetails;

  const ExtensometroChart({super.key, required this.infoDetails});

  @override
  State<ExtensometroChart> createState() => _ExtensometroChartState();
}

class _ExtensometroChartState extends State<ExtensometroChart> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? startDate;
  DateTime? endDate;
  late DateTime firstDate;
  late DateTime lastDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    if (widget.infoDetails.isNotEmpty) {
      firstDate = widget.infoDetails.first.createdAt;
      lastDate = widget.infoDetails.last.createdAt;
    } else {
      firstDate = DateTime.now();
      lastDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del extensometro', style: TextStyle(fontSize: 20.sp)),
        bottom: TabBar(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          overlayColor: MaterialStateProperty.all(Colors.blue),
          indicatorColor: Colors.blue,
          dividerColor: Colors.blue,
          controller: _tabController,
          tabs: const [
            Tab(text: 'MAX6675'),
            Tab(text: 'LM35'),
            Tab(text: 'Humedad'),
            Tab(text: 'Dia'),
            Tab(text: 'Corriente'),
            Tab(text: 'Batería'),
            Tab(text: 'Desplazamiento')
          ].toList(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _buildDatePicker(
                      'Fecha Inicio',
                      startDate,
                      (date) {
                        setState(
                          () {
                            startDate = date;
                          },
                        );
                      },
                    ),
                    _buildDatePicker(
                      'Fecha Fin',
                      endDate,
                      (date) {
                        setState(
                          () {
                            endDate = date;
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChart('Temperatura MAX6675 (°C)', Colors.red,
                      (info) => _parseDouble(info.temperaturaMAX6675)),
                  _buildChart('Temperatura LM35 (°C)', Colors.blue,
                      (info) => _parseDouble(info.temperaturaLM35)),
                  _buildChart('Humedad Relativa (%)', Colors.green,
                      (info) => _parseDouble(info.humedadRelativa)),
                  _buildChart('Es de día', Colors.purple, (info) => info.esDia ? 1 : 0),
                  _buildChart('Corriente CS712 (mp)', Colors.orange,
                      (info) => _parseDouble(info.corrienteCS712)),
                  _buildLevelIndicator('Nivel de Batería (%)', Colors.pink,
                      (info) => _parseDouble(info.nivelBateria)),
                  _buildChart('Desplazamiento Lineal (mm)', Colors.teal,
                      (info) => _parseDouble(info.desplazamientoLineal)),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                foregroundColor: Colors.white,
                overlayColor: Colors.grey,
              ),
              onPressed: () {
                if (startDate != null && endDate != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ExtensometroReport(
                      infoDetails: widget.infoDetails,
                      startDate: startDate!,
                      endDate: endDate!,
                    );
                  }));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            primary: Colors.blue,
                          ),
                        ),
                        child: AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Por favor seleccione una fecha de inicio y fin, para generar un reporte.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              child: Text('Generar reporte', style: TextStyle(fontSize: 16.sp)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String title, DateTime? date, ValueChanged<DateTime?> onDateChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 16.sp)),
          SizedBox(height: 2.h),
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
              DateTime initialDate = date ?? DateTime.now();
              if (initialDate.isAfter(lastDate)) {
                initialDate = lastDate;
              }
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: firstDate,
                lastDate: lastDate,
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.blue,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              onDateChanged(selectedDate);
            },
            child: Text(date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Seleccionar fecha'),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(String title, Color color, double Function(InfoDetail) valueMapper) {
    final filterInfoDetails = widget.infoDetails.where((info) {
      if (startDate != null && info.createdAt.isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && info.createdAt.isAfter(endDate!.add(const Duration(days: 1)))) {
        return false;
      }
      return true;
    }).toList();

    final maxYValue = filterInfoDetails.isNotEmpty
        ? filterInfoDetails
            .map((info) => valueMapper(info))
            .reduce((value, element) => value > element ? value : element)
        : null;

    final minYValue = filterInfoDetails.isNotEmpty
        ? filterInfoDetails
            .map((info) => valueMapper(info))
            .reduce((value, element) => value < element ? value : element)
        : null;

    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),
        Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: filterInfoDetails.map((info) {
                    return FlSpot(
                        info.createdAt.millisecondsSinceEpoch.toDouble(), valueMapper(info));
                  }).toList(),
                  isCurved: true,
                  color: color,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40.w),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20.h,
                    getTitlesWidget: (value, meta) {
                      final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                      return Text(
                        DateFormat('dd/MM').format(date),
                      );
                    },
                  ),
                  axisNameWidget: const Text(
                    'Fecha',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  axisNameSize: 20.h,
                ),
              ),
              borderData: FlBorderData(show: true),
              gridData: const FlGridData(show: true),
              minY: minYValue != null ? minYValue - 10 : 0,
              maxY: maxYValue != null ? maxYValue + 10 : 100,
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.linear,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelIndicator(String title, color, double Function(InfoDetail) valueMapper) {
    final filterInfoDetails = widget.infoDetails.where((info) {
      if (startDate != null && info.createdAt.isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && info.createdAt.isAfter(endDate!.add(const Duration(days: 1)))) {
        return false;
      }
      return true;
    }).toList();

    final batteryLevel = filterInfoDetails.isNotEmpty ? valueMapper(filterInfoDetails.last) : 0.0;

    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),
        Expanded(child: BatteryLevelIndicator(batteryLevel: batteryLevel)),
      ],
    );
  }

  double _parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }
}
