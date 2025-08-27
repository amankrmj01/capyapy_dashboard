part of 'build_bloc.dart';

abstract class BuildState extends Equatable {
  const BuildState();

  @override
  List<Object?> get props => [];
}

class BuildInitial extends BuildState {}

class BuildInProgress extends BuildState {}

class BuildSuccess extends BuildState {}
