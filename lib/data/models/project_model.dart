class Project {
  final String id;
  final String projectName;
  final String description;
  final String apiBasePath;
  final bool isActive;
  final bool hasAuth;
  final AuthStrategy? authStrategy;
  final List<ProjectDataModel> mongoDbDataModels;
  final List<ProjectEndpoint> endpoints;
  final StorageConfig storage;
  final ProjectMetadata metadata;
  final ApiCallsAnalytics apiCallsAnalytics;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.projectName,
    required this.description,
    required this.apiBasePath,
    required this.isActive,
    required this.hasAuth,
    this.authStrategy,
    required this.mongoDbDataModels,
    required this.endpoints,
    required this.storage,
    required this.metadata,
    required this.apiCallsAnalytics,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectName': projectName,
    'description': description,
    'apiBasePath': apiBasePath,
    'isActive': isActive,
    'hasAuth': hasAuth,
    'authStrategy': authStrategy?.toJson(),
    'mongoDbDataModels': mongoDbDataModels.map((e) => e.toJson()).toList(),
    'endpoints': endpoints.map((e) => e.toJson()).toList(),
    'storage': storage.toJson(),
    'metadata': metadata.toJson(),
    'apiCallsAnalytics': apiCallsAnalytics.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    projectName: json['projectName'],
    description: json['description'] ?? '',
    apiBasePath: json['apiBasePath'] ?? json['basePath'] ?? '',
    isActive: json['isActive'] ?? true,
    hasAuth: json['hasAuth'] ?? false,
    authStrategy: json['authStrategy'] != null
        ? AuthStrategy.fromJson(json['authStrategy'])
        : null,
    mongoDbDataModels:
        (json['mongoDbDataModels'] as List? ??
                json['dataModels'] as List? ??
                [])
            .map((e) => ProjectDataModel.fromJson(e))
            .toList(),
    endpoints: (json['endpoints'] as List? ?? [])
        .map((e) => ProjectEndpoint.fromJson(e))
        .toList(),
    storage: StorageConfig.fromJson(json['storage'] ?? {}),
    metadata: ProjectMetadata.fromJson(json['metadata'] ?? {}),
    apiCallsAnalytics: ApiCallsAnalytics.fromJson(
      json['apiCallsAnalytics'] ?? {},
    ),
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json['updatedAt'] ?? DateTime.now().toIso8601String(),
    ),
  );

  // Helper methods
  int get totalApiCalls => apiCallsAnalytics.totalCalls;

  int get totalEndpoints => endpoints.length;

  int get totalDataModels => mongoDbDataModels.length;

  Project copyWith({
    String? id,
    String? projectName,
    String? description,
    String? apiBasePath,
    bool? isActive,
    bool? hasAuth,
    AuthStrategy? authStrategy,
    List<ProjectDataModel>? mongoDbDataModels,
    List<ProjectEndpoint>? endpoints,
    StorageConfig? storage,
    ProjectMetadata? metadata,
    ApiCallsAnalytics? apiCallsAnalytics,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      apiBasePath: apiBasePath ?? this.apiBasePath,
      isActive: isActive ?? this.isActive,
      hasAuth: hasAuth ?? this.hasAuth,
      authStrategy: authStrategy ?? this.authStrategy,
      mongoDbDataModels: mongoDbDataModels ?? this.mongoDbDataModels,
      endpoints: endpoints ?? this.endpoints,
      storage: storage ?? this.storage,
      metadata: metadata ?? this.metadata,
      apiCallsAnalytics: apiCallsAnalytics ?? this.apiCallsAnalytics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Enhanced Data Model for MongoDB
class ProjectDataModel {
  final String id;
  final String modelName;
  final String collectionName;
  final String description;
  final List<MongoDbField> fields;
  final List<MongoDbIndex> indexes;
  final Map<String, dynamic> mongoDbOptions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectDataModel({
    required this.id,
    required this.modelName,
    required this.collectionName,
    required this.description,
    required this.fields,
    this.indexes = const [],
    this.mongoDbOptions = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'modelName': modelName,
    'collectionName': collectionName,
    'description': description,
    'fields': fields.map((e) => e.toJson()).toList(),
    'indexes': indexes.map((e) => e.toJson()).toList(),
    'mongoDbOptions': mongoDbOptions,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ProjectDataModel.fromJson(Map<String, dynamic> json) =>
      ProjectDataModel(
        id: json['id'] ?? '',
        modelName: json['modelName'] ?? '',
        collectionName: json['collectionName'] ?? '',
        description: json['description'] ?? '',
        fields: (json['fields'] as List? ?? [])
            .map((e) => MongoDbField.fromJson(e))
            .toList(),
        indexes: (json['indexes'] as List? ?? [])
            .map((e) => MongoDbIndex.fromJson(e))
            .toList(),
        mongoDbOptions: Map<String, dynamic>.from(json['mongoDbOptions'] ?? {}),
        createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
      );
}

// MongoDB-specific field model
class MongoDbField {
  final String name;
  final MongoDbFieldType type;
  final bool required;
  final bool unique;
  final dynamic defaultValue;
  final List<String>? enumValues;
  final List<MongoDbField>? nestedFields; // For embedded documents
  final String? ref; // For references
  final Map<String, dynamic>? validationRules;

  const MongoDbField({
    required this.name,
    required this.type,
    this.required = false,
    this.unique = false,
    this.defaultValue,
    this.enumValues,
    this.nestedFields,
    this.ref,
    this.validationRules,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.name,
    'required': required,
    'unique': unique,
    if (defaultValue != null) 'default': defaultValue,
    if (enumValues != null) 'enum': enumValues,
    if (nestedFields != null)
      'nestedFields': nestedFields!.map((e) => e.toJson()).toList(),
    if (ref != null) 'ref': ref,
    if (validationRules != null) 'validationRules': validationRules,
  };

  factory MongoDbField.fromJson(Map<String, dynamic> json) => MongoDbField(
    name: json['name'] ?? '',
    type: MongoDbFieldType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => MongoDbFieldType.string,
    ),
    required: json['required'] ?? false,
    unique: json['unique'] ?? false,
    defaultValue: json['default'],
    enumValues: json['enum']?.cast<String>(),
    nestedFields: json['nestedFields'] != null
        ? (json['nestedFields'] as List)
              .map((e) => MongoDbField.fromJson(e))
              .toList()
        : null,
    ref: json['ref'],
    validationRules: json['validationRules'] != null
        ? Map<String, dynamic>.from(json['validationRules'])
        : null,
  );
}

enum MongoDbFieldType {
  string,
  number,
  boolean,
  date,
  objectId,
  array,
  object,
  buffer,
  decimal,
  mixed,
  map;

  String get displayName {
    switch (this) {
      case MongoDbFieldType.string:
        return 'String';
      case MongoDbFieldType.number:
        return 'Number';
      case MongoDbFieldType.boolean:
        return 'Boolean';
      case MongoDbFieldType.date:
        return 'Date';
      case MongoDbFieldType.objectId:
        return 'ObjectId';
      case MongoDbFieldType.array:
        return 'Array';
      case MongoDbFieldType.object:
        return 'Object';
      case MongoDbFieldType.buffer:
        return 'Buffer';
      case MongoDbFieldType.decimal:
        return 'Decimal';
      case MongoDbFieldType.mixed:
        return 'Mixed';
      case MongoDbFieldType.map:
        return 'Map';
    }
  }
}

// MongoDB Index model
class MongoDbIndex {
  final String name;
  final Map<String, int> fields; // field: 1 for ascending, -1 for descending
  final bool unique;
  final bool sparse;
  final Map<String, dynamic>? options;

  const MongoDbIndex({
    required this.name,
    required this.fields,
    this.unique = false,
    this.sparse = false,
    this.options,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'fields': fields,
    'unique': unique,
    'sparse': sparse,
    if (options != null) 'options': options,
  };

  factory MongoDbIndex.fromJson(Map<String, dynamic> json) => MongoDbIndex(
    name: json['name'] ?? '',
    fields: Map<String, int>.from(json['fields'] ?? {}),
    unique: json['unique'] ?? false,
    sparse: json['sparse'] ?? false,
    options: json['options'] != null
        ? Map<String, dynamic>.from(json['options'])
        : null,
  );
}

// Enhanced Endpoint model with detailed analytics
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
}

// Endpoint analytics model
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
}

// API Call Data Point for detailed tracking
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

// Authentication Strategy
class AuthStrategy {
  final AuthType type;
  final Map<String, dynamic> config;
  final List<String> requiredFields;

  const AuthStrategy({
    required this.type,
    required this.config,
    this.requiredFields = const [],
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'config': config,
    'requiredFields': requiredFields,
  };

  factory AuthStrategy.fromJson(Map<String, dynamic> json) => AuthStrategy(
    type: AuthType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AuthType.bearer,
    ),
    config: Map<String, dynamic>.from(json['config'] ?? {}),
    requiredFields: (json['requiredFields'] as List? ?? []).cast<String>(),
  );
}

enum AuthType { bearer, apiKey, basic, oauth2, custom }

// Storage Configuration
class StorageConfig {
  final StorageType type;
  final String connectionString;
  final String databaseName;
  final Map<String, dynamic> options;

  const StorageConfig({
    required this.type,
    required this.connectionString,
    required this.databaseName,
    this.options = const {},
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'connectionString': connectionString,
    'databaseName': databaseName,
    'options': options,
  };

  factory StorageConfig.fromJson(Map<String, dynamic> json) => StorageConfig(
    type: StorageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => StorageType.mongodb,
    ),
    connectionString: json['connectionString'] ?? '',
    databaseName: json['databaseName'] ?? '',
    options: Map<String, dynamic>.from(json['options'] ?? {}),
  );
}

enum StorageType { mongodb, postgresql, mysql, sqlite }

// Project Metadata
class ProjectMetadata {
  final String version;
  final String author;
  final List<String> tags;
  final String? documentation;
  final Map<String, dynamic> customFields;

  const ProjectMetadata({
    required this.version,
    required this.author,
    this.tags = const [],
    this.documentation,
    this.customFields = const {},
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'author': author,
    'tags': tags,
    if (documentation != null) 'documentation': documentation,
    'customFields': customFields,
  };

  factory ProjectMetadata.fromJson(Map<String, dynamic> json) =>
      ProjectMetadata(
        version: json['version'] ?? '1.0.0',
        author: json['author'] ?? '',
        tags: (json['tags'] as List? ?? []).cast<String>(),
        documentation: json['documentation'],
        customFields: Map<String, dynamic>.from(json['customFields'] ?? {}),
      );
}

// Backward compatibility aliases for existing codebase
typedef DataModel = ProjectDataModel;
typedef ModelField = MongoDbField;
typedef FieldType = MongoDbFieldType;
typedef Endpoint = ProjectEndpoint;

// Additional backward compatibility for Project constructor
extension ProjectBackwardCompatibility on Project {
  // Getter for backward compatibility
  String get basePath => apiBasePath;

  List<ProjectDataModel> get dataModels => mongoDbDataModels;

  // Static factory method for backward compatibility
  static Project createLegacy({
    required String id,
    required String projectName,
    required String basePath,
    required bool hasAuth,
    AuthStrategy? authStrategy,
    required List<DataModel> dataModels,
    required List<Endpoint> endpoints,
    required StorageConfig storage,
    required ProjectMetadata metadata,
  }) {
    final now = DateTime.now();
    return Project(
      id: id,
      projectName: projectName,
      description: '',
      apiBasePath: basePath,
      isActive: true,
      hasAuth: hasAuth,
      authStrategy: authStrategy,
      mongoDbDataModels: dataModels,
      endpoints: endpoints,
      storage: storage,
      metadata: metadata,
      apiCallsAnalytics: ApiCallsAnalytics(lastUpdated: now),
      createdAt: now,
      updatedAt: now,
    );
  }
}

// Backward compatibility for StorageConfig
extension StorageConfigBackwardCompatibility on StorageConfig {
  bool get enabled => true;

  bool get persist => true;
}

// Backward compatibility for AuthStrategy
extension AuthStrategyBackwardCompatibility on AuthStrategy {
  String get strategy => type.name;

  List<String> get scopes => requiredFields;
}

// Backward compatibility for ProjectMetadata
extension ProjectMetadataBackwardCompatibility on ProjectMetadata {
  String get createdBy => author;

  DateTime get createdAt => DateTime.now();
}

// Backward compatibility for ResponseConfig
extension ResponseConfigBackwardCompatibility on ResponseConfig {
  String get status => statusCode.toString();

  Map<String, dynamic> get body => schema;
}
