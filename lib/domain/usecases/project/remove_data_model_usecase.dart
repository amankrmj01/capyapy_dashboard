import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class RemoveDataModelUseCase {
  final ProjectRepository repository;

  RemoveDataModelUseCase({required this.repository});

  Future<Project> call(String projectId, int index) async {
    return await repository.removeDataModel(projectId, index);
  }
}
