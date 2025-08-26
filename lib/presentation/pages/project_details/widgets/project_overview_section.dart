import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/project_model.dart';
import '../../../bloc/build/build_event.dart';
import '../../../bloc/build/build_state.dart';
import '../../../bloc/project_details/project_details_bloc.dart';
import '../../../bloc/project_details/project_details_state.dart';
import '../../../bloc/project_details/project_details_event.dart';
import '../../../bloc/build/build_bloc.dart';
import 'dart:convert';

class ProjectOverviewSection extends StatefulWidget {
  final Project project;
  final Function(Project)? onProjectUpdated;

  const ProjectOverviewSection({
    super.key,
    required this.project,
    required this.onProjectUpdated,
  });

  @override
  State<ProjectOverviewSection> createState() => _ProjectOverviewSectionState();
}

class _ProjectOverviewSectionState extends State<ProjectOverviewSection> {
  late TextEditingController _nameController;
  late TextEditingController _basePathController;
  late TextEditingController _descriptionController;
  bool _hasAuth = false;

  @override
  void initState() {
    super.initState();
    context.read<ProjectDetailsBloc>().add(
      LoadProjectDetails(widget.project.id),
    );
    _nameController = TextEditingController();
    _basePathController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void _updateControllers(Project project) {
    _nameController.text = project.projectName;
    _basePathController.text = project.apiBasePath;
    _descriptionController.text = project.description;
    _hasAuth = project.hasAuth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _basePathController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges(Project project) {
    final updatedProject = project.copyWith(
      projectName: _nameController.text,
      apiBasePath: _basePathController.text,
      hasAuth: _hasAuth,
      updatedAt: DateTime.now(),
    );
    widget.onProjectUpdated!(updatedProject);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BuildBloc>(
      create: (_) => BuildBloc(),
      child: Builder(
        builder: (context) {
          return BlocListener<BuildBloc, BuildState>(
            listener: (context, state) {
              if (state is BuildSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Successfully built!')));
              }
            },
            child: BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
              builder: (context, state) {
                if (state is ProjectDetailsInitial ||
                    state is ProjectDetailsLoading) {
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
                        _buildOverviewCards(project),
                        const SizedBox(height: 32),
                        _buildProjectBasics(project),
                        const SizedBox(height: 32),
                        _buildProjectStats(project),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('Unknown state'));
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(Project project) {
    return BlocBuilder<BuildBloc, BuildState>(
      builder: (context, buildState) {
        return Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Data Models',
                project.dataModels.length.toString(),
                Icons.table_chart,
                AppColors.primary(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Endpoints',
                project.endpoints.length.toString(),
                Icons.api,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Auth Required',
                project.hasAuth ? 'Yes' : 'No',
                Icons.security,
                project.hasAuth ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildDownloadBuildCard(project)),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectBasics(Project project) {
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
          Text(
            'Project Configuration',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            'Project Name',
            _nameController,
            'Enter project name',
          ),
          const SizedBox(height: 16),
          _buildTextField('Base Path', _basePathController, 'e.g., /api/v1'),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _hasAuth,
                onChanged: (value) {
                  setState(() {
                    _hasAuth = value ?? false;
                  });
                },
                activeColor: AppColors.primary(context),
              ),
              Text(
                'Enable Authentication',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Reset to original values
                  setState(() {
                    _updateControllers(project);
                  });
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _saveChanges(project),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: Colors.white,
                ),
                child: Text('Save Changes', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectStats(Project project) {
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
          Text(
            'Project Metadata',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          _buildMetadataRow('Created By', project.metadata.createdBy),
          _buildMetadataRow(
            'Created At',
            '${project.metadata.createdAt.day}/${project.metadata.createdAt.month}/${project.metadata.createdAt.year}',
          ),
          _buildMetadataRow('Project ID', project.id),
          if (project.metadata.tags.isNotEmpty) _buildTagsRow(project),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsRow(Project project) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Tags',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.metadata.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary(
                          context,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.primary(context),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadBuildCard(Project project) {
    return SizedBox(
      height: 110, // Match info card height
      child: AspectRatio(
        aspectRatio: 1.8, // Match info card width ratio
        child: BlocProvider<BuildBloc>(
          create: (_) => BuildBloc(),
          child: BlocConsumer<BuildBloc, BuildState>(
            listener: (context, state) {
              if (state is BuildSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Successfully built!')));
              }
            },
            builder: (context, buildState) {
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: buildState is BuildInProgress
                    ? null
                    : () {
                        context.read<BuildBloc>().add(StartBuild(project));
                      },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: buildState is BuildSuccess
                              ? [Colors.green.shade400, Colors.green.shade700]
                              : [Colors.blue.shade400, Colors.blue.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 51),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  buildState is BuildSuccess
                                      ? Icons.check_circle
                                      : Icons.download,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Download Build',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              buildState is BuildSuccess
                                  ? 'Build Ready!'
                                  : buildState is BuildInProgress
                                  ? 'Building...'
                                  : 'Tap to Download',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (buildState is BuildInProgress)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
