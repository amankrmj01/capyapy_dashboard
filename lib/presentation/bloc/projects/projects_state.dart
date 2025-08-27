part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectModel> projects;
  final int totalProjects;
  final int activeProjects;
  final int totalEndpoints;
  final int totalModels;
  final int totalApiCalls;

  const ProjectsLoaded({
    required this.projects,
    required this.totalProjects,
    required this.activeProjects,
    required this.totalEndpoints,
    required this.totalModels,
    required this.totalApiCalls,
  });

  @override
  List<Object> get props => [
    projects,
    totalProjects,
    activeProjects,
    totalEndpoints,
    totalModels,
    totalApiCalls,
  ];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object> get props => [message];
}
