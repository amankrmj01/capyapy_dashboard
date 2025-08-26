import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../data/models/mongodb_field.dart';
import '../../../../../data/models/mongodb_index.dart';
import '../../../../../data/models/resources_model.dart';
import '../../../../bloc/project_builder/project_builder_bloc.dart';
import '../../../../bloc/project_builder/project_builder_event.dart';
import '../../../../bloc/project_builder/project_builder_state.dart';
import '../../../../../core/constants/app_colors.dart';

class DataModelsStep extends StatefulWidget {
  final ProjectBuilderInProgress state;

  const DataModelsStep({super.key, required this.state});

  @override
  State<DataModelsStep> createState() => _DataModelsStepState();
}

class _DataModelsStepState extends State<DataModelsStep> {
  void _showCustomModelDialog({ResourcesModel? model, int? editIndex}) {
    final nameController = TextEditingController(text: model?.modelName ?? '');
    final collectionController = TextEditingController(
      text: model?.collectionName ?? '',
    );
    final descController = TextEditingController(
      text: model?.description ?? '',
    );
    List<MongoDbField> fields = List<MongoDbField>.from(model?.fields ?? []);
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                editIndex == null ? 'Add Custom Model' : 'Edit Model',
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Model Name'),
                    ),
                    TextField(
                      controller: collectionController,
                      decoration: InputDecoration(labelText: 'Collection Name'),
                    ),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Fields',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                    ...fields.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final field = entry.value;
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Field Name',
                              ),
                              controller: TextEditingController(
                                text: field.name,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  fields[idx] = MongoDbField(
                                    name: val,
                                    type: field.type,
                                    required: field.required,
                                    unique: field.unique,
                                    defaultValue: field.defaultValue,
                                    enumValues: field.enumValues,
                                    nestedFields: field.nestedFields,
                                    ref: field.ref,
                                    validationRules: field.validationRules,
                                  );
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButton<MongoDbFieldType>(
                            value: field.type,
                            items: MongoDbFieldType.values
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                fields[idx] = MongoDbField(
                                  name: field.name,
                                  type: val!,
                                  required: field.required,
                                  unique: field.unique,
                                  defaultValue: field.defaultValue,
                                  enumValues: field.enumValues,
                                  nestedFields: field.nestedFields,
                                  ref: field.ref,
                                  validationRules: field.validationRules,
                                );
                              });
                            },
                          ),
                          Checkbox(
                            value: field.required,
                            onChanged: (val) {
                              setState(() {
                                fields[idx] = MongoDbField(
                                  name: field.name,
                                  type: field.type,
                                  required: val!,
                                  unique: field.unique,
                                  defaultValue: field.defaultValue,
                                  enumValues: field.enumValues,
                                  nestedFields: field.nestedFields,
                                  ref: field.ref,
                                  validationRules: field.validationRules,
                                );
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                fields.removeAt(idx);
                              });
                            },
                          ),
                        ],
                      );
                    }),
                    TextButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add Field'),
                      onPressed: () {
                        setState(() {
                          fields.add(
                            MongoDbField(
                              name: '',
                              type: MongoDbFieldType.string,
                              required: false,
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final now = DateTime.now();
                    final newModel = ResourcesModel(
                      modelName: nameController.text,
                      collectionName: collectionController.text,
                      description: descController.text,
                      fields: fields,
                      indexes: [],
                      id: model?.id ?? UniqueKey().toString(),
                      createdAt: now,
                      updatedAt: now,
                    );
                    if (editIndex != null) {
                      context.read<ProjectBuilderBloc>().add(
                        UpdateDataModel(index: editIndex, dataModel: newModel),
                      );
                    } else {
                      context.read<ProjectBuilderBloc>().add(
                        AddDataModel(newModel),
                      );
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(editIndex == null ? 'Add Model' : 'Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
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
          _buildModelsList(context),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Custom Model'),
            onPressed: () => _showCustomModelDialog(),
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
        final idx = entry.key;
        final model = entry.value;
        return Card(
          child: ListTile(
            title: Text(model.modelName),
            subtitle: Text(model.collectionName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _showCustomModelDialog(model: model, editIndex: idx),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => context.read<ProjectBuilderBloc>().add(
                    RemoveDataModel(idx),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildModelCard(
    BuildContext context,
    ResourcesModel model,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
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
                  color: _getFieldTypeColor(field.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getFieldTypeColor(
                      field.type,
                    ).withValues(alpha: 0.3),
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
          color: Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blue.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
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
        model: ResourcesModel(
          id: 'user_profile_${DateTime.now().millisecondsSinceEpoch}',
          modelName: 'UserProfile',
          collectionName: 'user_profiles',
          description: 'Basic user information',
          fields: [
            MongoDbField(
              name: 'id',
              type: MongoDbFieldType.objectId,
              required: true,
              unique: true,
            ),
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
            MongoDbField(name: 'bio', type: MongoDbFieldType.string),
            MongoDbField(
              name: 'createdAt',
              type: MongoDbFieldType.date,
              defaultValue: 'now',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
      _ModelTemplate(
        name: 'Product',
        icon: '🛍️',
        description: 'E-commerce product',
        model: ResourcesModel(
          id: 'product_${DateTime.now().millisecondsSinceEpoch}',
          modelName: 'Product',
          collectionName: 'products',
          description: 'E-commerce product',
          fields: [
            MongoDbField(
              name: 'id',
              type: MongoDbFieldType.objectId,
              required: true,
              unique: true,
            ),
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
            MongoDbField(name: 'description', type: MongoDbFieldType.string),
            MongoDbField(
              name: 'inStock',
              type: MongoDbFieldType.boolean,
              defaultValue: true,
            ),
            MongoDbField(name: 'tags', type: MongoDbFieldType.array),
            MongoDbField(
              name: 'createdAt',
              type: MongoDbFieldType.date,
              defaultValue: 'now',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
      _ModelTemplate(
        name: 'Blog Post',
        icon: '📝',
        description: 'Blog content structure',
        model: ResourcesModel(
          id: 'blog_post_${DateTime.now().millisecondsSinceEpoch}',
          modelName: 'BlogPost',
          collectionName: 'blog_posts',
          description: 'Blog content structure',
          fields: [
            MongoDbField(
              name: 'id',
              type: MongoDbFieldType.objectId,
              required: true,
              unique: true,
            ),
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
              name: 'author',
              type: MongoDbFieldType.string,
              required: true,
            ),
            MongoDbField(
              name: 'published',
              type: MongoDbFieldType.boolean,
              defaultValue: false,
            ),
            MongoDbField(name: 'tags', type: MongoDbFieldType.array),
            MongoDbField(name: 'publishedAt', type: MongoDbFieldType.date),
            MongoDbField(
              name: 'createdAt',
              type: MongoDbFieldType.date,
              defaultValue: 'now',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
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

  Color _getFieldTypeColor(MongoDbFieldType type) {
    switch (type) {
      case MongoDbFieldType.string:
        return Colors.blue;
      case MongoDbFieldType.number:
        return Colors.green;
      case MongoDbFieldType.boolean:
        return Colors.orange;
      case MongoDbFieldType.date:
        return Colors.purple;
      case MongoDbFieldType.array:
        return Colors.teal;
      case MongoDbFieldType.object:
        return Colors.red;
      case MongoDbFieldType.objectId:
        return Colors.indigo;
      case MongoDbFieldType.buffer:
        return Colors.amber;
      case MongoDbFieldType.decimal:
        return Colors.cyan;
      case MongoDbFieldType.mixed:
        return Colors.grey;
      case MongoDbFieldType.map:
        return Colors.deepPurple;
    }
  }

  void _showModelEditor(
    BuildContext context,
    ResourcesModel? model,
    int? index,
  ) {
    // TODO: Implement model editor dialog
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Model editor coming soon!')));
  }

  void _deleteModel(int index) {
    context.read<ProjectBuilderBloc>().add(RemoveDataModel(index));
  }

  void _addTemplateModel(ResourcesModel model) {
    context.read<ProjectBuilderBloc>().add(AddDataModel(model));
  }
}

class _ModelTemplate {
  final String name;
  final String icon;
  final String description;
  final ResourcesModel model;

  const _ModelTemplate({
    required this.name,
    required this.icon,
    required this.description,
    required this.model,
  });
}
