import 'package:equatable/equatable.dart';

import '../models.dart';

class DashboardOverview extends Equatable {
  final List<OverviewCard> overviewCards;
  final AnalyticsData analytics;
  final List<RecentActivity> recentActivities;
  final List<ApiEndpoint> topEndpoints;

  const DashboardOverview({
    required this.overviewCards,
    required this.analytics,
    required this.recentActivities,
    required this.topEndpoints,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      overviewCards: (json['overviewCards'] as List)
          .map((e) => OverviewCard.fromJson(e))
          .toList(),
      analytics: AnalyticsData.fromJson(json['analytics']),
      recentActivities: (json['recentActivities'] as List)
          .map((e) => RecentActivity.fromJson(e))
          .toList(),
      topEndpoints: (json['topEndpoints'] as List)
          .map((e) => ApiEndpoint.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overviewCards': overviewCards.map((e) => e.toJson()).toList(),
      'analytics': analytics.toJson(),
      'recentActivities': recentActivities.map((e) => e.toJson()).toList(),
      'topEndpoints': topEndpoints.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [
    overviewCards,
    analytics,
    recentActivities,
    topEndpoints,
  ];
}
