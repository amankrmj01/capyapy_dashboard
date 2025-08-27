import 'package:equatable/equatable.dart';

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
