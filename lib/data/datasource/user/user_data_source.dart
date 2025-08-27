import '../../../domain/entities/user.dart';

abstract class UserDataSource {
  Future<User> getUser(String id);

  Future<String> getUserId();

  Future<String> getUserEmail();

  Future<String> getUserName();

  Future<String> getUserPhotoUrl();

  Future<String> getUserUserName();

  Future<bool> isUserLoggedIn();

  Future<void> logOutUser();

  Future<List<String>> getProjectIds();

  Future<void> addProjectId(String projectId);

  Future<void> removeProjectId(String projectId);
}
