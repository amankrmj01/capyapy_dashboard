import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/models.dart';
import '../../../domain/usecases/project/create_project_usecase.dart';
import 'package:equatable/equatable.dart';

part 'project_creation_event.dart';

part 'project_creation_state.dart';

class ProjectCreationBloc
    extends Bloc<ProjectCreationEvent, ProjectCreationState> {
  final uuid = Uuid();
  final CreateProjectUseCase createProjectUseCase;

  ProjectCreationBloc({required this.createProjectUseCase})
    : super(const ProjectCreationInitial()) {
    // Register all event handlers
    on<StartProjectCreation>(_onStartProjectCreation);
    on<UpdateProjectBasicInfo>(_onUpdateProjectBasicInfo);
    on<UpdateAuthSettings>(_onUpdateAuthSettings);
    on<AddDataModel>(_onAddDataModel);
    on<UpdateDataModel>(_onUpdateDataModel);
    on<RemoveDataModel>(_onRemoveDataModel);
    on<AddEndpoint>(_onAddEndpoint);
    on<UpdateEndpoint>(_onUpdateEndpoint);
    on<RemoveEndpoint>(_onRemoveEndpoint);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<CreateProject>(_onCreateProject);
    on<ResetBuilder>(_onResetBuilder);
    on<UpdateStorageSettings>(_onUpdateStorageSettings);
  }

  void _onStartProjectCreation(
    StartProjectCreation event,
    Emitter<ProjectCreationState> emit,
  ) {
    emit(
      const ProjectCreationInitial(
        step: 0,
        projectName: '',
        basePath: '/api/v1',
        hasAuth: false,
        dataModels: [],
        endpoints: [],
      ),
    );
  }

  void _onUpdateProjectBasicInfo(
    UpdateProjectBasicInfo event,
    Emitter<ProjectCreationState> emit,
  ) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final newState = currentState.copyWith(
        projectName: event.projectName,
        basePath: event.basePath,
      );
      emit(newState);
    }
  }

  void _onUpdateAuthSettings(
    UpdateAuthSettings event,
    Emitter<ProjectCreationState> emit,
  ) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final newState = currentState.copyWith(
        hasAuth: event.hasAuth,
        authStrategy: event.authStrategy,
      );
      emit(newState);
    }
  }

  void _onAddDataModel(AddDataModel event, Emitter<ProjectCreationState> emit) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final updatedModels = List<ProjectDataModel>.from(currentState.dataModels)
        ..add(event.dataModel);

      final newState = currentState.copyWith(dataModels: updatedModels);
      emit(newState);
    }
  }

  void _onUpdateDataModel(
    UpdateDataModel event,
    Emitter<ProjectCreationState> emit,
  ) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final updatedModels = List<ProjectDataModel>.from(
        currentState.dataModels,
      );

      if (event.index >= 0 && event.index < updatedModels.length) {
        updatedModels[event.index] = event.dataModel;
        final newState = currentState.copyWith(dataModels: updatedModels);
        emit(newState);
      }
    }
  }

  void _onRemoveDataModel(
    RemoveDataModel event,
    Emitter<ProjectCreationState> emit,
  ) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final updatedModels = List<ProjectDataModel>.from(
        currentState.dataModels,
      );

      if (event.index >= 0 && event.index < updatedModels.length) {
        updatedModels.removeAt(event.index);
        final newState = currentState.copyWith(dataModels: updatedModels);
        emit(newState);
      }
    }
  }

  void _onAddEndpoint(AddEndpoint event, Emitter<ProjectCreationState> emit) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final updatedEndpoints = List<ProjectEndpoint>.from(
        currentState.endpoints,
      )..add(event.endpoint);

      final newState = currentState.copyWith(endpoints: updatedEndpoints);
      emit(newState);
    }
  }

  void _onUpdateEndpoint(
    UpdateEndpoint event,
    Emitter<ProjectCreationState> emit,
  ) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final updatedEndpoints = List<ProjectEndpoint>.from(
        currentState.endpoints,
      );

      if (event.index >= 0 && event.index < updatedEndpoints.length) {
        updatedEndpoints[event.index] = event.endpoint;
        final newState = currentState.copyWith(endpoints: updatedEndpoints);
        emit(newState);
      }
    }
  }

  void _onRemoveEndpoint(
    RemoveEndpoint event,
    Emitter<ProjectCreationState> emit,
  ) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      final updatedEndpoints = List<ProjectEndpoint>.from(
        currentState.endpoints,
      );

      if (event.index >= 0 && event.index < updatedEndpoints.length) {
        updatedEndpoints.removeAt(event.index);
        final newState = currentState.copyWith(endpoints: updatedEndpoints);
        emit(newState);
      }
    }
  }

  void _onNextStep(NextStep event, Emitter<ProjectCreationState> emit) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      if (currentState.canProceedToNext && currentState.step < 4) {
        emit(currentState.copyWith(step: currentState.step + 1));
      }
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<ProjectCreationState> emit) {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      if (currentState.step > 0) {
        emit(currentState.copyWith(step: currentState.step - 1));
      }
    }
  }

  void _onCreateProject(
    CreateProject event,
    Emitter<ProjectCreationState> emit,
  ) async {
    if (state is ProjectCreationInitial) {
      final currentState = state as ProjectCreationInitial;
      emit(const ProjectCreationLoading());
      try {
        final project = _buildProjectFromState(currentState);
        final createdProject = await createProjectUseCase(project);
        emit(ProjectCreationSuccess(createdProject));
      } catch (error) {
        emit(ProjectCreationError(error.toString()));
      }
    }
  }

  void _onResetBuilder(ResetBuilder event, Emitter<ProjectCreationState> emit) {
    emit(const ProjectCreationInitial());
  }

  void _onUpdateStorageSettings(
    UpdateStorageSettings event,
    Emitter<ProjectCreationState> emit,
  ) {
    final currentState = state;
    if (currentState is ProjectCreationInitial) {
      emit(
        currentState.copyWith(
          storageConfig: event.storageConfig,
          hasStorage: event.storageConfig != null,
        ),
      );
    }
  }

  ProjectModel _buildProjectFromState(ProjectCreationInitial state) {
    final now = DateTime.now();

    // Generate unique ID: projectname_uuid
    final sanitizedName = state.projectName
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
    final uniqueId = '${sanitizedName}_${uuid.v4()}';

    // Create base project with default values
    final baseProject = ProjectModel(
      id: '',
      // Will be set with copyWith
      projectName: state.projectName,
      description: 'Auto-generated project description',
      apiBasePath: state.basePath,
      isActive: true,
      hasAuth: state.hasAuth,
      authStrategy: state.authStrategy,
      mongoDbDataModels: state.dataModels,
      endpoints: state.endpoints,
      storage: StorageConfig(
        type: StorageType.mongodb,
        connectionString: 'mongodb://localhost:27017',
        databaseName: sanitizedName,
        options: const {'useUnifiedTopology': true},
      ),
      metadata: ProjectMetadata(
        version: '1.0.0',
        author: 'Current User',
        tags: const ['mock', 'api', 'development'],
      ),
      apiCallsAnalytics: ApiCallsAnalytics(totalCalls: 0, lastUpdated: now),
      createdAt: now,
      updatedAt: now,
    );

    // Use copyWith to set the unique ID (same pattern as your ProjectBuilderBloc)
    return baseProject.copyWith(id: uniqueId, createdAt: now, updatedAt: now);
  }
}
