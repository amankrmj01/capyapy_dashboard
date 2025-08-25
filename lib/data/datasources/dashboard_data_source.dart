import '../models/dashboard_model.dart';

abstract class DashboardDataSource {
  Future<DashboardOverview> getDashboardOverview();

  Future<List<OverviewCard>> getOverviewCards();

  Future<AnalyticsData> getAnalyticsData();

  Future<List<RecentActivity>> getRecentActivities({int limit = 10});

  Future<List<ApiEndpoint>> getTopEndpoints({int limit = 5});

  Future<LineChartData> getLineChartData(String chartId);

  Future<PieChartData> getPieChartData(String chartId);

  Future<BarChartData> getBarChartData(String chartId);
}
