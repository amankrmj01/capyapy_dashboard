import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/backward_compatibility.dart';
import '../../../domain/usecases/project_usecases.dart';
import 'project_builder_event.dart';
import 'project_builder_state.dart';

class ProjectBuilderBlocs
    extends Bloc<ProjectBuilderEvent, ProjectBuilderState> {
  final CreateProjectUseCase createProjectUseCase;

  ProjectBuilderBlocs({required this.createProjectUseCase})
    : super(const ProjectBuilderInitial()) {
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
    on<GoToStep>(_onGoToStep);
    on<CreateProject>(_onCreateProject);
    on<ResetBuilder>(_onResetBuilder);
  }

  void _onStartProjectCreation(
    StartProjectCreation event,
    Emitter<ProjectBuilderState> emit,
  ) {
    emit(
      const ProjectBuilderInProgress(
        currentStep: 0,
        projectName: '',
        basePath: '/api/v1',
        hasAuth: false,
        dataModels: [],
        endpoints: [],
        isValid: false,
      ),
    );
  }

  void _onUpdateProjectBasicInfo(
    UpdateProjectBasicInfo event,
    Emitter<ProjectBuilderState> emit,
  ) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final newState = currentState.copyWith(
        projectName: event.projectName,
        basePath: event.basePath,
      );
      // Update validation state
      final isValid = _validateCurrentStep(newState);
      emit(newState.copyWith(isValid: isValid));
    }
  }

  void _onUpdateAuthSettings(
    UpdateAuthSettings event,
    Emitter<ProjectBuilderState> emit,
  ) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final newState = currentState.copyWith(
        hasAuth: event.hasAuth,
        authStrategy: event.authStrategy,
      );
      final isValid = _validateCurrentStep(newState);
      emit(newState.copyWith(isValid: isValid));
    }
  }

  void _onAddDataModel(AddDataModel event, Emitter<ProjectBuilderState> emit) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedModels = List<DataModel>.from(currentState.dataModels)
        ..add(event.dataModel);

      final newState = currentState.copyWith(dataModels: updatedModels);
      final isValid = _validateCurrentStep(newState);
      emit(newState.copyWith(isValid: isValid));
    }
  }

  void _onUpdateDataModel(
    UpdateDataModel event,
    Emitter<ProjectBuilderState> emit,
  ) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedModels = List<DataModel>.from(currentState.dataModels);

      if (event.index >= 0 && event.index < updatedModels.length) {
        updatedModels[event.index] = event.dataModel;
        final newState = currentState.copyWith(dataModels: updatedModels);
        final isValid = _validateCurrentStep(newState);
        emit(newState.copyWith(isValid: isValid));
      }
    }
  }

  void _onRemoveDataModel(
    RemoveDataModel event,
    Emitter<ProjectBuilderState> emit,
  ) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedModels = List<DataModel>.from(currentState.dataModels);

      if (event.index >= 0 && event.index < updatedModels.length) {
        updatedModels.removeAt(event.index);
        final newState = currentState.copyWith(dataModels: updatedModels);
        final isValid = _validateCurrentStep(newState);
        emit(newState.copyWith(isValid: isValid));
      }
    }
  }

  void _onAddEndpoint(AddEndpoint event, Emitter<ProjectBuilderState> emit) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedEndpoints = List<Endpoint>.from(currentState.endpoints)
        ..add(event.endpoint);

      final newState = currentState.copyWith(endpoints: updatedEndpoints);
      final isValid = _validateCurrentStep(newState);
      emit(newState.copyWith(isValid: isValid));
    }
  }

  void _onUpdateEndpoint(
    UpdateEndpoint event,
    Emitter<ProjectBuilderState> emit,
  ) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedEndpoints = List<Endpoint>.from(currentState.endpoints);

      if (event.index >= 0 && event.index < updatedEndpoints.length) {
        updatedEndpoints[event.index] = event.endpoint;
        final newState = currentState.copyWith(endpoints: updatedEndpoints);
        final isValid = _validateCurrentStep(newState);
        emit(newState.copyWith(isValid: isValid));
      }
    }
  }

  void _onRemoveEndpoint(
    RemoveEndpoint event,
    Emitter<ProjectBuilderState> emit,
  ) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedEndpoints = List<Endpoint>.from(currentState.endpoints);

      if (event.index >= 0 && event.index < updatedEndpoints.length) {
        updatedEndpoints.removeAt(event.index);
        final newState = currentState.copyWith(endpoints: updatedEndpoints);
        final isValid = _validateCurrentStep(newState);
        emit(newState.copyWith(isValid: isValid));
      }
    }
  }

  void _onNextStep(NextStep event, Emitter<ProjectBuilderState> emit) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      if (currentState.canProceedToNext && currentState.currentStep < 3) {
        emit(currentState.copyWith(currentStep: currentState.currentStep + 1));
      }
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<ProjectBuilderState> emit) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      if (currentState.currentStep > 0) {
        emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
      }
    }
  }

  void _onGoToStep(GoToStep event, Emitter<ProjectBuilderState> emit) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      if (event.step >= 0 && event.step <= 3) {
        emit(currentState.copyWith(currentStep: event.step));
      }
    }
  }

  void _onCreateProject(
    CreateProject event,
    Emitter<ProjectBuilderState> emit,
  ) async {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      emit(const ProjectBuilderCreating());
      try {
        final project = currentState.toProject();
        final createdProject = await createProjectUseCase(project);
        emit(ProjectBuilderSuccess(createdProject));
      } catch (error) {
        emit(ProjectBuilderError(error.toString()));
      }
    }
  }

  void _onResetBuilder(ResetBuilder event, Emitter<ProjectBuilderState> emit) {
    emit(const ProjectBuilderInitial());
  }

  bool _validateCurrentStep(ProjectBuilderInProgress state) {
    switch (state.currentStep) {
      case 0: // Basic Info
        return state.projectName.trim().isNotEmpty &&
            state.basePath.trim().isNotEmpty;
      case 1: // Auth Settings
        return true; // Auth step is always valid
      case 2: // Data Models
        return state.dataModels.isNotEmpty;
      case 3: // Endpoints
        return state.endpoints.isNotEmpty;
      default:
        return false;
    }
  }
}
