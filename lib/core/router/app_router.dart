import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/project_model.dart';
import '../../presentation/pages/main_page.dart';
import '../../presentation/pages/project_details/project_details_page.dart';
import '../../presentation/bloc/project_details/project_details_bloc.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/dashboard', builder: (context, state) => const MainPage()),
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
