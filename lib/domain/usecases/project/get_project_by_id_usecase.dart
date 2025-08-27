import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class GetProjectByIdUseCase {
  final ProjectRepository repository;

  GetProjectByIdUseCase({required this.repository});

  Future<Project?> call(String id) async {
    return await repository.getProjectById(id);
  }
}
