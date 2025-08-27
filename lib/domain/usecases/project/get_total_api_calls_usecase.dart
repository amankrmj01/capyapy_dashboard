import '../../repositories/project_repository.dart';

class GetTotalApiCallsUseCase {
  final ProjectRepository repository;

  GetTotalApiCallsUseCase(this.repository);

  Future<int> call() async {
    return await repository.getTotalApiCalls();
  }
}
