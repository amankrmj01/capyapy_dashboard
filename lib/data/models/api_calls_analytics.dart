// Overall API calls analytics for the project
class ApiCallsAnalytics {
  final int totalCalls;
  final int totalSuccessfulCalls;
  final int totalErrorCalls;
  final Map<String, int> callsByEndpoint; // endpoint_id: count
  final Map<String, int> callsByDate; // date: count
  final Map<String, int> callsByMonth; // month: count
  final double averageResponseTime;
  final DateTime lastUpdated;

  const ApiCallsAnalytics({
    this.totalCalls = 0,
    this.totalSuccessfulCalls = 0,
    this.totalErrorCalls = 0,
    this.callsByEndpoint = const {},
    this.callsByDate = const {},
    this.callsByMonth = const {},
    this.averageResponseTime = 0.0,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'totalCalls': totalCalls,
    'totalSuccessfulCalls': totalSuccessfulCalls,
    'totalErrorCalls': totalErrorCalls,
    'callsByEndpoint': callsByEndpoint,
    'callsByDate': callsByDate,
    'callsByMonth': callsByMonth,
    'averageResponseTime': averageResponseTime,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory ApiCallsAnalytics.fromJson(Map<String, dynamic> json) =>
      ApiCallsAnalytics(
        totalCalls: json['totalCalls'] ?? 0,
        totalSuccessfulCalls: json['totalSuccessfulCalls'] ?? 0,
        totalErrorCalls: json['totalErrorCalls'] ?? 0,
        callsByEndpoint: Map<String, int>.from(json['callsByEndpoint'] ?? {}),
        callsByDate: Map<String, int>.from(json['callsByDate'] ?? {}),
        callsByMonth: Map<String, int>.from(json['callsByMonth'] ?? {}),
        averageResponseTime: (json['averageResponseTime'] ?? 0.0).toDouble(),
        lastUpdated: DateTime.parse(
          json['lastUpdated'] ?? DateTime.now().toIso8601String(),
        ),
      );

  double get overallSuccessRate =>
      totalCalls > 0 ? (totalSuccessfulCalls / totalCalls) * 100 : 0.0;

  double get overallErrorRate =>
      totalCalls > 0 ? (totalErrorCalls / totalCalls) * 100 : 0.0;
}
