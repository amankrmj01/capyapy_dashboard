import '../models.dart';

class ProjectDataModel {
  final String id;
  final String modelName;
  final String collectionName;
  final String description;
  final List<MongoDbField> fields;
  final List<MongoDbIndex> indexes;
  final Map<String, dynamic> mongoDbOptions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectDataModel({
    required this.id,
    required this.modelName,
    required this.collectionName,
    required this.description,
    required this.fields,
    this.indexes = const [],
    this.mongoDbOptions = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'modelName': modelName,
    'collectionName': collectionName,
    'description': description,
    'fields': fields.map((e) => e.toJson()).toList(),
    'indexes': indexes.map((e) => e.toJson()).toList(),
    'mongoDbOptions': mongoDbOptions,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ProjectDataModel.fromJson(Map<String, dynamic> json) =>
      ProjectDataModel(
        id: json['id'] ?? '',
        modelName: json['modelName'] ?? '',
        collectionName: json['collectionName'] ?? '',
        description: json['description'] ?? '',
        fields: (json['fields'] as List? ?? [])
            .map((e) => MongoDbField.fromJson(e))
            .toList(),
        indexes: (json['indexes'] as List? ?? [])
            .map((e) => MongoDbIndex.fromJson(e))
            .toList(),
        mongoDbOptions: Map<String, dynamic>.from(json['mongoDbOptions'] ?? {}),
        createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
      );

  ProjectDataModel copyWith({
    String? id,
    String? modelName,
    String? collectionName,
    String? description,
    List<MongoDbField>? fields,
    List<MongoDbIndex>? indexes,
    Map<String, dynamic>? mongoDbOptions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectDataModel(
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      collectionName: collectionName ?? this.collectionName,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      indexes: indexes ?? this.indexes,
      mongoDbOptions: mongoDbOptions ?? this.mongoDbOptions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
