import 'models.dart';

class EndpointAnalytics {
  final int totalCalls;
  final int successfulCalls;
  final int errorCalls;
  final double averageResponseTime; // in milliseconds
  final Map<String, int> callsByDay; // date: count
  final Map<String, int> callsByHour; // hour: count
  final Map<int, int> responseCodeCounts; // status_code: count
  final DateTime lastCalledAt;
  final List<ApiCallDataPoint> recentDataPoints;

  const EndpointAnalytics({
    this.totalCalls = 0,
    this.successfulCalls = 0,
    this.errorCalls = 0,
    this.averageResponseTime = 0.0,
    this.callsByDay = const {},
    this.callsByHour = const {},
    this.responseCodeCounts = const {},
    required this.lastCalledAt,
    this.recentDataPoints = const [],
  });

  Map<String, dynamic> toJson() => {
    'totalCalls': totalCalls,
    'successfulCalls': successfulCalls,
    'errorCalls': errorCalls,
    'averageResponseTime': averageResponseTime,
    'callsByDay': callsByDay,
    'callsByHour': callsByHour,
    'responseCodeCounts': responseCodeCounts,
    'lastCalledAt': lastCalledAt.toIso8601String(),
    'recentDataPoints': recentDataPoints.map((e) => e.toJson()).toList(),
  };

  factory EndpointAnalytics.fromJson(Map<String, dynamic> json) =>
      EndpointAnalytics(
        totalCalls: json['totalCalls'] ?? 0,
        successfulCalls: json['successfulCalls'] ?? 0,
        errorCalls: json['errorCalls'] ?? 0,
        averageResponseTime: (json['averageResponseTime'] ?? 0.0).toDouble(),
        callsByDay: Map<String, int>.from(json['callsByDay'] ?? {}),
        callsByHour: Map<String, int>.from(json['callsByHour'] ?? {}),
        responseCodeCounts: Map<int, int>.from(
          (json['responseCodeCounts'] ?? {}).map(
            (key, value) => MapEntry(int.parse(key.toString()), value as int),
          ),
        ),
        lastCalledAt: DateTime.parse(
          json['lastCalledAt'] ?? DateTime.now().toIso8601String(),
        ),
        recentDataPoints: (json['recentDataPoints'] as List? ?? [])
            .map((e) => ApiCallDataPoint.fromJson(e))
            .toList(),
      );

  double get successRate =>
      totalCalls > 0 ? (successfulCalls / totalCalls) * 100 : 0.0;

  double get errorRate =>
      totalCalls > 0 ? (errorCalls / totalCalls) * 100 : 0.0;

  EndpointAnalytics copyWith({
    int? totalCalls,
    int? successfulCalls,
    int? errorCalls,
    double? averageResponseTime,
    Map<String, int>? callsByDay,
    Map<String, int>? callsByHour,
    Map<int, int>? responseCodeCounts,
    DateTime? lastCalledAt,
    List<ApiCallDataPoint>? recentDataPoints,
  }) {
    return EndpointAnalytics(
      totalCalls: totalCalls ?? this.totalCalls,
      successfulCalls: successfulCalls ?? this.successfulCalls,
      errorCalls: errorCalls ?? this.errorCalls,
      averageResponseTime: averageResponseTime ?? this.averageResponseTime,
      callsByDay: callsByDay ?? this.callsByDay,
      callsByHour: callsByHour ?? this.callsByHour,
      responseCodeCounts: responseCodeCounts ?? this.responseCodeCounts,
      lastCalledAt: lastCalledAt ?? this.lastCalledAt,
      recentDataPoints: recentDataPoints ?? this.recentDataPoints,
    );
  }
}
