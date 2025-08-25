// HTTP Methods enum
enum HttpMethod { get, post, put, delete, patch }

// Request Configuration
class RequestConfig {
  final String contentType;
  final Map<String, dynamic> bodySchema;
  final Map<String, String>? headers;

  const RequestConfig({
    required this.contentType,
    required this.bodySchema,
    this.headers,
  });

  Map<String, dynamic> toJson() => {
    'contentType': contentType,
    'bodySchema': bodySchema,
    if (headers != null) 'headers': headers,
  };

  factory RequestConfig.fromJson(Map<String, dynamic> json) => RequestConfig(
    contentType: json['contentType'] ?? 'application/json',
    bodySchema: Map<String, dynamic>.from(json['bodySchema'] ?? {}),
    headers: json['headers']?.cast<String, String>(),
  );
}

// Response Configuration
class ResponseConfig {
  final int statusCode;
  final String contentType;
  final Map<String, dynamic> schema;
  final List<ResponseExample>? examples;

  const ResponseConfig({
    required this.statusCode,
    required this.contentType,
    required this.schema,
    this.examples,
  });

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'contentType': contentType,
    'schema': schema,
    if (examples != null) 'examples': examples!.map((e) => e.toJson()).toList(),
  };

  factory ResponseConfig.fromJson(Map<String, dynamic> json) => ResponseConfig(
    statusCode: json['statusCode'] ?? 200,
    contentType: json['contentType'] ?? 'application/json',
    schema: Map<String, dynamic>.from(json['schema'] ?? {}),
    examples: json['examples'] != null
        ? (json['examples'] as List)
              .map((e) => ResponseExample.fromJson(e))
              .toList()
        : null,
  );
}

// Response Example
class ResponseExample {
  final String name;
  final String description;
  final Map<String, dynamic> data;

  const ResponseExample({
    required this.name,
    required this.description,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'data': data,
  };

  factory ResponseExample.fromJson(Map<String, dynamic> json) =>
      ResponseExample(
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        data: Map<String, dynamic>.from(json['data'] ?? {}),
      );
}
