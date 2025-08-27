import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class UpdateProjectUseCase {
  final ProjectRepository repository;

  UpdateProjectUseCase({required this.repository});

  Future<Project> call(Project project) async {
    return await repository.updateProject(project);
  }
}
