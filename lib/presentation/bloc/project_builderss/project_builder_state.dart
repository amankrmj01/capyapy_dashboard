import 'package:equatable/equatable.dart';
import '../../../data/models/api_calls_analytics.dart';
import '../../../data/models/auth_strategy.dart';
import '../../../data/models/backward_compatibility.dart';
import '../../../data/models/project_metadata.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/storage_config.dart';

abstract class ProjectBuilderState extends Equatable {
  const ProjectBuilderState();

  @override
  List<Object?> get props => [];
}

class ProjectBuilderInitial extends ProjectBuilderState {
  const ProjectBuilderInitial();
}

class ProjectBuilderInProgress extends ProjectBuilderState {
  final int currentStep;
  final String projectName;
  final String basePath;
  final bool hasAuth;
  final AuthStrategy? authStrategy;
  final List<DataModel> dataModels;
  final List<Endpoint> endpoints;
  final bool isValid;
  final String? error;

  const ProjectBuilderInProgress({
    required this.currentStep,
    required this.projectName,
    required this.basePath,
    required this.hasAuth,
    this.authStrategy,
    required this.dataModels,
    required this.endpoints,
    required this.isValid,
    this.error,
  });

  @override
  List<Object?> get props => [
    currentStep,
    projectName,
    basePath,
    hasAuth,
    authStrategy,
    dataModels,
    endpoints,
    isValid,
    error,
  ];

  ProjectBuilderInProgress copyWith({
    int? currentStep,
    String? projectName,
    String? basePath,
    bool? hasAuth,
    AuthStrategy? authStrategy,
    List<DataModel>? dataModels,
    List<Endpoint>? endpoints,
    bool? isValid,
    String? error,
  }) {
    return ProjectBuilderInProgress(
      currentStep: currentStep ?? this.currentStep,
      projectName: projectName ?? this.projectName,
      basePath: basePath ?? this.basePath,
      hasAuth: hasAuth ?? this.hasAuth,
      authStrategy: authStrategy ?? this.authStrategy,
      dataModels: dataModels ?? this.dataModels,
      endpoints: endpoints ?? this.endpoints,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
    );
  }

  bool get canProceedToNext {
    switch (currentStep) {
      case 0: // Basic Info
        return projectName.isNotEmpty && basePath.isNotEmpty;
      case 1: // Auth Settings
        return true;
      case 2: // Data Models
        return dataModels.isNotEmpty;
      case 3: // Endpoints
        return endpoints.isNotEmpty;
      default:
        return false;
    }
  }

  Project toProject() {
    final now = DateTime.now();
    return Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      projectName: projectName,
      description: '',
      apiBasePath: basePath,
      isActive: true,
      hasAuth: hasAuth,
      authStrategy: authStrategy,
      mongoDbDataModels: dataModels,
      endpoints: endpoints,
      storage: StorageConfig(
        type: StorageType.mongodb,
        connectionString: 'mongodb://localhost:27017',
        databaseName: 'database',
        options: const {'useUnifiedTopology': true},
      ),
      metadata: ProjectMetadata(
        version: '1.0.0',
        author: 'Current User',
        tags: const ['mock', 'api', 'development'],
      ),
      apiCallsAnalytics: ApiCallsAnalytics(lastUpdated: now),
      createdAt: now,
      updatedAt: now,
    );
  }
}

class ProjectBuilderCreating extends ProjectBuilderState {
  const ProjectBuilderCreating();
}

class ProjectBuilderSuccess extends ProjectBuilderState {
  final Project project;

  const ProjectBuilderSuccess(this.project);

  @override
  List<Object> get props => [project];
}

class ProjectBuilderError extends ProjectBuilderState {
  final String message;

  const ProjectBuilderError(this.message);

  @override
  List<Object> get props => [message];
}
