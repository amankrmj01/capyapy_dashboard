import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../bloc/project_details/project_details_bloc.dart';
import '../../bloc/project_details/project_details_event.dart';
import '../../bloc/project_details/project_details_state.dart';
import 'widgets/project_overview_section.dart';
import 'widgets/data_models_section.dart';
import 'widgets/endpoints_section.dart';
import 'widgets/project_settings_section.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;
  final Function(Project)? onProjectUpdated;

  const ProjectDetailsPage({
    super.key,
    required this.project,
    this.onProjectUpdated,
  });

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Initialize BLoC with the project data
    context.read<ProjectDetailsBloc>().add(UpdateProject(widget.project));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateProject(Project updatedProject) {
    context.read<ProjectDetailsBloc>().add(UpdateProject(updatedProject));
    widget.onProjectUpdated?.call(updatedProject);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectDetailsBloc()..add(UpdateProject(widget.project)),
      child: BlocConsumer<ProjectDetailsBloc, ProjectDetailsState>(
        listener: (context, state) {
          if (state is ProjectDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.inter()),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProjectDeleted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Project deleted successfully',
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProjectDetailsLoading) {
            return Scaffold(
              backgroundColor: AppColors.background(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProjectDetailsError) {
            return Scaffold(
              backgroundColor: AppColors.background(context),
              appBar: AppBar(
                backgroundColor: AppColors.surface(context),
                title: Text(
                  'Error',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Project',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final currentProject = state is ProjectDetailsLoaded
              ? state.project
              : state is ProjectDetailsUpdating
              ? state.project
              : widget.project;

          return Scaffold(
            backgroundColor: AppColors.background(context),
            appBar: AppBar(
              backgroundColor: AppColors.surface(context),
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: state is ProjectDetailsUpdating
                          ? Colors.orange
                          : AppColors.primary(context),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentProject.projectName,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      Text(
                        state is ProjectDetailsUpdating
                            ? 'Updating...'
                            : 'Project Details',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: state is ProjectDetailsUpdating
                              ? Colors.orange
                              : AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary(context),
                unselectedLabelColor: AppColors.textSecondary(context),
                indicatorColor: AppColors.primary(context),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Data Models'),
                  Tab(text: 'Endpoints'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                ProjectOverviewSection(
                  project: currentProject,
                  onProjectUpdated: _updateProject,
                ),
                DataModelsSection(
                  project: currentProject,
                  onProjectUpdated: _updateProject,
                ),
                EndpointsSection(
                  project: currentProject,
                  onProjectUpdated: _updateProject,
                ),
                ProjectSettingsSection(
                  project: currentProject,
                  onProjectUpdated: _updateProject,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
