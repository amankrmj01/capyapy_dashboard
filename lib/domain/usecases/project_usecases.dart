import '../../data/models/models.dart';
import '../repositories/project_repository.dart';

// Project CRUD Use Cases
class GetAllProjectsUseCase {
  final ProjectRepository repository;

  GetAllProjectsUseCase({required this.repository});

  Future<List<Project>> call() async {
    return await repository.getAllProjects();
  }
}

class GetProjectByIdUseCase {
  final ProjectRepository repository;

  GetProjectByIdUseCase({required this.repository});

  Future<Project?> call(String id) async {
    return await repository.getProjectById(id);
  }
}

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase({required this.repository});

  Future<Project> call(Project project) async {
    return await repository.createProject(project);
  }
}

class UpdateProjectUseCase {
  final ProjectRepository repository;

  UpdateProjectUseCase({required this.repository});

  Future<Project> call(Project project) async {
    return await repository.updateProject(project);
  }
}

class DeleteProjectUseCase {
  final ProjectRepository repository;

  DeleteProjectUseCase({required this.repository});

  Future<void> call(String id) async {
    await repository.deleteProject(id);
  }
}

// Project Filtering and Search Use Cases
class GetProjectsByUserIdUseCase {
  final ProjectRepository repository;

  GetProjectsByUserIdUseCase({required this.repository});

  Future<List<Project>> call(String userId) async {
    return await repository.getProjectsByUserId(userId);
  }
}

class SearchProjectsUseCase {
  final ProjectRepository repository;

  SearchProjectsUseCase({required this.repository});

  Future<List<Project>> call(String query) async {
    return await repository.searchProjects(query);
  }
}

class GetActiveProjectsUseCase {
  final ProjectRepository repository;

  GetActiveProjectsUseCase({required this.repository});

  Future<List<Project>> call() async {
    return await repository.getActiveProjects();
  }
}

class GetProjectsByStatusUseCase {
  final ProjectRepository repository;

  GetProjectsByStatusUseCase({required this.repository});

  Future<List<Project>> call(bool isActive) async {
    return await repository.getProjectsByStatus(isActive);
  }
}

// Data Model Management Use Cases
class AddDataModelUseCase {
  final ProjectRepository repository;

  AddDataModelUseCase({required this.repository});

  Future<Project> call(String projectId, ProjectDataModel dataModel) async {
    return await repository.addDataModel(projectId, dataModel);
  }
}

class UpdateDataModelUseCase {
  final ProjectRepository repository;

  UpdateDataModelUseCase({required this.repository});

  Future<Project> call(
    String projectId,
    int index,
    ProjectDataModel dataModel,
  ) async {
    return await repository.updateDataModel(projectId, index, dataModel);
  }
}

class RemoveDataModelUseCase {
  final ProjectRepository repository;

  RemoveDataModelUseCase({required this.repository});

  Future<Project> call(String projectId, int index) async {
    return await repository.removeDataModel(projectId, index);
  }
}

// Endpoint Management Use Cases
class AddEndpointUseCase {
  final ProjectRepository repository;

  AddEndpointUseCase({required this.repository});

  Future<Project> call(String projectId, ProjectEndpoint endpoint) async {
    return await repository.addEndpoint(projectId, endpoint);
  }
}

class UpdateEndpointUseCase {
  final ProjectRepository repository;

  UpdateEndpointUseCase({required this.repository});

  Future<Project> call(
    String projectId,
    int index,
    ProjectEndpoint endpoint,
  ) async {
    return await repository.updateEndpoint(projectId, index, endpoint);
  }
}

class RemoveEndpointUseCase {
  final ProjectRepository repository;

  RemoveEndpointUseCase({required this.repository});

  Future<Project> call(String projectId, int index) async {
    return await repository.removeEndpoint(projectId, index);
  }
}

// Project Settings Use Cases
class UpdateProjectSettingsUseCase {
  final ProjectRepository repository;

  UpdateProjectSettingsUseCase({required this.repository});

  Future<Project> call(
    String projectId, {
    String? projectName,
    String? description,
    String? apiBasePath,
    bool? isActive,
    bool? hasAuth,
    AuthStrategy? authStrategy,
    StorageConfig? storage,
    ProjectMetadata? metadata,
  }) async {
    return await repository.updateProjectSettings(
      projectId,
      projectName: projectName,
      description: description,
      apiBasePath: apiBasePath,
      isActive: isActive,
      hasAuth: hasAuth,
      authStrategy: authStrategy,
      storage: storage,
      metadata: metadata,
    );
  }
}

// Analytics Use Cases
class GetProjectAnalyticsUseCase {
  final ProjectRepository repository;

  GetProjectAnalyticsUseCase({required this.repository});

  Future<ApiCallsAnalytics> call(String projectId) async {
    return await repository.getProjectAnalytics(projectId);
  }
}

class IncrementApiCallUseCase {
  final ProjectRepository repository;

  IncrementApiCallUseCase({required this.repository});

  Future<void> call(String projectId, String endpointId) async {
    await repository.incrementApiCall(projectId, endpointId);
  }
}

class GetProjectsWithMostApiCallsUseCase {
  final ProjectRepository repository;

  GetProjectsWithMostApiCallsUseCase({required this.repository});

  Future<List<Project>> call({int limit = 10}) async {
    return await repository.getProjectsWithMostApiCalls(limit: limit);
  }
}

// Bulk Operations Use Cases
class CreateMultipleProjectsUseCase {
  final ProjectRepository repository;

  CreateMultipleProjectsUseCase({required this.repository});

  Future<List<Project>> call(List<Project> projects) async {
    return await repository.createMultipleProjects(projects);
  }
}

class DeleteMultipleProjectsUseCase {
  final ProjectRepository repository;

  DeleteMultipleProjectsUseCase({required this.repository});

  Future<void> call(List<String> projectIds) async {
    await repository.deleteMultipleProjects(projectIds);
  }
}

class UpdateMultipleProjectsUseCase {
  final ProjectRepository repository;

  UpdateMultipleProjectsUseCase({required this.repository});

  Future<List<Project>> call(List<Project> projects) async {
    return await repository.updateMultipleProjects(projects);
  }
}

// Validation Use Cases
class CheckProjectExistsUseCase {
  final ProjectRepository repository;

  CheckProjectExistsUseCase({required this.repository});

  Future<bool> call(String id) async {
    return await repository.projectExists(id);
  }
}

class CheckProjectNameUniqueUseCase {
  final ProjectRepository repository;

  CheckProjectNameUniqueUseCase({required this.repository});

  Future<bool> call(String name, {String? excludeId}) async {
    return await repository.isProjectNameUnique(name, excludeId: excludeId);
  }
}

// Statistics Use Cases
class GetProjectsCountUseCase {
  final ProjectRepository repository;

  GetProjectsCountUseCase({required this.repository});

  Future<int> call() async {
    return await repository.getProjectsCount();
  }
}

class GetProjectsCountByStatusUseCase {
  final ProjectRepository repository;

  GetProjectsCountByStatusUseCase({required this.repository});

  Future<Map<String, int>> call() async {
    return await repository.getProjectsCountByStatus();
  }
}

// Composite Use Cases for Complex Operations
class CreateProjectWithDataModelsUseCase {
  final ProjectRepository repository;

  CreateProjectWithDataModelsUseCase({required this.repository});

  Future<Project> call(
    Project project,
    List<ProjectDataModel> dataModels,
  ) async {
    // Create the project first
    final createdProject = await repository.createProject(project);

    // Add data models one by one
    Project updatedProject = createdProject;
    for (final dataModel in dataModels) {
      updatedProject = await repository.addDataModel(
        updatedProject.id,
        dataModel,
      );
    }

    return updatedProject;
  }
}

class CreateProjectWithEndpointsUseCase {
  final ProjectRepository repository;

  CreateProjectWithEndpointsUseCase({required this.repository});

  Future<Project> call(Project project, List<ProjectEndpoint> endpoints) async {
    // Create the project first
    final createdProject = await repository.createProject(project);

    // Add endpoints one by one
    Project updatedProject = createdProject;
    for (final endpoint in endpoints) {
      updatedProject = await repository.addEndpoint(
        updatedProject.id,
        endpoint,
      );
    }

    return updatedProject;
  }
}

class DuplicateProjectUseCase {
  final ProjectRepository repository;

  DuplicateProjectUseCase({required this.repository});

  Future<Project> call(String originalProjectId, String newProjectName) async {
    // Get the original project
    final originalProject = await repository.getProjectById(originalProjectId);
    if (originalProject == null) {
      throw Exception('Original project not found');
    }

    // Create a new project with copied data
    final now = DateTime.now();
    final duplicatedProject = originalProject.copyWith(
      id: '',
      // Will be assigned by repository
      projectName: newProjectName,
      createdAt: now,
      updatedAt: now,
      // Reset analytics for the new project
      apiCallsAnalytics: ApiCallsAnalytics(lastUpdated: now),
      // Reset endpoint analytics
      endpoints: originalProject.endpoints
          .map(
            (endpoint) => endpoint.copyWith(
              analytics: EndpointAnalytics(lastCalledAt: now),
              createdAt: now,
              updatedAt: now,
            ),
          )
          .toList(),
      // Reset data model timestamps
      mongoDbDataModels: originalProject.mongoDbDataModels
          .map(
            (dataModel) => dataModel.copyWith(createdAt: now, updatedAt: now),
          )
          .toList(),
    );

    return await repository.createProject(duplicatedProject);
  }
}
