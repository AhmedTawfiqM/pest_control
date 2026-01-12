import 'package:equatable/equatable.dart';
import '../../../dashboard/data/models/team_member_model.dart';

abstract class TeamSelectionState extends Equatable {
  const TeamSelectionState();

  @override
  List<Object?> get props => [];
}

class TeamSelectionInitial extends TeamSelectionState {}

class TeamSelectionLoading extends TeamSelectionState {}

class TeamSelectionLoaded extends TeamSelectionState {
  final List<TeamMemberModel> teamMembers;
  final Set<String> selectedMemberIds;

  const TeamSelectionLoaded({
    required this.teamMembers,
    required this.selectedMemberIds,
  });

  TeamSelectionLoaded copyWith({
    List<TeamMemberModel>? teamMembers,
    Set<String>? selectedMemberIds,
  }) {
    return TeamSelectionLoaded(
      teamMembers: teamMembers ?? this.teamMembers,
      selectedMemberIds: selectedMemberIds ?? this.selectedMemberIds,
    );
  }

  @override
  List<Object?> get props => [teamMembers, selectedMemberIds];
}

class TeamSelectionSaved extends TeamSelectionState {}

class TeamSelectionError extends TeamSelectionState {
  final String message;

  const TeamSelectionError(this.message);

  @override
  List<Object?> get props => [message];
}

