import 'package:equatable/equatable.dart';
import '../../../data/models/models.dart';

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
  final ProjectDataModel dataModel;

  const AddDataModel(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class UpdateDataModel extends ProjectCreationEvent {
  final int index;
  final ProjectDataModel dataModel;

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

class PreviousStep extends ProjectCreationEvent {
  const PreviousStep();
}

class NextStep extends ProjectCreationEvent {
  const NextStep();
}

class CreateProject extends ProjectCreationEvent {
  const CreateProject();
}

class ResetBuilder extends ProjectCreationEvent {
  const ResetBuilder();
}

class UpdateStorageSettings extends ProjectCreationEvent {
  final StorageConfig? storageConfig;

  const UpdateStorageSettings({required this.storageConfig});

  @override
  List<Object?> get props => [storageConfig];
}
