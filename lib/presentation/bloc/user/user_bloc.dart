import 'package:capyapy_dashboard/domain/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onUpdateUser);
    on<LogoutUser>(_onLogoutUser);
    on<AddProjectId>(_onAddProjectId);
    on<RemoveProjectId>(_onRemoveProjectId);
    on<GetProjectIds>(_onGetProjectIds);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await userRepository.updateUser(event.user);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.logoutUser();
      emit(UserInitial());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onAddProjectId(
    AddProjectId event,
    Emitter<UserState> emit,
  ) async {
    print(
      '[UserBloc] Received AddProjectId: userId=${event.userId}, projectId=${event.projectId}',
    );
    emit(UserLoading());
    try {
      await userRepository.addProjectId(event.userId, event.projectId);
      final user = await userRepository.getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onRemoveProjectId(
    RemoveProjectId event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await userRepository.removeProjectId(event.userId, event.projectId);
      final user = await userRepository.getUser(event.userId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onGetProjectIds(
    GetProjectIds event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUser(
        'mock_id',
      ); // Use correct userId if available
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
