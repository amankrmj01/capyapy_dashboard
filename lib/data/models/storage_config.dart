// Storage Configuration
class StorageConfig {
  final StorageType type;
  final String connectionString;
  final String databaseName;
  final Map<String, dynamic> options;

  const StorageConfig({
    required this.type,
    required this.connectionString,
    required this.databaseName,
    this.options = const {},
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'connectionString': connectionString,
    'databaseName': databaseName,
    'options': options,
  };

  factory StorageConfig.fromJson(Map<String, dynamic> json) => StorageConfig(
    type: StorageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => StorageType.mongodb,
    ),
    connectionString: json['connectionString'] ?? '',
    databaseName: json['databaseName'] ?? '',
    options: Map<String, dynamic>.from(json['options'] ?? {}),
  );
}

enum StorageType { mongodb, postgresql, mysql, sqlite }
