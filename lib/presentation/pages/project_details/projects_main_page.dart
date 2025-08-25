import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/data_models_section.dart';
import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/endpoints_section.dart';
import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/project_details_sidebar.dart';
import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/project_overview_section.dart';
import 'package:capyapy_dashboard/presentation/pages/project_details/widgets/project_settings_section.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';

class ProjectMainPage extends StatefulWidget {
  final Project project;
  final Function(Project)? onProjectUpdated;

  const ProjectMainPage({
    super.key,
    required this.project,
    this.onProjectUpdated,
  });

  @override
  State<ProjectMainPage> createState() => _ProjectMainPageState();
}

class _ProjectMainPageState extends State<ProjectMainPage> {
  int _selectedIndex = 0;

  Function(Project) get _onProjectUpdated => widget.onProjectUpdated ?? (p) {};

  List<Widget> get _pages => [
    ProjectOverviewSection(
      project: widget.project,
      onProjectUpdated: _onProjectUpdated,
    ),
    DataModelsSection(
      project: widget.project,
      onProjectUpdated: _onProjectUpdated,
    ),
    EndpointsSection(
      project: widget.project,
      onProjectUpdated: _onProjectUpdated,
    ),
    ProjectSettingsSection(
      project: widget.project,
      onProjectUpdated: _onProjectUpdated,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Row(
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
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
