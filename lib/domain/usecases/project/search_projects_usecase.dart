import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class SearchProjectsUseCase {
  final ProjectRepository repository;

  SearchProjectsUseCase({required this.repository});

  Future<List<Project>> call(String query) async {
    return await repository.searchProjects(query);
  }
}
