import '../repositories/dashboard_repository.dart';
import '../../data/models/dashboard_model.dart';

class GetOverviewCardsUseCase {
  final DashboardRepository repository;

  GetOverviewCardsUseCase({required this.repository});

  Future<List<OverviewCard>> call() async {
    return await repository.getOverviewCards();
  }
}

class GetAnalyticsDataUseCase {
  final DashboardRepository repository;

  GetAnalyticsDataUseCase({required this.repository});

  Future<AnalyticsData> call() async {
    return await repository.getAnalyticsData();
  }
}

class GetRecentActivitiesUseCase {
  final DashboardRepository repository;

  GetRecentActivitiesUseCase({required this.repository});

  Future<List<RecentActivity>> call({int limit = 10}) async {
    return await repository.getRecentActivities(limit: limit);
  }
}

class GetTopEndpointsUseCase {
  final DashboardRepository repository;

  GetTopEndpointsUseCase({required this.repository});

  Future<List<ApiEndpoint>> call({int limit = 5}) async {
    return await repository.getTopEndpoints(limit: limit);
  }
}

class GetChartDataUseCase {
  final DashboardRepository repository;

  GetChartDataUseCase({required this.repository});

  Future<LineChartData> getLineChart(String chartId) async {
    return await repository.getLineChartData(chartId);
  }

  Future<PieChartData> getPieChart(String chartId) async {
    return await repository.getPieChartData(chartId);
  }

  Future<BarChartData> getBarChart(String chartId) async {
    return await repository.getBarChartData(chartId);
  }
}
