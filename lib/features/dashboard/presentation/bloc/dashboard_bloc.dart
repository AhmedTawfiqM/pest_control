import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../visits/data/models/visit_model.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Box<ActiveVisitModel> activeVisitBox;
  final Box<VisitModel> visitBox;

  DashboardBloc({
    required this.activeVisitBox,
    required this.visitBox,
  }) : super(DashboardInitial()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
  }

  void _onLoadDashboardData(
    LoadDashboardDataEvent event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardLoading());

    try {
      final activeVisit = activeVisitBox.get(AppConstants.activeVisitKey);
      final completedVisits = visitBox.values.where((v) => v.endTime != null).toList();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekAgo = today.subtract(const Duration(days: 7));

      final todayVisits = completedVisits.where((v) {
        final visitDate = DateTime(v.date.year, v.date.month, v.date.day);
        return visitDate.isAtSameMomentAs(today);
      }).length;

      final weekVisits = completedVisits.where((v) {
        final visitDate = DateTime(v.date.year, v.date.month, v.date.day);
        return visitDate.isAfter(weekAgo) || visitDate.isAtSameMomentAs(weekAgo);
      }).length;

      emit(DashboardLoaded(
        activeVisit: activeVisit,
        completedVisitsCount: completedVisits.length,
        todayVisitsCount: todayVisits,
        weekVisitsCount: weekVisits,
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard data: $e'));
    }
  }

  void _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) {
    add(LoadDashboardDataEvent());
  }
}

