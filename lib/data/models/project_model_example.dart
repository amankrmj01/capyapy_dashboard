import 'models.dart';

/// Example usage and sample data for the Project model
/// This demonstrates how to create and use all the comprehensive project models

class ProjectModelExample {
  /// Creates a sample project with all features
  static Project createSampleProject() {
    final now = DateTime.now();

    return Project(
      id: 'proj_123456',
      projectName: 'E-commerce API',
      description:
          'A comprehensive e-commerce API with user management, product catalog, and order processing',
      apiBasePath: 'https://api.myecommerce.com/v1',
      isActive: true,
      hasAuth: true,
      authStrategy: AuthStrategy(
        type: AuthType.bearer,
        config: {
          'tokenExpiry': '24h',
          'refreshTokenExpiry': '30d',
          'algorithm': 'HS256',
        },
        requiredFields: ['email', 'password'],
      ),
      mongoDbDataModels: [
        _createUserModel(),
        _createProductModel(),
        _createOrderModel(),
      ],
      endpoints: [
        _createUserEndpoint(),
        _createProductEndpoint(),
        _createOrderEndpoint(),
      ],
      storage: StorageConfig(
        type: StorageType.mongodb,
        connectionString: 'mongodb://localhost:27017/ecommerce',
        databaseName: 'ecommerce_db',
        options: {
          'useUnifiedTopology': true,
          'useNewUrlParser': true,
          'maxPoolSize': 10,
        },
      ),
      metadata: ProjectMetadata(
        version: '2.1.0',
        author: 'Development Team',
        tags: ['ecommerce', 'api', 'mongodb', 'nodejs'],
        documentation: 'https://docs.myecommerce.com/api',
        customFields: {
          'environment': 'production',
          'region': 'us-east-1',
          'maintenanceWindow': '02:00-04:00 UTC',
        },
      ),
      apiCallsAnalytics: _createApiAnalytics(),
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
  }

  /// Sample User data model for MongoDB
  static ProjectDataModel _createUserModel() {
    final now = DateTime.now();

    return ProjectDataModel(
      id: 'model_user_001',
      modelName: 'User',
      collectionName: 'users',
      description: 'User account and profile information',
      fields: [
        MongoDbField(
          name: '_id',
          type: MongoDbFieldType.objectId,
          required: true,
        ),
        MongoDbField(
          name: 'email',
          type: MongoDbFieldType.string,
          required: true,
          unique: true,
          validationRules: {
            'pattern': r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
            'maxLength': 255,
          },
        ),
        MongoDbField(
          name: 'password',
          type: MongoDbFieldType.string,
          required: true,
          validationRules: {'minLength': 8, 'encrypted': true},
        ),
        MongoDbField(
          name: 'profile',
          type: MongoDbFieldType.object,
          nestedFields: [
            MongoDbField(
              name: 'firstName',
              type: MongoDbFieldType.string,
              required: true,
            ),
            MongoDbField(
              name: 'lastName',
              type: MongoDbFieldType.string,
              required: true,
            ),
            MongoDbField(name: 'avatar', type: MongoDbFieldType.string),
            MongoDbField(name: 'dateOfBirth', type: MongoDbFieldType.date),
          ],
        ),
        MongoDbField(
          name: 'roles',
          type: MongoDbFieldType.array,
          defaultValue: ['user'],
          enumValues: ['admin', 'user', 'moderator'],
        ),
        MongoDbField(
          name: 'isActive',
          type: MongoDbFieldType.boolean,
          defaultValue: true,
        ),
        MongoDbField(name: 'lastLogin', type: MongoDbFieldType.date),
        MongoDbField(
          name: 'createdAt',
          type: MongoDbFieldType.date,
          defaultValue: 'Date.now()',
        ),
        MongoDbField(
          name: 'updatedAt',
          type: MongoDbFieldType.date,
          defaultValue: 'Date.now()',
        ),
      ],
      indexes: [
        MongoDbIndex(name: 'email_unique', fields: {'email': 1}, unique: true),
        MongoDbIndex(name: 'created_at_desc', fields: {'createdAt': -1}),
        MongoDbIndex(name: 'roles_active', fields: {'roles': 1, 'isActive': 1}),
      ],
      mongoDbOptions: {
        'strict': true,
        'validateBeforeSave': true,
        'timestamps': true,
      },
      createdAt: now.subtract(const Duration(days: 25)),
      updatedAt: now,
    );
  }

  /// Sample Product data model
  static ProjectDataModel _createProductModel() {
    final now = DateTime.now();

    return ProjectDataModel(
      id: 'model_product_001',
      modelName: 'Product',
      collectionName: 'products',
      description: 'Product catalog with inventory and pricing',
      fields: [
        MongoDbField(
          name: '_id',
          type: MongoDbFieldType.objectId,
          required: true,
        ),
        MongoDbField(
          name: 'name',
          type: MongoDbFieldType.string,
          required: true,
          validationRules: {'maxLength': 200},
        ),
        MongoDbField(
          name: 'description',
          type: MongoDbFieldType.string,
          validationRules: {'maxLength': 2000},
        ),
        MongoDbField(
          name: 'price',
          type: MongoDbFieldType.decimal,
          required: true,
          validationRules: {'min': 0},
        ),
        MongoDbField(
          name: 'category',
          type: MongoDbFieldType.objectId,
          ref: 'Category',
          required: true,
        ),
        MongoDbField(
          name: 'inventory',
          type: MongoDbFieldType.object,
          nestedFields: [
            MongoDbField(
              name: 'quantity',
              type: MongoDbFieldType.number,
              defaultValue: 0,
            ),
            MongoDbField(
              name: 'reserved',
              type: MongoDbFieldType.number,
              defaultValue: 0,
            ),
            MongoDbField(
              name: 'lowStockAlert',
              type: MongoDbFieldType.number,
              defaultValue: 10,
            ),
          ],
        ),
        MongoDbField(
          name: 'images',
          type: MongoDbFieldType.array,
          validationRules: {'maxItems': 10},
        ),
        MongoDbField(
          name: 'status',
          type: MongoDbFieldType.string,
          enumValues: ['active', 'inactive', 'discontinued'],
          defaultValue: 'active',
        ),
      ],
      indexes: [
        MongoDbIndex(name: 'name_text', fields: {'name': 1}),
        MongoDbIndex(
          name: 'category_status',
          fields: {'category': 1, 'status': 1},
        ),
        MongoDbIndex(name: 'price_range', fields: {'price': 1}),
      ],
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now,
    );
  }

  /// Sample Order data model
  static ProjectDataModel _createOrderModel() {
    final now = DateTime.now();

    return ProjectDataModel(
      id: 'model_order_001',
      modelName: 'Order',
      collectionName: 'orders',
      description: 'Customer orders with items and payment information',
      fields: [
        MongoDbField(
          name: '_id',
          type: MongoDbFieldType.objectId,
          required: true,
        ),
        MongoDbField(
          name: 'orderNumber',
          type: MongoDbFieldType.string,
          required: true,
          unique: true,
        ),
        MongoDbField(
          name: 'customerId',
          type: MongoDbFieldType.objectId,
          ref: 'User',
          required: true,
        ),
        MongoDbField(
          name: 'items',
          type: MongoDbFieldType.array,
          nestedFields: [
            MongoDbField(
              name: 'productId',
              type: MongoDbFieldType.objectId,
              ref: 'Product',
            ),
            MongoDbField(name: 'quantity', type: MongoDbFieldType.number),
            MongoDbField(name: 'price', type: MongoDbFieldType.decimal),
          ],
        ),
        MongoDbField(
          name: 'totalAmount',
          type: MongoDbFieldType.decimal,
          required: true,
        ),
        MongoDbField(
          name: 'status',
          type: MongoDbFieldType.string,
          enumValues: [
            'pending',
            'confirmed',
            'shipped',
            'delivered',
            'cancelled',
          ],
          defaultValue: 'pending',
        ),
      ],
      indexes: [
        MongoDbIndex(
          name: 'order_number_unique',
          fields: {'orderNumber': 1},
          unique: true,
        ),
        MongoDbIndex(
          name: 'customer_orders',
          fields: {'customerId': 1, 'createdAt': -1},
        ),
      ],
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now,
    );
  }

  /// Sample User endpoint with analytics
  static ProjectEndpoint _createUserEndpoint() {
    final now = DateTime.now();

    return ProjectEndpoint(
      id: 'endpoint_user_create',
      path: '/users',
      method: HttpMethod.post,
      description: 'Create a new user account',
      authRequired: false,
      request: RequestConfig(
        contentType: 'application/json',
        bodySchema: {
          'type': 'object',
          'required': ['email', 'password', 'profile'],
          'properties': {
            'email': {'type': 'string', 'format': 'email'},
            'password': {'type': 'string', 'minLength': 8},
            'profile': {
              'type': 'object',
              'properties': {
                'firstName': {'type': 'string'},
                'lastName': {'type': 'string'},
              },
            },
          },
        },
      ),
      response: ResponseConfig(
        statusCode: 201,
        contentType: 'application/json',
        schema: {
          'type': 'object',
          'properties': {
            'id': {'type': 'string'},
            'email': {'type': 'string'},
            'profile': {'type': 'object'},
            'createdAt': {'type': 'string', 'format': 'date-time'},
          },
        },
        examples: [
          ResponseExample(
            name: 'successful_creation',
            description: 'User successfully created',
            data: {
              'id': '507f1f77bcf86cd799439011',
              'email': 'john@example.com',
              'profile': {'firstName': 'John', 'lastName': 'Doe'},
              'createdAt': '2024-01-15T10:30:00Z',
            },
          ),
        ],
      ),
      analytics: EndpointAnalytics(
        totalCalls: 15420,
        successfulCalls: 14850,
        errorCalls: 570,
        averageResponseTime: 245.5,
        callsByDay: {'2024-01-15': 450, '2024-01-14': 520, '2024-01-13': 380},
        callsByHour: {'09': 45, '10': 62, '11': 58, '14': 78, '15': 91},
        responseCodeCounts: {201: 14850, 400: 320, 409: 180, 500: 70},
        lastCalledAt: now.subtract(const Duration(minutes: 5)),
        recentDataPoints: [
          ApiCallDataPoint(
            timestamp: now.subtract(const Duration(minutes: 5)),
            responseCode: 201,
            responseTime: 198.5,
          ),
          ApiCallDataPoint(
            timestamp: now.subtract(const Duration(minutes: 8)),
            responseCode: 400,
            responseTime: 125.2,
            errorMessage: 'Invalid email format',
          ),
        ],
      ),
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
  }

  /// Sample Product endpoint
  static ProjectEndpoint _createProductEndpoint() {
    final now = DateTime.now();

    return ProjectEndpoint(
      id: 'endpoint_product_list',
      path: '/products',
      method: HttpMethod.get,
      description: 'Get paginated list of products with filters',
      authRequired: true,
      queryParams: {
        'page': 'Page number (default: 1)',
        'limit': 'Items per page (default: 20)',
        'category': 'Filter by category ID',
        'status': 'Filter by status (active, inactive)',
        'minPrice': 'Minimum price filter',
        'maxPrice': 'Maximum price filter',
      },
      response: ResponseConfig(
        statusCode: 200,
        contentType: 'application/json',
        schema: {
          'type': 'object',
          'properties': {
            'data': {'type': 'array'},
            'pagination': {'type': 'object'},
            'filters': {'type': 'object'},
          },
        },
      ),
      analytics: EndpointAnalytics(
        totalCalls: 48750,
        successfulCalls: 47920,
        errorCalls: 830,
        averageResponseTime: 180.3,
        callsByDay: {
          '2024-01-15': 1250,
          '2024-01-14': 1180,
          '2024-01-13': 1340,
        },
        responseCodeCounts: {200: 47920, 401: 420, 403: 280, 500: 130},
        lastCalledAt: now.subtract(const Duration(minutes: 2)),
      ),
      createdAt: now.subtract(const Duration(days: 25)),
      updatedAt: now,
    );
  }

  /// Sample Order endpoint
  static ProjectEndpoint _createOrderEndpoint() {
    final now = DateTime.now();

    return ProjectEndpoint(
      id: 'endpoint_order_create',
      path: '/orders',
      method: HttpMethod.post,
      description: 'Create a new order',
      authRequired: true,
      request: RequestConfig(
        contentType: 'application/json',
        bodySchema: {
          'type': 'object',
          'required': ['items'],
          'properties': {
            'items': {
              'type': 'array',
              'items': {
                'type': 'object',
                'properties': {
                  'productId': {'type': 'string'},
                  'quantity': {'type': 'number', 'minimum': 1},
                },
              },
            },
          },
        },
      ),
      response: ResponseConfig(
        statusCode: 201,
        contentType: 'application/json',
        schema: {
          'type': 'object',
          'properties': {
            'id': {'type': 'string'},
            'orderNumber': {'type': 'string'},
            'totalAmount': {'type': 'number'},
            'status': {'type': 'string'},
          },
        },
      ),
      analytics: EndpointAnalytics(
        totalCalls: 8940,
        successfulCalls: 8520,
        errorCalls: 420,
        averageResponseTime: 325.8,
        callsByDay: {'2024-01-15': 285, '2024-01-14': 320, '2024-01-13': 245},
        responseCodeCounts: {201: 8520, 400: 180, 401: 120, 409: 80, 500: 40},
        lastCalledAt: now.subtract(const Duration(minutes: 12)),
      ),
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now,
    );
  }

  /// Sample API analytics for the entire project
  static ApiCallsAnalytics _createApiAnalytics() {
    final now = DateTime.now();

    return ApiCallsAnalytics(
      totalCalls: 73110,
      totalSuccessfulCalls: 71290,
      totalErrorCalls: 1820,
      callsByEndpoint: {
        'endpoint_user_create': 15420,
        'endpoint_product_list': 48750,
        'endpoint_order_create': 8940,
      },
      callsByDate: {
        '2024-01-15': 1985,
        '2024-01-14': 2020,
        '2024-01-13': 1965,
        '2024-01-12': 1850,
        '2024-01-11': 1920,
      },
      callsByMonth: {'2024-01': 73110, '2023-12': 68450, '2023-11': 65230},
      averageResponseTime: 217.2,
      lastUpdated: now,
    );
  }

  /// Demonstrates JSON serialization
  static void demonstrateJsonSerialization() {
    final project = createSampleProject();

    // Convert to JSON
    final jsonData = project.toJson();
    print('Project JSON keys: ${jsonData.keys.join(', ')}');

    // Convert back from JSON
    final reconstructedProject = Project.fromJson(jsonData);

    print('Original project name: ${project.projectName}');
    print('Reconstructed project name: ${reconstructedProject.projectName}');
    print('Total API calls: ${reconstructedProject.totalApiCalls}');
    print('Total endpoints: ${reconstructedProject.totalEndpoints}');
    print('Total data models: ${reconstructedProject.totalDataModels}');
    print('Project is active: ${reconstructedProject.isActive}');
    print(
      'Success rate: ${reconstructedProject.apiCallsAnalytics.overallSuccessRate.toStringAsFixed(2)}%',
    );
  }
}
