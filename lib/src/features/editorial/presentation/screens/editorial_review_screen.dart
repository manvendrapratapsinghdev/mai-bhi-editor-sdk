import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../submission/domain/entities/submission.dart';
import '../../../submission/domain/entities/submission_detail.dart';
import '../../../submission/domain/entities/ai_review_result.dart';
import '../../data/models/editor_action_model.dart';
import '../bloc/editor_review_bloc.dart';

/// Editor review detail with approve/edit/reject/correct actions (S4-06)
/// and false-news flag button for published stories (S4-07).
class EditorialReviewScreen extends StatefulWidget {
  final String submissionId;

  const EditorialReviewScreen({super.key, required this.submissionId});

  @override
  State<EditorialReviewScreen> createState() => _EditorialReviewScreenState();
}

class _EditorialReviewScreenState extends State<EditorialReviewScreen> {
  late EditorReviewBloc _bloc;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _bloc = context.read<EditorReviewBloc>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditorReviewBloc, EditorReviewState>(
        listener: (context, state) {
          if (state is EditorReviewActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.statusPublished,
              ),
            );
            // Navigate back to queue.
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.editorialQueue);
            }
          } else if (state is EditorReviewFlagSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.statusPublished,
              ),
            );
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.editorialQueue);
            }
          } else if (state is EditorReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.statusRejected,
              ),
            );
            // Reload to get back to loaded state.
            if (state.submissionId != null) {
              _bloc.add(LoadReview(state.submissionId!));
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Review Submission'),
            ),
            body: _buildBody(context, state),
            bottomNavigationBar: _buildActionBar(context, state),
          );
        },
    );
  }

  Widget _buildBody(BuildContext context, EditorReviewState state) {
    if (state is EditorReviewLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is EditorReviewSubmitting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Submitting action...'),
          ],
        ),
      );
    }

    if (state is EditorReviewLoaded) {
      return _ReviewContent(
        detail: state.submissionDetail,
        editedTitle: state.editedTitle,
        editedDescription: state.editedDescription,
        isFlaggedFalse: state.isFlaggedFalse,
        isFlagging: state.isFlagging,
        onFlagFalse: () => _showFlagFalseDialog(context),
      );
    }

    if (state is EditorReviewError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: AppColors.statusRejected),
              const SizedBox(height: 16),
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  if (state.submissionId != null) {
                    _bloc.add(LoadReview(state.submissionId!));
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget? _buildActionBar(BuildContext context, EditorReviewState state) {
    if (state is! EditorReviewLoaded) return null;

    final isPublished =
        state.submissionDetail.status == SubmissionStatus.published;

    if (isPublished) {
      // For published stories, show only the "Flag as False" button.
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isFlaggedFalse || state.isFlagging
                  ? null
                  : () => _showFlagFalseDialog(context),
              icon: const Icon(Icons.flag_outlined),
              label: Text(state.isFlaggedFalse
                  ? 'Already Flagged'
                  : 'Flag as False News'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionReject,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.lightGrey,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      );
    }

    // For under-review submissions, show the 4 action buttons.
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider),
          ),
        ),
        child: Row(
          children: [
            // Approve.
            Expanded(
              child: _ActionButton(
                label: 'Approve',
                icon: Icons.check_circle_outline,
                color: AppColors.actionApprove,
                onPressed: () => _showApproveDialog(context, state),
              ),
            ),
            const SizedBox(width: 6),
            // Edit.
            Expanded(
              child: _ActionButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                color: AppColors.actionEdit,
                onPressed: () => _showEditDialog(context, state),
              ),
            ),
            const SizedBox(width: 6),
            // Reject.
            Expanded(
              child: _ActionButton(
                label: 'Reject',
                icon: Icons.cancel_outlined,
                color: AppColors.actionReject,
                onPressed: () => _showRejectDialog(context),
              ),
            ),
            const SizedBox(width: 6),
            // Mark Correction.
            Expanded(
              child: _ActionButton(
                label: 'Correct',
                icon: Icons.auto_fix_high,
                color: AppColors.actionCorrection,
                onPressed: () => _showCorrectionDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Action dialogs ──────────────────────────────────────────────────

  void _showApproveDialog(
      BuildContext context, EditorReviewLoaded state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Approve Submission'),
        content: const Text(
          'Are you sure you want to approve and publish this submission?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _bloc.add(const PerformAction(
                EditorAction(action: EditorActionType.approve),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.actionApprove,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, EditorReviewLoaded state) {
    final titleController =
        TextEditingController(text: state.editedTitle ?? '');
    final descController =
        TextEditingController(text: state.editedDescription ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Submission'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _bloc.add(PerformAction(
                EditorAction(
                  action: EditorActionType.edit,
                  editedTitle: titleController.text.trim(),
                  editedDescription: descController.text.trim(),
                ),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.actionEdit,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Submit Edit'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Submission'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: 'Rejection Reason',
              hintText: 'Explain why this submission is being rejected...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Rejection reason is required';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                _bloc.add(PerformAction(
                  EditorAction(
                    action: EditorActionType.reject,
                    rejectionReason: reasonController.text.trim(),
                  ),
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.actionReject,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showCorrectionDialog(BuildContext context) {
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark Correction'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: 'Correction Notes',
              hintText: 'What corrections are needed...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Correction notes are required';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx);
                _bloc.add(PerformAction(
                  EditorAction(
                    action: EditorActionType.markCorrection,
                    correctionNotes: notesController.text.trim(),
                  ),
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.actionCorrection,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Submit Correction'),
          ),
        ],
      ),
    );
  }

  void _showFlagFalseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Flag as False News'),
        content: const Text(
          'Are you sure? This will remove the story from the feed and deduct creator reputation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _bloc.add(const FlagAsFalse());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.actionReject,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Flag as False'),
          ),
        ],
      ),
    );
  }
}

// ── Review content widget ─────────────────────────────────────────────

class _ReviewContent extends StatelessWidget {
  final SubmissionDetail detail;
  final String? editedTitle;
  final String? editedDescription;
  final bool isFlaggedFalse;
  final bool isFlagging;
  final VoidCallback onFlagFalse;

  const _ReviewContent({
    required this.detail,
    this.editedTitle,
    this.editedDescription,
    this.isFlaggedFalse = false,
    this.isFlagging = false,
    required this.onFlagFalse,
  });

  @override
  Widget build(BuildContext context) {
    final aiReview = detail.aiReview;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Submission metadata section ────────────────────────────
          _MetadataSection(detail: detail),
          const SizedBox(height: 16),

          // ── Two-panel text comparison ──────────────────────────────
          _TextComparisonSection(detail: detail),
          const SizedBox(height: 16),

          // ── Safety score card ──────────────────────────────────────
          if (aiReview != null) ...[
            _SafetyScoreCard(aiReview: aiReview),
            const SizedBox(height: 12),
          ],

          // ── Duplicate alert card ───────────────────────────────────
          if (aiReview?.duplicateOf != null) ...[
            _DuplicateAlertCard(
              duplicateOf: aiReview!.duplicateOf!,
            ),
            const SizedBox(height: 12),
          ],

          // ── Community confirmations ────────────────────────────────
          const _InfoRow(
            icon: Icons.verified_outlined,
            label: 'Community Confirmations',
            // The queue item has the confirmations count;
            // for detail view, we show what we have.
            value: 'Available on queue',
          ),
          const SizedBox(height: 8),

          // ── Creator reputation ─────────────────────────────────────
          if (detail.creator != null) ...[
            _CreatorReputationCard(creator: detail.creator!),
            const SizedBox(height: 16),
          ],

          // ── Extra bottom padding for action bar ────────────────────
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ── Metadata section ──────────────────────────────────────────────────

class _MetadataSection extends StatelessWidget {
  final SubmissionDetail detail;

  const _MetadataSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusStr = _statusToString(detail.status);
    final statusColor = AppColors.statusColor(statusStr);
    final statusBg = AppColors.statusBackgroundColor(statusStr);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title.
            Text(
              detail.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Creator.
            if (detail.creator != null) ...[
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 16, color: AppColors.mediumGrey),
                  const SizedBox(width: 4),
                  Text(
                    detail.creator!.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],

            // City + time + status row.
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if (detail.city.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.mediumGrey),
                      const SizedBox(width: 2),
                      Text(detail.city, style: theme.textTheme.bodySmall),
                    ],
                  ),
                if (detail.createdAt != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.mediumGrey),
                      const SizedBox(width: 2),
                      Text(
                        DateFormatter.timeAgo(detail.createdAt!),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusDisplayLabel(detail.status),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
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

  String _statusToString(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.draft:
        return 'draft';
      case SubmissionStatus.inProgress:
        return 'in_progress';
      case SubmissionStatus.underReview:
        return 'under_review';
      case SubmissionStatus.published:
        return 'published';
      case SubmissionStatus.rejected:
        return 'rejected';
    }
  }

  String _statusDisplayLabel(SubmissionStatus status) {
    switch (status) {
      case SubmissionStatus.draft:
        return 'Draft';
      case SubmissionStatus.inProgress:
        return 'In Progress';
      case SubmissionStatus.underReview:
        return 'Under Review';
      case SubmissionStatus.published:
        return 'Published';
      case SubmissionStatus.rejected:
        return 'Rejected';
    }
  }
}

// ── Two-panel text comparison ─────────────────────────────────────────

class _TextComparisonSection extends StatelessWidget {
  final SubmissionDetail detail;

  const _TextComparisonSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final originalText = detail.originalText ?? detail.description;
    final aiCorrectedText = detail.aiRewrittenText ?? detail.description;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Original text panel.
        _TextPanel(
          title: 'Original Text',
          text: originalText,
          backgroundColor: AppColors.statusDraftBg,
          borderColor: AppColors.statusDraft,
        ),
        const SizedBox(height: 12),

        // AI Corrected text panel.
        _TextPanel(
          title: 'AI Corrected Text',
          text: aiCorrectedText,
          backgroundColor: AppColors.statusUnderReviewBg,
          borderColor: AppColors.statusUnderReview,
        ),
      ],
    );
  }
}

class _TextPanel extends StatelessWidget {
  final String title;
  final String text;
  final Color backgroundColor;
  final Color borderColor;

  const _TextPanel({
    required this.title,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: borderColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ── Safety score card ────────────────────────────────────────────────

class _SafetyScoreCard extends StatelessWidget {
  final AIReviewResult aiReview;

  const _SafetyScoreCard({required this.aiReview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safetyScore = aiReview.safetyScore;
    final color = safetyScore >= 0.7
        ? AppColors.safetyGood
        : safetyScore >= 0.4
            ? AppColors.safetyWarning
            : AppColors.safetyDanger;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Safety Score: ${(safetyScore * 100).toInt()}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: safetyScore.clamp(0.0, 1.0),
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),

            // Individual safety flags.
            _SafetyFlag(
              label: 'Hate Speech',
              detected: aiReview.hateSpeechDetected,
            ),
            _SafetyFlag(
              label: 'Toxicity',
              detected: aiReview.toxicityDetected,
            ),
            _SafetyFlag(
              label: 'Spam',
              detected: aiReview.spamDetected,
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyFlag extends StatelessWidget {
  final String label;
  final bool detected;

  const _SafetyFlag({
    required this.label,
    required this.detected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            detected ? Icons.warning_amber_outlined : Icons.check_circle_outline,
            size: 16,
            color: detected ? AppColors.safetyDanger : AppColors.safetyGood,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: detected ? AppColors.safetyDanger : AppColors.darkGrey,
              fontWeight: detected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            detected ? 'DETECTED' : 'Clear',
            style: theme.textTheme.labelSmall?.copyWith(
              color: detected ? AppColors.safetyDanger : AppColors.safetyGood,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Duplicate alert card ─────────────────────────────────────────────

class _DuplicateAlertCard extends StatelessWidget {
  final String duplicateOf;

  const _DuplicateAlertCard({required this.duplicateOf});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: AppColors.confidenceLowBg,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.copy_all,
                color: AppColors.confidenceLow, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Possible Duplicate Detected',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.confidenceLow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This may be a duplicate of submission: $duplicateOf',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.darkGrey,
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
}

// ── Creator reputation card ──────────────────────────────────────────

class _CreatorReputationCard extends StatelessWidget {
  final dynamic creator;

  const _CreatorReputationCard({required this.creator});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Creator Info',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 16, color: AppColors.mediumGrey),
                const SizedBox(width: 8),
                Text(
                  creator.name as String,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star_outline,
                    size: 16, color: AppColors.mediumGrey),
                const SizedBox(width: 8),
                Text(
                  'Reputation: ${creator.reputationPoints}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.article_outlined,
                    size: 16, color: AppColors.mediumGrey),
                const SizedBox(width: 8),
                Text(
                  'Stories Published: ${creator.storiesPublished}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info row helper ──────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.mediumGrey),
        const SizedBox(width: 8),
        Text('$label: ', style: theme.textTheme.bodySmall),
        Expanded(
          child: Text(value, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}

// ── Action button ─────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
