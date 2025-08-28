import '../models/models.dart';

abstract class ProjectDataSource {
  Future<List<ProjectModel>> getProjectsByIds(List<String> ids);

  Future<ProjectModel?> getProjectById(String id);

  Future<ProjectModel> createProject(ProjectModel project);

  Future<ProjectModel> updateProject(ProjectModel project);

  Future<void> deleteProject(String id);

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

  Future<List<ProjectModel>> getAllProjects();
}
