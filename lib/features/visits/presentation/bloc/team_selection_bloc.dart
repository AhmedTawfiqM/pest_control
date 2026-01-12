import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../dashboard/data/models/team_member_model.dart';
import '../../data/models/visit_model.dart';
import 'team_selection_event.dart';
import 'team_selection_state.dart';

class TeamSelectionBloc extends Bloc<TeamSelectionEvent, TeamSelectionState> {
  TeamSelectionBloc() : super(TeamSelectionInitial()) {
    on<LoadTeamMembers>(_onLoadTeamMembers);
    on<ToggleTeamMember>(_onToggleTeamMember);
    on<SaveTeamSelection>(_onSaveTeamSelection);
  }

  Future<void> _onLoadTeamMembers(
    LoadTeamMembers event,
    Emitter<TeamSelectionState> emit,
  ) async {
    emit(TeamSelectionLoading());

    try {
      final teamMemberBox = Hive.box<TeamMemberModel>(AppConstants.teamMemberBox);
      final teamMembers = teamMemberBox.values.toList();

      emit(TeamSelectionLoaded(
        teamMembers: teamMembers,
        selectedMemberIds: {},
      ));
    } catch (e) {
      emit(TeamSelectionError('Failed to load team members: $e'));
    }
  }

  void _onToggleTeamMember(
    ToggleTeamMember event,
    Emitter<TeamSelectionState> emit,
  ) {
    if (state is TeamSelectionLoaded) {
      final currentState = state as TeamSelectionLoaded;
      final newSelectedIds = Set<String>.from(currentState.selectedMemberIds);

      if (newSelectedIds.contains(event.memberId)) {
        newSelectedIds.remove(event.memberId);
      } else {
        newSelectedIds.add(event.memberId);
      }

      emit(currentState.copyWith(selectedMemberIds: newSelectedIds));
    }
  }

  Future<void> _onSaveTeamSelection(
    SaveTeamSelection event,
    Emitter<TeamSelectionState> emit,
  ) async {
    if (state is TeamSelectionLoaded) {
      final currentState = state as TeamSelectionLoaded;

      if (currentState.selectedMemberIds.isEmpty) {
        emit(const TeamSelectionError('Please select at least one team member'));
        emit(currentState); // Return to loaded state
        return;
      }

      try {
        final visitBox = Hive.box<VisitModel>(AppConstants.visitBox);

        final updatedVisit = VisitModel(
          id: event.visit.id,
          supervisorId: event.visit.supervisorId,
          customerId: event.visit.customerId,
          projectId: event.visit.projectId,
          date: event.visit.date,
          startTime: event.visit.startTime,
          endTime: event.visit.endTime,
          teamMemberIds: currentState.selectedMemberIds.toList(),
          serviceReportId: event.visit.serviceReportId,
        );

        // Find and update the visit
        for (int i = 0; i < visitBox.length; i++) {
          final visit = visitBox.getAt(i);
          if (visit?.id == event.visit.id) {
            await visitBox.putAt(i, updatedVisit);
            break;
          }
        }

        emit(TeamSelectionSaved());
      } catch (e) {
        emit(TeamSelectionError('Failed to save team selection: $e'));
        emit(currentState); // Return to loaded state
      }
    }
  }
}

