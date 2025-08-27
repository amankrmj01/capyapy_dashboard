part of 'projects_bloc.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class LoadProjects extends ProjectsEvent {
  const LoadProjects();
}

class RefreshProjects extends ProjectsEvent {
  const RefreshProjects();
}

class DeleteProject extends ProjectsEvent {
  final String projectId;

  const DeleteProject(this.projectId);

  @override
  List<Object> get props => [projectId];
}
