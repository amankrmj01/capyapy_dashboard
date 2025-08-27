part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProjectIdsLoaded extends UserState {
  final List<String> projectIds;

  ProjectIdsLoaded(this.projectIds);

  @override
  List<Object?> get props => [projectIds];
}

class ProjectIdAdded extends UserState {
  final String projectId;

  ProjectIdAdded(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class ProjectIdRemoved extends UserState {
  final String projectId;

  ProjectIdRemoved(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class ProjectIdError extends UserState {
  final String message;

  ProjectIdError(this.message);

  @override
  List<Object?> get props => [message];
}
