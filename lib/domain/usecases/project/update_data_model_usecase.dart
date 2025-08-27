import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class UpdateDataModelUseCase {
  final ProjectRepository repository;

  UpdateDataModelUseCase({required this.repository});

  Future<ProjectModel> call(
    String projectId,
    int index,
    ProjectDataModel dataModel,
  ) async {
    return await repository.updateDataModel(projectId, index, dataModel);
  }
}
