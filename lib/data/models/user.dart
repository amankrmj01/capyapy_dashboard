import 'package:equatable/equatable.dart';

enum AppThemeMode { light, dark, system }

class UserPreferences extends Equatable {
  final AppThemeMode theme;
  final String language;
  final bool emailNotifications;
  final bool pushNotifications;
  final Map<String, dynamic> customSettings;

  const UserPreferences({
    this.theme = AppThemeMode.system,
    this.language = 'en',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.customSettings = const {},
  });

  @override
  List<Object?> get props => [
    theme,
    language,
    emailNotifications,
    pushNotifications,
    customSettings,
  ];

  Map<String, dynamic> toJson() => {
    'theme': theme.name,
    'language': language,
    'emailNotifications': emailNotifications,
    'pushNotifications': pushNotifications,
    'customSettings': customSettings,
  };

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        theme: AppThemeMode.values.firstWhere(
          (e) => e.name == (json['theme'] ?? 'system'),
          orElse: () => AppThemeMode.system,
        ),
        language: json['language'] ?? 'en',
        emailNotifications: json['emailNotifications'] ?? true,
        pushNotifications: json['pushNotifications'] ?? true,
        customSettings: Map<String, dynamic>.from(json['customSettings'] ?? {}),
      );

  UserPreferences copyWith({
    AppThemeMode? theme,
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

class UserProfile extends Equatable {
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

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    company,
    jobTitle,
    bio,
    avatarUrl,
    phoneNumber,
    website,
    socialLinks,
  ];

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

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final UserProfile profile;
  final UserPreferences preferences;
  final List<String> projectIds;
  final Map<String, dynamic> permissions;
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
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    required this.isEmailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
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
  };

  User copyWith({
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
    return User(
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
    createdAt,
    updatedAt,
    lastLoginAt,
    isEmailVerified,
  ];
}
