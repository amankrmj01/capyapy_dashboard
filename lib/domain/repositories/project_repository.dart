import '../../data/models/models.dart';

abstract class ProjectRepository {
  // Project CRUD operations
  Future<List<Project>> getAllProjects();

  Future<Project?> getProjectById(String id);

  Future<Project> createProject(Project project);

  Future<Project> updateProject(Project project);

  Future<void> deleteProject(String id);

  // Project filtering and searching
  Future<List<Project>> getProjectsByUserId(String userId);

  Future<List<Project>> searchProjects(String query);

  Future<List<Project>> getActiveProjects();

  Future<List<Project>> getProjectsByStatus(bool isActive);

  // Data Models operations
  Future<Project> addDataModel(String projectId, ResourcesModel dataModel);

  Future<Project> updateDataModel(
    String projectId,
    int index,
    ResourcesModel dataModel,
  );

  Future<Project> removeDataModel(String projectId, int index);

  // Endpoints operations
  Future<Project> addEndpoint(String projectId, ProjectEndpoint endpoint);

  Future<Project> updateEndpoint(
    String projectId,
    int index,
    ProjectEndpoint endpoint,
  );

  Future<Project> removeEndpoint(String projectId, int index);

  // Project settings
  Future<Project> updateProjectSettings(
    String projectId, {
    String? projectName,
    String? description,
    String? apiBasePath,
    bool? isActive,
    bool? hasAuth,
    AuthStrategy? authStrategy,
    StorageConfig? storage,
    ProjectMetadata? metadata,
  });

  // Analytics and statistics
  Future<ApiCallsAnalytics> getProjectAnalytics(String projectId);

  Future<void> incrementApiCall(String projectId, String endpointId);

  Future<List<Project>> getProjectsWithMostApiCalls({int limit = 10});

  // Bulk operations
  Future<List<Project>> createMultipleProjects(List<Project> projects);

  Future<void> deleteMultipleProjects(List<String> projectIds);

  Future<List<Project>> updateMultipleProjects(List<Project> projects);

  // Validation and utilities
  Future<bool> projectExists(String id);

  Future<bool> isProjectNameUnique(String name, {String? excludeId});

  Future<int> getProjectsCount();

  Future<Map<String, int>> getProjectsCountByStatus();
}
