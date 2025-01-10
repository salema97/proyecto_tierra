import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BatteryLevelIndicator extends StatefulWidget {
  final double batteryLevel;
  const BatteryLevelIndicator({super.key, required this.batteryLevel});

  @override
  State<BatteryLevelIndicator> createState() => _BatteryLevelIndicatorState();
}

class _BatteryLevelIndicatorState extends State<BatteryLevelIndicator> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 60,
              sections: _showingSections(widget.batteryLevel),
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
            ),
          ),
          Text(
            '${widget.batteryLevel.toStringAsFixed(2)}%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getColor(widget.batteryLevel),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(double batteryLevel) {
    final remainingLevel = 100 - batteryLevel;
    final isTouched = touchedIndex == 0;

    final radius = isTouched ? 70.0 : 60.0;

    return [
      PieChartSectionData(
        color: _getColor(batteryLevel),
        value: batteryLevel,
        title: '',
        radius: radius,
      ),
      PieChartSectionData(
        color: Colors.grey[300],
        value: remainingLevel,
        title: '',
        radius: radius,
      )
    ];
  }

  Color _getColor(double level) {
    if (level >= 75) {
      return Colors.green;
    } else if (level >= 50) {
      return Colors.yellow;
    } else if (level >= 25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
