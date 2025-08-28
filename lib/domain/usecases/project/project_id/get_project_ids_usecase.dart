import '../../../../data/models/project/project_model.dart';
import '../../../repositories/project_repository.dart';

class GetProjectIdUseCase {
  final ProjectRepository repository;

  GetProjectIdUseCase({required this.repository});

  Future<List<ProjectModel>> call(List<String> projectIds) async {
    return await repository.getProjectsByIds(projectIds);
  }
}
