import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../visits/data/models/visit_model.dart';
import '../widgets/live_timer_widget.dart';
import '../widgets/end_visit_dialog.dart';
import 'profile_page.dart';
import 'visit_history_page.dart';
import '../../../visits/presentation/pages/visit_setup_page.dart';
import '../../../visits/presentation/pages/team_selection_page.dart';
import '../../../service_report/presentation/pages/service_report_page.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: l10n.profile,
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

                // Visit History Button
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, VisitHistoryPage.routeName);
                  },
                  icon: const Icon(Icons.history),
                  label: Text(l10n.visitHistory),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 16),

                // Active Visit or Start Visit Button
                if (activeVisit != null)
                  _buildActiveVisitCard(activeVisit)
                else
                  Expanded(
                    child: Center(
                      child: _buildStartVisitButton(),
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
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_location_alt,
            size: 64,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, VisitSetupPage.routeName);
          },
          icon: const Icon(Icons.play_arrow, size: 28),
          label: Text(
            l10n.startNewVisit,
            style: const TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveVisitCard(ActiveVisitModel activeVisit) {
    final l10n = AppLocalizations.of(context);

    return ValueListenableBuilder(
      valueListenable: Hive.box<VisitModel>(AppConstants.visitBox).listenable(),
      builder: (context, Box<VisitModel> visitBox, _) {
        final visit = visitBox.get(activeVisit.visitId);
        final hasReport = visit?.serviceReportId != null;

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
                      Expanded(
                        child: Text(
                          l10n.visitInProgress,
                          style: const TextStyle(
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
                        child: Text(
                          l10n.active,
                          style: const TextStyle(
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
                  LiveTimerWidget(startTimeUtc: activeVisit.startTimeUtc),
                  const SizedBox(height: 20),

                  // Visit Details
                  _buildDetailItem(
                    Icons.business,
                    l10n.customer,
                    activeVisit.customerName,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailItem(
                    Icons.assignment,
                    l10n.project,
                    activeVisit.projectName,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailItem(
                    Icons.calendar_today,
                    l10n.started,
                    AppDateTime.format(
                      activeVisit.startTimeLocal,
                      AppDateTimeFormat.shortDateTime,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons Row
                  Row(
                    children: [
                      // Service Report Button or Report Added Component
                      Expanded(
                        child: hasReport
                            ? _buildReportAddedComponent()
                            : OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, ServiceReportPage.routeName);
                                },
                                icon: const Icon(Icons.description, size: 20),
                                label: Text(
                                  l10n.serviceReport,
                                  style: const TextStyle(
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
                            EndVisitDialog.show(context, activeVisit);
                          },
                          icon: const Icon(Icons.stop, size: 20),
                          label: Text(
                            l10n.endVisit,
                            style: const TextStyle(
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
      },
    );
  }

  Widget _buildReportAddedComponent() {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            l10n.reportAdded,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
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
}

