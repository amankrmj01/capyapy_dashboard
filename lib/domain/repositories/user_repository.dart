import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUser(String id);

  Future<User> updateUser(User user);

  Future<void> logoutUser();

  Future<void> addProjectId(String userId, String projectId);

  Future<void> removeProjectId(String userId, String projectId);

  Future<List<String>> getProjectIds();
}
