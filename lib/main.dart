import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'core/di/services/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/theme_cubit.dart';

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
        // Add this line
        // Add other BLoC providers here as you create them
        // BlocProvider<AuthBloc>(
        //   create: (context) => sl<AuthBloc>(),
        // ),
        // BlocProvider<ApiBloc>(
        //   create: (context) => sl<ApiBloc>(),
        // ),
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
