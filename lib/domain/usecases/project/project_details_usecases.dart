import 'export_project_usecases.dart';
import '../../repositories/project_repository.dart';

class ProjectDetailsUseCases {
  final AddDataModelUseCase addDataModel;
  final UpdateDataModelUseCase updateDataModel;
  final RemoveDataModelUseCase deleteDataModel;
  final AddEndpointUseCase addEndpoint;
  final UpdateEndpointUseCase updateEndpoint;
  final RemoveEndpointUseCase deleteEndpoint;

  ProjectDetailsUseCases(ProjectRepository repository)
    : addDataModel = AddDataModelUseCase(repository: repository),
      updateDataModel = UpdateDataModelUseCase(repository: repository),
      deleteDataModel = RemoveDataModelUseCase(repository: repository),
      addEndpoint = AddEndpointUseCase(repository: repository),
      updateEndpoint = UpdateEndpointUseCase(repository: repository),
      deleteEndpoint = RemoveEndpointUseCase(repository: repository);
}
