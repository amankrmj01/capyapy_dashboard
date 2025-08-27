import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class AddDataModelUseCase {
  final ProjectRepository repository;

  AddDataModelUseCase({required this.repository});

  Future<ProjectModel> call(
    String projectId,
    ProjectDataModel dataModel,
  ) async {
    return await repository.addDataModel(projectId, dataModel);
  }
}
