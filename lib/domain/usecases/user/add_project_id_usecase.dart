import '../../repositories/user_repository.dart';

class AddProjectIdUseCase {
  final UserRepository repository;

  AddProjectIdUseCase(this.repository);

  Future<void> call(String userId, String projectId) async {
    await repository.addProjectId(userId, projectId);
  }
}
