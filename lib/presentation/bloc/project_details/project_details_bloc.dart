import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/usecases/project/project_details_usecases.dart';
import 'project_details_event.dart';
import 'project_details_state.dart';

class ProjectDetailsBloc
    extends Bloc<ProjectDetailsEvent, ProjectDetailsState> {
  final ProjectRepository repository;
  final ProjectDetailsUseCases useCases;

  ProjectDetailsBloc(this.repository, this.useCases)
    : super(ProjectDetailsInitial()) {
    on<LoadProjectDetails>(_onLoadProjectDetails);
    on<UpdateProject>(_onUpdateProject);
    on<AddDataModel>(_onAddDataModel);
    on<UpdateDataModel>(_onUpdateDataModel);
    on<DeleteDataModel>(_onDeleteDataModel);
    on<AddEndpoint>(_onAddEndpoint);
    on<UpdateEndpoint>(_onUpdateEndpoint);
    on<DeleteEndpoint>(_onDeleteEndpoint);
    on<DeleteProject>(_onDeleteProject);
  }

  void _onLoadProjectDetails(
    LoadProjectDetails event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    emit(ProjectDetailsLoading());
    final project = await repository.getProjectById(event.projectId);
    if (project != null) {
      emit(ProjectDetailsLoaded(project));
    } else {
      emit(ProjectDetailsError('Project not found'));
    }
  }

  void _onUpdateProject(
    UpdateProject event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      emit(ProjectDetailsUpdating(event.project));

      try {
        // In a real app, you would save the project to a repository
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate API call

        emit(ProjectDetailsLoaded(event.project));
      } catch (e) {
        emit(ProjectDetailsError('Failed to update project: ${e.toString()}'));
      }
    } else {
      emit(ProjectDetailsLoaded(event.project));
    }
  }

  void _onAddDataModel(
    AddDataModel event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      final currentState = state as ProjectDetailsLoaded;
      emit(ProjectDetailsUpdating(currentState.project));
      try {
        final updatedProject = await useCases.addDataModel.call(
          currentState.project.id,
          event.dataModel,
        );
        emit(ProjectDetailsLoaded(updatedProject));
      } catch (e) {
        emit(ProjectDetailsError('Failed to add data model: ${e.toString()}'));
      }
    }
  }

  void _onUpdateDataModel(
    UpdateDataModel event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      final currentState = state as ProjectDetailsLoaded;
      emit(ProjectDetailsUpdating(currentState.project));
      try {
        final updatedProject = await useCases.updateDataModel.call(
          currentState.project.id,
          event.index,
          event.dataModel,
        );
        emit(ProjectDetailsLoaded(updatedProject));
      } catch (e) {
        emit(
          ProjectDetailsError('Failed to update data model: ${e.toString()}'),
        );
      }
    }
  }

  void _onDeleteDataModel(
    DeleteDataModel event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      final currentState = state as ProjectDetailsLoaded;
      emit(ProjectDetailsUpdating(currentState.project));
      try {
        final updatedProject = await useCases.deleteDataModel.call(
          currentState.project.id,
          event.index,
        );
        emit(ProjectDetailsLoaded(updatedProject));
      } catch (e) {
        emit(
          ProjectDetailsError('Failed to delete data model: ${e.toString()}'),
        );
      }
    }
  }

  void _onAddEndpoint(
    AddEndpoint event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      final currentState = state as ProjectDetailsLoaded;
      emit(ProjectDetailsUpdating(currentState.project));
      try {
        final updatedProject = await useCases.addEndpoint.call(
          currentState.project.id,
          event.endpoint,
        );
        emit(ProjectDetailsLoaded(updatedProject));
      } catch (e) {
        emit(ProjectDetailsError('Failed to add endpoint: ${e.toString()}'));
      }
    }
  }

  void _onUpdateEndpoint(
    UpdateEndpoint event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      final currentState = state as ProjectDetailsLoaded;
      emit(ProjectDetailsUpdating(currentState.project));
      try {
        final updatedProject = await useCases.updateEndpoint.call(
          currentState.project.id,
          event.index,
          event.endpoint,
        );
        emit(ProjectDetailsLoaded(updatedProject));
      } catch (e) {
        emit(ProjectDetailsError('Failed to update endpoint: ${e.toString()}'));
      }
    }
  }

  void _onDeleteEndpoint(
    DeleteEndpoint event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      final currentState = state as ProjectDetailsLoaded;
      emit(ProjectDetailsUpdating(currentState.project));
      try {
        final updatedProject = await useCases.deleteEndpoint.call(
          currentState.project.id,
          event.index,
        );
        emit(ProjectDetailsLoaded(updatedProject));
      } catch (e) {
        emit(ProjectDetailsError('Failed to delete endpoint: ${e.toString()}'));
      }
    }
  }

  void _onDeleteProject(
    DeleteProject event,
    Emitter<ProjectDetailsState> emit,
  ) async {
    if (state is ProjectDetailsLoaded) {
      emit(ProjectDetailsLoading());

      try {
        // In a real app, you would delete the project from a repository
        await Future.delayed(const Duration(milliseconds: 500));
        emit(ProjectDeleted());
      } catch (e) {
        emit(ProjectDetailsError('Failed to delete project: ${e.toString()}'));
      }
    }
  }
}
