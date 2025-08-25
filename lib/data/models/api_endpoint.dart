class ApiCallDataPoint {
  final DateTime timestamp;
  final int responseCode;
  final double responseTime; // in milliseconds
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  const ApiCallDataPoint({
    required this.timestamp,
    required this.responseCode,
    required this.responseTime,
    this.errorMessage,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'responseCode': responseCode,
    'responseTime': responseTime,
    if (errorMessage != null) 'errorMessage': errorMessage,
    if (metadata != null) 'metadata': metadata,
  };

  factory ApiCallDataPoint.fromJson(Map<String, dynamic> json) =>
      ApiCallDataPoint(
        timestamp: DateTime.parse(
          json['timestamp'] ?? DateTime.now().toIso8601String(),
        ),
        responseCode: json['responseCode'] ?? 0,
        responseTime: (json['responseTime'] ?? 0.0).toDouble(),
        errorMessage: json['errorMessage'],
        metadata: json['metadata'] != null
            ? Map<String, dynamic>.from(json['metadata'])
            : null,
      );

  bool get isSuccessful => responseCode >= 200 && responseCode < 300;
}
