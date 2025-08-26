import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/project_model.dart';
import 'widgets/widgets.dart';
import '../../../core/constants/app_colors.dart';

class ProjectShellPage extends StatelessWidget {
  final Widget child;

  const ProjectShellPage({super.key, required this.child});

  int _getSidebarIndex(String location) {
    if (location.contains('/data-models')) {
      return 1;
    } else if (location.contains('/endpoints')) {
      return 2;
    } else if (location.contains('/settings')) {
      return 3;
    }
    return 0;
  }

  void _onSidebarItemSelected(BuildContext context, int index) {
    final location = GoRouterState.of(context).uri.toString();
    final project = GoRouterState.of(context).extra as Project?;
    final projectId = _extractProjectId(location);
    if (project == null || projectId == null) return;
    if (index == 0) {
      context.go('/dashboard/project/$projectId', extra: project);
    } else if (index == 1) {
      context.go('/dashboard/project/$projectId/data-models', extra: project);
    } else if (index == 2) {
      context.go('/dashboard/project/$projectId/endpoints', extra: project);
    } else if (index == 3) {
      context.go('/dashboard/project/$projectId/settings', extra: project);
    }
  }

  String? _extractProjectId(String location) {
    final regExp = RegExp(r'/dashboard/project/(\w+)');
    final match = regExp.firstMatch(location);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final location = GoRouterState.of(context).uri.toString();
    final sidebarIndex = _getSidebarIndex(location);
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Row(
        children: [
          if (isDesktop)
            ProjectDetailsSidebar(
              selectedIndex: sidebarIndex,
              onItemSelected: (index) => _onSidebarItemSelected(context, index),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
