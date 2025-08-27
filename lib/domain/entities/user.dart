import 'package:equatable/equatable.dart';
import '../../data/models/user/user_plan.dart';
import '../../data/models/user/user_profile.dart';
import '../../data/models/user/user_preferences.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final UserProfile profile;
  final UserPreferences preferences;
  final List<String> projectIds;
  final Map<String, dynamic> permissions;
  final UserPlan plan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.profile,
    required this.preferences,
    required this.projectIds,
    required this.permissions,
    required this.plan,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    required this.isEmailVerified,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    profile,
    preferences,
    projectIds,
    permissions,
    plan,
    createdAt,
    updatedAt,
    lastLoginAt,
    isEmailVerified,
  ];
}
