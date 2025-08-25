import '../models/models.dart';

abstract class ProjectDataSource {
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

  // Analytics
  Future<ApiCallsAnalytics> getProjectAnalytics(String projectId);

  Future<void> incrementApiCall(String projectId, String endpointId);

  // Utility methods
  Future<bool> projectExists(String id);

  Future<bool> isProjectNameUnique(String name, {String? excludeId});

  Future<int> getProjectsCount();
}
