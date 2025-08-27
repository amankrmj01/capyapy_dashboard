import '../../repositories/project_repository.dart';

class GetTotalModelsUseCase {
  final ProjectRepository repository;

  GetTotalModelsUseCase(this.repository);

  Future<int> call() async {
    return await repository.getTotalModels();
  }
}
