import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/project_model.dart';
import 'project_builder_event.dart';
import 'project_builder_state.dart';

class ProjectBuilderBloc
    extends Bloc<ProjectBuilderEvent, ProjectBuilderState> {
  ProjectBuilderBloc() : super(const ProjectBuilderInitial()) {
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
      emit(
        currentState.copyWith(
          projectName: event.projectName,
          basePath: event.basePath,
          isValid: event.projectName.isNotEmpty && event.basePath.isNotEmpty,
        ),
      );
    }
  }

  void _onUpdateAuthSettings(
    UpdateAuthSettings event,
    Emitter<ProjectBuilderState> emit,
  ) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      List<DataModel> updatedModels = List.from(currentState.dataModels);

      // Add default User model if auth is enabled and doesn't exist
      if (event.hasAuth &&
          !updatedModels.any((model) => model.modelName == 'User')) {
        updatedModels.insert(0, _createDefaultUserModel());
      }

      // Remove User model if auth is disabled
      if (!event.hasAuth) {
        updatedModels.removeWhere((model) => model.modelName == 'User');
      }

      emit(
        currentState.copyWith(
          hasAuth: event.hasAuth,
          authStrategy: event.authStrategy,
          dataModels: updatedModels,
        ),
      );
    }
  }

  void _onAddDataModel(AddDataModel event, Emitter<ProjectBuilderState> emit) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedModels = List<DataModel>.from(currentState.dataModels)
        ..add(event.dataModel);

      emit(currentState.copyWith(dataModels: updatedModels));
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
        emit(currentState.copyWith(dataModels: updatedModels));
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
        emit(currentState.copyWith(dataModels: updatedModels));
      }
    }
  }

  void _onAddEndpoint(AddEndpoint event, Emitter<ProjectBuilderState> emit) {
    if (state is ProjectBuilderInProgress) {
      final currentState = state as ProjectBuilderInProgress;
      final updatedEndpoints = List<Endpoint>.from(currentState.endpoints)
        ..add(event.endpoint);

      emit(currentState.copyWith(endpoints: updatedEndpoints));
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
        emit(currentState.copyWith(endpoints: updatedEndpoints));
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
        emit(currentState.copyWith(endpoints: updatedEndpoints));
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
        // Simulate project creation
        await Future.delayed(const Duration(seconds: 2));

        final project = currentState.toProject();
        emit(ProjectBuilderSuccess(project));
      } catch (error) {
        emit(ProjectBuilderError(error.toString()));
      }
    }
  }

  void _onResetBuilder(ResetBuilder event, Emitter<ProjectBuilderState> emit) {
    emit(const ProjectBuilderInitial());
  }

  DataModel _createDefaultUserModel() {
    return const DataModel(
      modelName: 'User',
      collectionName: 'users',
      fields: [
        ModelField(
          name: 'id',
          type: FieldType.string,
          required: true,
          unique: true,
        ),
        ModelField(
          name: 'username',
          type: FieldType.string,
          required: true,
          unique: true,
        ),
        ModelField(name: 'password', type: FieldType.string, required: true),
        ModelField(
          name: 'email',
          type: FieldType.string,
          required: true,
          unique: true,
        ),
        ModelField(
          name: 'createdAt',
          type: FieldType.date,
          defaultValue: 'now',
        ),
      ],
    );
  }
}
