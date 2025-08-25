import '../repositories/dashboard_repository.dart';
import '../../data/models/dashboard_model.dart';

class GetDashboardOverviewUseCase {
  final DashboardRepository repository;

  GetDashboardOverviewUseCase({required this.repository});

  Future<DashboardOverview> call() async {
    return await repository.getDashboardOverview();
  }
}
