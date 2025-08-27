part of 'build_bloc.dart';

abstract class BuildEvent extends Equatable {
  const BuildEvent();

  @override
  List<Object?> get props => [];
}

class StartBuild extends BuildEvent {
  final ProjectModel project;

  const StartBuild(this.project);

  @override
  List<Object?> get props => [project];
}
