import 'package:equatable/equatable.dart';

import '../../../data/models/auth_strategy.dart';
import '../../../data/models/project_endpoint.dart';
import '../../../data/models/resources_model.dart';

abstract class ProjectCreationEvent extends Equatable {
  const ProjectCreationEvent();

  @override
  List<Object?> get props => [];
}

class StartProjectCreation extends ProjectCreationEvent {
  const StartProjectCreation();
}

class UpdateProjectBasicInfo extends ProjectCreationEvent {
  final String projectName;
  final String basePath;

  const UpdateProjectBasicInfo({
    required this.projectName,
    required this.basePath,
  });

  @override
  List<Object> get props => [projectName, basePath];
}

class UpdateAuthSettings extends ProjectCreationEvent {
  final bool hasAuth;
  final AuthStrategy? authStrategy;

  const UpdateAuthSettings({required this.hasAuth, this.authStrategy});

  @override
  List<Object?> get props => [hasAuth, authStrategy];
}

class AddDataModel extends ProjectCreationEvent {
  final ResourcesModel dataModel;

  const AddDataModel(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class UpdateDataModel extends ProjectCreationEvent {
  final int index;
  final ResourcesModel dataModel;

  const UpdateDataModel({required this.index, required this.dataModel});

  @override
  List<Object> get props => [index, dataModel];
}

class RemoveDataModel extends ProjectCreationEvent {
  final int index;

  const RemoveDataModel(this.index);

  @override
  List<Object> get props => [index];
}

class AddEndpoint extends ProjectCreationEvent {
  final ProjectEndpoint endpoint;

  const AddEndpoint(this.endpoint);

  @override
  List<Object> get props => [endpoint];
}

class UpdateEndpoint extends ProjectCreationEvent {
  final int index;
  final ProjectEndpoint endpoint;

  const UpdateEndpoint({required this.index, required this.endpoint});

  @override
  List<Object> get props => [index, endpoint];
}

class RemoveEndpoint extends ProjectCreationEvent {
  final int index;

  const RemoveEndpoint(this.index);

  @override
  List<Object> get props => [index];
}

class NextStep extends ProjectCreationEvent {
  const NextStep();
}

class PreviousStep extends ProjectCreationEvent {
  const PreviousStep();
}

class GoToStep extends ProjectCreationEvent {
  final int step;

  const GoToStep(this.step);

  @override
  List<Object> get props => [step];
}

class CreateProject extends ProjectCreationEvent {
  const CreateProject();
}

class ResetBuilder extends ProjectCreationEvent {
  const ResetBuilder();
}
