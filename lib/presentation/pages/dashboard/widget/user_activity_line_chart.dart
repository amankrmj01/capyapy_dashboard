// Widget for the user activity line chart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserActivityLineChart extends StatelessWidget {
  const UserActivityLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 1),
              FlSpot(1, 3),
              FlSpot(2, 2),
              FlSpot(3, 5),
              FlSpot(4, 3),
              FlSpot(5, 4),
            ],
            isCurved: true,
            color: Colors.orange,
            barWidth: 4,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
