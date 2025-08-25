import 'package:equatable/equatable.dart';
import '../../../data/models/auth_strategy.dart';
import '../../../data/models/backward_compatibility.dart';

abstract class ProjectBuilderEvent extends Equatable {
  const ProjectBuilderEvent();

  @override
  List<Object?> get props => [];
}

class StartProjectCreation extends ProjectBuilderEvent {
  const StartProjectCreation();
}

class UpdateProjectBasicInfo extends ProjectBuilderEvent {
  final String projectName;
  final String basePath;

  const UpdateProjectBasicInfo({
    required this.projectName,
    required this.basePath,
  });

  @override
  List<Object> get props => [projectName, basePath];
}

class UpdateAuthSettings extends ProjectBuilderEvent {
  final bool hasAuth;
  final AuthStrategy? authStrategy;

  const UpdateAuthSettings({required this.hasAuth, this.authStrategy});

  @override
  List<Object?> get props => [hasAuth, authStrategy];
}

class AddDataModel extends ProjectBuilderEvent {
  final DataModel dataModel;

  const AddDataModel(this.dataModel);

  @override
  List<Object> get props => [dataModel];
}

class UpdateDataModel extends ProjectBuilderEvent {
  final int index;
  final DataModel dataModel;

  const UpdateDataModel({required this.index, required this.dataModel});

  @override
  List<Object> get props => [index, dataModel];
}

class RemoveDataModel extends ProjectBuilderEvent {
  final int index;

  const RemoveDataModel(this.index);

  @override
  List<Object> get props => [index];
}

class AddEndpoint extends ProjectBuilderEvent {
  final Endpoint endpoint;

  const AddEndpoint(this.endpoint);

  @override
  List<Object> get props => [endpoint];
}

class UpdateEndpoint extends ProjectBuilderEvent {
  final int index;
  final Endpoint endpoint;

  const UpdateEndpoint({required this.index, required this.endpoint});

  @override
  List<Object> get props => [index, endpoint];
}

class RemoveEndpoint extends ProjectBuilderEvent {
  final int index;

  const RemoveEndpoint(this.index);

  @override
  List<Object> get props => [index];
}

class NextStep extends ProjectBuilderEvent {
  const NextStep();
}

class PreviousStep extends ProjectBuilderEvent {
  const PreviousStep();
}

class GoToStep extends ProjectBuilderEvent {
  final int step;

  const GoToStep(this.step);

  @override
  List<Object> get props => [step];
}

class CreateProject extends ProjectBuilderEvent {
  const CreateProject();
}

class ResetBuilder extends ProjectBuilderEvent {
  const ResetBuilder();
}
