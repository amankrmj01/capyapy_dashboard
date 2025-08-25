enum UserRole {
  admin,
  developer,
  viewer;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.developer:
        return 'Developer';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  String get description {
    switch (this) {
      case UserRole.admin:
        return 'Full access to all features and settings';
      case UserRole.developer:
        return 'Can create and manage projects';
      case UserRole.viewer:
        return 'Read-only access to projects';
    }
  }
}

enum UserStatus {
  active,
  inactive,
  suspended,
  pending;

  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.pending:
        return 'Pending';
    }
  }
}

class UserPreferences {
  final String theme; // 'light', 'dark', 'system'
  final String language;
  final bool emailNotifications;
  final bool pushNotifications;
  final Map<String, dynamic> customSettings;

  const UserPreferences({
    this.theme = 'system',
    this.language = 'en',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.customSettings = const {},
  });

  Map<String, dynamic> toJson() => {
    'theme': theme,
    'language': language,
    'emailNotifications': emailNotifications,
    'pushNotifications': pushNotifications,
    'customSettings': customSettings,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        theme: json['theme'] ?? 'system',
        language: json['language'] ?? 'en',
        emailNotifications: json['emailNotifications'] ?? true,
        pushNotifications: json['pushNotifications'] ?? true,
        customSettings: Map<String, dynamic>.from(json['customSettings'] ?? {}),
      );

  UserPreferences copyWith({
    String? theme,
    String? language,
    bool? emailNotifications,
    bool? pushNotifications,
    Map<String, dynamic>? customSettings,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      customSettings: customSettings ?? this.customSettings,
    );
  }
}

class UserProfile {
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? jobTitle;
  final String? bio;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? website;
  final Map<String, String> socialLinks; // 'github', 'linkedin', etc.

  const UserProfile({
    this.firstName,
    this.lastName,
    this.company,
    this.jobTitle,
    this.bio,
    this.avatarUrl,
    this.phoneNumber,
    this.website,
    this.socialLinks = const {},
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return '';
  }

  String get initials {
    String initials = '';
    if (firstName?.isNotEmpty == true) {
      initials += firstName![0].toUpperCase();
    }
    if (lastName?.isNotEmpty == true) {
      initials += lastName![0].toUpperCase();
    }
    return initials.isNotEmpty ? initials : '?';
  }

  Map<String, dynamic> toJson() => {
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (company != null) 'company': company,
    if (jobTitle != null) 'jobTitle': jobTitle,
    if (bio != null) 'bio': bio,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
    if (website != null) 'website': website,
    'socialLinks': socialLinks,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    firstName: json['firstName'],
    lastName: json['lastName'],
    company: json['company'],
    jobTitle: json['jobTitle'],
    bio: json['bio'],
    avatarUrl: json['avatarUrl'],
    phoneNumber: json['phoneNumber'],
    website: json['website'],
    socialLinks: Map<String, String>.from(json['socialLinks'] ?? {}),
  );

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? jobTitle,
    String? bio,
    String? avatarUrl,
    String? phoneNumber,
    String? website,
    Map<String, String>? socialLinks,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}

class User {
  final String id;
  final String email;
  final String username;
  final UserRole role;
  final UserStatus status;
  final UserProfile profile;
  final UserPreferences preferences;
  final List<String> projectIds; // Projects the user has access to
  final Map<String, dynamic> permissions; // Fine-grained permissions
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final DateTime? emailVerifiedAt;
  final bool isEmailVerified;
  final String? resetPasswordToken;
  final DateTime? resetPasswordTokenExpiresAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.status,
    required this.profile,
    required this.preferences,
    this.projectIds = const [],
    this.permissions = const {},
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.emailVerifiedAt,
    required this.isEmailVerified,
    this.resetPasswordToken,
    this.resetPasswordTokenExpiresAt,
  });

  // Computed properties
  String get displayName {
    if (profile.fullName.isNotEmpty) {
      return profile.fullName;
    }
    return username;
  }

  bool get isActive => status == UserStatus.active;

  bool get isAdmin => role == UserRole.admin;

  bool get isDeveloper => role == UserRole.developer;

  bool get isViewer => role == UserRole.viewer;

  bool get canCreateProjects => isAdmin || isDeveloper;

  bool get canManageUsers => isAdmin;

  bool get canViewAnalytics => isAdmin || isDeveloper;

  bool hasPermission(String permission) {
    return permissions[permission] == true || isAdmin;
  }

  bool canAccessProject(String projectId) {
    return isAdmin || projectIds.contains(projectId);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'role': role.name,
    'status': status.name,
    'profile': profile.toJson(),
    'preferences': preferences.toJson(),
    'projectIds': projectIds,
    'permissions': permissions,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    if (lastLoginAt != null) 'lastLoginAt': lastLoginAt!.toIso8601String(),
    if (emailVerifiedAt != null)
      'emailVerifiedAt': emailVerifiedAt!.toIso8601String(),
    'isEmailVerified': isEmailVerified,
    if (resetPasswordToken != null) 'resetPasswordToken': resetPasswordToken,
    if (resetPasswordTokenExpiresAt != null)
      'resetPasswordTokenExpiresAt': resetPasswordTokenExpiresAt!
          .toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    username: json['username'],
    role: UserRole.values.firstWhere(
      (e) => e.name == json['role'],
      orElse: () => UserRole.viewer,
    ),
    status: UserStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => UserStatus.active,
    ),
    profile: UserProfile.fromJson(json['profile'] ?? {}),
    preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    projectIds: (json['projectIds'] as List? ?? []).cast<String>(),
    permissions: Map<String, dynamic>.from(json['permissions'] ?? {}),
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json['updatedAt'] ?? DateTime.now().toIso8601String(),
    ),
    lastLoginAt: json['lastLoginAt'] != null
        ? DateTime.parse(json['lastLoginAt'])
        : null,
    emailVerifiedAt: json['emailVerifiedAt'] != null
        ? DateTime.parse(json['emailVerifiedAt'])
        : null,
    isEmailVerified: json['isEmailVerified'] ?? false,
    resetPasswordToken: json['resetPasswordToken'],
    resetPasswordTokenExpiresAt: json['resetPasswordTokenExpiresAt'] != null
        ? DateTime.parse(json['resetPasswordTokenExpiresAt'])
        : null,
  );

  User copyWith({
    String? id,
    String? email,
    String? username,
    UserRole? role,
    UserStatus? status,
    UserProfile? profile,
    UserPreferences? preferences,
    List<String>? projectIds,
    Map<String, dynamic>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    DateTime? emailVerifiedAt,
    bool? isEmailVerified,
    String? resetPasswordToken,
    DateTime? resetPasswordTokenExpiresAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      status: status ?? this.status,
      profile: profile ?? this.profile,
      preferences: preferences ?? this.preferences,
      projectIds: projectIds ?? this.projectIds,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      resetPasswordToken: resetPasswordToken ?? this.resetPasswordToken,
      resetPasswordTokenExpiresAt:
          resetPasswordTokenExpiresAt ?? this.resetPasswordTokenExpiresAt,
    );
  }

  // Helper methods for common operations
  User updateLastLogin() {
    return copyWith(lastLoginAt: DateTime.now(), updatedAt: DateTime.now());
  }

  User verifyEmail() {
    return copyWith(
      isEmailVerified: true,
      emailVerifiedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  User updateProfile(UserProfile newProfile) {
    return copyWith(profile: newProfile, updatedAt: DateTime.now());
  }

  User updatePreferences(UserPreferences newPreferences) {
    return copyWith(preferences: newPreferences, updatedAt: DateTime.now());
  }

  User grantProjectAccess(String projectId) {
    if (projectIds.contains(projectId)) return this;
    return copyWith(
      projectIds: [...projectIds, projectId],
      updatedAt: DateTime.now(),
    );
  }

  User revokeProjectAccess(String projectId) {
    if (!projectIds.contains(projectId)) return this;
    return copyWith(
      projectIds: projectIds.where((id) => id != projectId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  User updateStatus(UserStatus newStatus) {
    return copyWith(status: newStatus, updatedAt: DateTime.now());
  }

  User updateRole(UserRole newRole) {
    return copyWith(role: newRole, updatedAt: DateTime.now());
  }
}
