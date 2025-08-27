import '../models/models.dart';

abstract class ProjectDataSource {
  // Project CRUD operations
  Future<List<ProjectModel>> getAllProjects();

  Future<ProjectModel?> getProjectById(String id);

  Future<ProjectModel> createProject(ProjectModel project);

  Future<ProjectModel> updateProject(ProjectModel project);

  Future<void> deleteProject(String id);

  // Project filtering and searching
  Future<List<ProjectModel>> getProjectsByUserId(String userId);

  Future<List<ProjectModel>> searchProjects(String query);

  Future<List<ProjectModel>> getActiveProjects();

  Future<List<ProjectModel>> getProjectsByStatus(bool isActive);

  // Analytics
  Future<ApiCallsAnalytics> getProjectAnalytics(String projectId);

  Future<void> incrementApiCall(String projectId, String endpointId);

  // Utility methods
  Future<bool> projectExists(String id);

  Future<bool> isProjectNameUnique(String name, {String? excludeId});

  Future<int> getProjectsCount();

  Future<int> getTotalEndpoints();

  Future<int> getTotalModels();

  Future<int> getTotalApiCalls();
}
