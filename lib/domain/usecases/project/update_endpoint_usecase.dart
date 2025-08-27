import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class UpdateEndpointUseCase {
  final ProjectRepository repository;

  UpdateEndpointUseCase({required this.repository});

  Future<Project> call(
    String projectId,
    int index,
    ProjectEndpoint endpoint,
  ) async {
    return await repository.updateEndpoint(projectId, index, endpoint);
  }
}
