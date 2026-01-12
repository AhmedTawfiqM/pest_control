import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../visits/data/models/visit_model.dart';
import '../../../dashboard/data/models/customer_model.dart';
import '../../../dashboard/data/models/project_model.dart';
import '../../../dashboard/data/models/team_member_model.dart';
import '../../../service_report/presentation/pages/service_report_details_page.dart';

class VisitHistoryPage extends StatelessWidget {
  static const String routeName = '/visit-history';

  const VisitHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.visitHistory),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<VisitModel>(AppConstants.visitBox).listenable(),
        builder: (context, Box<VisitModel> visitBox, _) {
          final completedVisits = visitBox.values
              .where((v) => v.endTime != null)
              .toList()
            ..sort((a, b) => b.startTime.compareTo(a.startTime)); // Most recent first

          if (completedVisits.isEmpty) {
            return _buildEmptyState(l10n);
          }

          return ValueListenableBuilder(
            valueListenable: Hive.box<CustomerModel>(AppConstants.customerBox).listenable(),
            builder: (context, Box<CustomerModel> customerBox, _) {
              return ValueListenableBuilder(
                valueListenable: Hive.box<ProjectModel>(AppConstants.projectBox).listenable(),
                builder: (context, Box<ProjectModel> projectBox, _) {
                  final customers = {for (var c in customerBox.values) c.id: c};
                  final projects = {for (var p in projectBox.values) p.id: p};

                  return Column(
                    children: [
                      // Summary Card
                      _buildSummaryCard(completedVisits, l10n),

                      // List of visits
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: completedVisits.length,
                          itemBuilder: (context, index) {
                            final visit = completedVisits[index];
                            final customer = customers[visit.customerId];
                            final project = projects[visit.projectId];

                            return _buildVisitCard(
                              context,
                              visit,
                              customer?.name ?? l10n.noDataAvailable,
                              project?.name ?? l10n.noDataAvailable,
                              l10n,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 100,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noVisitsYet,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.startFirstVisit,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(List<VisitModel> visits, AppLocalizations l10n) {
    final totalDuration = visits.fold<Duration>(
      Duration.zero,
      (sum, visit) {
        if (visit.endTime != null) {
          return sum + visit.endTime!.difference(visit.startTime);
        }
        return sum;
      },
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryGreen,
            AppTheme.primaryGreen.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(
            icon: Icons.assignment_turned_in,
            label: l10n.totalVisits,
            value: visits.length.toString(),
          ),
          Container(
            height: 50,
            width: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          _buildStat(
            icon: Icons.access_time,
            label: l10n.totalTime,
            value: AppDateTime.formatDuration(totalDuration),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildVisitCard(
    BuildContext context,
    VisitModel visit,
    String customerName,
    String projectName,
    AppLocalizations l10n,
  ) {
    final duration = visit.endTime!.difference(visit.startTime);
    final hasCrossedMidnight = AppDateTime.hasCrossedMidnight(
      visit.startTime,
      visit.endTime!,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppTheme.success,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          projectName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasCrossedMidnight)
                    Tooltip(
                      message: 'Visit crossed midnight',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.warning,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.nights_stay,
                              size: 14,
                              color: AppTheme.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Overnight',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (duration.inSeconds < 60 && !hasCrossedMidnight)
                    Tooltip(
                      message: 'Very short visit (< 1 minute)',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.info,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flash_on,
                              size: 14,
                              color: AppTheme.info,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Quick',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.info,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Visit Details
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: AppDateTime.format(
                        visit.date,
                        AppDateTimeFormat.shortDate,
                      ),
                      color: AppTheme.info,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.timer,
                      label: duration.inSeconds < 60
                          ? '${duration.inSeconds}s'  // Show seconds for very short visits
                          : AppDateTime.formatDurationCompact(duration),
                      color: duration.inSeconds < 60
                          ? AppTheme.warning  // Highlight very short visits
                          : AppTheme.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Time Range
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      AppDateTime.format(visit.startTime, AppDateTimeFormat.time12Hour),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 8),
                    Text(
                      AppDateTime.format(visit.endTime!, AppDateTimeFormat.time12Hour),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (hasCrossedMidnight) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(+1 day)',
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.warning,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showVisitDetails(context, visit, customerName, projectName, l10n);
                      },
                      icon: const Icon(Icons.visibility, size: 16),
                      label: Text(
                        l10n.viewDetails,
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        side: const BorderSide(color: AppTheme.primaryGreen),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: visit.serviceReportId != null
                          ? () {
                              _showServiceReportSheet(context, visit, l10n);
                            }
                          : null,
                      icon: const Icon(Icons.description, size: 16),
                      label: Text(
                        l10n.openReport,
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showVisitDetails(
    BuildContext context,
    VisitModel visit,
    String customerName,
    String projectName,
    AppLocalizations l10n,
  ) {
    final duration = visit.endTime!.difference(visit.startTime);
    final hasCrossedMidnight = AppDateTime.hasCrossedMidnight(
      visit.startTime,
      visit.endTime!,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppTheme.success,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        l10n.visitDetails,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Midnight Wraparound Warning
                if (hasCrossedMidnight) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.nights_stay,
                          color: AppTheme.warning,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overnight Visit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.warning,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'This visit crossed midnight into the next day',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Details
                _buildDetailSection(l10n.customer, [
                  _buildDetailRow(Icons.business, l10n.customer, customerName),
                  _buildDetailRow(Icons.assignment, l10n.project, projectName),
                ]),
                const SizedBox(height: 24),

                _buildDetailSection(l10n.timeline, [
                  _buildDetailRow(
                    Icons.calendar_today,
                    l10n.date,
                    AppDateTime.format(visit.date, AppDateTimeFormat.longDate),
                  ),
                  _buildDetailRow(
                    Icons.play_arrow,
                    l10n.startTime,
                    AppDateTime.format(visit.startTime, AppDateTimeFormat.time12Hour),
                  ),
                  _buildDetailRow(
                    Icons.stop,
                    l10n.endTime,
                    '${AppDateTime.format(visit.endTime!, AppDateTimeFormat.time12Hour)}'
                    '${hasCrossedMidnight ? ' (+1 day)' : ''}',
                  ),
                  _buildDetailRow(
                    Icons.timer,
                    l10n.duration,
                    duration.inSeconds < 60
                        ? '${duration.inSeconds} seconds'
                        : duration.inMinutes < 60
                            ? '${duration.inMinutes} minutes ${duration.inSeconds.remainder(60)} seconds'
                            : AppDateTime.formatDurationHuman(duration),
                  ),
                ]),
                const SizedBox(height: 24),

                _buildDetailSection(l10n.additionalInformation, [
                  _buildDetailRow(Icons.badge, l10n.visitId, visit.id),
                  _buildDetailRow(
                    Icons.person,
                    l10n.supervisor,
                    visit.supervisorId,
                  ),
                  _buildTeamMembersRow(visit.teamMemberIds, l10n),
                ]),
                const SizedBox(height: 24),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.close),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showServiceReportSheet(BuildContext context, VisitModel visit, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceReportDetailsPage(visit: visit),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembersRow(List<String> teamMemberIds, AppLocalizations l10n) {
    if (teamMemberIds.isEmpty) {
      return _buildDetailRow(Icons.group, l10n.teamMembers, l10n.notAssigned);
    }

    // Get team member names from Hive
    final teamMemberBox = Hive.box<TeamMemberModel>(AppConstants.teamMemberBox);
    final teamMemberNames = teamMemberIds
        .map((id) => teamMemberBox.get(id)?.name ?? l10n.noDataAvailable)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.group, size: 20, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              l10n.teamMembers,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ...teamMemberNames.map((name) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











