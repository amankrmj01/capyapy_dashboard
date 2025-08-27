import 'package:equatable/equatable.dart';

import 'chart_data.dart';

class AnalyticsData extends Equatable {
  final LineChartData lineChart;
  final PieChartData pieChart;
  final BarChartData barChart;

  const AnalyticsData({
    required this.lineChart,
    required this.pieChart,
    required this.barChart,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      lineChart: LineChartData.fromJson(json['lineChart']),
      pieChart: PieChartData.fromJson(json['pieChart']),
      barChart: BarChartData.fromJson(json['barChart']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lineChart': lineChart.toJson(),
      'pieChart': pieChart.toJson(),
      'barChart': barChart.toJson(),
    };
  }

  AnalyticsData copyWith({
    LineChartData? lineChart,
    PieChartData? pieChart,
    BarChartData? barChart,
  }) {
    return AnalyticsData(
      lineChart: lineChart ?? this.lineChart,
      pieChart: pieChart ?? this.pieChart,
      barChart: barChart ?? this.barChart,
    );
  }

  @override
  List<Object> get props => [lineChart, pieChart, barChart];
}
