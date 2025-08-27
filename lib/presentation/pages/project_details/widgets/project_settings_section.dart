import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/project_details/project_details_bloc.dart';
import '../../../bloc/project_details/project_details_state.dart';
import '../../../bloc/project_details/project_details_event.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../../data/models/models.dart';
import '../project_provider.dart';

class ProjectSettingsSection extends StatefulWidget {
  final ProjectModel project;
  final Function(ProjectModel)? onProjectUpdated;

  const ProjectSettingsSection({
    super.key,
    required this.project,
    this.onProjectUpdated,
  });

  @override
  State<ProjectSettingsSection> createState() => _ProjectSettingsSectionState();
}

class _ProjectSettingsSectionState extends State<ProjectSettingsSection> {
  late TextEditingController _tagsController;
  late StorageType _storageType;
  late AuthType _authType;
  late List<String> _authRequiredFields;

  @override
  void initState() {
    super.initState();
    context.read<ProjectDetailsBloc>().add(
      LoadProjectDetails(widget.project.id),
    );
    _tagsController = TextEditingController();
    _storageType = widget.project.storage.type;
    _authType = widget.project.authStrategy?.type ?? AuthType.bearer;
    _authRequiredFields = widget.project.authStrategy?.requiredFields ?? [];
  }

  void _updateControllers(ProjectModel project) {
    _tagsController.text = project.metadata.tags.join(', ');
    _storageType = project.storage.type;
    _authType = project.authStrategy?.type ?? AuthType.bearer;
    _authRequiredFields = project.authStrategy?.requiredFields ?? [];
  }

  @override
  void dispose() {
    _tagsController.dispose();
    super.dispose();
  }

  void _saveSettings(ProjectModel project) {
    _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    final updatedProject = project.copyWith(
      authStrategy: project.hasAuth
          ? AuthStrategy(
              type: _authType,
              config: project.authStrategy?.config ?? {},
              requiredFields: _authRequiredFields,
            )
          : null,
      storage: StorageConfig(
        type: _storageType,
        connectionString: project.storage.connectionString,
        databaseName: project.storage.databaseName,
      ),
      metadata: project.metadata,
    );
    widget.onProjectUpdated?.call(updatedProject);
  }

  void _addAuthRequiredField() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(
            'Add Required Field',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Field Name',
              hintText: 'e.g., username, email, role',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _authRequiredFields.add(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: Colors.white,
              ),
              child: Text('Add', style: GoogleFonts.inter()),
            ),
          ],
        );
      },
    );
  }

  void _removeAuthRequiredField(int index) {
    setState(() {
      _authRequiredFields.removeAt(index);
    });
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
          _updateControllers(project);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuthenticationSettings(),
                const SizedBox(height: 32),
                _buildStorageSettings(),
                const SizedBox(height: 32),
                _buildProjectTags(),
                const SizedBox(height: 32),
                _buildDangerZone(),
                const SizedBox(height: 32),
                _buildSaveButton(project),
              ],
            ),
          );
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildAuthenticationSettings() {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Icon(Icons.security, color: AppColors.primary(context), size: 20),
              const SizedBox(width: 12),
              Text(
                'Authentication Settings',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!(ProjectProvider.of(context)?.project.hasAuth ?? false))
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Authentication is disabled for this project. Enable it in the Overview tab to configure auth settings.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authentication Type',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<AuthType>(
                  initialValue: _authType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: AuthType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.name.toUpperCase(),
                        style: GoogleFonts.inter(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _authType = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Required Fields',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _addAuthRequiredField,
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(
                        'Add Field',
                        style: GoogleFonts.inter(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_authRequiredFields.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border(context)),
                    ),
                    child: Center(
                      child: Text(
                        'No required fields defined',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _authRequiredFields.asMap().entries.map((entry) {
                      final index = entry.key;
                      final field = entry.value;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary(
                            context,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              field,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.primary(context),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => _removeAuthRequiredField(index),
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.primary(context),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStorageSettings() {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Icon(Icons.storage, color: AppColors.primary(context), size: 20),
              const SizedBox(width: 12),
              Text(
                'Storage Configuration',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Storage Type',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<StorageType>(
                initialValue: _storageType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: StorageType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type.name.toUpperCase(),
                      style: GoogleFonts.inter(),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _storageType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Connection String',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Read-only connection string',
                  suffixIcon: const Icon(Icons.lock_outline),
                ),
                controller: TextEditingController(
                  text:
                      ProjectProvider.of(
                            context,
                          )?.project.storage.connectionString.isEmpty ??
                          true
                      ? 'Not configured'
                      : '••••••••••••••••',
                ),
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 16),
              Text(
                'Database Name',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Read-only database name',
                  suffixIcon: const Icon(Icons.lock_outline),
                ),
                controller: TextEditingController(
                  text:
                      ProjectProvider.of(
                            context,
                          )?.project.storage.databaseName.isEmpty ??
                          true
                      ? 'Not configured'
                      : ProjectProvider.of(
                          context,
                        )?.project.storage.databaseName,
                ),
                style: GoogleFonts.inter(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectTags() {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Icon(Icons.label, color: AppColors.primary(context), size: 20),
              const SizedBox(width: 12),
              Text(
                'Project Tags',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              labelText: 'Tags (comma-separated)',
              hintText: 'e.g., api, backend, production',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              helperText: 'Separate multiple tags with commas',
            ),
            style: GoogleFonts.inter(),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 20),
              const SizedBox(width: 12),
              Text(
                'Danger Zone',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Irreversible and destructive actions',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.red.shade700),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete Project',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Once deleted, this project and all its data will be permanently removed. This action cannot be undone.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Delete Project',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Are you absolutely sure you want to delete "${ProjectProvider.of(context)?.project.projectName}"?',
                            style: GoogleFonts.inter(),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This will permanently delete:',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• ${ProjectProvider.of(context)?.project.mongoDbDataModels.length} data models',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          Text(
                            '• ${ProjectProvider.of(context)?.project.endpoints.length} endpoints',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          Text(
                            '• All project configuration',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This action cannot be undone.',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.pop(context); // Close project details
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Project "${ProjectProvider.of(context)?.project.projectName}" deleted',
                                  style: GoogleFonts.inter(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Delete Project',
                            style: GoogleFonts.inter(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('Delete Project', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(ProjectModel project) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _saveSettings(project),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary(context),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Save Settings',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
