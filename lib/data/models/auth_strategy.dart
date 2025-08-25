// Authentication Strategy
class AuthStrategy {
  final AuthType type;
  final Map<String, dynamic> config;
  final List<String> requiredFields;

  const AuthStrategy({
    required this.type,
    required this.config,
    this.requiredFields = const [],
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'config': config,
    'requiredFields': requiredFields,
  };

  factory AuthStrategy.fromJson(Map<String, dynamic> json) => AuthStrategy(
    type: AuthType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AuthType.bearer,
    ),
    config: Map<String, dynamic>.from(json['config'] ?? {}),
    requiredFields: (json['requiredFields'] as List? ?? []).cast<String>(),
  );
}

enum AuthType { bearer, apiKey, basic, oauth2, custom }
