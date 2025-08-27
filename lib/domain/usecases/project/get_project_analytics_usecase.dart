import '../../../data/models/models.dart';
import '../../repositories/project_repository.dart';

class GetProjectAnalyticsUseCase {
  final ProjectRepository repository;

  GetProjectAnalyticsUseCase({required this.repository});

  Future<ApiCallsAnalytics> call(String projectId) async {
    return await repository.getProjectAnalytics(projectId);
  }
}
