import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/admin_report.dart';
import '../bloc/admin_bloc.dart';

/// Admin reports queue screen with pending reports and action buttons.
class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Reports Queue'),
        ),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.statusPublished,
                ),
              );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.statusRejected,
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.isLoadingReports) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ExcludeSemantics(
                    child: Icon(
                      Icons.flag_outlined,
                      size: 64,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No pending reports',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.mediumGrey,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(const LoadReports());
              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.reports.length,
              itemBuilder: (context, index) {
                final report = state.reports[index];
                return _ReportCard(report: report);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final AdminReport report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          'Report on ${report.storyTitle} by ${report.reporterName}, reason: ${report.reason}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ExpansionTile(
          leading: Semantics(
            label: 'Report flag',
            child: const Icon(Icons.flag, color: AppColors.statusRejected),
          ),
          title: Text(
            report.storyTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Reported by ${report.reporterName}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                'Reason: ${report.reason}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.mediumGrey,
                ),
              ),
              Text(
                DateFormatter.timeAgo(report.reportedAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.lightGrey,
                ),
              ),
            ],
          ),
          children: [
            if (report.storyContent != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  report.storyContent!,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Tooltip(
                    message: 'Dismiss this report',
                    child: OutlinedButton.icon(
                      onPressed: () => _actionReport(context, 'dismiss'),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Dismiss'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.mediumGrey,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Remove the reported story',
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _actionReport(context, 'remove_story'),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Remove Story'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.statusRejected,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Send a warning to the creator',
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _actionReport(context, 'warn_creator'),
                      icon: const Icon(Icons.warning_amber_outlined,
                          size: 16),
                      label: const Text('Warn Creator'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.actionCorrection,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Suspend the creator',
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _actionReport(context, 'suspend_creator'),
                      icon: const Icon(Icons.block, size: 16),
                      label: const Text('Suspend Creator'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _actionReport(BuildContext context, String action) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Confirm: $action'),
        content: Text(
          'Are you sure you want to $action for "${report.storyTitle}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AdminBloc>().add(
                    ActionReport(reportId: report.id, action: action),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.statusRejected,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
