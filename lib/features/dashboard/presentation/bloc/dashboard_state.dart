import 'package:equatable/equatable.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../visits/data/models/visit_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final ActiveVisitModel? activeVisit;
  final int completedVisitsCount;
  final int todayVisitsCount;
  final int weekVisitsCount;

  const DashboardLoaded({
    this.activeVisit,
    required this.completedVisitsCount,
    required this.todayVisitsCount,
    required this.weekVisitsCount,
  });

  @override
  List<Object?> get props => [
        activeVisit,
        completedVisitsCount,
        todayVisitsCount,
        weekVisitsCount,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}

