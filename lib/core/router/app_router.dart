import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../data/datasources/mock_project_data_source.dart';
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
          routes: [
            GoRoute(
              path: 'edit-profile',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final nameController =
                    extra?['nameController'] as TextEditingController?;
                final emailController =
                    extra?['emailController'] as TextEditingController?;
                final onUpdate = extra?['onUpdate'] as VoidCallback?;
                return ProfileEditPage(
                  nameController: nameController!,
                  emailController: emailController!,
                  onUpdate: onUpdate!,
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/dashboard/project/:id',
      builder: (context, state) {
        final project = state.extra as Project?;
        return BlocProvider<ProjectDetailsBloc>(
          create: (_) => ProjectDetailsBloc(
            ProjectRepositoryImpl(dataSource: MockProjectDataSource()),
          ),
          child: ProjectDetailsPage(project: project!),
        );
      },
    ),
  ],
);
