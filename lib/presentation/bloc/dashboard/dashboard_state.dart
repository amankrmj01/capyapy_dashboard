import 'package:equatable/equatable.dart';

import 'dashboard_event.dart';

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
  final DashboardData data;
  final DateTime lastUpdated;
  final bool isRefreshing;

  const DashboardLoaded({
    required this.data,
    required this.lastUpdated,
    this.isRefreshing = false,
  });

  DashboardLoaded copyWith({
    DashboardData? data,
    DateTime? lastUpdated,
    bool? isRefreshing,
  }) {
    return DashboardLoaded(
      data: data ?? this.data,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [data, lastUpdated, isRefreshing];
}

class DashboardError extends DashboardState {
  final String message;
  final String? errorCode;

  const DashboardError(this.message, {this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class DashboardMetricsLoading extends DashboardState {
  final DashboardMetricsType type;

  const DashboardMetricsLoading(this.type);

  @override
  List<Object> get props => [type];
}

class DashboardExporting extends DashboardState {
  final DashboardExportFormat format;
  final double progress;

  const DashboardExporting({required this.format, this.progress = 0.0});

  @override
  List<Object> get props => [format, progress];
}

class DashboardExportCompleted extends DashboardState {
  final String filePath;
  final DashboardExportFormat format;

  const DashboardExportCompleted({
    required this.filePath,
    required this.format,
  });

  @override
  List<Object> get props => [filePath, format];
}

enum DashboardMetricsType { api, user, financial }

// Data models for dashboard
class DashboardData extends Equatable {
  final ApiMetrics apiMetrics;
  final UserMetrics userMetrics;
  final FinancialMetrics financialMetrics;
  final List<ChartData> apiUsageChart;
  final List<ChartData> userActivityChart;
  final List<CustomerOrder> recentOrders;
  final DateTime dateFrom;
  final DateTime dateTo;

  const DashboardData({
    required this.apiMetrics,
    required this.userMetrics,
    required this.financialMetrics,
    required this.apiUsageChart,
    required this.userActivityChart,
    required this.recentOrders,
    required this.dateFrom,
    required this.dateTo,
  });

  DashboardData copyWith({
    ApiMetrics? apiMetrics,
    UserMetrics? userMetrics,
    FinancialMetrics? financialMetrics,
    List<ChartData>? apiUsageChart,
    List<ChartData>? userActivityChart,
    List<CustomerOrder>? recentOrders,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return DashboardData(
      apiMetrics: apiMetrics ?? this.apiMetrics,
      userMetrics: userMetrics ?? this.userMetrics,
      financialMetrics: financialMetrics ?? this.financialMetrics,
      apiUsageChart: apiUsageChart ?? this.apiUsageChart,
      userActivityChart: userActivityChart ?? this.userActivityChart,
      recentOrders: recentOrders ?? this.recentOrders,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
    );
  }

  @override
  List<Object?> get props => [
    apiMetrics,
    userMetrics,
    financialMetrics,
    apiUsageChart,
    userActivityChart,
    recentOrders,
    dateFrom,
    dateTo,
  ];
}

class ApiMetrics extends Equatable {
  final int totalCalls;
  final double changePercentage;
  final int activeEndpoints;
  final double endpointsChangePercentage;
  final int errorCount;
  final double errorRate;
  final double averageResponseTime;

  const ApiMetrics({
    required this.totalCalls,
    required this.changePercentage,
    required this.activeEndpoints,
    required this.endpointsChangePercentage,
    required this.errorCount,
    required this.errorRate,
    required this.averageResponseTime,
  });

  @override
  List<Object> get props => [
    totalCalls,
    changePercentage,
    activeEndpoints,
    endpointsChangePercentage,
    errorCount,
    errorRate,
    averageResponseTime,
  ];
}

class UserMetrics extends Equatable {
  final int totalUsers;
  final double changePercentage;
  final int activeUsers;
  final int newUsers;
  final int returningUsers;
  final int inactiveUsers;
  final Map<String, int> usersByPlan;

  const UserMetrics({
    required this.totalUsers,
    required this.changePercentage,
    required this.activeUsers,
    required this.newUsers,
    required this.returningUsers,
    required this.inactiveUsers,
    required this.usersByPlan,
  });

  @override
  List<Object> get props => [
    totalUsers,
    changePercentage,
    activeUsers,
    newUsers,
    returningUsers,
    inactiveUsers,
    usersByPlan,
  ];
}

class FinancialMetrics extends Equatable {
  final double monthlyRevenue;
  final double revenueChangePercentage;
  final double totalRevenue;
  final double totalRevenueChangePercentage;
  final double paidInvoices;
  final double fundsReceived;
  final int subscriptions;
  final double subscriptionChangePercentage;

  const FinancialMetrics({
    required this.monthlyRevenue,
    required this.revenueChangePercentage,
    required this.totalRevenue,
    required this.totalRevenueChangePercentage,
    required this.paidInvoices,
    required this.fundsReceived,
    required this.subscriptions,
    required this.subscriptionChangePercentage,
  });

  @override
  List<Object> get props => [
    monthlyRevenue,
    revenueChangePercentage,
    totalRevenue,
    totalRevenueChangePercentage,
    paidInvoices,
    fundsReceived,
    subscriptions,
    subscriptionChangePercentage,
  ];
}

class ChartData extends Equatable {
  final DateTime date;
  final double value;
  final String? label;

  const ChartData({required this.date, required this.value, this.label});

  @override
  List<Object?> get props => [date, value, label];
}

class CustomerOrder extends Equatable {
  final String id;
  final String customerName;
  final String customerEmail;
  final String? customerAvatar;
  final String address;
  final DateTime date;
  final OrderStatus status;
  final double amount;

  const CustomerOrder({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    this.customerAvatar,
    required this.address,
    required this.date,
    required this.status,
    required this.amount,
  });

  @override
  List<Object?> get props => [
    id,
    customerName,
    customerEmail,
    customerAvatar,
    address,
    date,
    status,
    amount,
  ];
}

enum OrderStatus { pending, processed, delivered, cancelled }
