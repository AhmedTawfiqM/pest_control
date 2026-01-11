import 'package:equatable/equatable.dart';
import '../../../dashboard/data/models/customer_model.dart';
import '../../../dashboard/data/models/project_model.dart';

abstract class VisitEvent extends Equatable {
  const VisitEvent();

  @override
  List<Object?> get props => [];
}

class LoadVisitSetupDataEvent extends VisitEvent {}

class LoadVisitHistoryEvent extends VisitEvent {}

class SelectCustomerEvent extends VisitEvent {
  final CustomerModel customer;

  const SelectCustomerEvent({required this.customer});

  @override
  List<Object> get props => [customer];
}

class SelectProjectEvent extends VisitEvent {
  final ProjectModel project;

  const SelectProjectEvent({required this.project});

  @override
  List<Object> get props => [project];
}

class SearchCustomersEvent extends VisitEvent {
  final String query;

  const SearchCustomersEvent(this.query);

  @override
  List<Object> get props => [query];
}

class SearchProjectsEvent extends VisitEvent {
  final String query;

  const SearchProjectsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class StartVisitEvent extends VisitEvent {
  final String supervisorId;

  const StartVisitEvent({required this.supervisorId});

  @override
  List<Object> get props => [supervisorId];
}

class EndVisitEvent extends VisitEvent {
  const EndVisitEvent();
}

