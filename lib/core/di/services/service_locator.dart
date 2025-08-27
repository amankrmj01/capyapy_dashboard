import 'package:get_it/get_it.dart';
import '../../theme/theme_cubit.dart';
import '../../../data/datasource/mock_project_data_source.dart';
import '../../../data/datasource/mock_collection_store.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // BLoCs
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // Data sources
  sl.registerSingleton<MockProjectDataSource>(MockProjectDataSource());
  // Add other dependencies here as needed

  sl.registerSingleton<MockCollectionStore>(MockCollectionStore());
}
