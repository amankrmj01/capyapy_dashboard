import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<UpdateDateRange>(_onUpdateDateRange);
    on<FilterByPeriod>(_onFilterByPeriod);
    on<LoadApiMetrics>(_onLoadApiMetrics);
    on<LoadUserMetrics>(_onLoadUserMetrics);
    on<LoadFinancialMetrics>(_onLoadFinancialMetrics);
    on<ExportDashboardData>(_onExportDashboardData);
  }

  void _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    try {
      // Simulate loading dashboard data
      await Future.delayed(const Duration(seconds: 1));

      final dashboardData = await _loadDashboardData();

      emit(DashboardLoaded(data: dashboardData, lastUpdated: DateTime.now()));
    } catch (error) {
      emit(
        DashboardError(
          'Failed to load dashboard: ${error.toString()}',
          errorCode: 'DASHBOARD_LOAD_ERROR',
        ),
      );
    }
  }

  void _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;

    if (currentState is DashboardLoaded) {
      emit(currentState.copyWith(isRefreshing: true));

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        final refreshedData = await _loadDashboardData();

        emit(
          DashboardLoaded(
            data: refreshedData,
            lastUpdated: DateTime.now(),
            isRefreshing: false,
          ),
        );
      } catch (error) {
        emit(
          DashboardError(
            'Failed to refresh dashboard: ${error.toString()}',
            errorCode: 'DASHBOARD_REFRESH_ERROR',
          ),
        );
      }
    }
  }

  void _onUpdateDateRange(
    UpdateDateRange event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    try {
      final filteredData = await _loadDashboardDataForDateRange(
        event.startDate,
        event.endDate,
      );

      emit(DashboardLoaded(data: filteredData, lastUpdated: DateTime.now()));
    } catch (error) {
      emit(
        DashboardError(
          'Failed to update date range: ${error.toString()}',
          errorCode: 'DATE_RANGE_ERROR',
        ),
      );
    }
  }

  void _onFilterByPeriod(
    FilterByPeriod event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    try {
      final dateRange = _getDateRangeForPeriod(event.period);
      final filteredData = await _loadDashboardDataForDateRange(
        dateRange.start,
        dateRange.end,
      );

      emit(DashboardLoaded(data: filteredData, lastUpdated: DateTime.now()));
    } catch (error) {
      emit(
        DashboardError(
          'Failed to filter by period: ${error.toString()}',
          errorCode: 'PERIOD_FILTER_ERROR',
        ),
      );
    }
  }

  void _onLoadApiMetrics(
    LoadApiMetrics event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardMetricsLoading(DashboardMetricsType.api));

    try {
      // Load specific API metrics
      await Future.delayed(const Duration(milliseconds: 500));

      final currentState = state;
      if (currentState is DashboardLoaded) {
        final updatedApiMetrics = await _loadApiMetrics();
        final updatedData = currentState.data.copyWith(
          apiMetrics: updatedApiMetrics,
        );

        emit(currentState.copyWith(data: updatedData));
      }
    } catch (error) {
      emit(
        DashboardError(
          'Failed to load API metrics: ${error.toString()}',
          errorCode: 'API_METRICS_ERROR',
        ),
      );
    }
  }

  void _onLoadUserMetrics(
    LoadUserMetrics event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardMetricsLoading(DashboardMetricsType.user));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final currentState = state;
      if (currentState is DashboardLoaded) {
        final updatedUserMetrics = await _loadUserMetrics();
        final updatedData = currentState.data.copyWith(
          userMetrics: updatedUserMetrics,
        );

        emit(currentState.copyWith(data: updatedData));
      }
    } catch (error) {
      emit(
        DashboardError(
          'Failed to load user metrics: ${error.toString()}',
          errorCode: 'USER_METRICS_ERROR',
        ),
      );
    }
  }

  void _onLoadFinancialMetrics(
    LoadFinancialMetrics event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardMetricsLoading(DashboardMetricsType.financial));

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final currentState = state;
      if (currentState is DashboardLoaded) {
        final updatedFinancialMetrics = await _loadFinancialMetrics();
        final updatedData = currentState.data.copyWith(
          financialMetrics: updatedFinancialMetrics,
        );

        emit(currentState.copyWith(data: updatedData));
      }
    } catch (error) {
      emit(
        DashboardError(
          'Failed to load financial metrics: ${error.toString()}',
          errorCode: 'FINANCIAL_METRICS_ERROR',
        ),
      );
    }
  }

  void _onExportDashboardData(
    ExportDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardExporting(format: event.format));

    try {
      // Simulate export progress
      for (double progress = 0.0; progress <= 1.0; progress += 0.2) {
        emit(DashboardExporting(format: event.format, progress: progress));
        await Future.delayed(const Duration(milliseconds: 200));
      }

      final filePath = await _exportData(event.format);

      emit(DashboardExportCompleted(filePath: filePath, format: event.format));

      // Return to loaded state
      if (state is DashboardLoaded) {
        // Keep the current loaded state
      } else {
        add(const LoadDashboard());
      }
    } catch (error) {
      emit(
        DashboardError(
          'Failed to export dashboard data: ${error.toString()}',
          errorCode: 'EXPORT_ERROR',
        ),
      );
    }
  }

  // Private helper methods
  Future<DashboardData> _loadDashboardData() async {
    // Simulate API call to load dashboard data
    await Future.delayed(const Duration(milliseconds: 500));

    return DashboardData(
      apiMetrics: await _loadApiMetrics(),
      userMetrics: await _loadUserMetrics(),
      financialMetrics: await _loadFinancialMetrics(),
      apiUsageChart: await _loadApiUsageChart(),
      userActivityChart: await _loadUserActivityChart(),
      recentOrders: await _loadRecentOrders(),
      dateFrom: DateTime.now().subtract(const Duration(days: 30)),
      dateTo: DateTime.now(),
    );
  }

  Future<DashboardData> _loadDashboardDataForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Load data filtered by date range
    await Future.delayed(const Duration(milliseconds: 500));

    return DashboardData(
      apiMetrics: await _loadApiMetrics(),
      userMetrics: await _loadUserMetrics(),
      financialMetrics: await _loadFinancialMetrics(),
      apiUsageChart: await _loadApiUsageChart(),
      userActivityChart: await _loadUserActivityChart(),
      recentOrders: await _loadRecentOrders(),
      dateFrom: startDate,
      dateTo: endDate,
    );
  }

  Future<ApiMetrics> _loadApiMetrics() async {
    return const ApiMetrics(
      totalCalls: 201,
      changePercentage: 8.2,
      activeEndpoints: 36,
      endpointsChangePercentage: 3.4,
      errorCount: 5,
      errorRate: 0.02,
      averageResponseTime: 150.5,
    );
  }

  Future<UserMetrics> _loadUserMetrics() async {
    return const UserMetrics(
      totalUsers: 4890,
      changePercentage: 12.5,
      activeUsers: 3200,
      newUsers: 62,
      returningUsers: 26,
      inactiveUsers: 12,
      usersByPlan: {'free': 3000, 'pro': 1500, 'enterprise': 390},
    );
  }

  Future<FinancialMetrics> _loadFinancialMetrics() async {
    return const FinancialMetrics(
      monthlyRevenue: 25410.0,
      revenueChangePercentage: -0.2,
      totalRevenue: 1352.0,
      totalRevenueChangePercentage: -1.2,
      paidInvoices: 30256.23,
      fundsReceived: 150256.23,
      subscriptions: 1201,
      subscriptionChangePercentage: 5.8,
    );
  }

  Future<List<ChartData>> _loadApiUsageChart() async {
    return [
      ChartData(date: DateTime(2024, 1), value: 250),
      ChartData(date: DateTime(2024, 2), value: 300),
      ChartData(date: DateTime(2024, 3), value: 320),
      ChartData(date: DateTime(2024, 4), value: 280),
      ChartData(date: DateTime(2024, 5), value: 350),
      ChartData(date: DateTime(2024, 6), value: 300),
      ChartData(date: DateTime(2024, 7), value: 280),
      ChartData(date: DateTime(2024, 8), value: 400),
      ChartData(date: DateTime(2024, 9), value: 350),
      ChartData(date: DateTime(2024, 10), value: 380),
      ChartData(date: DateTime(2024, 11), value: 370),
      ChartData(date: DateTime(2024, 12), value: 400),
    ];
  }

  Future<List<ChartData>> _loadUserActivityChart() async {
    return [
      ChartData(date: DateTime(2024, 1), value: 200),
      ChartData(date: DateTime(2024, 2), value: 250),
      ChartData(date: DateTime(2024, 3), value: 300),
      ChartData(date: DateTime(2024, 4), value: 280),
      ChartData(date: DateTime(2024, 5), value: 350),
      ChartData(date: DateTime(2024, 6), value: 320),
      ChartData(date: DateTime(2024, 7), value: 380),
      ChartData(date: DateTime(2024, 8), value: 400),
      ChartData(date: DateTime(2024, 9), value: 370),
      ChartData(date: DateTime(2024, 10), value: 420),
      ChartData(date: DateTime(2024, 11), value: 400),
      ChartData(date: DateTime(2024, 12), value: 450),
    ];
  }

  Future<List<CustomerOrder>> _loadRecentOrders() async {
    return [
      CustomerOrder(
        id: '1',
        customerName: 'Press',
        customerEmail: 'press@example.com',
        address: 'London',
        date: DateTime(2022, 8, 22),
        status: OrderStatus.delivered,
        amount: 920.0,
      ),
      CustomerOrder(
        id: '2',
        customerName: 'Marina',
        customerEmail: 'marina@example.com',
        address: 'Man city',
        date: DateTime(2022, 8, 24),
        status: OrderStatus.processed,
        amount: 452.0,
      ),
      CustomerOrder(
        id: '3',
        customerName: 'Alex',
        customerEmail: 'alex@example.com',
        address: 'Unknown',
        date: DateTime(2022, 8, 18),
        status: OrderStatus.cancelled,
        amount: 1200.0,
      ),
      CustomerOrder(
        id: '4',
        customerName: 'Robert',
        customerEmail: 'robert@example.com',
        address: 'New York',
        date: DateTime(2022, 8, 3),
        status: OrderStatus.delivered,
        amount: 1235.0,
      ),
    ];
  }

  DateRange _getDateRangeForPeriod(DashboardPeriod period) {
    final now = DateTime.now();

    switch (period) {
      case DashboardPeriod.today:
        return DateRange(
          start: DateTime(now.year, now.month, now.day),
          end: now,
        );
      case DashboardPeriod.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return DateRange(
          start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          end: now,
        );
      case DashboardPeriod.thisMonth:
        return DateRange(start: DateTime(now.year, now.month, 1), end: now);
      case DashboardPeriod.thisYear:
        return DateRange(start: DateTime(now.year, 1, 1), end: now);
      case DashboardPeriod.custom:
        return DateRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
    }
  }

  Future<String> _exportData(DashboardExportFormat format) async {
    // Simulate file export
    await Future.delayed(const Duration(seconds: 1));

    switch (format) {
      case DashboardExportFormat.pdf:
        return '/downloads/dashboard_export.pdf';
      case DashboardExportFormat.csv:
        return '/downloads/dashboard_export.csv';
      case DashboardExportFormat.json:
        return '/downloads/dashboard_export.json';
    }
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});
}
