import 'models.dart';

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
