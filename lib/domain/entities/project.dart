import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Add other business-relevant fields here

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    // Add other fields here
  });

  @override
  List<Object?> get props => [id, name, description, createdAt, updatedAt];
}
