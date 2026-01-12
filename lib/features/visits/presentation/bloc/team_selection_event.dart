import 'package:equatable/equatable.dart';
import '../../data/models/visit_model.dart';

abstract class TeamSelectionEvent extends Equatable {
  const TeamSelectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTeamMembers extends TeamSelectionEvent {}

class ToggleTeamMember extends TeamSelectionEvent {
  final String memberId;

  const ToggleTeamMember(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class SaveTeamSelection extends TeamSelectionEvent {
  final VisitModel visit;

  const SaveTeamSelection(this.visit);

  @override
  List<Object?> get props => [visit];
}

