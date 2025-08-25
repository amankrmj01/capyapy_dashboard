import 'models.dart';

class MongoDbIndex {
  final String name;
  final Map<String, int> fields; // field: 1 for ascending, -1 for descending
  final bool unique;
  final bool sparse;
  final Map<String, dynamic>? options;

  const MongoDbIndex({
    required this.name,
    required this.fields,
    this.unique = false,
    this.sparse = false,
    this.options,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'fields': fields,
    'unique': unique,
    'sparse': sparse,
    if (options != null) 'options': options,
  };

  factory MongoDbIndex.fromJson(Map<String, dynamic> json) => MongoDbIndex(
    name: json['name'] ?? '',
    fields: Map<String, int>.from(json['fields'] ?? {}),
    unique: json['unique'] ?? false,
    sparse: json['sparse'] ?? false,
    options: json['options'] != null
        ? Map<String, dynamic>.from(json['options'])
        : null,
  );
}

enum MongoDbFieldType {
  string,
  number,
  boolean,
  date,
  objectId,
  array,
  object,
  buffer,
  decimal,
  mixed,
  map;

  String get displayName {
    switch (this) {
      case MongoDbFieldType.string:
        return 'String';
      case MongoDbFieldType.number:
        return 'Number';
      case MongoDbFieldType.boolean:
        return 'Boolean';
      case MongoDbFieldType.date:
        return 'Date';
      case MongoDbFieldType.objectId:
        return 'ObjectId';
      case MongoDbFieldType.array:
        return 'Array';
      case MongoDbFieldType.object:
        return 'Object';
      case MongoDbFieldType.buffer:
        return 'Buffer';
      case MongoDbFieldType.decimal:
        return 'Decimal';
      case MongoDbFieldType.mixed:
        return 'Mixed';
      case MongoDbFieldType.map:
        return 'Map';
    }
  }
}
