import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class GetAllProjectsUseCase {
  final ProjectRepository repository;

  GetAllProjectsUseCase({required this.repository});

  Future<List<ProjectModel>> call() async {
    return await repository.getAllProjects();
  }
}
