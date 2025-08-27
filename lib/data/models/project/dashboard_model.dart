import 'package:equatable/equatable.dart';

class OverviewCard extends Equatable {
  final String id;
  final String title;
  final String value;
  final String subtitle;
  final String icon;
  final String color;
  final double changePercentage;
  final bool isPositiveChange;
  final String period;

  const OverviewCard({
    required this.id,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.changePercentage,
    required this.isPositiveChange,
    required this.period,
  });

  factory OverviewCard.fromJson(Map<String, dynamic> json) {
    return OverviewCard(
      id: json['id'],
      title: json['title'],
      value: json['value'],
      subtitle: json['subtitle'],
      icon: json['icon'],
      color: json['color'],
      changePercentage: json['changePercentage'].toDouble(),
      isPositiveChange: json['isPositiveChange'],
      period: json['period'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'subtitle': subtitle,
      'icon': icon,
      'color': color,
      'changePercentage': changePercentage,
      'isPositiveChange': isPositiveChange,
      'period': period,
    };
  }

  @override
  List<Object> get props => [
    id,
    title,
    value,
    subtitle,
    icon,
    color,
    changePercentage,
    isPositiveChange,
    period,
  ];
}
