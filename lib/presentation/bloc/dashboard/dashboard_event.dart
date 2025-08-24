import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

class ToggleMockServer extends DashboardEvent {
  final bool isEnabled;

  const ToggleMockServer(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}
