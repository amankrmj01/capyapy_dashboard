import 'package:capyapy_dashboard/data/datasource/user/user_data_source.dart';
import 'package:capyapy_dashboard/data/models/models.dart';

import '../../../domain/entities/user.dart';

class MockUserData implements UserDataSource {
  User _user = User(
    id: 'mock_id',
    email: 'mock@email.com',
    username: 'mockuser',
    profile: UserProfile(
      firstName: 'Mock',
      lastName: 'User',
      avatarUrl: 'https://example.com/avatar.png',
    ),
    preferences: UserPreferences(theme: AppThemeMode.dark),
    projectIds: ['project_1', 'project_2', 'project_3'],
    permissions: const {},
    plan: UserPlan.free,
    createdAt: DateTime(2023, 1, 1),
    updatedAt: DateTime(2023, 1, 1),
    lastLoginAt: DateTime(2022, 1, 1),
    isEmailVerified: true,
  );

  @override
  Future<void> addProjectId(String projectId) async {
    final ids = List<String>.from(_user.projectIds);
    if (!ids.contains(projectId)) {
      ids.add(projectId);
      _user = User(
        id: _user.id,
        email: _user.email,
        username: _user.username,
        profile: _user.profile,
        preferences: _user.preferences,
        projectIds: ids,
        permissions: _user.permissions,
        plan: _user.plan,
        createdAt: _user.createdAt,
        updatedAt: DateTime.now(),
        lastLoginAt: _user.lastLoginAt,
        isEmailVerified: _user.isEmailVerified,
      );
    }
  }

  @override
  Future<List<String>> getProjectIds() async {
    return _user.projectIds;
  }

  @override
  Future<void> removeProjectId(String projectId) async {
    final ids = List<String>.from(_user.projectIds);
    ids.remove(projectId);
    _user = User(
      id: _user.id,
      email: _user.email,
      username: _user.username,
      profile: _user.profile,
      preferences: _user.preferences,
      projectIds: ids,
      permissions: _user.permissions,
      plan: _user.plan,
      createdAt: _user.createdAt,
      updatedAt: DateTime.now(),
      lastLoginAt: _user.lastLoginAt,
      isEmailVerified: _user.isEmailVerified,
    );
  }

  @override
  Future<String> getUserEmail() async {
    return _user.email;
  }

  @override
  Future<String> getUserId() async {
    return _user.id;
  }

  @override
  Future<String> getUserName() async {
    return _user.username;
  }

  @override
  Future<String> getUserPhotoUrl() async {
    return _user.profile.avatarUrl ?? '';
  }

  @override
  Future<String> getUserUserName() async {
    return _user.username;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return _user.id.isNotEmpty;
  }

  @override
  Future<void> logOutUser() async {
    _user = User(
      id: '',
      email: '',
      username: '',
      profile: UserProfile(),
      preferences: UserPreferences(),
      projectIds: [],
      permissions: {},
      plan: UserPlan.free,
      createdAt: DateTime(2000, 1, 1),
      updatedAt: DateTime(2000, 1, 1),
      lastLoginAt: null,
      isEmailVerified: false,
    );
  }

  @override
  Future<User> getUser(String id) {
    return Future.value(_user);
  }
}
