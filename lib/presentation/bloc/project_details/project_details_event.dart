part of 'project_details_bloc.dart';

abstract class ProjectDetailsEvent extends Equatable {
  const ProjectDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProjectDetails extends ProjectDetailsEvent {
  final String projectId;

  const LoadProjectDetails(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class UpdateProject extends ProjectDetailsEvent {
  final ProjectModel project;

  const UpdateProject(this.project);

  @override
  List<Object?> get props => [project];
}

class AddDataModel extends ProjectDetailsEvent {
  final DataModel dataModel;

  const AddDataModel(this.dataModel);

  @override
  List<Object?> get props => [dataModel];
}

class UpdateDataModel extends ProjectDetailsEvent {
  final int index;
  final DataModel dataModel;

  const UpdateDataModel(this.index, this.dataModel);

  @override
  List<Object?> get props => [index, dataModel];
}

class DeleteDataModel extends ProjectDetailsEvent {
  final int index;

  const DeleteDataModel(this.index);

  @override
  List<Object?> get props => [index];
}

class AddEndpoint extends ProjectDetailsEvent {
  final Endpoint endpoint;

  const AddEndpoint(this.endpoint);

  @override
  List<Object?> get props => [endpoint];
}

class UpdateEndpoint extends ProjectDetailsEvent {
  final int index;
  final Endpoint endpoint;

  const UpdateEndpoint(this.index, this.endpoint);

  @override
  List<Object?> get props => [index, endpoint];
}

class DeleteEndpoint extends ProjectDetailsEvent {
  final int index;

  const DeleteEndpoint(this.index);

  @override
  List<Object?> get props => [index];
}

class DeleteProject extends ProjectDetailsEvent {
  final String projectId;

  const DeleteProject(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
