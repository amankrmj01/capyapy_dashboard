import '../../repositories/project_repository.dart';

class IncrementApiCallUseCase {
  final ProjectRepository repository;

  IncrementApiCallUseCase({required this.repository});

  Future<void> call(String projectId, String endpointId) async {
    await repository.incrementApiCall(projectId, endpointId);
  }
}
