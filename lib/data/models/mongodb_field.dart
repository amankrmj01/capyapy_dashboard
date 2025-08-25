import 'package:capyapy_dashboard/data/models/project_model.dart';

import 'models.dart';

class MongoDbField {
  final String name;
  final MongoDbFieldType type;
  final bool required;
  final bool unique;
  final dynamic defaultValue;
  final List<String>? enumValues;
  final List<MongoDbField>? nestedFields; // For embedded documents
  final String? ref; // For references
  final Map<String, dynamic>? validationRules;

  const MongoDbField({
    required this.name,
    required this.type,
    this.required = false,
    this.unique = false,
    this.defaultValue,
    this.enumValues,
    this.nestedFields,
    this.ref,
    this.validationRules,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.name,
    'required': required,
    'unique': unique,
    if (defaultValue != null) 'default': defaultValue,
    if (enumValues != null) 'enum': enumValues,
    if (nestedFields != null)
      'nestedFields': nestedFields!.map((e) => e.toJson()).toList(),
    if (ref != null) 'ref': ref,
    if (validationRules != null) 'validationRules': validationRules,
  };

  factory MongoDbField.fromJson(Map<String, dynamic> json) => MongoDbField(
    name: json['name'] ?? '',
    type: MongoDbFieldType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => MongoDbFieldType.string,
    ),
    required: json['required'] ?? false,
    unique: json['unique'] ?? false,
    defaultValue: json['default'],
    enumValues: json['enum']?.cast<String>(),
    nestedFields: json['nestedFields'] != null
        ? (json['nestedFields'] as List)
              .map((e) => MongoDbField.fromJson(e))
              .toList()
        : null,
    ref: json['ref'],
    validationRules: json['validationRules'] != null
        ? Map<String, dynamic>.from(json['validationRules'])
        : null,
  );
}
