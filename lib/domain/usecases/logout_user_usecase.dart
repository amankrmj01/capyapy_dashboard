import '../repositories/user_repository.dart';

class LogoutUserUseCase {
  final UserRepository repository;

  LogoutUserUseCase(this.repository);

  Future<void> call() {
    return repository.logoutUser();
  }
}
