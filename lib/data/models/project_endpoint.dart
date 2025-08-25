import 'models.dart';

class ProjectEndpoint {
  final String id;
  final String path;
  final HttpMethod method;
  final String description;
  final bool authRequired;
  final RequestConfig? request;
  final ResponseConfig response;
  final Map<String, String>? pathParams;
  final Map<String, String>? queryParams;
  final EndpointAnalytics analytics;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectEndpoint({
    required this.id,
    required this.path,
    required this.method,
    required this.description,
    required this.authRequired,
    this.request,
    required this.response,
    this.pathParams,
    this.queryParams,
    required this.analytics,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'method': method.name,
    'description': description,
    'authRequired': authRequired,
    if (request != null) 'request': request!.toJson(),
    'response': response.toJson(),
    if (pathParams != null) 'pathParams': pathParams,
    if (queryParams != null) 'queryParams': queryParams,
    'analytics': analytics.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ProjectEndpoint.fromJson(Map<String, dynamic> json) =>
      ProjectEndpoint(
        id: json['id'] ?? '',
        path: json['path'] ?? '',
        method: HttpMethod.values.firstWhere(
          (e) =>
              e.name.toUpperCase() == (json['method'] ?? 'GET').toUpperCase(),
          orElse: () => HttpMethod.get,
        ),
        description: json['description'] ?? '',
        authRequired: json['authRequired'] ?? false,
        request: json['request'] != null
            ? RequestConfig.fromJson(json['request'])
            : null,
        response: ResponseConfig.fromJson(json['response'] ?? {}),
        pathParams: json['pathParams']?.cast<String, String>(),
        queryParams: json['queryParams']?.cast<String, String>(),
        analytics: EndpointAnalytics.fromJson(json['analytics'] ?? {}),
        createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
      );

  ProjectEndpoint copyWith({
    String? id,
    String? path,
    HttpMethod? method,
    String? description,
    bool? authRequired,
    RequestConfig? request,
    ResponseConfig? response,
    Map<String, String>? pathParams,
    Map<String, String>? queryParams,
    EndpointAnalytics? analytics,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectEndpoint(
      id: id ?? this.id,
      path: path ?? this.path,
      method: method ?? this.method,
      description: description ?? this.description,
      authRequired: authRequired ?? this.authRequired,
      request: request ?? this.request,
      response: response ?? this.response,
      pathParams: pathParams ?? this.pathParams,
      queryParams: queryParams ?? this.queryParams,
      analytics: analytics ?? this.analytics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
