import '../../repositories/user_repository.dart';

class RemoveProjectIdUseCase {
  final UserRepository repository;

  RemoveProjectIdUseCase(this.repository);

  Future<void> call(String userId, String projectId) async {
    await repository.removeProjectId(userId, projectId);
  }
}
