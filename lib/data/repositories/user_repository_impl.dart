import 'package:capyapy_dashboard/domain/entities/user.dart';
import 'package:capyapy_dashboard/domain/repositories/user_repository.dart';

import '../datasource/user/mock_user_data.dart';
import '../models/user/user.dart';

class UserRepositoryImpl implements UserRepository {
  final MockUserData userData;

  UserRepositoryImpl({required this.userData});

  @override
  Future<User> getUser(String id) async {
    return userData.getUser(id);
  }

  @override
  Future<User> updateUser(User user) async {
    // TODO: Replace with real update logic
    final userModel = UserModel.fromEntity(user);
    // Simulate update and return the updated entity
    return userModel.toEntity();
  }

  @override
  Future<void> logoutUser() async {
    // TODO: Implement logout logic
  }

  @override
  Future<void> addProjectId(String userId, String projectId) async {
    await userData.addProjectId(projectId);
  }

  @override
  Future<void> removeProjectId(String userId, String projectId) async {
    await userData.removeProjectId(projectId);
  }

  @override
  Future<List<String>> getProjectIds(String userId) async {
    return await userData.getProjectIds();
  }
}
