import '../models/dashboard_model.dart';
import 'dashboard_data_source.dart';

class MockDashboardDataSource implements DashboardDataSource {
  // Simulated network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(
      Duration(
        milliseconds: 300 + (DateTime.now().millisecondsSinceEpoch % 500),
      ),
    );
  }

  @override
  Future<DashboardOverview> getDashboardOverview() async {
    await _simulateNetworkDelay();

    final overviewCards = await getOverviewCards();
    final analytics = await getAnalyticsData();
    final recentActivities = await getRecentActivities();
    final topEndpoints = await getTopEndpoints();

    return DashboardOverview(
      overviewCards: overviewCards,
      analytics: analytics,
      recentActivities: recentActivities,
      topEndpoints: topEndpoints,
    );
  }

  @override
  Future<List<OverviewCard>> getOverviewCards() async {
    await _simulateNetworkDelay();

    return [
      OverviewCard(
        id: 'total_requests',
        title: 'Total Requests',
        value: '2,845',
        subtitle: 'This month',
        icon: '📊',
        color: 'blue',
        changePercentage: 12.5,
        isPositiveChange: true,
        period: '30d',
      ),
      OverviewCard(
        id: 'active_projects',
        title: 'Active Projects',
        value: '24',
        subtitle: '8 in development',
        icon: '🚀',
        color: 'green',
        changePercentage: 8.2,
        isPositiveChange: true,
        period: '30d',
      ),
      OverviewCard(
        id: 'api_endpoints',
        title: 'API Endpoints',
        value: '156',
        subtitle: 'Across all projects',
        icon: '🔗',
        color: 'orange',
        changePercentage: 15.3,
        isPositiveChange: true,
        period: '30d',
      ),
      OverviewCard(
        id: 'response_time',
        title: 'Avg Response Time',
        value: '245ms',
        subtitle: '99.8% uptime',
        icon: '⚡',
        color: 'purple',
        changePercentage: 3.1,
        isPositiveChange: false,
        period: '24h',
      ),
      OverviewCard(
        id: 'data_models',
        title: 'Data Models',
        value: '87',
        subtitle: 'Total schemas',
        icon: '📋',
        color: 'indigo',
        changePercentage: 6.7,
        isPositiveChange: true,
        period: '30d',
      ),
      OverviewCard(
        id: 'mock_data_points',
        title: 'Mock Data Points',
        value: '12.4K',
        subtitle: 'Generated records',
        icon: '💾',
        color: 'teal',
        changePercentage: 22.1,
        isPositiveChange: true,
        period: '30d',
      ),
      OverviewCard(
        id: 'users_active',
        title: 'Active Users',
        value: '342',
        subtitle: 'Last 24 hours',
        icon: '👥',
        color: 'pink',
        changePercentage: 4.8,
        isPositiveChange: true,
        period: '24h',
      ),
      OverviewCard(
        id: 'error_rate',
        title: 'Error Rate',
        value: '0.12%',
        subtitle: 'Below threshold',
        icon: '⚠️',
        color: 'red',
        changePercentage: 0.8,
        isPositiveChange: false,
        period: '24h',
      ),
    ];
  }

  @override
  Future<AnalyticsData> getAnalyticsData() async {
    await _simulateNetworkDelay();

    final lineChart = await getLineChartData('api_requests_trend');
    final pieChart = await getPieChartData('request_methods');
    final barChart = await getBarChartData('project_activity');

    return AnalyticsData(
      lineChart: lineChart,
      pieChart: pieChart,
      barChart: barChart,
    );
  }

  @override
  Future<LineChartData> getLineChartData(String chartId) async {
    await _simulateNetworkDelay();

    switch (chartId) {
      case 'api_requests_trend':
        return LineChartData(
          title: 'API Requests Trend',
          dataPoints: [
            ChartPoint(x: 0, y: 450, label: 'Mon'),
            ChartPoint(x: 1, y: 620, label: 'Tue'),
            ChartPoint(x: 2, y: 380, label: 'Wed'),
            ChartPoint(x: 3, y: 720, label: 'Thu'),
            ChartPoint(x: 4, y: 890, label: 'Fri'),
            ChartPoint(x: 5, y: 540, label: 'Sat'),
            ChartPoint(x: 6, y: 1150, label: 'Sun'),
          ],
          xAxisLabel: 'Days',
          yAxisLabel: 'Requests',
          color: 'blue',
        );
      case 'user_activity':
        return LineChartData(
          title: 'User Activity',
          dataPoints: [
            ChartPoint(x: 0, y: 120, label: '00:00'),
            ChartPoint(x: 1, y: 85, label: '04:00'),
            ChartPoint(x: 2, y: 65, label: '08:00'),
            ChartPoint(x: 3, y: 180, label: '12:00'),
            ChartPoint(x: 4, y: 220, label: '16:00'),
            ChartPoint(x: 5, y: 195, label: '20:00'),
          ],
          xAxisLabel: 'Time',
          yAxisLabel: 'Active Users',
          color: 'green',
        );
      default:
        return LineChartData(
          title: 'Default Chart',
          dataPoints: [
            ChartPoint(x: 0, y: 100, label: 'Start'),
            ChartPoint(x: 1, y: 200, label: 'End'),
          ],
          xAxisLabel: 'X Axis',
          yAxisLabel: 'Y Axis',
          color: 'blue',
        );
    }
  }

  @override
  Future<PieChartData> getPieChartData(String chartId) async {
    await _simulateNetworkDelay();

    switch (chartId) {
      case 'request_methods':
        return PieChartData(
          title: 'HTTP Request Methods',
          segments: [
            PieChartSegment(
              label: 'GET',
              value: 1280,
              color: 'blue',
              percentage: 45.0,
            ),
            PieChartSegment(
              label: 'POST',
              value: 711,
              color: 'green',
              percentage: 25.0,
            ),
            PieChartSegment(
              label: 'PUT',
              value: 569,
              color: 'orange',
              percentage: 20.0,
            ),
            PieChartSegment(
              label: 'DELETE',
              value: 285,
              color: 'red',
              percentage: 10.0,
            ),
          ],
        );
      case 'project_status':
        return PieChartData(
          title: 'Project Status Distribution',
          segments: [
            PieChartSegment(
              label: 'Active',
              value: 12,
              color: 'green',
              percentage: 50.0,
            ),
            PieChartSegment(
              label: 'Development',
              value: 8,
              color: 'orange',
              percentage: 33.3,
            ),
            PieChartSegment(
              label: 'Maintenance',
              value: 3,
              color: 'yellow',
              percentage: 12.5,
            ),
            PieChartSegment(
              label: 'Inactive',
              value: 1,
              color: 'red',
              percentage: 4.2,
            ),
          ],
        );
      default:
        return PieChartData(
          title: 'Default Pie Chart',
          segments: [
            PieChartSegment(
              label: 'Category A',
              value: 100,
              color: 'blue',
              percentage: 50.0,
            ),
            PieChartSegment(
              label: 'Category B',
              value: 100,
              color: 'green',
              percentage: 50.0,
            ),
          ],
        );
    }
  }

  @override
  Future<BarChartData> getBarChartData(String chartId) async {
    await _simulateNetworkDelay();

    switch (chartId) {
      case 'project_activity':
        return BarChartData(
          title: 'Project Activity by Type',
          bars: [
            BarChartItem(label: 'E-commerce', value: 24, color: 'blue'),
            BarChartItem(label: 'Blog APIs', value: 18, color: 'green'),
            BarChartItem(label: 'User Auth', value: 15, color: 'orange'),
            BarChartItem(label: 'Finance', value: 12, color: 'purple'),
            BarChartItem(label: 'Social', value: 8, color: 'pink'),
          ],
          xAxisLabel: 'Project Type',
          yAxisLabel: 'Number of Projects',
        );
      case 'monthly_requests':
        return BarChartData(
          title: 'Monthly API Requests',
          bars: [
            BarChartItem(label: 'Jan', value: 1200, color: 'blue'),
            BarChartItem(label: 'Feb', value: 1450, color: 'blue'),
            BarChartItem(label: 'Mar', value: 1680, color: 'blue'),
            BarChartItem(label: 'Apr', value: 1890, color: 'blue'),
            BarChartItem(label: 'May', value: 2100, color: 'blue'),
            BarChartItem(label: 'Jun', value: 2350, color: 'blue'),
          ],
          xAxisLabel: 'Month',
          yAxisLabel: 'API Requests',
        );
      default:
        return BarChartData(
          title: 'Default Bar Chart',
          bars: [
            BarChartItem(label: 'Item 1', value: 100, color: 'blue'),
            BarChartItem(label: 'Item 2', value: 150, color: 'green'),
          ],
          xAxisLabel: 'Items',
          yAxisLabel: 'Values',
        );
    }
  }

  @override
  Future<List<RecentActivity>> getRecentActivities({int limit = 10}) async {
    await _simulateNetworkDelay();

    final allActivities = [
      RecentActivity(
        id: 'activity_1',
        title: 'New Project Created',
        description:
            'E-commerce API v2.0 project has been successfully created',
        timestamp: '2 minutes ago',
        type: 'project',
        icon: '🚀',
        status: 'success',
      ),
      RecentActivity(
        id: 'activity_2',
        title: 'Endpoint Modified',
        description: 'GET /api/products endpoint updated with new filters',
        timestamp: '15 minutes ago',
        type: 'endpoint',
        icon: '🔗',
        status: 'info',
      ),
      RecentActivity(
        id: 'activity_3',
        title: 'High Traffic Alert',
        description:
            'Blog API receiving unusually high traffic (200% increase)',
        timestamp: '32 minutes ago',
        type: 'alert',
        icon: '⚠️',
        status: 'warning',
      ),
      RecentActivity(
        id: 'activity_4',
        title: 'Data Model Updated',
        description:
            'User schema updated with new fields: avatar_url, preferences',
        timestamp: '1 hour ago',
        type: 'model',
        icon: '📋',
        status: 'info',
      ),
      RecentActivity(
        id: 'activity_5',
        title: 'System Maintenance',
        description: 'Scheduled maintenance completed successfully',
        timestamp: '2 hours ago',
        type: 'system',
        icon: '🛠️',
        status: 'success',
      ),
      RecentActivity(
        id: 'activity_6',
        title: 'New User Registration',
        description: 'john.doe@example.com registered and verified account',
        timestamp: '3 hours ago',
        type: 'user',
        icon: '👤',
        status: 'info',
      ),
      RecentActivity(
        id: 'activity_7',
        title: 'API Key Generated',
        description: 'New API key generated for Mobile App v3.2',
        timestamp: '4 hours ago',
        type: 'security',
        icon: '🔑',
        status: 'success',
      ),
      RecentActivity(
        id: 'activity_8',
        title: 'Error Rate Spike',
        description: 'Authentication service error rate increased to 2.1%',
        timestamp: '5 hours ago',
        type: 'error',
        icon: '🚨',
        status: 'error',
      ),
      RecentActivity(
        id: 'activity_9',
        title: 'Database Backup',
        description: 'Weekly automated backup completed (2.3GB)',
        timestamp: '6 hours ago',
        type: 'system',
        icon: '💾',
        status: 'success',
      ),
      RecentActivity(
        id: 'activity_10',
        title: 'Performance Optimization',
        description: 'Response time improved by 15% after caching update',
        timestamp: '8 hours ago',
        type: 'performance',
        icon: '⚡',
        status: 'success',
      ),
      RecentActivity(
        id: 'activity_11',
        title: 'Feature Flag Updated',
        description: 'Beta search feature enabled for 25% of users',
        timestamp: '12 hours ago',
        type: 'feature',
        icon: '🎛️',
        status: 'info',
      ),
      RecentActivity(
        id: 'activity_12',
        title: 'Security Scan',
        description: 'Daily security scan completed - no vulnerabilities found',
        timestamp: '1 day ago',
        type: 'security',
        icon: '🛡️',
        status: 'success',
      ),
    ];

    return allActivities.take(limit).toList();
  }

  @override
  Future<List<ApiEndpoint>> getTopEndpoints({int limit = 5}) async {
    await _simulateNetworkDelay();

    final allEndpoints = [
      ApiEndpoint(
        id: 'endpoint_1',
        path: '/api/v1/users',
        method: 'GET',
        hits: 1234,
        responseTime: 142.5,
        successRate: 99.8,
        status: 'healthy',
      ),
      ApiEndpoint(
        id: 'endpoint_2',
        path: '/api/v1/products',
        method: 'GET',
        hits: 987,
        responseTime: 89.3,
        successRate: 99.9,
        status: 'healthy',
      ),
      ApiEndpoint(
        id: 'endpoint_3',
        path: '/api/v1/orders',
        method: 'POST',
        hits: 765,
        responseTime: 256.7,
        successRate: 98.5,
        status: 'healthy',
      ),
      ApiEndpoint(
        id: 'endpoint_4',
        path: '/api/v1/auth/login',
        method: 'POST',
        hits: 543,
        responseTime: 178.2,
        successRate: 97.8,
        status: 'warning',
      ),
      ApiEndpoint(
        id: 'endpoint_5',
        path: '/api/v1/products/search',
        method: 'GET',
        hits: 432,
        responseTime: 145.8,
        successRate: 99.2,
        status: 'healthy',
      ),
      ApiEndpoint(
        id: 'endpoint_6',
        path: '/api/v1/users/profile',
        method: 'PUT',
        hits: 321,
        responseTime: 198.4,
        successRate: 99.1,
        status: 'healthy',
      ),
      ApiEndpoint(
        id: 'endpoint_7',
        path: '/api/v1/orders/{id}',
        method: 'GET',
        hits: 298,
        responseTime: 112.6,
        successRate: 99.7,
        status: 'healthy',
      ),
      ApiEndpoint(
        id: 'endpoint_8',
        path: '/api/v1/payments',
        method: 'POST',
        hits: 187,
        responseTime: 324.1,
        successRate: 96.2,
        status: 'critical',
      ),
    ];

    return allEndpoints.take(limit).toList();
  }
}
