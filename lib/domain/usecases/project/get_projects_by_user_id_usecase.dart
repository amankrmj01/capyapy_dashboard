import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class GetProjectsByUserIdUseCase {
  final ProjectRepository repository;

  GetProjectsByUserIdUseCase({required this.repository});

  Future<List<ProjectModel>> call(String userId) async {
    return await repository.getProjectsByUserId(userId);
  }
}
