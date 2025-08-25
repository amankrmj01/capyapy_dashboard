import 'package:equatable/equatable.dart';

// Dashboard Overview Models
class DashboardOverview extends Equatable {
  final List<OverviewCard> overviewCards;
  final AnalyticsData analytics;
  final List<RecentActivity> recentActivities;
  final List<ApiEndpoint> topEndpoints;

  const DashboardOverview({
    required this.overviewCards,
    required this.analytics,
    required this.recentActivities,
    required this.topEndpoints,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      overviewCards: (json['overviewCards'] as List)
          .map((e) => OverviewCard.fromJson(e))
          .toList(),
      analytics: AnalyticsData.fromJson(json['analytics']),
      recentActivities: (json['recentActivities'] as List)
          .map((e) => RecentActivity.fromJson(e))
          .toList(),
      topEndpoints: (json['topEndpoints'] as List)
          .map((e) => ApiEndpoint.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overviewCards': overviewCards.map((e) => e.toJson()).toList(),
      'analytics': analytics.toJson(),
      'recentActivities': recentActivities.map((e) => e.toJson()).toList(),
      'topEndpoints': topEndpoints.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [
    overviewCards,
    analytics,
    recentActivities,
    topEndpoints,
  ];
}

class OverviewCard extends Equatable {
  final String id;
  final String title;
  final String value;
  final String subtitle;
  final String icon;
  final String color;
  final double changePercentage;
  final bool isPositiveChange;
  final String period;

  const OverviewCard({
    required this.id,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.changePercentage,
    required this.isPositiveChange,
    required this.period,
  });

  factory OverviewCard.fromJson(Map<String, dynamic> json) {
    return OverviewCard(
      id: json['id'],
      title: json['title'],
      value: json['value'],
      subtitle: json['subtitle'],
      icon: json['icon'],
      color: json['color'],
      changePercentage: json['changePercentage'].toDouble(),
      isPositiveChange: json['isPositiveChange'],
      period: json['period'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'subtitle': subtitle,
      'icon': icon,
      'color': color,
      'changePercentage': changePercentage,
      'isPositiveChange': isPositiveChange,
      'period': period,
    };
  }

  @override
  List<Object> get props => [
    id,
    title,
    value,
    subtitle,
    icon,
    color,
    changePercentage,
    isPositiveChange,
    period,
  ];
}

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

class LineChartData extends Equatable {
  final String title;
  final List<ChartPoint> dataPoints;
  final String xAxisLabel;
  final String yAxisLabel;
  final String color;

  const LineChartData({
    required this.title,
    required this.dataPoints,
    required this.xAxisLabel,
    required this.yAxisLabel,
    required this.color,
  });

  factory LineChartData.fromJson(Map<String, dynamic> json) {
    return LineChartData(
      title: json['title'],
      dataPoints: (json['dataPoints'] as List)
          .map((e) => ChartPoint.fromJson(e))
          .toList(),
      xAxisLabel: json['xAxisLabel'],
      yAxisLabel: json['yAxisLabel'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dataPoints': dataPoints.map((e) => e.toJson()).toList(),
      'xAxisLabel': xAxisLabel,
      'yAxisLabel': yAxisLabel,
      'color': color,
    };
  }

  @override
  List<Object> get props => [title, dataPoints, xAxisLabel, yAxisLabel, color];
}

class PieChartData extends Equatable {
  final String title;
  final List<PieChartSegment> segments;

  const PieChartData({required this.title, required this.segments});

  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      title: json['title'],
      segments: (json['segments'] as List)
          .map((e) => PieChartSegment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'segments': segments.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [title, segments];
}

class PieChartSegment extends Equatable {
  final String label;
  final double value;
  final String color;
  final double percentage;

  const PieChartSegment({
    required this.label,
    required this.value,
    required this.color,
    required this.percentage,
  });

  factory PieChartSegment.fromJson(Map<String, dynamic> json) {
    return PieChartSegment(
      label: json['label'],
      value: json['value'].toDouble(),
      color: json['color'],
      percentage: json['percentage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'color': color,
      'percentage': percentage,
    };
  }

  @override
  List<Object> get props => [label, value, color, percentage];
}

class BarChartData extends Equatable {
  final String title;
  final List<BarChartItem> bars;
  final String xAxisLabel;
  final String yAxisLabel;

  const BarChartData({
    required this.title,
    required this.bars,
    required this.xAxisLabel,
    required this.yAxisLabel,
  });

  factory BarChartData.fromJson(Map<String, dynamic> json) {
    return BarChartData(
      title: json['title'],
      bars: (json['bars'] as List)
          .map((e) => BarChartItem.fromJson(e))
          .toList(),
      xAxisLabel: json['xAxisLabel'],
      yAxisLabel: json['yAxisLabel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'bars': bars.map((e) => e.toJson()).toList(),
      'xAxisLabel': xAxisLabel,
      'yAxisLabel': yAxisLabel,
    };
  }

  @override
  List<Object> get props => [title, bars, xAxisLabel, yAxisLabel];
}

class BarChartItem extends Equatable {
  final String label;
  final double value;
  final String color;

  const BarChartItem({
    required this.label,
    required this.value,
    required this.color,
  });

  factory BarChartItem.fromJson(Map<String, dynamic> json) {
    return BarChartItem(
      label: json['label'],
      value: json['value'].toDouble(),
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value, 'color': color};
  }

  @override
  List<Object> get props => [label, value, color];
}

class ChartPoint extends Equatable {
  final double x;
  final double y;
  final String? label;

  const ChartPoint({required this.x, required this.y, this.label});

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      x: json['x'].toDouble(),
      y: json['y'].toDouble(),
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y, 'label': label};
  }

  @override
  List<Object?> get props => [x, y, label];
}

class RecentActivity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final String type;
  final String icon;
  final String status;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.icon,
    required this.status,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      timestamp: json['timestamp'],
      type: json['type'],
      icon: json['icon'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'type': type,
      'icon': icon,
      'status': status,
    };
  }

  @override
  List<Object> get props => [
    id,
    title,
    description,
    timestamp,
    type,
    icon,
    status,
  ];
}

class ApiEndpoint extends Equatable {
  final String id;
  final String path;
  final String method;
  final int hits;
  final double responseTime;
  final double successRate;
  final String status;

  const ApiEndpoint({
    required this.id,
    required this.path,
    required this.method,
    required this.hits,
    required this.responseTime,
    required this.successRate,
    required this.status,
  });

  factory ApiEndpoint.fromJson(Map<String, dynamic> json) {
    return ApiEndpoint(
      id: json['id'],
      path: json['path'],
      method: json['method'],
      hits: json['hits'],
      responseTime: json['responseTime'].toDouble(),
      successRate: json['successRate'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'method': method,
      'hits': hits,
      'responseTime': responseTime,
      'successRate': successRate,
      'status': status,
    };
  }

  @override
  List<Object> get props => [
    id,
    path,
    method,
    hits,
    responseTime,
    successRate,
    status,
  ];
}
