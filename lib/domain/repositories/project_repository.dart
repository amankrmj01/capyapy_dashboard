import '../../data/models/models.dart';

abstract class ProjectRepository {
  // Project CRUD operations
  Future<List<ProjectModel>> getAllProjects();

  Future<List<ProjectModel>> getProjectsByIds(List<String> ids);

  Future<ProjectModel?> getProjectById(String id);

  Future<ProjectModel> createProject(ProjectModel project);

  Future<ProjectModel> updateProject(ProjectModel project);

  Future<void> deleteProject(String id);

  // Project filtering and searching
  Future<List<ProjectModel>> getProjectsByUserId(String userId);

  Future<List<ProjectModel>> searchProjects(String query);

  Future<List<ProjectModel>> getActiveProjects();

  Future<List<ProjectModel>> getProjectsByStatus(bool isActive);

  // Data Models operations
  Future<ProjectModel> addDataModel(
    String projectId,
    ProjectDataModel dataModel,
  );

  Future<ProjectModel> updateDataModel(
    String projectId,
    int index,
    ProjectDataModel dataModel,
  );

  Future<ProjectModel> removeDataModel(String projectId, int index);

  // Endpoints operations
  Future<ProjectModel> addEndpoint(String projectId, ProjectEndpoint endpoint);

  Future<ProjectModel> updateEndpoint(
    String projectId,
    int index,
    ProjectEndpoint endpoint,
  );

  Future<ProjectModel> removeEndpoint(String projectId, int index);

  // Project settings
  Future<ProjectModel> updateProjectSettings(
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

  Future<List<ProjectModel>> getProjectsWithMostApiCalls({int limit = 10});

  // Bulk operations
  Future<List<ProjectModel>> createMultipleProjects(
    List<ProjectModel> projects,
  );

  Future<void> deleteMultipleProjects(List<String> projectIds);

  Future<List<ProjectModel>> updateMultipleProjects(
    List<ProjectModel> projects,
  );

  // Validation and utilities
  Future<bool> projectExists(String id);

  Future<bool> isProjectNameUnique(String name, {String? excludeId});

  Future<int> getProjectsCount();

  Future<Map<String, int>> getProjectsCountByStatus();

  Future<int> getTotalEndpoints();

  Future<int> getTotalModels();

  Future<int> getTotalApiCalls();
}
