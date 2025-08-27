import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

abstract class ProjectCreationState extends Equatable {
  const ProjectCreationState();

  @override
  List<Object?> get props => [];
}

class ProjectCreationInitial extends ProjectCreationState {
  final int step;
  final String projectName;
  final String basePath;
  final bool hasAuth;
  final AuthStrategy? authStrategy;
  final List<ProjectDataModel> dataModels;
  final List<ProjectEndpoint> endpoints;
  final bool hasStorage;
  final StorageConfig? storageConfig;

  const ProjectCreationInitial({
    this.step = 0,
    this.projectName = '',
    this.basePath = '/api/v1',
    this.hasAuth = false,
    this.authStrategy,
    this.dataModels = const [],
    this.endpoints = const [],
    this.hasStorage = false,
    this.storageConfig,
  });

  @override
  List<Object?> get props => [
    step,
    projectName,
    basePath,
    hasAuth,
    authStrategy,
    dataModels,
    endpoints,
    hasStorage,
    storageConfig,
  ];

  ProjectCreationInitial copyWith({
    int? step,
    String? projectName,
    String? basePath,
    bool? hasAuth,
    AuthStrategy? authStrategy,
    List<ProjectDataModel>? dataModels,
    List<ProjectEndpoint>? endpoints,
    bool? hasStorage,
    StorageConfig? storageConfig,
  }) {
    return ProjectCreationInitial(
      step: step ?? this.step,
      projectName: projectName ?? this.projectName,
      basePath: basePath ?? this.basePath,
      hasAuth: hasAuth ?? this.hasAuth,
      authStrategy: authStrategy ?? this.authStrategy,
      dataModels: dataModels ?? this.dataModels,
      endpoints: endpoints ?? this.endpoints,
      hasStorage: hasStorage ?? this.hasStorage,
      storageConfig: storageConfig ?? this.storageConfig,
    );
  }

  bool get canProceedToNext {
    switch (step) {
      case 0: // Basic Info
        return projectName.isNotEmpty && basePath.isNotEmpty;
      case 1: // Auth Settings
        return true;
      case 2: // Storage
        if (!hasStorage) return true;
        return storageConfig != null &&
            storageConfig!.connectionString.isNotEmpty &&
            storageConfig!.databaseName.isNotEmpty;
      case 3: // Data Models
        return dataModels.isNotEmpty;
      case 4: // Endpoints
        return endpoints.isNotEmpty;
      default:
        return false;
    }
  }

  // Legacy support for formData access pattern
  Map<String, dynamic> get formData => {
    'name': projectName,
    'basePath': basePath,
    'hasAuth': hasAuth,
    'authStrategy': authStrategy,
    'dataModels': dataModels,
    'endpoints': endpoints,
  };
}

class ProjectCreationLoading extends ProjectCreationState {
  const ProjectCreationLoading();
}

class ProjectCreationSuccess extends ProjectCreationState {
  final ProjectModel project;

  const ProjectCreationSuccess(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectCreationError extends ProjectCreationState {
  final String message;

  const ProjectCreationError(this.message);

  @override
  List<Object> get props => [message];
}
