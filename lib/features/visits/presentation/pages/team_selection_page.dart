import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/data/models/team_member_model.dart';
import '../../data/models/visit_model.dart';
import '../bloc/team_selection_bloc.dart';
import '../bloc/team_selection_event.dart';
import '../bloc/team_selection_state.dart';

class TeamSelectionPage extends StatelessWidget {
  static const String routeName = '/team-selection';

  final VisitModel visit;

  const TeamSelectionPage({
    super.key,
    required this.visit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeamSelectionBloc()..add(LoadTeamMembers()),
      child: _TeamSelectionView(visit: visit),
    );
  }
}

class _TeamSelectionView extends StatelessWidget {
  final VisitModel visit;

  const _TeamSelectionView({required this.visit});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamSelectionBloc, TeamSelectionState>(
      listener: (context, state) {
        if (state is TeamSelectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
            ),
          );
        } else if (state is TeamSelectionSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Team members saved successfully!'),
              backgroundColor: AppTheme.success,
            ),
          );
          // Navigate back to dashboard
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Team Members'),
            elevation: 0,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TeamSelectionState state) {
    if (state is TeamSelectionLoading || state is TeamSelectionInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TeamSelectionLoaded) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppTheme.primaryGreen.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select team members who participated in this visit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.selectedMemberIds.length} member(s) selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.teamMembers.isEmpty
                ? const Center(
                    child: Text('No team members available'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.teamMembers.length,
                    itemBuilder: (context, index) {
                      final teamMember = state.teamMembers[index];
                      final isSelected = state.selectedMemberIds.contains(teamMember.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (_) {
                            context.read<TeamSelectionBloc>().add(
                                  ToggleTeamMember(teamMember.id),
                                );
                          },
                          title: Text(
                            teamMember.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'ID: ${teamMember.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          activeColor: AppTheme.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<TeamSelectionBloc>().add(
                          SaveTeamSelection(visit),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const Center(child: Text('Something went wrong'));
  }
}

