import '../../repositories/project_repository.dart';

class GetTotalEndpointsUseCase {
  final ProjectRepository repository;

  GetTotalEndpointsUseCase(this.repository);

  Future<int> call() async {
    return await repository.getTotalEndpoints();
  }
}
