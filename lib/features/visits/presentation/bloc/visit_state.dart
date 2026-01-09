import 'package:equatable/equatable.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../data/models/visit_model.dart';
import '../../../dashboard/data/models/customer_model.dart';
import '../../../dashboard/data/models/project_model.dart';

abstract class VisitState extends Equatable {
  const VisitState();

  @override
  List<Object?> get props => [];
}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitSetupState extends VisitState {
  final List<CustomerModel> customers;
  final List<ProjectModel> projects;
  final List<CustomerModel> filteredCustomers;
  final List<ProjectModel> filteredProjects;
  final CustomerModel? selectedCustomer;
  final ProjectModel? selectedProject;
  final ActiveVisitModel? activeVisit;
  final String customerSearchQuery;
  final String projectSearchQuery;

  const VisitSetupState({
    required this.customers,
    required this.projects,
    required this.filteredCustomers,
    required this.filteredProjects,
    this.selectedCustomer,
    this.selectedProject,
    this.activeVisit,
    this.customerSearchQuery = '',
    this.projectSearchQuery = '',
  });

  VisitSetupState copyWith({
    List<CustomerModel>? customers,
    List<ProjectModel>? projects,
    List<CustomerModel>? filteredCustomers,
    List<ProjectModel>? filteredProjects,
    CustomerModel? selectedCustomer,
    ProjectModel? selectedProject,
    ActiveVisitModel? activeVisit,
    String? customerSearchQuery,
    String? projectSearchQuery,
    bool clearSelectedProject = false,
  }) {
    return VisitSetupState(
      customers: customers ?? this.customers,
      projects: projects ?? this.projects,
      filteredCustomers: filteredCustomers ?? this.filteredCustomers,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      selectedProject: clearSelectedProject ? null : (selectedProject ?? this.selectedProject),
      activeVisit: activeVisit ?? this.activeVisit,
      customerSearchQuery: customerSearchQuery ?? this.customerSearchQuery,
      projectSearchQuery: projectSearchQuery ?? this.projectSearchQuery,
    );
  }

  @override
  List<Object?> get props => [
        customers,
        projects,
        filteredCustomers,
        filteredProjects,
        selectedCustomer,
        selectedProject,
        activeVisit,
        customerSearchQuery,
        projectSearchQuery,
      ];
}

class VisitStartedState extends VisitState {
  final ActiveVisitModel visit;

  const VisitStartedState({required this.visit});

  @override
  List<Object> get props => [visit];
}

class VisitEndedState extends VisitState {
  final VisitModel visit;

  const VisitEndedState({required this.visit});

  @override
  List<Object> get props => [visit];
}

class VisitHistoryState extends VisitState {
  final List<VisitModel> visits;
  final Map<String, CustomerModel> customers;
  final Map<String, ProjectModel> projects;

  const VisitHistoryState({
    required this.visits,
    required this.customers,
    required this.projects,
  });

  @override
  List<Object> get props => [visits, customers, projects];
}

class VisitErrorState extends VisitState {
  final String message;

  const VisitErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

