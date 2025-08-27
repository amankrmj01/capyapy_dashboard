import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class GetProjectsByStatusUseCase {
  final ProjectRepository repository;

  GetProjectsByStatusUseCase({required this.repository});

  Future<List<ProjectModel>> call(bool isActive) async {
    return await repository.getProjectsByStatus(isActive);
  }
}
