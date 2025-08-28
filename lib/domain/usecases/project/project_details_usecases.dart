import 'package:capyapy_dashboard/domain/usecases/project/project_id/get_project_ids_usecase.dart';

import 'export_project_usecases.dart';
import '../../repositories/project_repository.dart';

class ProjectDetailsUseCases {
  final AddDataModelUseCase addDataModel;
  final UpdateDataModelUseCase updateDataModel;
  final RemoveDataModelUseCase deleteDataModel;
  final AddEndpointUseCase addEndpoint;
  final UpdateEndpointUseCase updateEndpoint;
  final RemoveEndpointUseCase deleteEndpoint;
  final GetProjectByIdUseCase getProjectById;

  ProjectDetailsUseCases(ProjectRepository repository)
    : addDataModel = AddDataModelUseCase(repository: repository),
      updateDataModel = UpdateDataModelUseCase(repository: repository),
      deleteDataModel = RemoveDataModelUseCase(repository: repository),
      addEndpoint = AddEndpointUseCase(repository: repository),
      updateEndpoint = UpdateEndpointUseCase(repository: repository),
      getProjectById = GetProjectByIdUseCase(repository: repository),
      deleteEndpoint = RemoveEndpointUseCase(repository: repository);
}
