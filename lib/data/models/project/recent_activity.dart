import 'package:equatable/equatable.dart';

class RecentActivity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final String type;
  final String icon;
  final String status;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.icon,
    required this.status,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      timestamp: json['timestamp'],
      type: json['type'],
      icon: json['icon'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'type': type,
      'icon': icon,
      'status': status,
    };
  }

  @override
  List<Object> get props => [
    id,
    title,
    description,
    timestamp,
    type,
    icon,
    status,
  ];
}
