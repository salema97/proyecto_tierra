import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:proyecto_tierra/src/models/info.dart';

class ExtensometroChart extends StatefulWidget {
  final List<InfoDetail> infoDetails;

  const ExtensometroChart({super.key, required this.infoDetails});

  @override
  State<ExtensometroChart> createState() => _ExtensometroChartState();
}

class _ExtensometroChartState extends State<ExtensometroChart> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int minId = 0;
  int maxId = 20;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
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
            padding: EdgeInsets.all(10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('ID Min: ',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 2.w),
                    Text('$minId', style: TextStyle(fontSize: 16.sp, color: Colors.blue)),
                  ],
                ),
                Row(
                  children: [
                    Text('ID Max: ',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(width: 2.w),
                    Text('$maxId', style: TextStyle(fontSize: 16.sp, color: Colors.blue)),
                  ],
                ),
              ],
            ),
          ),
          _buildSlider(),
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
                  _buildChart('Nivel de Batería (%)', Colors.pink,
                      (info) => _parseDouble(info.nivelBateria)),
                  _buildChart('Desplazamiento Lineal (mm)', Colors.teal,
                      (info) => _parseDouble(info.desplazamientoLineal)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          RangeSlider(
            activeColor: Colors.blue,
            overlayColor: MaterialStateProperty.all(Colors.blue[200]),
            inactiveColor: Colors.black12,
            values: RangeValues(minId.toDouble(), maxId.toDouble()),
            onChanged: (RangeValues values) {
              setState(() {
                minId = values.start.toInt();
                maxId = values.end.toInt();
              });
            },
            min: 0,
            max: widget.infoDetails.length.toDouble(),
            divisions: widget.infoDetails.length,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(String title, Color color, double Function(InfoDetail) valueMapper) {
    final filterInfoDetails =
        widget.infoDetails.where((info) => info.id >= minId && info.id <= maxId).toList();

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
                    return FlSpot(info.id.toDouble(), valueMapper(info));
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
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40.h),
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

  double _parseDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }
}
