import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../data/models/models.dart';
import '../../data/datasource/mock_collection_store.dart';
import '../../data/repositories/document_resources_repository_impl.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../../data/datasource/mock_project_data_source.dart';
import '../../domain/usecases/project/export_project_usecases.dart';
import '../../presentation/bloc/collection/collection_bloc.dart';
import '../../presentation/bloc/project_creation/project_creation_bloc.dart';
import '../../presentation/bloc/project_details/project_details_bloc.dart';
import '../../presentation/pages/billings/billing_page.dart';
import '../../presentation/pages/main_page.dart';
import '../../presentation/pages/project_details/project_shell_page.dart';
import '../../presentation/pages/project_details/widgets/data_models_section.dart';
import '../../presentation/pages/project_details/widgets/endpoints_section.dart';
import '../../presentation/pages/project_details/widgets/project_overview_section.dart';
import '../../presentation/pages/project_details/widgets/project_settings_section.dart';
import '../../presentation/pages/projects/projects_page.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/projects/widgets/project_creation_wizard.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../di/services/service_locator.dart';

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
          routes: [
            GoRoute(
              path: 'new',
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) => ProjectCreationBloc(
                    createProjectUseCase: CreateProjectUseCase(
                      repository: ProjectRepositoryImpl(
                        dataSource: sl<MockProjectDataSource>(), // Use DI
                      ),
                    ),
                  ),
                  child: ProjectCreationWizard(
                    onClose: () {
                      context.go('/dashboard/project');
                    },
                  ),
                ),
              ),
            ),
          ],
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
    ShellRoute(
      builder: (context, state, child) => ProjectShellPage(child: child),
      routes: [
        GoRoute(
          path: '/dashboard/project/:id',
          pageBuilder: (context, state) {
            final project = state.extra as ProjectModel?;
            final repository = ProjectRepositoryImpl(
              dataSource: sl<MockProjectDataSource>(),
            );
            final projectId = state.pathParameters['id']!;
            if (project != null) {
              return NoTransitionPage(
                child: BlocProvider<ProjectDetailsBloc>(
                  create: (_) => ProjectDetailsBloc(
                    repository,
                    ProjectDetailsUseCases(repository),
                  )..add(LoadProjectDetails(project.id)),
                  child: ProjectOverviewSection(
                    project: project,
                    onProjectUpdated: (updatedProject) {
                      context.read<ProjectDetailsBloc>().add(
                        UpdateProject(updatedProject),
                      );
                    },
                  ),
                ),
              );
            } else {
              return NoTransitionPage(
                child: FutureBuilder<ProjectModel?>(
                  future: repository.getProjectById(projectId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data == null) {
                      return Center(child: Text('Project not found'));
                    }
                    return BlocProvider<ProjectDetailsBloc>(
                      create: (_) => ProjectDetailsBloc(
                        repository,
                        ProjectDetailsUseCases(repository),
                      )..add(LoadProjectDetails(snapshot.data!.id)),
                      child: ProjectOverviewSection(
                        project: snapshot.data!,
                        onProjectUpdated: (updatedProject) {
                          context.read<ProjectDetailsBloc>().add(
                            UpdateProject(updatedProject),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
          routes: [
            GoRoute(
              path: 'data-models',
              pageBuilder: (context, state) {
                final project = state.extra as ProjectModel?;
                final repository = ProjectRepositoryImpl(
                  dataSource: sl<MockProjectDataSource>(),
                );
                final projectId = state.pathParameters['id']!;
                if (project != null) {
                  return NoTransitionPage(
                    child: BlocProvider<ProjectDetailsBloc>(
                      create: (_) => ProjectDetailsBloc(
                        repository,
                        ProjectDetailsUseCases(repository),
                      )..add(LoadProjectDetails(project.id)),
                      child: BlocProvider<CollectionBloc>(
                        create: (_) => CollectionBloc(
                          repository: DocumentResourcesRepositoryImpl(
                            store: sl<MockCollectionStore>(),
                          ),
                        ),
                        child: DataModelsSection(
                          project: project,
                          onProjectUpdated: (updatedProject) {
                            context.read<ProjectDetailsBloc>().add(
                              UpdateProject(updatedProject),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                } else {
                  return NoTransitionPage(
                    child: FutureBuilder<ProjectModel?>(
                      future: repository.getProjectById(projectId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.data == null) {
                          return Center(child: Text('Project not found'));
                        }
                        return BlocProvider<ProjectDetailsBloc>(
                          create: (_) => ProjectDetailsBloc(
                            repository,
                            ProjectDetailsUseCases(repository),
                          )..add(LoadProjectDetails(snapshot.data!.id)),
                          child: DataModelsSection(
                            project: snapshot.data!,
                            onProjectUpdated: (updatedProject) {
                              context.read<ProjectDetailsBloc>().add(
                                UpdateProject(updatedProject),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            GoRoute(
              path: 'endpoints',
              pageBuilder: (context, state) {
                final project = state.extra as ProjectModel?;
                final repository = ProjectRepositoryImpl(
                  dataSource: sl<MockProjectDataSource>(),
                );
                final projectId = state.pathParameters['id']!;
                if (project != null) {
                  return NoTransitionPage(
                    child: BlocProvider<ProjectDetailsBloc>(
                      create: (_) => ProjectDetailsBloc(
                        repository,
                        ProjectDetailsUseCases(repository),
                      )..add(LoadProjectDetails(project.id)),
                      child: EndpointsSection(
                        project: project,
                        onProjectUpdated: (updatedProject) {
                          context.read<ProjectDetailsBloc>().add(
                            UpdateProject(updatedProject),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return NoTransitionPage(
                    child: FutureBuilder<ProjectModel?>(
                      future: repository.getProjectById(projectId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.data == null) {
                          return Center(child: Text('Project not found'));
                        }
                        return BlocProvider<ProjectDetailsBloc>(
                          create: (_) => ProjectDetailsBloc(
                            repository,
                            ProjectDetailsUseCases(repository),
                          )..add(LoadProjectDetails(snapshot.data!.id)),
                          child: EndpointsSection(
                            project: snapshot.data!,
                            onProjectUpdated: (updatedProject) {
                              context.read<ProjectDetailsBloc>().add(
                                UpdateProject(updatedProject),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            GoRoute(
              path: 'settings',
              pageBuilder: (context, state) {
                final project = state.extra as ProjectModel?;
                final repository = ProjectRepositoryImpl(
                  dataSource: sl<MockProjectDataSource>(),
                );
                final projectId = state.pathParameters['id']!;
                if (project != null) {
                  return NoTransitionPage(
                    child: BlocProvider<ProjectDetailsBloc>(
                      create: (_) => ProjectDetailsBloc(
                        repository,
                        ProjectDetailsUseCases(repository),
                      )..add(LoadProjectDetails(project.id)),
                      child: ProjectSettingsSection(
                        project: project,
                        onProjectUpdated: (updatedProject) {
                          context.read<ProjectDetailsBloc>().add(
                            UpdateProject(updatedProject),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return NoTransitionPage(
                    child: FutureBuilder<ProjectModel?>(
                      future: repository.getProjectById(projectId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.data == null) {
                          return Center(child: Text('Project not found'));
                        }
                        return BlocProvider<ProjectDetailsBloc>(
                          create: (_) => ProjectDetailsBloc(
                            repository,
                            ProjectDetailsUseCases(repository),
                          )..add(LoadProjectDetails(snapshot.data!.id)),
                          child: ProjectSettingsSection(
                            project: snapshot.data!,
                            onProjectUpdated: (updatedProject) {
                              context.read<ProjectDetailsBloc>().add(
                                UpdateProject(updatedProject),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
