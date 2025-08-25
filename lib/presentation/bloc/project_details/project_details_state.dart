import 'package:equatable/equatable.dart';
import '../../../data/models/project_model.dart';

abstract class ProjectDetailsState extends Equatable {
  const ProjectDetailsState();

  @override
  List<Object?> get props => [];
}

class ProjectDetailsInitial extends ProjectDetailsState {}

class ProjectDetailsLoading extends ProjectDetailsState {}

class ProjectDetailsLoaded extends ProjectDetailsState {
  final Project project;

  const ProjectDetailsLoaded(this.project);

  @override
  List<Object?> get props => [project];

  ProjectDetailsLoaded copyWith({Project? project}) {
    return ProjectDetailsLoaded(project ?? this.project);
  }
}

class ProjectDetailsError extends ProjectDetailsState {
  final String message;

  const ProjectDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectDeleted extends ProjectDetailsState {}

class ProjectDetailsUpdating extends ProjectDetailsState {
  final Project project;

  const ProjectDetailsUpdating(this.project);

  @override
  List<Object?> get props => [project];
}
