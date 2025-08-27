import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class UpdateProjectSettingsUseCase {
  final ProjectRepository repository;

  UpdateProjectSettingsUseCase({required this.repository});

  Future<ProjectModel> call(
    String projectId, {
    String? projectName,
    String? description,
    String? apiBasePath,
    bool? isActive,
    bool? hasAuth,
    AuthStrategy? authStrategy,
    StorageConfig? storage,
    ProjectMetadata? metadata,
  }) async {
    return await repository.updateProjectSettings(
      projectId,
      projectName: projectName,
      description: description,
      apiBasePath: apiBasePath,
      isActive: isActive,
      hasAuth: hasAuth,
      authStrategy: authStrategy,
      storage: storage,
      metadata: metadata,
    );
  }
}
