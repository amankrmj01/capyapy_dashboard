import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase({required this.repository});

  Future<ProjectModel> call(ProjectModel project) async {
    return await repository.createProject(project);
  }
}
