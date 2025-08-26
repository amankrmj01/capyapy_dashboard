import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/project_details_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/project_details/project_details_bloc.dart';
import '../../bloc/project_details/project_details_event.dart';
import '../../bloc/project_details/project_details_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
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

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Dispatch LoadProjectDetails event when the page is initialized
    context.read<ProjectDetailsBloc>().add(
      LoadProjectDetails(widget.project.id),
    );
  }

  Function(Project) get _onProjectUpdated => widget.onProjectUpdated ?? (p) {};

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
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
            return Row(
              children: [
                if (isDesktop)
                  ProjectDetailsSidebar(
                    selectedIndex: _selectedIndex,
                    onItemSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                Expanded(child: _pagesBuilder(project)),
              ],
            );
          } else {
            return Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _pagesBuilder(Project project) {
    final pages = [
      ProjectOverviewSection(
        project: project,
        onProjectUpdated: _onProjectUpdated,
      ),
      DataModelsSection(project: project, onProjectUpdated: _onProjectUpdated),
      EndpointsSection(project: project, onProjectUpdated: _onProjectUpdated),
      ProjectSettingsSection(
        project: project,
        onProjectUpdated: _onProjectUpdated,
      ),
    ];
    return pages[_selectedIndex];
  }
}
