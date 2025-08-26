import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'build_event.dart';
import 'build_state.dart';
import 'dart:async';
import 'dart:convert';

class BuildBloc extends Bloc<BuildEvent, BuildState> {
  BuildBloc() : super(BuildInitial()) {
    on<StartBuild>(_onStartBuild);
  }

  Future<void> _onStartBuild(StartBuild event, Emitter<BuildState> emit) async {
    emit(BuildInProgress());
    await Future.delayed(Duration(seconds: 5));
    debugPrint(JsonEncoder.withIndent('  ').convert(event.project));
    emit(BuildSuccess());
  }
}
