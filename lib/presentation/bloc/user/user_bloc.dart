import 'package:capyapy_dashboard/presentation/bloc/user/user_event.dart';
import 'package:capyapy_dashboard/presentation/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_user_usecase.dart';
import '../../../domain/usecases/update_user_usecase.dart';
import '../../../domain/usecases/logout_user_usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final LogoutUserUseCase logoutUserUseCase;

  UserBloc({
    required this.getUserUseCase,
    required this.updateUserUseCase,
    required this.logoutUserUseCase,
  }) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await getUserUseCase(event.userId);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<UpdateUser>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await updateUserUseCase(event.user);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<LogoutUser>((event, emit) async {
      emit(UserLoading());
      try {
        await logoutUserUseCase();
        emit(UserInitial());
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
