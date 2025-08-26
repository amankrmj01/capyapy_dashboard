import '../models/models.dart';
import 'project_data_source.dart';

class MockProjectDataSource implements ProjectDataSource {
  final List<Project> _projects = [];
  static final List<Project> _staticProjects = [];

  MockProjectDataSource() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();

    // Create sample projects
    _projects.addAll([
      Project(
        id: 'project_1',
        projectName: 'E-commerce API',
        description: 'REST API for e-commerce platform',
        apiBasePath: '/api/v1',
        isActive: true,
        hasAuth: true,
        authStrategy: AuthStrategy(
          type: AuthType.bearer,
          config: {'tokenType': 'JWT'},
          requiredFields: ['token'],
        ),
        mongoDbDataModels: [
          ProjectDataModel(
            id: 'model_1',
            modelName: 'Product',
            collectionName: 'products',
            description: 'Product data model',
            fields: [
              MongoDbField(
                name: 'name',
                type: MongoDbFieldType.string,
                required: true,
              ),
              MongoDbField(
                name: 'price',
                type: MongoDbFieldType.number,
                required: true,
              ),
              MongoDbField(
                name: 'inStock',
                type: MongoDbFieldType.boolean,
                defaultValue: true,
              ),
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ],
        endpoints: [
          ProjectEndpoint(
            id: 'endpoint_1',
            path: '/products',
            method: HttpMethod.get,
            description: 'Get all products',
            authRequired: false,
            response: ResponseConfig(
              statusCode: 200,
              contentType: 'application/json',
              schema: {'type': 'array'},
            ),
            analytics: EndpointAnalytics(
              totalCalls: 1250,
              successfulCalls: 1200,
              errorCalls: 50,
              averageResponseTime: 145.5,
              lastCalledAt: now,
            ),
            createdAt: now,
            updatedAt: now,
          ),
        ],
        storage: StorageConfig(
          type: StorageType.mongodb,
          connectionString: 'mongodb://localhost:27017',
          databaseName: 'ecommerce',
        ),
        metadata: ProjectMetadata(
          version: '1.0.0',
          author: 'Development Team',
          tags: ['ecommerce', 'api', 'mongodb'],
        ),
        apiCallsAnalytics: ApiCallsAnalytics(
          totalCalls: 1250,
          totalSuccessfulCalls: 1200,
          totalErrorCalls: 50,
          averageResponseTime: 145.5,
          lastUpdated: now,
        ),
        createdAt: now,
        updatedAt: now,
      ),
      Project(
        id: 'project_2',
        projectName: 'Blog Management System',
        description: 'Content management system for blogs',
        apiBasePath: '/api/v2',
        isActive: true,
        hasAuth: true,
        authStrategy: AuthStrategy(
          type: AuthType.apiKey,
          config: {'keyLocation': 'header'},
          requiredFields: ['x-api-key'],
        ),
        mongoDbDataModels: [
          ProjectDataModel(
            id: 'model_2',
            modelName: 'Post',
            collectionName: 'posts',
            description: 'Blog post model',
            fields: [
              MongoDbField(
                name: 'title',
                type: MongoDbFieldType.string,
                required: true,
              ),
              MongoDbField(
                name: 'content',
                type: MongoDbFieldType.string,
                required: true,
              ),
              MongoDbField(
                name: 'published',
                type: MongoDbFieldType.boolean,
                defaultValue: false,
              ),
              MongoDbField(name: 'publishedAt', type: MongoDbFieldType.date),
            ],
            createdAt: now,
            updatedAt: now,
          ),
        ],
        endpoints: [
          ProjectEndpoint(
            id: 'endpoint_2',
            path: '/posts',
            method: HttpMethod.post,
            description: 'Create new blog post',
            authRequired: true,
            request: RequestConfig(
              contentType: 'application/json',
              bodySchema: {
                'type': 'object',
                'properties': {
                  'title': {'type': 'string'},
                  'content': {'type': 'string'},
                },
              },
            ),
            response: ResponseConfig(
              statusCode: 201,
              contentType: 'application/json',
              schema: {'type': 'object'},
            ),
            analytics: EndpointAnalytics(
              totalCalls: 856,
              successfulCalls: 820,
              errorCalls: 36,
              averageResponseTime: 89.2,
              lastCalledAt: now,
            ),
            createdAt: now,
            updatedAt: now,
          ),
        ],
        storage: StorageConfig(
          type: StorageType.mongodb,
          connectionString: 'mongodb://localhost:27017',
          databaseName: 'blog',
        ),
        metadata: ProjectMetadata(
          version: '2.1.0',
          author: 'Content Team',
          tags: ['blog', 'cms', 'content'],
        ),
        apiCallsAnalytics: ApiCallsAnalytics(
          totalCalls: 856,
          totalSuccessfulCalls: 820,
          totalErrorCalls: 36,
          averageResponseTime: 89.2,
          lastUpdated: now,
        ),
        createdAt: now,
        updatedAt: now,
      ),
      Project(
        id: 'project_3',
        projectName: 'Analytics Dashboard',
        description: 'Real-time analytics and reporting system',
        apiBasePath: '/analytics/v1',
        isActive: false,
        hasAuth: true,
        authStrategy: AuthStrategy(
          type: AuthType.oauth2,
          config: {'scope': 'read:analytics'},
          requiredFields: ['access_token'],
        ),
        mongoDbDataModels: [],
        endpoints: [],
        storage: StorageConfig(
          type: StorageType.postgresql,
          connectionString: 'postgresql://localhost:5432',
          databaseName: 'analytics',
        ),
        metadata: ProjectMetadata(
          version: '0.5.0',
          author: 'Analytics Team',
          tags: ['analytics', 'dashboard', 'reporting'],
        ),
        apiCallsAnalytics: ApiCallsAnalytics(
          totalCalls: 0,
          totalSuccessfulCalls: 0,
          totalErrorCalls: 0,
          averageResponseTime: 0,
          lastUpdated: now,
        ),
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ]);
  }

  @override
  Future<List<Project>> getAllProjects() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return List.from(_projects);
  }

  @override
  Future<Project?> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Project> createProject(Project project) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newProject = project.copyWith(
      id: 'project_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _projects.add(newProject);
    return newProject;
  }

  @override
  Future<Project> updateProject(Project project) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index == -1) {
      throw Exception('Project not found');
    }
    final updatedProject = project.copyWith(updatedAt: DateTime.now());
    _projects[index] = updatedProject;
    return updatedProject;
  }

  @override
  Future<void> deleteProject(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _projects.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Project not found');
    }
    _projects.removeAt(index);
  }

  @override
  Future<List<Project>> getProjectsByUserId(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // For mock purposes, return all projects (in real implementation, filter by userId)
    return List.from(_projects);
  }

  @override
  Future<List<Project>> searchProjects(String query) async {
    await Future.delayed(const Duration(milliseconds: 350));
    if (query.isEmpty) return getAllProjects();

    final lowerQuery = query.toLowerCase();
    return _projects.where((project) {
      return project.projectName.toLowerCase().contains(lowerQuery) ||
          project.description.toLowerCase().contains(lowerQuery) ||
          project.metadata.tags.any(
            (tag) => tag.toLowerCase().contains(lowerQuery),
          );
    }).toList();
  }

  @override
  Future<List<Project>> getActiveProjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _projects.where((project) => project.isActive).toList();
  }

  @override
  Future<List<Project>> getProjectsByStatus(bool isActive) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _projects.where((project) => project.isActive == isActive).toList();
  }

  @override
  Future<ApiCallsAnalytics> getProjectAnalytics(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final project = await getProjectById(projectId);
    if (project == null) {
      throw Exception('Project not found');
    }
    return project.apiCallsAnalytics;
  }

  @override
  Future<void> incrementApiCall(String projectId, String endpointId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final projectIndex = _projects.indexWhere((p) => p.id == projectId);
    if (projectIndex == -1) return;

    final project = _projects[projectIndex];
    final endpointIndex = project.endpoints.indexWhere(
      (e) => e.id == endpointId,
    );
    if (endpointIndex == -1) return;

    // Update endpoint analytics
    final endpoint = project.endpoints[endpointIndex];
    final updatedAnalytics = endpoint.analytics.copyWith(
      totalCalls: endpoint.analytics.totalCalls + 1,
      successfulCalls: endpoint.analytics.successfulCalls + 1,
      lastCalledAt: DateTime.now(),
    );

    final updatedEndpoints = List<ProjectEndpoint>.from(project.endpoints);
    updatedEndpoints[endpointIndex] = endpoint.copyWith(
      analytics: updatedAnalytics,
    );

    // Update project analytics
    final updatedProjectAnalytics = project.apiCallsAnalytics.copyWith(
      totalCalls: project.apiCallsAnalytics.totalCalls + 1,
      totalSuccessfulCalls: project.apiCallsAnalytics.totalSuccessfulCalls + 1,
      lastUpdated: DateTime.now(),
    );

    _projects[projectIndex] = project.copyWith(
      endpoints: updatedEndpoints,
      apiCallsAnalytics: updatedProjectAnalytics,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<bool> projectExists(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _projects.any((project) => project.id == id);
  }

  @override
  Future<bool> isProjectNameUnique(String name, {String? excludeId}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return !_projects.any(
      (project) =>
          project.projectName.toLowerCase() == name.toLowerCase() &&
          project.id != excludeId,
    );
  }

  @override
  Future<int> getProjectsCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _projects.length;
  }

  // Additional helper methods for mock data management
  void addMockProject(Project project) {
    _projects.add(project);
  }

  void clearMockData() {
    _projects.clear();
  }

  void resetMockData() {
    _projects.clear();
    _initializeMockData();
  }

  static void addProject(Project project) {
    _staticProjects.add(project);
  }

  List<Project> get projects => [..._projects, ..._staticProjects];
}
