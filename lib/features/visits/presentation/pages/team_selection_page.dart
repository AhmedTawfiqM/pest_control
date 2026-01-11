import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/data/models/team_member_model.dart';
import '../../data/models/visit_model.dart';

class TeamSelectionPage extends StatefulWidget {
  static const String routeName = '/team-selection';

  final VisitModel visit;

  const TeamSelectionPage({
    super.key,
    required this.visit,
  });

  @override
  State<TeamSelectionPage> createState() => _TeamSelectionPageState();
}

class _TeamSelectionPageState extends State<TeamSelectionPage> {
  final Set<String> _selectedTeamMemberIds = {};
  List<TeamMemberModel> _teamMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamMembers();
  }

  Future<void> _loadTeamMembers() async {
    final teamMemberBox = Hive.box<TeamMemberModel>(AppConstants.teamMemberBox);
    setState(() {
      _teamMembers = teamMemberBox.values.toList();
      _isLoading = false;
    });
  }

  void _toggleTeamMember(String id) {
    setState(() {
      if (_selectedTeamMemberIds.contains(id)) {
        _selectedTeamMemberIds.remove(id);
      } else {
        _selectedTeamMemberIds.add(id);
      }
    });
  }

  Future<void> _saveAndContinue() async {
    if (_selectedTeamMemberIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one team member'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    // Update the visit with selected team members
    final visitBox = Hive.box<VisitModel>(AppConstants.visitBox);
    final updatedVisit = VisitModel(
      id: widget.visit.id,
      supervisorId: widget.visit.supervisorId,
      customerId: widget.visit.customerId,
      projectId: widget.visit.projectId,
      date: widget.visit.date,
      startTime: widget.visit.startTime,
      endTime: widget.visit.endTime,
      teamMemberIds: _selectedTeamMemberIds.toList(),
      serviceReportId: widget.visit.serviceReportId,
    );

    // Find the visit in the box and update it
    for (int i = 0; i < visitBox.length; i++) {
      final visit = visitBox.getAt(i);
      if (visit?.id == widget.visit.id) {
        await visitBox.putAt(i, updatedVisit);
        break;
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Team members saved successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );

      // Navigate back to dashboard
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Team Members'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                        '${_selectedTeamMemberIds.length} member(s) selected',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _teamMembers.isEmpty
                      ? const Center(
                          child: Text('No team members available'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _teamMembers.length,
                          itemBuilder: (context, index) {
                            final teamMember = _teamMembers[index];
                            final isSelected = _selectedTeamMemberIds.contains(teamMember.id);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              child: CheckboxListTile(
                                value: isSelected,
                                onChanged: (_) => _toggleTeamMember(teamMember.id),
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
                        onPressed: _saveAndContinue,
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
            ),
    );
  }
}

