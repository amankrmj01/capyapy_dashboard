import 'package:equatable/equatable.dart';
import '../../../../data/models/project_model.dart';

abstract class BuildEvent extends Equatable {
  const BuildEvent();

  @override
  List<Object?> get props => [];
}

class StartBuild extends BuildEvent {
  final Project project;

  const StartBuild(this.project);

  @override
  List<Object?> get props => [project];
}
