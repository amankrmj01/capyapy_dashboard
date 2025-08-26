import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../data/models/endpoint_analytics.dart';
import '../../../../../data/models/http_config.dart';

import '../../../../../data/models/project_endpoint.dart';
import '../../../../../core/constants/app_colors.dart';
import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/endpoint_editor_dialog.dart';
import '../../../../bloc/project_creation/project_creation_bloc.dart';
import '../../../../bloc/project_creation/project_creation_state.dart';

class EndpointsStep extends StatefulWidget {
  final ProjectCreationInitial state;

  const EndpointsStep({super.key, required this.state});

  @override
  State<EndpointsStep> createState() => _EndpointsStepState();
}

class _EndpointsStepState extends State<EndpointsStep> {
  List<ProjectEndpoint> get endpoints =>
      List<ProjectEndpoint>.from(widget.state.formData['endpoints'] ?? []);

  void _addNewEndpoint() {
    showDialog(
      context: context,
      builder: (dialogContext) => EndpointEditorDialog(
        onSave: (endpoint) {
          // Use the step's context which has access to ProjectCreationBloc
          final bloc = context.read<ProjectCreationBloc>();
          final currentState = bloc.state;
          if (currentState is ProjectCreationInitial) {
            final updatedEndpoints = List<ProjectEndpoint>.from(
              currentState.formData['endpoints'] ?? [],
            );
            updatedEndpoints.add(endpoint);
            bloc.add(
              ProjectCreationFieldUpdated('endpoints', updatedEndpoints),
            );
          }
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _editEndpoint(int index, ProjectEndpoint endpoint) {
    showDialog(
      context: context,
      builder: (dialogContext) => EndpointEditorDialog(
        endpoint: endpoint,
        onSave: (updatedEndpoint) {
          // Use the step's context which has access to ProjectCreationBloc
          final bloc = context.read<ProjectCreationBloc>();
          final currentState = bloc.state;
          if (currentState is ProjectCreationInitial) {
            final updatedEndpoints = List<ProjectEndpoint>.from(
              currentState.formData['endpoints'] ?? [],
            );
            updatedEndpoints[index] = updatedEndpoint;
            bloc.add(
              ProjectCreationFieldUpdated('endpoints', updatedEndpoints),
            );
          }
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _deleteEndpoint(int index) {
    final bloc = context.read<ProjectCreationBloc>();
    final currentState = bloc.state;
    if (currentState is ProjectCreationInitial) {
      final updatedEndpoints = List<ProjectEndpoint>.from(
        currentState.formData['endpoints'] ?? [],
      );
      updatedEndpoints.removeAt(index);
      bloc.add(ProjectCreationFieldUpdated('endpoints', updatedEndpoints));
    }
  }

  void _addTemplateEndpoint(ProjectEndpoint endpoint) {
    final bloc = context.read<ProjectCreationBloc>();
    final currentState = bloc.state;
    if (currentState is ProjectCreationInitial) {
      final updatedEndpoints = List<ProjectEndpoint>.from(
        currentState.formData['endpoints'] ?? [],
      );
      updatedEndpoints.add(endpoint);
      bloc.add(ProjectCreationFieldUpdated('endpoints', updatedEndpoints));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildEndpointsList(context),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Custom Endpoint'),
            onPressed: _addNewEndpoint,
          ),
          const SizedBox(height: 32),
          _buildQuickTemplates(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🔗', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              'API Endpoints',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Define your API endpoints. Each endpoint will be automatically configured with realistic responses based on your data models.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary(context),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEndpointsList(BuildContext context) {
    if (endpoints.isEmpty) {
      return _buildEmptyState(context);
    }
    return Column(
      children: endpoints.asMap().entries.map((entry) {
        final idx = entry.key;
        final endpoint = entry.value;
        return Card(
          child: ListTile(
            title: Text(endpoint.path),
            subtitle: Text(endpoint.method.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editEndpoint(idx, endpoint),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteEndpoint(idx),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'No endpoints found. Create your first endpoint by tapping the button above.',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildQuickTemplates(BuildContext context) {
    final templates = [
      _EndpointTemplate(
        name: 'Get All Products',
        icon: '📦',
        description: 'GET /products - List all products',
        endpoint: ProjectEndpoint(
          id: 'get_all_products_${DateTime.now().millisecondsSinceEpoch}',
          path: '/products',
          method: HttpMethod.get,
          description: 'List all products',
          authRequired: false,
          response: ResponseConfig(
            statusCode: 200,
            contentType: 'application/json',
            schema: {'products': 'array'},
          ),
          analytics: EndpointAnalytics(
            totalCalls: 0,
            averageResponseTime: 0,
            lastCalledAt: DateTime.now(),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
      _EndpointTemplate(
        name: 'Create Product',
        icon: '➕',
        description: 'POST /products - Add a new product',
        endpoint: ProjectEndpoint(
          id: 'create_product_${DateTime.now().millisecondsSinceEpoch}',
          path: '/products',
          method: HttpMethod.post,
          description: 'Add a new product',
          authRequired: true,
          request: RequestConfig(
            contentType: 'application/json',
            bodySchema: {'name': 'string', 'price': 'number'},
          ),
          response: ResponseConfig(
            statusCode: 201,
            contentType: 'application/json',
            schema: {'message': 'Product created successfully'},
          ),
          analytics: EndpointAnalytics(
            totalCalls: 0,
            averageResponseTime: 0,
            lastCalledAt: DateTime.now(),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
      _EndpointTemplate(
        name: 'Delete Product',
        icon: '🗑️',
        description: 'DELETE /products/:id - Remove a product',
        endpoint: ProjectEndpoint(
          id: 'delete_product_${DateTime.now().millisecondsSinceEpoch}',
          path: '/products/:id',
          method: HttpMethod.delete,
          description: 'Remove a product by ID',
          authRequired: true,
          pathParams: {'id': 'string'},
          response: ResponseConfig(
            statusCode: 200,
            contentType: 'application/json',
            schema: {'message': 'Product deleted successfully'},
          ),
          analytics: EndpointAnalytics(
            totalCalls: 0,
            averageResponseTime: 0,
            lastCalledAt: DateTime.now(),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Endpoint Templates',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: templates.map((template) {
            return InkWell(
              onTap: () => _addTemplateEndpoint(template.endpoint),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.28,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(template.icon, style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            template.name,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      template.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _EndpointTemplate {
  final String name;
  final String icon;
  final String description;
  final ProjectEndpoint endpoint;

  const _EndpointTemplate({
    required this.name,
    required this.icon,
    required this.description,
    required this.endpoint,
  });
}
