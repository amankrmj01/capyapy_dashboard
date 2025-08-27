import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../data/models/models.dart';
import '../../../project_details/widgets/data_model_editor_dialog.dart';
import '../../../../bloc/project_creation/project_creation_bloc.dart';

class DataModelsStep extends StatefulWidget {
  final ProjectCreationInitial state;

  const DataModelsStep({super.key, required this.state});

  @override
  State<DataModelsStep> createState() => _DataModelsStepState();
}

class _DataModelsStepState extends State<DataModelsStep> {
  void _showCustomModelDialog({ProjectDataModel? model, int? editIndex}) {
    showDialog(
      context: context,
      builder: (dialogContext) => DataModelEditorDialog(
        dataModel: model,
        onSave: (updatedDataModel) {
          final bloc = context.read<ProjectCreationBloc>();
          if (editIndex != null) {
            // Update existing model
            bloc.add(
              UpdateDataModel(index: editIndex, dataModel: updatedDataModel),
            );
          } else {
            // Add new model
            bloc.add(AddDataModel(updatedDataModel));
          }
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _addNewDataModel() {
    showDialog(
      context: context,
      builder: (dialogContext) => DataModelEditorDialog(
        onSave: (dataModel) {
          final bloc = context.read<ProjectCreationBloc>();
          bloc.add(AddDataModel(dataModel));
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _deleteModel(int index) {
    final bloc = context.read<ProjectCreationBloc>();
    bloc.add(RemoveDataModel(index));
  }

  void _addTemplateModel(ProjectDataModel model) {
    final bloc = context.read<ProjectCreationBloc>();
    bloc.add(AddDataModel(model));
  }

  @override
  Widget build(BuildContext context) {
    final models = widget.state.dataModels;

    if (widget.state.runtimeType != ProjectCreationInitial) {
      return Container();
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildModelsList(context, models),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Custom Model'),
            onPressed: _addNewDataModel,
          ),
          const SizedBox(height: 32),
          _buildQuickTemplates(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Data Models',
      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildModelsList(BuildContext context, List<ProjectDataModel> models) {
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
                  onPressed: () => _deleteModel(idx),
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
        'No data models found. Create your first model by tapping the button above.',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildQuickTemplates(BuildContext context) {
    final templates = [
      _ModelTemplate(
        name: 'User Profile',
        icon: '👤',
        description: 'Basic user information',
        model: ProjectDataModel(
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
        model: ProjectDataModel(
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
        model: ProjectDataModel(
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
}

class _ModelTemplate {
  final String name;
  final String icon;
  final String description;
  final ProjectDataModel model;

  const _ModelTemplate({
    required this.name,
    required this.icon,
    required this.description,
    required this.model,
  });
}
