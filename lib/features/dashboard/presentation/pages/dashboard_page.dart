import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../service_report/presentation/pages/service_report_page.dart';
import '../../../visits/data/models/visit_model.dart';
import 'profile_page.dart';
import 'visit_history_page.dart';
import '../../../visits/presentation/pages/visit_setup_page.dart';
import '../../../visits/presentation/pages/team_selection_page.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.pushNamed(context, ProfilePage.routeName);
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox).listenable(),
        builder: (context, Box<ActiveVisitModel> box, _) {
          final activeVisit = box.get(AppConstants.activeVisitKey);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Card
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                state.supervisor.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),

                // Active Visit or Start Visit Button
                if (activeVisit != null)
                  _buildActiveVisitCard(activeVisit)
                else
                  _buildStartVisitButton(),

                const SizedBox(height: 16),

                // Visit History Button
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, VisitHistoryPage.routeName);
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('Visit History'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const Spacer(),

                // Quick Stats (Placeholder)
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          context,
                          'Today',
                          '0',
                          Icons.today,
                        ),
                        _buildStatColumn(
                          context,
                          'This Week',
                          '0',
                          Icons.calendar_today_outlined,
                        ),
                        _buildStatColumn(
                          context,
                          'Total',
                          '0',
                          Icons.assessment,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartVisitButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, VisitSetupPage.routeName);
      },
      icon: const Icon(Icons.play_arrow, size: 28),
      label: const Text(
        'Start New Visit',
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }

  Widget _buildActiveVisitCard(ActiveVisitModel activeVisit) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.success,
              AppTheme.success.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Visit In Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Live Timer
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  final duration = AppDateTime.durationFromNowUtc(activeVisit.startTimeUtc);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppDateTime.formatDuration(duration),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Visit Details
              _buildDetailItem(
                Icons.business,
                'Customer',
                activeVisit.customerName,
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                Icons.assignment,
                'Project',
                activeVisit.projectName,
              ),
              const SizedBox(height: 12),
              _buildDetailItem(
                Icons.calendar_today,
                'Started',
                AppDateTime.format(
                  activeVisit.startTimeLocal,
                  AppDateTimeFormat.shortDateTime,
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons Row
              Row(
                children: [
                  // Service Report Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, ServiceReportPage.routeName);
                      },
                      icon: const Icon(Icons.description, size: 20),
                      label: const Text(
                        'Service Report',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // End Visit Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showEndVisitDialog(context, activeVisit);
                      },
                      icon: const Icon(Icons.stop, size: 20),
                      label: const Text(
                        'End Visit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showEndVisitDialog(BuildContext context, ActiveVisitModel activeVisit) {
    final activeVisitBox = Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox);
    final duration = AppDateTime.durationFromNowUtc(activeVisit.startTimeUtc);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
            SizedBox(width: 8),
            Text('End Visit'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to end this visit?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildSummaryRow('Date', AppDateTime.format(
              activeVisit.startTimeLocal,
              AppDateTimeFormat.shortDate,
            )),
            const SizedBox(height: 8),
            _buildSummaryRow('Start Time', AppDateTime.format(
              activeVisit.startTimeLocal,
              AppDateTimeFormat.time12Hour,
            )),
            const SizedBox(height: 8),
            _buildSummaryRow('Duration', AppDateTime.formatDuration(duration)),
            const SizedBox(height: 8),
            _buildSummaryRow('Customer', activeVisit.customerName),
            const SizedBox(height: 8),
            _buildSummaryRow('Project', activeVisit.projectName),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'You will be asked to select team members who participated.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Get supervisor ID from auth state
              final authState = context.read<AuthBloc>().state;
              String? supervisorId;
              if (authState is AuthAuthenticated) {
                supervisorId = authState.supervisor.id;
              }

              // Save visit to database
              final visitBox = Hive.box<VisitModel>(AppConstants.visitBox);
              final endTimeUtc = AppDateTime.nowUtc();
              final uuid = const Uuid();

              final completedVisit = VisitModel(
                id: uuid.v4(),
                supervisorId: supervisorId ?? 'UNKNOWN',
                customerId: activeVisit.customerId,
                projectId: activeVisit.projectId,
                date: activeVisit.startTimeLocal,
                startTime: activeVisit.startTimeLocal,
                endTime: endTimeUtc.toLocal(),
                teamMemberIds: [], // Will be filled in team selection screen
                serviceReportId: null,
              );

              await visitBox.add(completedVisit);

              // Clear active visit from Hive
              await activeVisitBox.delete(AppConstants.activeVisitKey);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Visit ended successfully! Please select team members.'),
                    backgroundColor: AppTheme.success,
                  ),
                );

                // Navigate to team selection screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeamSelectionPage(visit: completedVisit),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('End Visit'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

