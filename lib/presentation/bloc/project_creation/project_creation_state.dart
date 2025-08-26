import 'package:equatable/equatable.dart';
import '../../../data/models/auth_strategy.dart';
import '../../../data/models/project_endpoint.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/project_data_model.dart';

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

  const ProjectCreationInitial({
    this.step = 0,
    this.projectName = '',
    this.basePath = '/api/v1',
    this.hasAuth = false,
    this.authStrategy,
    this.dataModels = const [],
    this.endpoints = const [],
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
  ];

  ProjectCreationInitial copyWith({
    int? step,
    String? projectName,
    String? basePath,
    bool? hasAuth,
    AuthStrategy? authStrategy,
    List<ProjectDataModel>? dataModels,
    List<ProjectEndpoint>? endpoints,
  }) {
    return ProjectCreationInitial(
      step: step ?? this.step,
      projectName: projectName ?? this.projectName,
      basePath: basePath ?? this.basePath,
      hasAuth: hasAuth ?? this.hasAuth,
      authStrategy: authStrategy ?? this.authStrategy,
      dataModels: dataModels ?? this.dataModels,
      endpoints: endpoints ?? this.endpoints,
    );
  }

  bool get canProceedToNext {
    switch (step) {
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
  final Project project;

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
