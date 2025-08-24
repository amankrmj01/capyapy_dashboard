import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';

enum ChartType { line, pie, table }

class AnalyticsChart extends StatelessWidget {
  final String title;
  final ChartType type;

  const AnalyticsChart({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 20),
            _buildChart(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    switch (type) {
      case ChartType.line:
        return SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun',
                      ];
                      return Text(
                        days[value.toInt() % days.length],
                        style: GoogleFonts.inter(fontSize: 12),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 45),
                    FlSpot(1, 78),
                    FlSpot(2, 95),
                    FlSpot(3, 123),
                    FlSpot(4, 87),
                    FlSpot(5, 156),
                    FlSpot(6, 128),
                  ],
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        );
      case ChartType.pie:
        return SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: 45,
                  title: 'GET\n45%',
                  color: Colors.blue,
                  radius: 60,
                  titleStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: 25,
                  title: 'POST\n25%',
                  color: Colors.green,
                  radius: 60,
                  titleStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: 20,
                  title: 'PUT\n20%',
                  color: Colors.orange,
                  radius: 60,
                  titleStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: 10,
                  title: 'DELETE\n10%',
                  color: Colors.red,
                  radius: 60,
                  titleStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
              centerSpaceRadius: 40,
            ),
          ),
        );
      case ChartType.table:
        return Column(
          children: [
            _buildTableRow(
              context,
              'Endpoint',
              'Calls',
              'Status',
              isHeader: true,
            ),
            const Divider(),
            _buildTableRow(context, '/api/users', '2,543', '✅ Active'),
            _buildTableRow(context, '/api/posts', '1,867', '✅ Active'),
            _buildTableRow(context, '/api/comments', '1,234', '✅ Active'),
            _buildTableRow(context, '/api/auth/login', '987', '✅ Active'),
            _buildTableRow(context, '/api/products', '765', '🟡 Warning'),
          ],
        );
    }
  }

  Widget _buildTableRow(
    BuildContext context,
    String col1,
    String col2,
    String col3, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              col1,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader
                    ? AppColors.textPrimary(context)
                    : AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              col2,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader
                    ? AppColors.textPrimary(context)
                    : AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              col3,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader
                    ? AppColors.textPrimary(context)
                    : AppColors.textSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
