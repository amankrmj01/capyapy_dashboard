import '../../repositories/user_repository.dart';

class GetProjectIdsUseCase {
  final UserRepository repository;

  GetProjectIdsUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getProjectIds();
  }
}
