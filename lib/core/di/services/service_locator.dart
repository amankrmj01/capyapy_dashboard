import 'package:get_it/get_it.dart';
import '../../theme/theme_cubit.dart';
import '../../../data/datasources/mock_project_data_source.dart';
import '../../../data/datasources/mock_collection_store.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // BLoCs
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // Data sources
  sl.registerSingleton<MockProjectDataSource>(MockProjectDataSource());
  // Add other dependencies here as needed

  sl.registerSingleton(MockCollectionStore());
  // sl.registerLazySingleton<GenericResourcesRepository>(
  //   () => GenericResourcesRepositoryImpl(store: sl<MockCollectionStore>()),
  // );
  //
  // // Register use cases
  // sl.registerLazySingleton(() => GetAllDocumentsUseCase(sl()));
  // sl.registerLazySingleton(() => AddDocumentUseCase(sl()));
  // sl.registerLazySingleton(() => UpdateDocumentUseCase(sl()));
  // sl.registerLazySingleton(() => DeleteDocumentUseCase(sl()));
  //
  // sl.registerFactory(
  //   () => GenericCollectionBloc(
  //     getAllDocuments: sl(),
  //     addDocument: sl(),
  //     updateDocument: sl(),
  //     deleteDocument: sl(),
  //   ),
  // );
}
