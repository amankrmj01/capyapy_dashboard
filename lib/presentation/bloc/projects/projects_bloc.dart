import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/project_repository.dart';
import 'projects_event.dart';
import 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectRepository projectRepository;

  ProjectsBloc({required this.projectRepository}) : super(ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<RefreshProjects>(_onRefreshProjects);
    on<DeleteProject>(_onDeleteProject);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());
    try {
      final projects = await projectRepository.getAllProjects();
      final activeProjects = await projectRepository.getActiveProjects();
      final totalEndpoints = projects.fold<int>(
        0,
        (sum, project) => sum + project.endpoints.length,
      );
      final totalModels = projects.fold<int>(
        0,
        (sum, project) => sum + project.mongoDbDataModels.length,
      );
      final totalApiCalls = projects.fold<int>(
        0,
        (sum, project) => sum + (project.apiCallsAnalytics.totalCalls),
      );

      emit(
        ProjectsLoaded(
          projects: projects,
          totalProjects: projects.length,
          activeProjects: activeProjects.length,
          totalEndpoints: totalEndpoints,
          totalModels: totalModels,
          totalApiCalls: totalApiCalls,
        ),
      );
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> _onRefreshProjects(
    RefreshProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      final projects = await projectRepository.getAllProjects();
      final activeProjects = projects.where((p) => p.isActive).length;
      final totalEndpoints = projects.fold<int>(
        0,
        (sum, project) => sum + project.endpoints.length,
      );
      final totalModels = projects.fold<int>(
        0,
        (sum, project) => sum + project.mongoDbDataModels.length,
      );
      final totalApiCalls = projects.fold<int>(
        0,
        (sum, project) => sum + (project.apiCallsAnalytics.totalCalls),
      );

      emit(
        ProjectsLoaded(
          projects: projects,
          totalProjects: projects.length,
          activeProjects: activeProjects,
          totalEndpoints: totalEndpoints,
          totalModels: totalModels,
          totalApiCalls: totalApiCalls,
        ),
      );
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      await projectRepository.deleteProject(event.projectId);
      add(RefreshProjects());
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }
}
