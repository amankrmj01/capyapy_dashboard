import '../../data/models/user/user.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUser(String id);

  Future<User> updateUser(User user);

  Future<void> logoutUser();
}
