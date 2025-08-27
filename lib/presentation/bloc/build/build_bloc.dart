import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../data/models/models.dart';

import 'dart:async';
import 'dart:convert';

part 'build_event.dart';

part 'build_state.dart';

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
