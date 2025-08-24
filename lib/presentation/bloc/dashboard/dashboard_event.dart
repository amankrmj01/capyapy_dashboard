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

class UpdateDateRange extends DashboardEvent {
  final DateTime startDate;
  final DateTime endDate;

  const UpdateDateRange({required this.startDate, required this.endDate});

  @override
  List<Object> get props => [startDate, endDate];
}

class FilterByPeriod extends DashboardEvent {
  final DashboardPeriod period;

  const FilterByPeriod(this.period);

  @override
  List<Object> get props => [period];
}

class LoadApiMetrics extends DashboardEvent {
  const LoadApiMetrics();
}

class LoadUserMetrics extends DashboardEvent {
  const LoadUserMetrics();
}

class LoadFinancialMetrics extends DashboardEvent {
  const LoadFinancialMetrics();
}

class ExportDashboardData extends DashboardEvent {
  final DashboardExportFormat format;

  const ExportDashboardData(this.format);

  @override
  List<Object> get props => [format];
}

enum DashboardPeriod { today, thisWeek, thisMonth, thisYear, custom }

enum DashboardExportFormat { pdf, csv, json }
