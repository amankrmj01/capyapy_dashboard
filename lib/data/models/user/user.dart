import 'package:capyapy_dashboard/data/models/user/user_plan.dart';
import 'package:capyapy_dashboard/data/models/user/user_preferences.dart';
import 'package:capyapy_dashboard/data/models/user/user_profile.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user.dart';

class UserModel extends Equatable {
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

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    plan: UserPlan.values.firstWhere(
      (e) => e.name == json['plan'],
      orElse: () => UserPlan.free,
    ),
    email: json['email'] as String,
    username: json['username'] as String,
    profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
    preferences: UserPreferences.fromJson(
      json['preferences'] as Map<String, dynamic>,
    ),
    projectIds: (json['projectIds'] as List<dynamic>? ?? []).cast<String>(),
    permissions: Map<String, dynamic>.from(json['permissions'] ?? {}),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    lastLoginAt: json['lastLoginAt'] != null
        ? DateTime.parse(json['lastLoginAt'] as String)
        : null,
    isEmailVerified: json['isEmailVerified'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'profile': profile.toJson(),
    'preferences': preferences.toJson(),
    'projectIds': projectIds,
    'permissions': permissions,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    if (lastLoginAt != null) 'lastLoginAt': lastLoginAt!.toIso8601String(),
    'isEmailVerified': isEmailVerified,
    'plan': plan.name,
  };

  UserModel copyWith({
    UserPlan? plan,
    String? id,
    String? email,
    String? username,
    UserProfile? profile,
    UserPreferences? preferences,
    List<String>? projectIds,
    Map<String, dynamic>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
      projectIds: projectIds ?? this.projectIds,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      plan: plan ?? this.plan,
    );
  }

  // Conversion from domain entity to data model
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      profile: entity.profile,
      preferences: entity.preferences,
      projectIds: entity.projectIds,
      permissions: entity.permissions,
      plan: entity.plan,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastLoginAt: entity.lastLoginAt,
      isEmailVerified: entity.isEmailVerified,
    );
  }

  // Conversion from data model to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      profile: profile,
      preferences: preferences,
      projectIds: projectIds,
      permissions: permissions,
      plan: plan,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastLoginAt: lastLoginAt,
      isEmailVerified: isEmailVerified,
    );
  }

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
