part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  final String userId;

  LoadUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUser extends UserEvent {
  final User user;

  UpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}

class LogoutUser extends UserEvent {}

class AddProjectId extends UserEvent {
  final String userId;
  final String projectId;

  AddProjectId(this.userId, this.projectId);

  @override
  List<Object?> get props => [userId, projectId];
}

class RemoveProjectId extends UserEvent {
  final String userId;
  final String projectId;

  RemoveProjectId(this.userId, this.projectId);

  @override
  List<Object?> get props => [userId, projectId];
}

class GetProjectIds extends UserEvent {}
