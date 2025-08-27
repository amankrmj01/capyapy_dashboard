import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class GetProjectsWithMostApiCallsUseCase {
  final ProjectRepository repository;

  GetProjectsWithMostApiCallsUseCase({required this.repository});

  Future<List<ProjectModel>> call({int limit = 10}) async {
    return await repository.getProjectsWithMostApiCalls(limit: limit);
  }
}
