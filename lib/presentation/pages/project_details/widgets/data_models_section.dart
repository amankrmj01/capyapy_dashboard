import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/data_models_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/k.showBlurredBackgroundGeneralDialog.dart';
import '../../../../data/models/models.dart';
import '../../../bloc/project_details/project_details_bloc.dart';
import '../../../bloc/project_details/project_details_event.dart';
import '../../../bloc/project_details/project_details_state.dart';
import 'data_model_editor_dialog.dart';
import '../../project_details/project_provider.dart';

class DataModelsSection extends StatefulWidget {
  final ProjectModel project;
  final Function(ProjectModel)? onProjectUpdated;

  const DataModelsSection({
    super.key,
    required this.project,
    this.onProjectUpdated,
  });

  @override
  State<DataModelsSection> createState() => _DataModelsSectionState();
}

class _DataModelsSectionState extends State<DataModelsSection> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectDetailsBloc>().add(
      LoadProjectDetails(widget.project.id),
    );
  }

  void _addNewDataModel() {
    final bloc = context.read<ProjectDetailsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => DataModelEditorDialog(
        onSave: (dataModel) {
          bloc.add(AddDataModel(dataModel));
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _editDataModel(int index, DataModel dataModel) {
    final bloc = context.read<ProjectDetailsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => DataModelEditorDialog(
        dataModel: dataModel,
        onSave: (updatedDataModel) {
          // Use the section's context which has access to ProjectDetailsBloc
          bloc.add(UpdateDataModel(index, updatedDataModel));
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _deleteDataModel(int index) {
    final bloc = context.read<ProjectDetailsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete Data Model',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${ProjectProvider.of(context)?.project.dataModels[index].modelName}"? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.textSecondary(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(DeleteDataModel(index));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
      builder: (context, state) {
        if (state is ProjectDetailsInitial || state is ProjectDetailsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProjectDetailsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ProjectDetailsLoaded ||
            state is ProjectDetailsUpdating) {
          final project = (state is ProjectDetailsLoaded)
              ? state.project
              : (state as ProjectDetailsUpdating).project;
          return Column(
            children: [
              _buildHeader(project),
              Expanded(
                child: project.dataModels.isEmpty
                    ? _buildEmptyState()
                    : _buildDataModelsList(project.dataModels),
              ),
            ],
          );
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildHeader(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(bottom: BorderSide(color: AppColors.border(context))),
      ),
      child: Row(
        children: [
          Text(
            'Data Models',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${project.dataModels.length}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.primary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _addNewDataModel,
            icon: const Icon(Icons.add, size: 18),
            label: Text('Add Model', style: GoogleFonts.inter(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart,
            size: 64,
            color: AppColors.textSecondary(context).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Data Models',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first data model to define the structure of your data.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary(context).withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addNewDataModel,
            icon: const Icon(Icons.add),
            label: Text('Create Data Model', style: GoogleFonts.inter()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataModelsList(List<DataModel> dataModels) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: dataModels.length,
      itemBuilder: (context, index) {
        final dataModel = dataModels[index];
        return _buildDataModelCard(index, dataModel);
      },
    );
  }

  Widget _buildDataModelCard(int index, DataModel dataModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary(context).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.table_chart,
                    color: AppColors.primary(context),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataModel.modelName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Collection: ${dataModel.collectionName}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${dataModel.fields.length} fields',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary(
                            context,
                          ).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    showBlurredBackGroundGeneralDialog(
                      context: context,
                      builder: (dialogContext) {
                        return DataModelsData(
                          collectionName: dataModel.collectionName,
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.show_chart, size: 18),
                  label: Text('Stats', style: GoogleFonts.inter(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface(context),
                    foregroundColor: AppColors.primary(context),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary(context),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.textPrimary(context),
                          ),
                          const SizedBox(width: 8),
                          Text('Edit', style: GoogleFonts.inter()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 16, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: GoogleFonts.inter(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editDataModel(index, dataModel);
                    } else if (value == 'delete') {
                      _deleteDataModel(index);
                    }
                  },
                ),
              ],
            ),
          ),
          if (dataModel.fields.isNotEmpty) _buildFieldsList(dataModel.fields),
        ],
      ),
    );
  }

  Widget _buildFieldsList(List<ModelField> fields) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border(context))),
      ),
      child: Column(
        children: fields.take(5).map((field) => _buildFieldRow(field)).toList()
          ..addAll([
            if (fields.length > 5)
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '... and ${fields.length - 5} more fields',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ]),
      ),
    );
  }

  Widget _buildFieldRow(ModelField field) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.border(context).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getFieldTypeColor(field.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              field.type.displayName,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: _getFieldTypeColor(field.type),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              field.name,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
          if (field.required)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'Required',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (field.unique) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'Unique',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
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
      case MongoDbFieldType.objectId:
        return Colors.red;
      case MongoDbFieldType.array:
        return Colors.teal;
      case MongoDbFieldType.object:
        return Colors.indigo;
      case MongoDbFieldType.buffer:
        return Colors.brown;
      case MongoDbFieldType.decimal:
        return Colors.cyan;
      case MongoDbFieldType.mixed:
        return Colors.grey;
      case MongoDbFieldType.map:
        return Colors.amber;
    }
  }
}
