import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../bloc/project_builder/project_builder_bloc.dart';
import '../../../../bloc/project_builder/project_builder_event.dart';
import '../../../../bloc/project_builder/project_builder_state.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../data/models/project_model.dart';

class DataModelsStep extends StatefulWidget {
  final ProjectBuilderInProgress state;

  const DataModelsStep({super.key, required this.state});

  @override
  State<DataModelsStep> createState() => _DataModelsStepState();
}

class _DataModelsStepState extends State<DataModelsStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildModelsList(context),
          const SizedBox(height: 24),
          _buildAddModelButton(context),
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
            Text('📝', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              'Data Models',
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
          'Define the data structures for your MongoDB collections. These will be used to generate realistic mock data.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary(context),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildModelsList(BuildContext context) {
    final models = widget.state.dataModels;

    if (models.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: models.asMap().entries.map((entry) {
        final index = entry.key;
        final model = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildModelCard(context, model, index),
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
            child: Center(child: Text('📋', style: TextStyle(fontSize: 32))),
          ),
          const SizedBox(height: 16),
          Text(
            'No Data Models Yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first data model to define the structure of your mock data',
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

  Widget _buildModelCard(BuildContext context, DataModel model, int index) {
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text('📋', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.modelName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      'Collection: ${model.collectionName}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
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
                  if (model.modelName !=
                      'User') // Don't allow deleting User model
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
                    _showModelEditor(context, model, index);
                  } else if (value == 'delete') {
                    _deleteModel(index);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Fields (${model.fields.length})',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: model.fields.map((field) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getFieldTypeColor(field.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getFieldTypeColor(field.type).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      field.name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${field.type.displayName})',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: _getFieldTypeColor(field.type),
                      ),
                    ),
                    if (field.required) ...[
                      const SizedBox(width: 2),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 10),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddModelButton(BuildContext context) {
    return InkWell(
      onTap: () => _showModelEditor(context, null, null),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blue.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.add, color: Colors.blue, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Data Model',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Define a new collection structure',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTemplates(BuildContext context) {
    final templates = [
      _ModelTemplate(
        name: 'User Profile',
        icon: '👤',
        description: 'Basic user information',
        model: DataModel(
          modelName: 'UserProfile',
          collectionName: 'user_profiles',
          fields: [
            ModelField(
              name: 'id',
              type: FieldType.string,
              required: true,
              unique: true,
            ),
            ModelField(
              name: 'firstName',
              type: FieldType.string,
              required: true,
            ),
            ModelField(
              name: 'lastName',
              type: FieldType.string,
              required: true,
            ),
            ModelField(name: 'avatar', type: FieldType.string),
            ModelField(name: 'bio', type: FieldType.string),
            ModelField(
              name: 'createdAt',
              type: FieldType.date,
              defaultValue: 'now',
            ),
          ],
        ),
      ),
      _ModelTemplate(
        name: 'Product',
        icon: '🛍️',
        description: 'E-commerce product',
        model: DataModel(
          modelName: 'Product',
          collectionName: 'products',
          fields: [
            ModelField(
              name: 'id',
              type: FieldType.string,
              required: true,
              unique: true,
            ),
            ModelField(name: 'name', type: FieldType.string, required: true),
            ModelField(name: 'price', type: FieldType.number, required: true),
            ModelField(name: 'description', type: FieldType.string),
            ModelField(
              name: 'inStock',
              type: FieldType.boolean,
              defaultValue: true,
            ),
            ModelField(
              name: 'tags',
              type: FieldType.array,
              itemsType: 'String',
            ),
            ModelField(
              name: 'createdAt',
              type: FieldType.date,
              defaultValue: 'now',
            ),
          ],
        ),
      ),
      _ModelTemplate(
        name: 'Blog Post',
        icon: '📝',
        description: 'Blog content structure',
        model: DataModel(
          modelName: 'BlogPost',
          collectionName: 'blog_posts',
          fields: [
            ModelField(
              name: 'id',
              type: FieldType.string,
              required: true,
              unique: true,
            ),
            ModelField(name: 'title', type: FieldType.string, required: true),
            ModelField(name: 'content', type: FieldType.string, required: true),
            ModelField(name: 'author', type: FieldType.string, required: true),
            ModelField(
              name: 'published',
              type: FieldType.boolean,
              defaultValue: false,
            ),
            ModelField(
              name: 'tags',
              type: FieldType.array,
              itemsType: 'String',
            ),
            ModelField(name: 'publishedAt', type: FieldType.date),
            ModelField(
              name: 'createdAt',
              type: FieldType.date,
              defaultValue: 'now',
            ),
          ],
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Templates',
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
              onTap: () => _addTemplateModel(template.model),
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
                    const SizedBox(height: 8),
                    Text(
                      '${template.model.fields.length} fields',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
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

  Color _getFieldTypeColor(FieldType type) {
    switch (type) {
      case FieldType.string:
        return Colors.blue;
      case FieldType.number:
        return Colors.green;
      case FieldType.boolean:
        return Colors.orange;
      case FieldType.date:
        return Colors.purple;
      case FieldType.array:
        return Colors.teal;
      case FieldType.object:
        return Colors.red;
    }
  }

  void _showModelEditor(BuildContext context, DataModel? model, int? index) {
    // TODO: Implement model editor dialog
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Model editor coming soon!')));
  }

  void _deleteModel(int index) {
    context.read<ProjectBuilderBloc>().add(RemoveDataModel(index));
  }

  void _addTemplateModel(DataModel model) {
    context.read<ProjectBuilderBloc>().add(AddDataModel(model));
  }
}

class _ModelTemplate {
  final String name;
  final String icon;
  final String description;
  final DataModel model;

  const _ModelTemplate({
    required this.name,
    required this.icon,
    required this.description,
    required this.model,
  });
}
