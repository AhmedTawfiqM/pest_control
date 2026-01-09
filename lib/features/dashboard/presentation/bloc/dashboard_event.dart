import 'package:equatable/equatable.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../visits/data/models/visit_model.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardDataEvent extends DashboardEvent {}

class RefreshDashboardEvent extends DashboardEvent {}

