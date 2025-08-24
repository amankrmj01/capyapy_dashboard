import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/bloc/dashboard/dashboard_bloc.dart';
import '../../presentation/pages/dashboard/dashboard_page.dart';
import '../../presentation/pages/main_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const MainPage())],
);
