import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/active_visit_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_datetime.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../visits/data/models/visit_model.dart';
import '../../../visits/presentation/pages/team_selection_page.dart';

class EndVisitDialog extends StatelessWidget {
  final ActiveVisitModel activeVisit;

  const EndVisitDialog({
    super.key,
    required this.activeVisit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final duration = AppDateTime.durationFromNowUtc(activeVisit.startTimeUtc);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
          const SizedBox(width: 8),
          Text(l10n.endVisit),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.endVisitConfirm,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          _buildSummaryRow(
            l10n.date,
            AppDateTime.format(
              activeVisit.startTimeLocal,
              AppDateTimeFormat.shortDate,
            ),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            l10n.startTime,
            AppDateTime.format(
              activeVisit.startTimeLocal,
              AppDateTimeFormat.time12Hour,
            ),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            l10n.duration,
            AppDateTime.formatDuration(duration),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(l10n.customer, activeVisit.customerName),
          const SizedBox(height: 8),
          _buildSummaryRow(l10n.project, activeVisit.projectName),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            l10n.selectTeamMembersMsg,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => _onEndVisit(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.error,
          ),
          child: Text(l10n.endVisit),
        ),
      ],
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

  Future<void> _onEndVisit(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final activeVisitBox = Hive.box<ActiveVisitModel>(AppConstants.activeVisitBox);

    // Close dialog first
    Navigator.pop(context);

    try {
      // Update visit in database
      final visitBox = Hive.box<VisitModel>(AppConstants.visitBox);
      final existingVisit = visitBox.get(activeVisit.visitId);

      if (existingVisit == null) {
        throw Exception('Visit not found in database');
      }

      final endTimeUtc = AppDateTime.nowUtc();

      final completedVisit = VisitModel(
        id: existingVisit.id,
        supervisorId: existingVisit.supervisorId,
        customerId: existingVisit.customerId,
        projectId: existingVisit.projectId,
        date: existingVisit.date,
        startTime: existingVisit.startTime,
        endTime: endTimeUtc.toLocal(),
        teamMemberIds: [], // Will be filled in team selection screen
        serviceReportId: existingVisit.serviceReportId,
      );

      await visitBox.put(activeVisit.visitId, completedVisit);

      // Clear active visit from Hive
      await activeVisitBox.delete(AppConstants.activeVisitKey);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.visitEnded),
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
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ending visit: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  static Future<void> show(BuildContext context, ActiveVisitModel activeVisit) {
    return showDialog(
      context: context,
      builder: (dialogContext) => EndVisitDialog(activeVisit: activeVisit),
    );
  }
}

