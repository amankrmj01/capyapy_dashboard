import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class AddEndpointUseCase {
  final ProjectRepository repository;

  AddEndpointUseCase({required this.repository});

  Future<ProjectModel> call(String projectId, ProjectEndpoint endpoint) async {
    return await repository.addEndpoint(projectId, endpoint);
  }
}
