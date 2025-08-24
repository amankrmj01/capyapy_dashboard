import 'package:get_it/get_it.dart';
import '../../theme/theme_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // BLoCs
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // Add other dependencies here as needed
}
