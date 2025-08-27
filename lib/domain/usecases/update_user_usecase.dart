import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<User> call(User user) {
    return repository.updateUser(user);
  }
}
