import '../models/models.dart';
import 'project_data_source.dart';

class MockProjectDataSource implements ProjectDataSource {
  final List<ProjectModel> _projects = [];
  static final List<ProjectModel> _staticProjects = [];

  MockProjectDataSource() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();

    // Create sample projects
    _projects.addAll([
      ProjectModel(
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
      ProjectModel(
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
      ProjectModel(
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
  Future<ProjectModel?> getProjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
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
  Future<ProjectModel> updateProject(ProjectModel project) async {
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
  Future<List<ProjectModel>> getProjectsByIds(List<String> ids) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _projects.where((project) => ids.contains(project.id)).toList();
  }

  @override
  Future<List<ProjectModel>> getAllProjects() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<ProjectModel>.from(_projects);
  }

  @override
  Future<ProjectModel> addDataModel(
    String projectId,
    ProjectDataModel dataModel,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = await getProjectById(projectId);
    if (project == null) throw Exception('Project not found');
    final updatedProject = project.copyWith(
      mongoDbDataModels: [...project.mongoDbDataModels, dataModel],
      updatedAt: DateTime.now(),
    );
    return await updateProject(updatedProject);
  }

  @override
  Future<ProjectModel> updateDataModel(
    String projectId,
    int index,
    ProjectDataModel dataModel,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = await getProjectById(projectId);
    if (project == null) throw Exception('Project not found');
    if (index < 0 || index >= project.mongoDbDataModels.length)
      throw Exception('Data model index out of bounds');
    final updatedDataModels = List<ProjectDataModel>.from(
      project.mongoDbDataModels,
    );
    updatedDataModels[index] = dataModel.copyWith(updatedAt: DateTime.now());
    final updatedProject = project.copyWith(
      mongoDbDataModels: updatedDataModels,
      updatedAt: DateTime.now(),
    );
    return await updateProject(updatedProject);
  }

  @override
  Future<ProjectModel> removeDataModel(String projectId, int index) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = await getProjectById(projectId);
    if (project == null) throw Exception('Project not found');
    if (index < 0 || index >= project.mongoDbDataModels.length)
      throw Exception('Data model index out of bounds');
    final updatedDataModels = List<ProjectDataModel>.from(
      project.mongoDbDataModels,
    );
    updatedDataModels.removeAt(index);
    final updatedProject = project.copyWith(
      mongoDbDataModels: updatedDataModels,
      updatedAt: DateTime.now(),
    );
    return await updateProject(updatedProject);
  }

  @override
  Future<ProjectModel> addEndpoint(
    String projectId,
    ProjectEndpoint endpoint,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = await getProjectById(projectId);
    if (project == null) throw Exception('Project not found');
    final updatedProject = project.copyWith(
      endpoints: [...project.endpoints, endpoint],
      updatedAt: DateTime.now(),
    );
    return await updateProject(updatedProject);
  }

  @override
  Future<ProjectModel> updateEndpoint(
    String projectId,
    int index,
    ProjectEndpoint endpoint,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = await getProjectById(projectId);
    if (project == null) throw Exception('Project not found');
    if (index < 0 || index >= project.endpoints.length)
      throw Exception('Endpoint index out of bounds');
    final updatedEndpoints = List<ProjectEndpoint>.from(project.endpoints);
    updatedEndpoints[index] = endpoint.copyWith(updatedAt: DateTime.now());
    final updatedProject = project.copyWith(
      endpoints: updatedEndpoints,
      updatedAt: DateTime.now(),
    );
    return await updateProject(updatedProject);
  }

  @override
  Future<ProjectModel> removeEndpoint(String projectId, int index) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final project = await getProjectById(projectId);
    if (project == null) throw Exception('Project not found');
    if (index < 0 || index >= project.endpoints.length)
      throw Exception('Endpoint index out of bounds');
    final updatedEndpoints = List<ProjectEndpoint>.from(project.endpoints);
    updatedEndpoints.removeAt(index);
    final updatedProject = project.copyWith(
      endpoints: updatedEndpoints,
      updatedAt: DateTime.now(),
    );
    return await updateProject(updatedProject);
  }
}
