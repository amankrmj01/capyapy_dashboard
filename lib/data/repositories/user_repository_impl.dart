import 'package:capyapy_dashboard/domain/entities/user.dart';
import 'package:capyapy_dashboard/domain/repositories/user_repository.dart';

import '../models/user/user.dart';
import '../models/user/user_plan.dart';
import '../models/user/user_preferences.dart';
import '../models/user/user_profile.dart';

class UserRepositoryImpl implements UserRepository {
  // You can inject data sources here (API, local DB, etc.)

  @override
  Future<User> getUser(String id) async {
    // TODO: Replace with real data source
    // Example mock implementation:
    final userModel = UserModel(
      id: id,
      email: 'mock@email.com',
      username: 'mockuser',
      profile: UserProfile(),
      preferences: UserPreferences(),
      projectIds: [],
      permissions: {},
      plan: UserPlan.free,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isEmailVerified: true,
    );
    return userModel.toEntity();
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
}
