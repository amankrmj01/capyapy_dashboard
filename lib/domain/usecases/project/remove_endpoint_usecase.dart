import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class RemoveEndpointUseCase {
  final ProjectRepository repository;

  RemoveEndpointUseCase({required this.repository});

  Future<Project> call(String projectId, int index) async {
    return await repository.removeEndpoint(projectId, index);
  }
}
