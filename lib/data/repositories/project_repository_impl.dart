import '../../domain/repositories/project_repository.dart';
import '../datasource/project_data_source.dart';
import '../models/models.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectDataSource dataSource;

  ProjectRepositoryImpl({required this.dataSource});

  @override
  Future<ProjectModel?> getProjectById(String id) async {
    try {
      return await dataSource.getProjectById(id);
    } catch (e) {
      throw Exception('Failed to fetch project: $e');
    }
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    try {
      // Validate project name uniqueness
      final allProjects = await dataSource.getAllProjects();
      final isUnique = !allProjects.any(
        (p) => p.projectName == project.projectName,
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
  Future<ProjectModel> updateProject(ProjectModel project) async {
    try {
      // Validate project exists
      final allProjects = await dataSource.getAllProjects();
      final exists = allProjects.any((p) => p.id == project.id);
      if (!exists) {
        throw Exception('Project not found');
      }
      // Validate project name uniqueness (excluding current project)
      final isUnique = !allProjects.any(
        (p) => p.projectName == project.projectName && p.id != project.id,
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
      final allProjects = await dataSource.getAllProjects();
      final exists = allProjects.any((p) => p.id == id);
      if (!exists) {
        throw Exception('Project not found');
      }
      await dataSource.deleteProject(id);
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }

  @override
  Future<List<ProjectModel>> searchProjects(String query) async {
    try {
      final allProjects = await dataSource.getAllProjects();
      final lowerQuery = query.toLowerCase();
      return allProjects.where((project) {
        return project.projectName.toLowerCase().contains(lowerQuery) ||
            project.description.toLowerCase().contains(lowerQuery) ||
            project.metadata.tags.any(
              (tag) => tag.toLowerCase().contains(lowerQuery),
            );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search projects: $e');
    }
  }

  @override
  Future<List<ProjectModel>> getActiveProjects() async {
    try {
      final allProjects = await dataSource.getAllProjects();
      return allProjects.where((p) => p.isActive).toList();
    } catch (e) {
      throw Exception('Failed to fetch active projects: $e');
    }
  }

  @override
  Future<List<ProjectModel>> getProjectsByStatus(bool isActive) async {
    try {
      final allProjects = await dataSource.getAllProjects();
      return allProjects.where((p) => p.isActive == isActive).toList();
    } catch (e) {
      throw Exception('Failed to fetch projects by status: $e');
    }
  }

  @override
  Future<ProjectModel> addDataModel(
    String projectId,
    ProjectDataModel dataModel,
  ) async {
    return await dataSource.addDataModel(projectId, dataModel);
  }

  @override
  Future<ProjectModel> updateDataModel(
    String projectId,
    int index,
    ProjectDataModel dataModel,
  ) async {
    return await dataSource.updateDataModel(projectId, index, dataModel);
  }

  @override
  Future<ProjectModel> removeDataModel(String projectId, int index) async {
    return await dataSource.removeDataModel(projectId, index);
  }

  @override
  Future<ProjectModel> addEndpoint(
    String projectId,
    ProjectEndpoint endpoint,
  ) async {
    return await dataSource.addEndpoint(projectId, endpoint);
  }

  @override
  Future<ProjectModel> updateEndpoint(
    String projectId,
    int index,
    ProjectEndpoint endpoint,
  ) async {
    return await dataSource.updateEndpoint(projectId, index, endpoint);
  }

  @override
  Future<ProjectModel> removeEndpoint(String projectId, int index) async {
    return await dataSource.removeEndpoint(projectId, index);
  }

  @override
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
  }) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }
      // Validate project name uniqueness if name is being changed
      if (projectName != null && projectName != project.projectName) {
        final allProjects = await dataSource.getAllProjects();
        final isUnique = !allProjects.any(
          (p) => p.projectName == projectName && p.id != projectId,
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
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }
      return project.apiCallsAnalytics;
    } catch (e) {
      throw Exception('Failed to fetch project analytics: $e');
    }
  }

  @override
  Future<void> incrementApiCall(String projectId, String endpointId) async {
    try {
      final project = await dataSource.getProjectById(projectId);
      if (project == null) {
        throw Exception('Project not found');
      }
      final endpointIndex = project.endpoints.indexWhere(
        (e) => e.id == endpointId,
      );
      if (endpointIndex == -1) {
        throw Exception('Endpoint not found');
      }
      final endpoint = project.endpoints[endpointIndex];
      final updatedAnalytics = endpoint.analytics.copyWith(
        totalCalls: endpoint.analytics.totalCalls + 1,
      );
      final updatedEndpoint = endpoint.copyWith(
        analytics: updatedAnalytics,
        updatedAt: DateTime.now(),
      );
      final updatedEndpoints = List<ProjectEndpoint>.from(project.endpoints);
      updatedEndpoints[endpointIndex] = updatedEndpoint;
      final updatedProject = project.copyWith(
        endpoints: updatedEndpoints,
        updatedAt: DateTime.now(),
      );
      await dataSource.updateProject(updatedProject);
    } catch (e) {
      throw Exception('Failed to increment API call: $e');
    }
  }

  @override
  Future<List<ProjectModel>> getProjectsWithMostApiCalls({
    int limit = 10,
  }) async {
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
  Future<List<ProjectModel>> createMultipleProjects(
    List<ProjectModel> projects,
  ) async {
    try {
      final createdProjects = <ProjectModel>[];
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
  Future<List<ProjectModel>> updateMultipleProjects(
    List<ProjectModel> projects,
  ) async {
    try {
      final updatedProjects = <ProjectModel>[];
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
      final allProjects = await dataSource.getAllProjects();
      return allProjects.any((p) => p.id == id);
    } catch (e) {
      throw Exception('Failed to check if project exists: $e');
    }
  }

  @override
  Future<bool> isProjectNameUnique(String name, {String? excludeId}) async {
    try {
      final allProjects = await dataSource.getAllProjects();
      return !allProjects.any(
        (p) =>
            p.projectName == name && (excludeId == null || p.id != excludeId),
      );
    } catch (e) {
      throw Exception('Failed to check project name uniqueness: $e');
    }
  }

  @override
  Future<int> getProjectsCount() async {
    try {
      final allProjects = await dataSource.getAllProjects();
      return allProjects.length;
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
    try {
      final allProjects = await dataSource.getAllProjects();
      return allProjects.fold<int>(0, (sum, p) => sum + p.endpoints.length);
    } catch (e) {
      throw Exception('Failed to get total endpoints: $e');
    }
  }

  @override
  Future<int> getTotalModels() async {
    try {
      final allProjects = await dataSource.getAllProjects();
      return allProjects.fold<int>(
        0,
        (sum, p) => sum + p.mongoDbDataModels.length,
      );
    } catch (e) {
      throw Exception('Failed to get total models: $e');
    }
  }

  @override
  Future<int> getTotalApiCalls() async {
    try {
      final allProjects = await dataSource.getAllProjects();
      return allProjects.fold<int>(
        0,
        (sum, p) => sum + p.apiCallsAnalytics.totalCalls,
      );
    } catch (e) {
      throw Exception('Failed to get total API calls: $e');
    }
  }

  @override
  Future<List<ProjectModel>> getProjectsByIds(List<String> ids) async {
    return await dataSource.getProjectsByIds(ids);
  }
}
