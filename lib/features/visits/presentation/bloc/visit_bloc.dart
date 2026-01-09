import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../dashboard/data/models/customer_model.dart';
import '../../../dashboard/data/models/project_model.dart';
import '../../data/models/visit_model.dart';
import 'visit_event.dart';
import 'visit_state.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  final Box<CustomerModel> customerBox;
  final Box<ProjectModel> projectBox;
  final Box<ActiveVisitModel> activeVisitBox;
  final Box<VisitModel> visitBox;
  final Uuid uuid;

  VisitBloc({
    required this.customerBox,
    required this.projectBox,
    required this.activeVisitBox,
    required this.visitBox,
    required this.uuid,
  }) : super(VisitInitial()) {
    on<LoadVisitSetupDataEvent>(_onLoadVisitSetupData);
    on<SelectCustomerEvent>(_onSelectCustomer);
    on<SelectProjectEvent>(_onSelectProject);
    on<SearchCustomersEvent>(_onSearchCustomers);
    on<SearchProjectsEvent>(_onSearchProjects);
    on<StartVisitEvent>(_onStartVisit);
    on<EndVisitEvent>(_onEndVisit);
    on<LoadVisitHistoryEvent>(_onLoadVisitHistory);
  }

  void _onLoadVisitSetupData(
    LoadVisitSetupDataEvent event,
    Emitter<VisitState> emit,
  ) {
    final customers = customerBox.values.toList();
    final projects = projectBox.values.toList();
    final activeVisit = activeVisitBox.get(AppConstants.activeVisitKey);

    emit(VisitSetupState(
      customers: customers,
      projects: projects,
      activeVisit: activeVisit,
      filteredCustomers: customers,
      filteredProjects: [],
    ));
  }

  void _onSelectCustomer(
    SelectCustomerEvent event,
    Emitter<VisitState> emit,
  ) {
    if (state is VisitSetupState) {
      final currentState = state as VisitSetupState;
      final projects = currentState.projects
          .where((p) => p.customerId == event.customer.id)
          .toList();

      emit(currentState.copyWith(
        selectedCustomer: event.customer,
        selectedProject: null,
        filteredProjects: projects,
        projectSearchQuery: '',
      ));
    }
  }

  void _onSelectProject(
    SelectProjectEvent event,
    Emitter<VisitState> emit,
  ) {
    if (state is VisitSetupState) {
      final currentState = state as VisitSetupState;
      emit(currentState.copyWith(
        selectedProject: event.project,
      ));
    }
  }

  void _onSearchCustomers(
    SearchCustomersEvent event,
    Emitter<VisitState> emit,
  ) {
    if (state is VisitSetupState) {
      final currentState = state as VisitSetupState;
      final query = event.query.toLowerCase();

      final filtered = query.isEmpty
          ? currentState.customers
          : currentState.customers
              .where((c) => c.name.toLowerCase().contains(query))
              .toList();

      emit(currentState.copyWith(
        filteredCustomers: filtered,
        customerSearchQuery: query,
      ));
    }
  }

  void _onSearchProjects(
    SearchProjectsEvent event,
    Emitter<VisitState> emit,
  ) {
    if (state is VisitSetupState) {
      final currentState = state as VisitSetupState;
      final query = event.query.toLowerCase();

      if (currentState.selectedCustomer == null) return;

      final filtered = currentState.projects
          .where((p) =>
              p.customerId == currentState.selectedCustomer!.id &&
              (query.isEmpty || p.name.toLowerCase().contains(query)))
          .toList();

      emit(currentState.copyWith(
        filteredProjects: filtered,
        projectSearchQuery: query,
      ));
    }
  }

  void _onStartVisit(
    StartVisitEvent event,
    Emitter<VisitState> emit,
  ) async {
    if (state is VisitSetupState) {
      final currentState = state as VisitSetupState;

      if (currentState.selectedCustomer == null ||
          currentState.selectedProject == null) {
        return;
      }

      emit(VisitLoading());

      try {
        final activeVisit = ActiveVisitModel(
          customerId: currentState.selectedCustomer!.id,
          projectId: currentState.selectedProject!.id,
          customerName: currentState.selectedCustomer!.name,
          projectName: currentState.selectedProject!.name,
          startTimeUtc: AppDateTime.nowUtc(),
        );

        await activeVisitBox.put(AppConstants.activeVisitKey, activeVisit);

        emit(VisitStartedState(visit: activeVisit));
      } catch (e) {
        emit(VisitErrorState(message: 'Failed to start visit: $e'));
      }
    }
  }

  void _onEndVisit(
    EndVisitEvent event,
    Emitter<VisitState> emit,
  ) async {
    emit(VisitLoading());

    try {
      final activeVisit = activeVisitBox.get(AppConstants.activeVisitKey);

      if (activeVisit == null) {
        emit(VisitErrorState(message: 'No active visit found'));
        return;
      }

      final endTimeUtc = AppDateTime.nowUtc();

      final completedVisit = VisitModel(
        id: uuid.v4(),
        supervisorId: event.supervisorId,
        customerId: activeVisit.customerId,
        projectId: activeVisit.projectId,
        date: activeVisit.startTimeLocal,
        startTime: activeVisit.startTimeLocal,
        endTime: endTimeUtc.toLocal(),
        teamMemberIds: [],
        serviceReportId: null,
      );

      await visitBox.add(completedVisit);
      await activeVisitBox.delete(AppConstants.activeVisitKey);

      emit(VisitEndedState(visit: completedVisit));
    } catch (e) {
      emit(VisitErrorState(message: 'Failed to end visit: $e'));
    }
  }

  void _onLoadVisitHistory(
    LoadVisitHistoryEvent event,
    Emitter<VisitState> emit,
  ) {
    emit(VisitLoading());

    try {
      final visits = visitBox.values
          .where((v) => v.endTime != null)
          .toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));

      final customers = {for (var c in customerBox.values) c.id: c};
      final projects = {for (var p in projectBox.values) p.id: p};

      emit(VisitHistoryState(
        visits: visits,
        customers: customers,
        projects: projects,
      ));
    } catch (e) {
      emit(VisitErrorState(message: 'Failed to load visit history: $e'));
    }
  }
}

