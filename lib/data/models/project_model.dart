class Project {
  final String id;
  final String projectName;
  final String basePath;
  final bool hasAuth;
  final AuthStrategy? authStrategy;
  final List<DataModel> dataModels;
  final List<Endpoint> endpoints;
  final StorageConfig storage;
  final ProjectMetadata metadata;

  const Project({
    required this.id,
    required this.projectName,
    required this.basePath,
    required this.hasAuth,
    this.authStrategy,
    required this.dataModels,
    required this.endpoints,
    required this.storage,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectName': projectName,
    'basePath': basePath,
    'hasAuth': hasAuth,
    'authStrategy': authStrategy?.toJson(),
    'dataModels': dataModels.map((e) => e.toJson()).toList(),
    'endpoints': endpoints.map((e) => e.toJson()).toList(),
    'storage': storage.toJson(),
    'metadata': metadata.toJson(),
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    projectName: json['projectName'],
    basePath: json['basePath'],
    hasAuth: json['hasAuth'],
    authStrategy: json['authStrategy'] != null
        ? AuthStrategy.fromJson(json['authStrategy'])
        : null,
    dataModels: (json['dataModels'] as List)
        .map((e) => DataModel.fromJson(e))
        .toList(),
    endpoints: (json['endpoints'] as List)
        .map((e) => Endpoint.fromJson(e))
        .toList(),
    storage: StorageConfig.fromJson(json['storage']),
    metadata: ProjectMetadata.fromJson(json['metadata']),
  );
}

class DataModel {
  final String modelName;
  final String collectionName;
  final List<ModelField> fields;

  const DataModel({
    required this.modelName,
    required this.collectionName,
    required this.fields,
  });

  Map<String, dynamic> toJson() => {
    'modelName': modelName,
    'collectionName': collectionName,
    'fields': fields.map((e) => e.toJson()).toList(),
  };

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    modelName: json['modelName'],
    collectionName: json['collectionName'],
    fields: (json['fields'] as List)
        .map((e) => ModelField.fromJson(e))
        .toList(),
  );
}

class ModelField {
  final String name;
  final FieldType type;
  final bool required;
  final bool unique;
  final dynamic defaultValue;
  final List<String>? enumValues;
  final List<ModelField>? fields; // For Object type
  final String? itemsType; // For Array type
  final Map<String, dynamic>? items; // For complex Array items

  const ModelField({
    required this.name,
    required this.type,
    this.required = false,
    this.unique = false,
    this.defaultValue,
    this.enumValues,
    this.fields,
    this.itemsType,
    this.items,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.name,
    'required': required,
    'unique': unique,
    if (defaultValue != null) 'default': defaultValue,
    if (enumValues != null) 'enum': enumValues,
    if (fields != null) 'fields': fields!.map((e) => e.toJson()).toList(),
    if (itemsType != null) 'itemsType': itemsType,
    if (items != null) 'items': items,
  };

  factory ModelField.fromJson(Map<String, dynamic> json) => ModelField(
    name: json['name'],
    type: FieldType.values.firstWhere((e) => e.name == json['type']),
    required: json['required'] ?? false,
    unique: json['unique'] ?? false,
    defaultValue: json['default'],
    enumValues: json['enum']?.cast<String>(),
    fields: json['fields'] != null
        ? (json['fields'] as List).map((e) => ModelField.fromJson(e)).toList()
        : null,
    itemsType: json['itemsType'],
    items: json['items'],
  );
}

enum FieldType {
  string('String'),
  number('Number'),
  boolean('Boolean'),
  date('Date'),
  array('Array'),
  object('Object');

  const FieldType(this.displayName);

  final String displayName;
}

class Endpoint {
  final String path;
  final HttpMethod method;
  final String description;
  final bool authRequired;
  final RequestConfig? request;
  final ResponseConfig response;
  final Map<String, String>? pathParams;
  final Map<String, String>? queryParams;

  const Endpoint({
    required this.path,
    required this.method,
    required this.description,
    required this.authRequired,
    this.request,
    required this.response,
    this.pathParams,
    this.queryParams,
  });

  Map<String, dynamic> toJson() => {
    'path': path,
    'method': method.name,
    'description': description,
    'authRequired': authRequired,
    if (request != null) 'request': request!.toJson(),
    'response': response.toJson(),
    if (pathParams != null) 'params': {'path': pathParams},
    if (queryParams != null) 'params': {'query': queryParams},
  };

  factory Endpoint.fromJson(Map<String, dynamic> json) => Endpoint(
    path: json['path'],
    method: HttpMethod.values.firstWhere(
      (e) => e.name.toUpperCase() == json['method'].toUpperCase(),
    ),
    description: json['description'],
    authRequired: json['authRequired'],
    request: json['request'] != null
        ? RequestConfig.fromJson(json['request'])
        : null,
    response: ResponseConfig.fromJson(json['response']),
    pathParams: json['params']?['path']?.cast<String, String>(),
    queryParams: json['params']?['query']?.cast<String, String>(),
  );
}

enum HttpMethod { get, post, put, delete, patch }

class RequestConfig {
  final String contentType;
  final Map<String, dynamic> bodySchema;

  const RequestConfig({required this.contentType, required this.bodySchema});

  Map<String, dynamic> toJson() => {
    'contentType': contentType,
    'bodySchema': bodySchema,
  };

  factory RequestConfig.fromJson(Map<String, dynamic> json) => RequestConfig(
    contentType: json['contentType'],
    bodySchema: json['bodySchema'],
  );
}

class ResponseConfig {
  final int status;
  final String contentType;
  final dynamic body;

  const ResponseConfig({
    required this.status,
    this.contentType = 'application/json',
    required this.body,
  });

  Map<String, dynamic> toJson() => {
    'status': status,
    'contentType': contentType,
    'body': body,
  };

  factory ResponseConfig.fromJson(Map<String, dynamic> json) => ResponseConfig(
    status: json['status'],
    contentType: json['contentType'] ?? 'application/json',
    body: json['body'],
  );
}

class AuthStrategy {
  final String strategy;
  final List<String> scopes;

  const AuthStrategy({required this.strategy, required this.scopes});

  Map<String, dynamic> toJson() => {'strategy': strategy, 'scopes': scopes};

  factory AuthStrategy.fromJson(Map<String, dynamic> json) => AuthStrategy(
    strategy: json['strategy'],
    scopes: json['scopes'].cast<String>(),
  );
}

class StorageConfig {
  final bool enabled;
  final String type;
  final bool persist;

  const StorageConfig({
    required this.enabled,
    required this.type,
    required this.persist,
  });

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'type': type,
    'persist': persist,
  };

  factory StorageConfig.fromJson(Map<String, dynamic> json) => StorageConfig(
    enabled: json['enabled'],
    type: json['type'],
    persist: json['persist'],
  );
}

class ProjectMetadata {
  final String createdBy;
  final DateTime createdAt;
  final List<String> tags;

  const ProjectMetadata({
    required this.createdBy,
    required this.createdAt,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'tags': tags,
  };

  factory ProjectMetadata.fromJson(Map<String, dynamic> json) =>
      ProjectMetadata(
        createdBy: json['createdBy'],
        createdAt: DateTime.parse(json['createdAt']),
        tags: json['tags'].cast<String>(),
      );
}
