import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final int totalProjects;
  final int activeProjects;
  final int totalEndpoints;
  final int totalModels;
  final int apiCallsToday;
  final int apiCallsThisMonth;
  final int creditsRemaining;
  final bool mockServerRunning;

  const DashboardLoaded({
    required this.totalProjects,
    required this.activeProjects,
    required this.totalEndpoints,
    required this.totalModels,
    required this.apiCallsToday,
    required this.apiCallsThisMonth,
    required this.creditsRemaining,
    required this.mockServerRunning,
  });

  @override
  List<Object> get props => [
    totalProjects,
    activeProjects,
    totalEndpoints,
    totalModels,
    apiCallsToday,
    apiCallsThisMonth,
    creditsRemaining,
    mockServerRunning,
  ];

  DashboardLoaded copyWith({
    int? totalProjects,
    int? activeProjects,
    int? totalEndpoints,
    int? totalModels,
    int? apiCallsToday,
    int? apiCallsThisMonth,
    int? creditsRemaining,
    bool? mockServerRunning,
  }) {
    return DashboardLoaded(
      totalProjects: totalProjects ?? this.totalProjects,
      activeProjects: activeProjects ?? this.activeProjects,
      totalEndpoints: totalEndpoints ?? this.totalEndpoints,
      totalModels: totalModels ?? this.totalModels,
      apiCallsToday: apiCallsToday ?? this.apiCallsToday,
      apiCallsThisMonth: apiCallsThisMonth ?? this.apiCallsThisMonth,
      creditsRemaining: creditsRemaining ?? this.creditsRemaining,
      mockServerRunning: mockServerRunning ?? this.mockServerRunning,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}
