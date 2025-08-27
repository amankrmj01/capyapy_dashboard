import 'package:equatable/equatable.dart';
import 'app_theme_mode.dart';

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
