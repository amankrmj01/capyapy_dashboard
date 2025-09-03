import 'package:capyapy_dashboard/data/repositories/user_repository_impl.dart';
import 'package:capyapy_dashboard/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'core/di/services/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/theme_cubit.dart';
import 'data/datasource/user/mock_user_data.dart';
import 'data/repositories/project_repository_impl.dart';
import 'data/datasource/mock_project_data_source.dart';
import 'presentation/bloc/projects/projects_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const CapyAPYApp());
}

class CapyAPYApp extends StatelessWidget {
  const CapyAPYApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => sl<ThemeCubit>()),

        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            userRepository: UserRepositoryImpl(userData: sl<MockUserData>()),
          ),
        ),

        BlocProvider<ProjectsBloc>(
          create: (context) => ProjectsBloc(
            projectRepository: ProjectRepositoryImpl(
              dataSource: sl<MockProjectDataSource>(),
            ),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode == AppThemeMode.light
                ? ThemeMode.light
                : ThemeMode.dark,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
