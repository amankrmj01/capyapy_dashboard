import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/project_model.dart';
import '../../presentation/pages/billings/billing_page.dart';
import '../../presentation/pages/main_page.dart';
import '../../presentation/pages/project_details/project_details_page.dart';
import '../../presentation/bloc/project_details/project_details_bloc.dart';
import '../../presentation/pages/projects/projects_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/settings/settings_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainPage(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const DashboardPage()),
        ),
        GoRoute(
          path: '/dashboard/project',
          builder: (context, state) => const ProjectsPage(),
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const ProjectsPage()),
        ),
        GoRoute(
          path: '/dashboard/billing',
          builder: (context, state) => const BillingPage(),
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const BillingPage()),
        ),
        GoRoute(
          path: '/dashboard/settings',
          builder: (context, state) => const SettingsPage(),
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const SettingsPage()),
        ),
      ],
    ),
    GoRoute(
      path: '/dashboard/project/:id',
      builder: (context, state) {
        final project = state.extra as Project?;
        return BlocProvider<ProjectDetailsBloc>(
          create: (_) => ProjectDetailsBloc(),
          child: ProjectDetailsPage(project: project!),
        );
      },
    ),
  ],
);
