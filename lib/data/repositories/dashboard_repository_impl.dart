import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_data_source.dart';
import '../models/dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl({required this.dataSource});

  @override
  Future<DashboardOverview> getDashboardOverview() async {
    try {
      return await dataSource.getDashboardOverview();
    } catch (e) {
      throw Exception('Failed to fetch dashboard overview: $e');
    }
  }

  @override
  Future<List<OverviewCard>> getOverviewCards() async {
    try {
      return await dataSource.getOverviewCards();
    } catch (e) {
      throw Exception('Failed to fetch overview cards: $e');
    }
  }

  @override
  Future<AnalyticsData> getAnalyticsData() async {
    try {
      return await dataSource.getAnalyticsData();
    } catch (e) {
      throw Exception('Failed to fetch analytics data: $e');
    }
  }

  @override
  Future<List<RecentActivity>> getRecentActivities({int limit = 10}) async {
    try {
      return await dataSource.getRecentActivities(limit: limit);
    } catch (e) {
      throw Exception('Failed to fetch recent activities: $e');
    }
  }

  @override
  Future<List<ApiEndpoint>> getTopEndpoints({int limit = 5}) async {
    try {
      return await dataSource.getTopEndpoints(limit: limit);
    } catch (e) {
      throw Exception('Failed to fetch top endpoints: $e');
    }
  }

  @override
  Future<LineChartData> getLineChartData(String chartId) async {
    try {
      return await dataSource.getLineChartData(chartId);
    } catch (e) {
      throw Exception('Failed to fetch line chart data: $e');
    }
  }

  @override
  Future<PieChartData> getPieChartData(String chartId) async {
    try {
      return await dataSource.getPieChartData(chartId);
    } catch (e) {
      throw Exception('Failed to fetch pie chart data: $e');
    }
  }

  @override
  Future<BarChartData> getBarChartData(String chartId) async {
    try {
      return await dataSource.getBarChartData(chartId);
    } catch (e) {
      throw Exception('Failed to fetch bar chart data: $e');
    }
  }
}
