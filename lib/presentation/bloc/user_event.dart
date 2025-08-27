import 'package:equatable/equatable.dart';
import '../../data/models/user/user.dart';
import '../../domain/entities/user.dart';

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
