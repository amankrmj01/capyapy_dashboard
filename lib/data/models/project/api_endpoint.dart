import 'package:equatable/equatable.dart';

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
