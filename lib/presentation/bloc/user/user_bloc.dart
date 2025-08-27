import 'package:capyapy_dashboard/domain/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.getUser(event.userId);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.updateUser(event.user);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<LogoutUser>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.logoutUser();
        emit(UserInitial());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<AddProjectId>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.addProjectId(event.userId, event.projectId);
        emit(ProjectIdAdded(event.projectId));
      } catch (e) {
        emit(ProjectIdError(e.toString()));
      }
    });

    on<RemoveProjectId>((event, emit) async {
      emit(UserLoading());
      try {
        await userRepository.removeProjectId(event.userId, event.projectId);
        emit(ProjectIdRemoved(event.projectId));
      } catch (e) {
        emit(ProjectIdError(e.toString()));
      }
    });

    on<GetProjectIds>((event, emit) async {
      emit(UserLoading());
      try {
        final ids = await userRepository.getProjectIds(event.userId);
        emit(ProjectIdsLoaded(ids));
      } catch (e) {
        emit(ProjectIdError(e.toString()));
      }
    });
  }
}
