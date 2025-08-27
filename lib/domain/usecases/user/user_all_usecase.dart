import 'package:capyapy_dashboard/domain/repositories/user_repository.dart';
import 'package:capyapy_dashboard/domain/usecases/user/add_project_id_usecase.dart';
import 'package:capyapy_dashboard/domain/usecases/user/get_project_ids_usecase.dart';
import 'package:capyapy_dashboard/domain/usecases/user/get_user_usecase.dart';
import 'package:capyapy_dashboard/domain/usecases/user/logout_user_usecase.dart';
import 'package:capyapy_dashboard/domain/usecases/user/remove_project_id_usecase.dart';
import 'package:capyapy_dashboard/domain/usecases/user/update_user_usecase.dart';

class UserAllUseCase {
  AddProjectIdUseCase addProjectIdUseCase;
  GetProjectIdsUseCase getProjectIdsUseCase;
  GetUserUseCase getUserUseCase;
  LogoutUserUseCase logoutUserUseCase;
  RemoveProjectIdUseCase removeProjectIdUseCase;
  UpdateUserUseCase updateUserUseCase;

  UserAllUseCase(UserRepository repository)
    : addProjectIdUseCase = AddProjectIdUseCase(repository),
      getProjectIdsUseCase = GetProjectIdsUseCase(repository),
      getUserUseCase = GetUserUseCase(repository),
      removeProjectIdUseCase = RemoveProjectIdUseCase(repository),
      updateUserUseCase = UpdateUserUseCase(repository),
      logoutUserUseCase = LogoutUserUseCase(repository);
}
