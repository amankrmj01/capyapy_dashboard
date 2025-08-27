import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<ToggleMockServer>(_onToggleMockServer);
  }

  void _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    try {
      // Simulate API call to load dashboard data
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        const DashboardLoaded(
          totalProjects: 12,
          activeProjects: 8,
          totalEndpoints: 42,
          totalModels: 15,
          apiCallsToday: 128,
          apiCallsThisMonth: 1234,
          creditsRemaining: 15230,
          mockServerRunning: true,
        ),
      );
    } catch (error) {
      emit(DashboardError(error.toString()));
    }
  }

  void _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      try {
        // Simulate refresh - keep current data but show it's refreshed
        await Future.delayed(const Duration(milliseconds: 300));

        final currentState = state as DashboardLoaded;
        emit(
          currentState.copyWith(apiCallsToday: currentState.apiCallsToday + 5),
        );
      } catch (error) {
        emit(DashboardError(error.toString()));
      }
    }
  }

  void _onToggleMockServer(
    ToggleMockServer event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      try {
        // Simulate server toggle
        await Future.delayed(const Duration(milliseconds: 200));

        final currentState = state as DashboardLoaded;
        emit(currentState.copyWith(mockServerRunning: event.isEnabled));
      } catch (error) {
        emit(DashboardError(error.toString()));
      }
    }
  }
}
