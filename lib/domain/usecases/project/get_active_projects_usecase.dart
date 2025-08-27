import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class GetActiveProjectsUseCase {
  final ProjectRepository repository;

  GetActiveProjectsUseCase({required this.repository});

  Future<List<ProjectModel>> call() async {
    return await repository.getActiveProjects();
  }
}
