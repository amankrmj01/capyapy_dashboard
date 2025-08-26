import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/backward_compatibility.dart';
import '../../../data/models/project_model.dart';
import '../../../domain/repositories/project_repository.dart';
import 'project_details_event.dart';
import 'project_details_state.dart';

class ProjectDetailsBloc
    extends Bloc<ProjectDetailsEvent, ProjectDetailsState> {
  final ProjectRepository repository;

  ProjectDetailsBloc(this.repository) : super(ProjectDetailsInitial()) {
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
      final updatedProject = currentState.project.copyWith(
        mongoDbDataModels: [
          ...currentState.project.mongoDbDataModels,
          event.dataModel,
        ],
        updatedAt: DateTime.now(),
      );

      emit(ProjectDetailsUpdating(updatedProject));

      try {
        await Future.delayed(const Duration(milliseconds: 300));
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
      final updatedDataModels = List<DataModel>.from(
        currentState.project.dataModels,
      );
      updatedDataModels[event.index] = event.dataModel;

      final updatedProject = currentState.project.copyWith(
        mongoDbDataModels: updatedDataModels,
        updatedAt: DateTime.now(),
      );

      emit(ProjectDetailsUpdating(updatedProject));

      try {
        await Future.delayed(const Duration(milliseconds: 300));
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
      final updatedDataModels = List<DataModel>.from(
        currentState.project.dataModels,
      );
      updatedDataModels.removeAt(event.index);

      final updatedProject = currentState.project.copyWith(
        mongoDbDataModels: updatedDataModels,
        updatedAt: DateTime.now(),
      );

      emit(ProjectDetailsUpdating(updatedProject));

      try {
        await Future.delayed(const Duration(milliseconds: 300));
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
      final updatedProject = currentState.project.copyWith(
        endpoints: [...currentState.project.endpoints, event.endpoint],
        updatedAt: DateTime.now(),
      );

      emit(ProjectDetailsUpdating(updatedProject));

      try {
        await Future.delayed(const Duration(milliseconds: 300));
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
      final updatedEndpoints = List<Endpoint>.from(
        currentState.project.endpoints,
      );
      updatedEndpoints[event.index] = event.endpoint;

      final updatedProject = currentState.project.copyWith(
        endpoints: updatedEndpoints,
        updatedAt: DateTime.now(),
      );

      emit(ProjectDetailsUpdating(updatedProject));

      try {
        await Future.delayed(const Duration(milliseconds: 300));
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
      final updatedEndpoints = List<Endpoint>.from(
        currentState.project.endpoints,
      );
      updatedEndpoints.removeAt(event.index);

      final updatedProject = currentState.project.copyWith(
        endpoints: updatedEndpoints,
        updatedAt: DateTime.now(),
      );

      emit(ProjectDetailsUpdating(updatedProject));

      try {
        await Future.delayed(const Duration(milliseconds: 300));
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
