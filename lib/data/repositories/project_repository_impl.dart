import '../../domain/repositories/project_repository.dart';
import '../datasources/project_data_source.dart';
import '../models/models.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSource dataSource;

  ProjectRepositoryImpl({required this.dataSource});

  @override
  Future<List<Project>> getAllProjects() async {
    try {
      return await dataSource.getAllProjects();
    } catch (e) {
      throw Exception('Failed to fetch projects: $e');
    }
  }

  @override
  Future<Project?> getProjectById(String id) async {
    try {
      return await dataSource.getProjectById(id);
    } catch (e) {
      throw Exception('Failed to fetch project: $e');
    }
  }

  @override
  Future<Project> createProject(Project project) async {
    try {
      // Validate project name uniqueness
      final isUnique = await dataSource.isProjectNameUnique(
        project.projectName,
      );
      if (!isUnique) {
        throw Exception('Project name already exists');
      }
      return await dataSource.createProject(project);
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  @override
  Future<Project> updateProject(Project project) async {
    try {
      // Validate project exists
      final exists = await dataSource.projectExists(project.id);
      if (!exists) {
        throw Exception('Project not found');
      }

      // Validate project name uniqueness (excluding current project)
      final isUnique = await dataSource.isProjectNameUnique(
        project.projectName,
        excludeId: project.id,
      );
      if (!isUnique) {
        throw Exception('Project name already exists');
      }

      return await dataSource.updateProject(project);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  @override
  Future<void> deleteProject(String id) async {
    try {
      final exists = await dataSource.projectExists(id);
      if (!exists) {
        throw Exception('Project not found');
      }
      await dataSource.deleteProject(id);
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  @override
  Future<List<Project>> getProjectsByUserId(String userId) async {
    try {
      return await dataSource.getProjectsByUserId(userId);
    } catch (e) {
      throw Exception('Failed to fetch user projects: $e');
    }
  }

  @override
  Future<List<Project>> searchProjects(String query) async {
    try {
      return await dataSource.searchProjects(query);
    } catch (e) {
      throw Exception('Failed to search projects: $e');
    }
  }

  @override
  Future<List<Project>> getActiveProjects() async {
    try {
      return await dataSource.getActiveProjects();
    } catch (e) {
      throw Exception('Failed to fetch active projects: $e');
    }
  }

  @override
  Future<List<Project>> getProjectsByStatus(bool isActive) async {
    try {
      return await dataSource.getProjectsByStatus(isActive);
    } catch (e) {
      throw Exception('Failed to fetch projects by status: $e');
    }
  }

  @override
  Future<Project> addDataModel(
    String projectId,
    ProjectDataModel dataModel,
  ) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      final updatedProject = project.copyWith(
        mongoDbDataModels: [...project.mongoDbDataModels, dataModel],
        updatedAt: DateTime.now(),
      );

      return await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to add data model: $e');
    }
  }

  @override
  Future<Project> updateDataModel(
    String projectId,
    int index,
    ProjectDataModel dataModel,
  ) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      if (index < 0 || index >= project.mongoDbDataModels.length) {
        throw Exception('Data model index out of bounds');
      }

      final updatedDataModels = List<ProjectDataModel>.from(
        project.mongoDbDataModels,
      );
      updatedDataModels[index] = dataModel.copyWith(updatedAt: DateTime.now());

      final updatedProject = project.copyWith(
        mongoDbDataModels: updatedDataModels,
        updatedAt: DateTime.now(),
      );

      return await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to update data model: $e');
    }
  }

  @override
  Future<Project> removeDataModel(String projectId, int index) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      if (index < 0 || index >= project.mongoDbDataModels.length) {
        throw Exception('Data model index out of bounds');
      }

      final updatedDataModels = List<ProjectDataModel>.from(
        project.mongoDbDataModels,
      );
      updatedDataModels.removeAt(index);

      final updatedProject = project.copyWith(
        mongoDbDataModels: updatedDataModels,
        updatedAt: DateTime.now(),
      );

      return await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to remove data model: $e');
    }
  }

  @override
  Future<Project> addEndpoint(
    String projectId,
    ProjectEndpoint endpoint,
  ) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      final updatedProject = project.copyWith(
        endpoints: [...project.endpoints, endpoint],
        updatedAt: DateTime.now(),
      );

      return await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to add endpoint: $e');
    }
  }

  @override
  Future<Project> updateEndpoint(
    String projectId,
    int index,
    ProjectEndpoint endpoint,
  ) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      if (index < 0 || index >= project.endpoints.length) {
        throw Exception('Endpoint index out of bounds');
      }

      final updatedEndpoints = List<ProjectEndpoint>.from(project.endpoints);
      updatedEndpoints[index] = endpoint.copyWith(updatedAt: DateTime.now());

      final updatedProject = project.copyWith(
        endpoints: updatedEndpoints,
        updatedAt: DateTime.now(),
      );

      return await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to update endpoint: $e');
    }
  }

  @override
  Future<Project> removeEndpoint(String projectId, int index) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      if (index < 0 || index >= project.endpoints.length) {
        throw Exception('Endpoint index out of bounds');
      }

      final updatedEndpoints = List<ProjectEndpoint>.from(project.endpoints);
      updatedEndpoints.removeAt(index);

      final updatedProject = project.copyWith(
        endpoints: updatedEndpoints,
        updatedAt: DateTime.now(),
      );

      return await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to remove endpoint: $e');
    }
  }

  @override
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
  }) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }

      // Validate project name uniqueness if name is being changed
      if (projectName != null && projectName != project.projectName) {
        final isUnique = await dataSource.isProjectNameUnique(
          projectName,
          excludeId: projectId,
        );
        if (!isUnique) {
          throw Exception('Project name already exists');
        }
      }

      final updatedProject = project.copyWith(
        projectName: projectName ?? project.projectName,
        description: description ?? project.description,
        apiBasePath: apiBasePath ?? project.apiBasePath,
        isActive: isActive ?? project.isActive,
        hasAuth: hasAuth ?? project.hasAuth,
        authStrategy: authStrategy ?? project.authStrategy,
        storage: storage ?? project.storage,
        metadata: metadata ?? project.metadata,
        updatedAt: DateTime.now(),
      );

      return await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to update project settings: $e');
    }
  }

  @override
  Future<ApiCallsAnalytics> getProjectAnalytics(String projectId) async {
    try {
      return await dataSource.getProjectAnalytics(projectId);
    } catch (e) {
      throw Exception('Failed to fetch project analytics: $e');
    }
  }

  @override
  Future<void> incrementApiCall(String projectId, String endpointId) async {
    try {
      await dataSource.incrementApiCall(projectId, endpointId);
    } catch (e) {
      throw Exception('Failed to increment API call: $e');
    }
  }

  @override
  Future<List<Project>> getProjectsWithMostApiCalls({int limit = 10}) async {
    try {
      final allProjects = await dataSource.getAllProjects();
      allProjects.sort(
        (a, b) => b.apiCallsAnalytics.totalCalls.compareTo(
          a.apiCallsAnalytics.totalCalls,
        ),
      );
      return allProjects.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch projects with most API calls: $e');
    }
  }

  @override
  Future<List<Project>> createMultipleProjects(List<Project> projects) async {
    try {
      final createdProjects = <Project>[];
      for (final project in projects) {
        final createdProject = await createProject(project);
        createdProjects.add(createdProject);
      }
      return createdProjects;
    } catch (e) {
      throw Exception('Failed to create multiple projects: $e');
    }
  }

  @override
  Future<void> deleteMultipleProjects(List<String> projectIds) async {
    try {
      for (final id in projectIds) {
        await deleteProject(id);
      }
    } catch (e) {
      throw Exception('Failed to delete multiple projects: $e');
    }
  }

  @override
  Future<List<Project>> updateMultipleProjects(List<Project> projects) async {
    try {
      final updatedProjects = <Project>[];
      for (final project in projects) {
        final updatedProject = await updateProject(project);
        updatedProjects.add(updatedProject);
      }
      return updatedProjects;
    } catch (e) {
      throw Exception('Failed to update multiple projects: $e');
    }
  }

  @override
  Future<bool> projectExists(String id) async {
    try {
      return await dataSource.projectExists(id);
    } catch (e) {
      throw Exception('Failed to check if project exists: $e');
    }
  }

  @override
  Future<bool> isProjectNameUnique(String name, {String? excludeId}) async {
    try {
      return await dataSource.isProjectNameUnique(name, excludeId: excludeId);
    } catch (e) {
      throw Exception('Failed to check project name uniqueness: $e');
    }
  }

  @override
  Future<int> getProjectsCount() async {
    try {
      return await dataSource.getProjectsCount();
    } catch (e) {
      throw Exception('Failed to get projects count: $e');
    }
  }

  @override
  Future<Map<String, int>> getProjectsCountByStatus() async {
    try {
      final allProjects = await dataSource.getAllProjects();
      final activeCount = allProjects.where((p) => p.isActive).length;
      final inactiveCount = allProjects.length - activeCount;

      return {
        'active': activeCount,
        'inactive': inactiveCount,
        'total': allProjects.length,
      };
    } catch (e) {
      throw Exception('Failed to get projects count by status: $e');
    }
  }

  @override
  Future<int> getTotalEndpoints() async {
    return await dataSource.getTotalEndpoints();
  }

  @override
  Future<int> getTotalModels() async {
    return await dataSource.getTotalModels();
  }

  @override
  Future<int> getTotalApiCalls() async {
    return await dataSource.getTotalApiCalls();
  }
}
