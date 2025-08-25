// Project Metadata
class ProjectMetadata {
  final String version;
  final String author;
  final List<String> tags;
  final String? documentation;
  final Map<String, dynamic> customFields;

  const ProjectMetadata({
    required this.version,
    required this.author,
    this.tags = const [],
    this.documentation,
    this.customFields = const {},
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'author': author,
    'tags': tags,
    if (documentation != null) 'documentation': documentation,
    'customFields': customFields,
  };

  factory ProjectMetadata.fromJson(Map<String, dynamic> json) =>
      ProjectMetadata(
        version: json['version'] ?? '1.0.0',
        author: json['author'] ?? '',
        tags: (json['tags'] as List? ?? []).cast<String>(),
        documentation: json['documentation'],
        customFields: Map<String, dynamic>.from(json['customFields'] ?? {}),
      );
}
