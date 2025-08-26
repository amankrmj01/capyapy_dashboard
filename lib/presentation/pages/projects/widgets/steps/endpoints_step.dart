import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../data/models/endpoint_analytics.dart';
import '../../../../../data/models/http_config.dart';
import '../../../../../data/models/resources_model.dart';
import '../../../../../data/models/project_endpoint.dart';
import '../../../../bloc/project_builder/project_builder_event.dart';
import '../../../../bloc/project_builder/project_builder_state.dart';
import '../../../../bloc/project_builder/project_builder_bloc.dart';
import '../../../../../core/constants/app_colors.dart';

class EndpointsStep extends StatefulWidget {
  final ProjectBuilderInProgress state;

  const EndpointsStep({super.key, required this.state});

  @override
  State<EndpointsStep> createState() => _EndpointsStepState();
}

class _EndpointsStepState extends State<EndpointsStep> {
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
          _buildAddEndpointButton(context),
          const SizedBox(height: 32),
          _buildQuickEndpoints(context),
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
    final endpoints = widget.state.endpoints;

    if (endpoints.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: endpoints.asMap().entries.map((entry) {
        final index = entry.key;
        final endpoint = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildEndpointCard(context, endpoint, index),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(child: Text('🔗', style: TextStyle(fontSize: 32))),
          ),
          const SizedBox(height: 16),
          Text(
            'No Endpoints Yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first API endpoint to handle requests',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointCard(
    BuildContext context,
    ProjectEndpoint endpoint,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getMethodColor(endpoint.method),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  endpoint.method.name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${widget.state.basePath}${endpoint.path}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ).copyWith(fontFeatures: [FontFeature.tabularFigures()]),
                ),
              ),
              if (endpoint.authRequired)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        'Auth',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        const SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEndpointEditor(context, endpoint, index);
                  } else if (value == 'delete') {
                    _deleteEndpoint(index);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            endpoint.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                context,
                'Status: ${endpoint.response.statusCode}',
                endpoint.response.statusCode < 300 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                context,
                'Response: ${endpoint.response.contentType}',
                Colors.blue,
              ),
              if (endpoint.pathParams?.isNotEmpty == true) ...[
                const SizedBox(width: 8),
                _buildInfoChip(
                  context,
                  'Path Params: ${endpoint.pathParams!.length}',
                  Colors.purple,
                ),
              ],
              if (endpoint.queryParams?.isNotEmpty == true) ...[
                const SizedBox(width: 8),
                _buildInfoChip(
                  context,
                  'Query Params: ${endpoint.queryParams!.length}',
                  Colors.orange,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAddEndpointButton(BuildContext context) {
    return InkWell(
      onTap: () => _showEndpointEditor(context, null, null),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.add, color: Colors.green, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Endpoint',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Create a new API endpoint',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.green, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickEndpoints(BuildContext context) {
    final models = widget.state.dataModels;

    if (models.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add some data models first to see quick endpoint suggestions based on your models.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick CRUD Endpoints',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Generate common endpoints for your data models',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary(context),
          ),
        ),
        const SizedBox(height: 16),
        ...models.where((model) => model.modelName != 'User').map((model) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.modelName} Endpoints',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickEndpointChip(
                      context,
                      'GET',
                      '/${model.collectionName}',
                      'Get all ${model.modelName.toLowerCase()}s',
                      Colors.blue,
                      () => _addCrudEndpoint(
                        model,
                        HttpMethod.get,
                        '/${model.collectionName}',
                        'Fetch all ${model.modelName.toLowerCase()}s',
                      ),
                    ),
                    _buildQuickEndpointChip(
                      context,
                      'GET',
                      '/${model.collectionName}/:id',
                      'Get ${model.modelName.toLowerCase()} by ID',
                      Colors.blue,
                      () => _addCrudEndpoint(
                        model,
                        HttpMethod.get,
                        '/${model.collectionName}/:id',
                        'Fetch a ${model.modelName.toLowerCase()} by ID',
                      ),
                    ),
                    _buildQuickEndpointChip(
                      context,
                      'POST',
                      '/${model.collectionName}',
                      'Create ${model.modelName.toLowerCase()}',
                      Colors.green,
                      () => _addCrudEndpoint(
                        model,
                        HttpMethod.post,
                        '/${model.collectionName}',
                        'Create a new ${model.modelName.toLowerCase()}',
                      ),
                    ),
                    _buildQuickEndpointChip(
                      context,
                      'PUT',
                      '/${model.collectionName}/:id',
                      'Update ${model.modelName.toLowerCase()}',
                      Colors.orange,
                      () => _addCrudEndpoint(
                        model,
                        HttpMethod.put,
                        '/${model.collectionName}/:id',
                        'Update a ${model.modelName.toLowerCase()} by ID',
                      ),
                    ),
                    _buildQuickEndpointChip(
                      context,
                      'DELETE',
                      '/${model.collectionName}/:id',
                      'Delete ${model.modelName.toLowerCase()}',
                      Colors.red,
                      () => _addCrudEndpoint(
                        model,
                        HttpMethod.delete,
                        '/${model.collectionName}/:id',
                        'Delete a ${model.modelName.toLowerCase()} by ID',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuickEndpointChip(
    BuildContext context,
    String method,
    String path,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              method,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ).copyWith(fontFeatures: [FontFeature.tabularFigures()]),
            ),
            const SizedBox(width: 6),
            Text(
              path,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary(context),
              ).copyWith(fontFeatures: [FontFeature.tabularFigures()]),
            ),
            const SizedBox(width: 4),
            Icon(Icons.add, size: 12, color: color),
          ],
        ),
      ),
    );
  }

  Color _getMethodColor(HttpMethod method) {
    switch (method) {
      case HttpMethod.get:
        return Colors.blue;
      case HttpMethod.post:
        return Colors.green;
      case HttpMethod.put:
        return Colors.orange;
      case HttpMethod.delete:
        return Colors.red;
      case HttpMethod.patch:
        return Colors.purple;
    }
  }

  void _showEndpointEditor(
    BuildContext context,
    ProjectEndpoint? endpoint,
    int? index,
  ) {
    // TODO: Implement endpoint editor dialog
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Endpoint editor coming soon!')));
  }

  void _deleteEndpoint(int index) {
    context.read<ProjectBuilderBloc>().add(RemoveEndpoint(index));
  }

  void _addCrudEndpoint(
    ResourcesModel model,
    HttpMethod method,
    String path,
    String description,
  ) {
    final endpoint = ProjectEndpoint(
      id: 'endpoint_${DateTime.now().millisecondsSinceEpoch}',
      path: path,
      method: method,
      description: description,
      authRequired: method != HttpMethod.get && widget.state.hasAuth,
      response: ResponseConfig(
        statusCode: method == HttpMethod.post ? 201 : 200,
        contentType: 'application/json',
        schema: method == HttpMethod.delete
            ? {
                'message': '${model.modelName} deleted successfully',
                'deletedId': 'auto',
              }
            : method == HttpMethod.post
            ? {
                'message': '${model.modelName} created successfully',
                '${model.modelName.toLowerCase()}Id': 'auto',
              }
            : method == HttpMethod.put
            ? {
                'message': '${model.modelName} updated successfully',
                'updatedId': 'auto',
              }
            : _generateSchemaFromModel(model),
      ),
      pathParams: path.contains(':id') ? {'id': 'string'} : null,
      request: (method == HttpMethod.post || method == HttpMethod.put)
          ? RequestConfig(
              contentType: 'application/json',
              bodySchema: _generateSchemaFromModel(model),
            )
          : null,
      analytics: EndpointAnalytics(
        totalCalls: 0,
        averageResponseTime: 0,
        lastCalledAt: DateTime.now(),
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<ProjectBuilderBloc>().add(AddEndpoint(endpoint));
  }

  Map<String, dynamic> _generateSchemaFromModel(ResourcesModel model) {
    final schema = <String, dynamic>{};
    for (final field in model.fields) {
      if (field.name != 'id' && field.name != 'createdAt') {
        schema[field.name] = field.type.displayName.toLowerCase();
      }
    }
    return schema;
  }
}
