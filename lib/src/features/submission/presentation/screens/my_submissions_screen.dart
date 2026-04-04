import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../editorial/presentation/widgets/appeal_bottom_sheet.dart';
import '../../domain/entities/submission.dart';
import '../bloc/my_submissions_bloc.dart';

/// "Posted by You" dashboard listing the user's submissions.
///
/// Implements S2-07: status filter chips, submission list with status badges,
/// rejection/correction notes, empty state, pull-to-refresh, infinite scroll,
/// and FAB for creating new submissions.
class MySubmissionsScreen extends StatefulWidget {
  const MySubmissionsScreen({super.key});

  @override
  State<MySubmissionsScreen> createState() => _MySubmissionsScreenState();
}

class _MySubmissionsScreenState extends State<MySubmissionsScreen> {
  late MySubmissionsBloc _bloc;
  final ScrollController _scrollController = ScrollController();
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _bloc = context.read<MySubmissionsBloc>();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _bloc.add(const LoadMoreSubmissions());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posted by You'),
        ),
        body: Column(
          children: [
            // ── Status filter chips ───────────────────────────────────
            _buildFilterChips(context, theme),
            const Divider(height: 1),

            // ── Submissions list ──────────────────────────────────────
            Expanded(
              child: BlocBuilder<MySubmissionsBloc, MySubmissionsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.errorMessage != null && state.submissions.isEmpty) {
                    return _buildErrorState(context, state, theme);
                  }

                  if (state.isEmpty) {
                    return _buildEmptyState(context, theme);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _bloc.add(const RefreshMySubmissions());
                      // Wait for state change.
                      await _bloc.stream.firstWhere(
                        (s) => !s.isLoading,
                      );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8, bottom: 80),
                      itemCount: state.submissions.length +
                          (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.submissions.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final submission = state.submissions[index];
                        return _SubmissionListTile(
                          submission: submission,
                          onTap: () => _onSubmissionTapped(submission),
                          onDismissed: submission.status ==
                                  SubmissionStatus.draft
                              ? () => _bloc.add(
                                    DeleteDraftSubmission(submission.id),
                                  )
                              : null,
                          onAppeal: submission.status ==
                                  SubmissionStatus.rejected
                              ? () => _onAppealTapped(submission)
                              : null,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.submit),
          backgroundColor: AppColors.primaryRed,
          tooltip: 'Create new submission',
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, ThemeData theme) {
    return BlocBuilder<MySubmissionsBloc, MySubmissionsState>(
      buildWhen: (prev, curr) => prev.filterStatus != curr.filterStatus,
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _StatusFilterChip(
                label: 'All',
                isSelected: state.filterStatus == null,
                color: AppColors.primaryRed,
                backgroundColor: AppColors.primaryRedLight,
                onSelected: () => _bloc.add(const FilterByStatus(null)),
              ),
              const SizedBox(width: 8),
              _StatusFilterChip(
                label: 'Draft',
                isSelected: state.filterStatus == SubmissionStatus.draft,
                color: AppColors.statusDraft,
                backgroundColor: AppColors.statusDraftBg,
                onSelected: () =>
                    _bloc.add(const FilterByStatus(SubmissionStatus.draft)),
              ),
              const SizedBox(width: 8),
              _StatusFilterChip(
                label: 'In Progress',
                isSelected: state.filterStatus == SubmissionStatus.inProgress,
                color: AppColors.statusInProgress,
                backgroundColor: AppColors.statusInProgressBg,
                onSelected: () => _bloc
                    .add(const FilterByStatus(SubmissionStatus.inProgress)),
              ),
              const SizedBox(width: 8),
              _StatusFilterChip(
                label: 'Under Review',
                isSelected: state.filterStatus == SubmissionStatus.underReview,
                color: AppColors.statusUnderReview,
                backgroundColor: AppColors.statusUnderReviewBg,
                onSelected: () => _bloc
                    .add(const FilterByStatus(SubmissionStatus.underReview)),
              ),
              const SizedBox(width: 8),
              _StatusFilterChip(
                label: 'Published',
                isSelected: state.filterStatus == SubmissionStatus.published,
                color: AppColors.statusPublished,
                backgroundColor: AppColors.statusPublishedBg,
                onSelected: () => _bloc
                    .add(const FilterByStatus(SubmissionStatus.published)),
              ),
              const SizedBox(width: 8),
              _StatusFilterChip(
                label: 'Rejected',
                isSelected: state.filterStatus == SubmissionStatus.rejected,
                color: AppColors.statusRejected,
                backgroundColor: AppColors.statusRejectedBg,
                onSelected: () => _bloc
                    .add(const FilterByStatus(SubmissionStatus.rejected)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.article_outlined,
              size: 96,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 24),
            Text(
              'No submissions yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your submitted news reports will appear here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.submit),
              icon: const Icon(Icons.add),
              label: const Text('Create your first report'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    MySubmissionsState state,
    ThemeData theme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.statusRejected,
            ),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'Something went wrong',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _bloc.add(const LoadMySubmissions()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmissionTapped(Submission submission) {
    if (submission.status == SubmissionStatus.draft) {
      // Navigate to edit form with draft ID.
      context.push('${AppRoutes.submit}?draftId=${submission.id}');
    } else {
      // Navigate to detail screen (for now just show detail route).
      context.push('/submissions/${submission.id}');
    }
  }

  /// Show the appeal bottom sheet for a rejected submission (S4-08).
  void _onAppealTapped(Submission submission) {
    showAppealBottomSheet(
      context: context,
      submissionId: submission.id,
      rejectionReason: null, // Detail view will fetch the full reason.
    );
  }
}

/// A filter chip for submission status filtering.
class _StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onSelected;

  const _StatusFilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.backgroundColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: backgroundColor,
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.darkGrey,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected ? color : AppColors.lightGrey,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

/// A single submission list item card.
class _SubmissionListTile extends StatelessWidget {
  final Submission submission;
  final VoidCallback onTap;
  final VoidCallback? onDismissed;
  final VoidCallback? onAppeal;

  const _SubmissionListTile({
    required this.submission,
    required this.onTap,
    this.onDismissed,
    this.onAppeal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusStr = _statusToString(submission.status);
    final statusColor = AppColors.statusColor(statusStr);
    final statusBgColor = AppColors.statusBackgroundColor(statusStr);

    Widget card = Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image thumbnail.
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildThumbnail(),
              ),
              const SizedBox(width: 12),
              // Content.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title.
                    Text(
                      submission.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // City and time.
                    Row(
                      children: [
                        if (submission.city.isNotEmpty) ...[
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.mediumGrey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            submission.city,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (submission.createdAt != null) ...[
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.mediumGrey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            DateFormatter.timeAgo(submission.createdAt!),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Status badge + appeal button row.
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _statusDisplayLabel(submission.status),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Appeal button for rejected submissions (S4-08).
                        if (submission.status == SubmissionStatus.rejected &&
                            onAppeal != null) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: onAppeal,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRedLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primaryRed
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                'Appeal',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Chevron.
              const Icon(
                Icons.chevron_right,
                color: AppColors.lightGrey,
              ),
            ],
          ),
        ),
      ),
    );

    // Swipe-to-dismiss for drafts.
    if (onDismissed != null) {
      card = Dismissible(
        key: ValueKey('submission_${submission.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          color: AppColors.statusRejected,
          child: const Icon(Icons.delete, color: AppColors.white),
        ),
        confirmDismiss: (_) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete Draft'),
              content: const Text(
                'Are you sure you want to delete this draft?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.statusRejected,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) => onDismissed!(),
        child: card,
      );
    }

    return card;
  }

  Widget _buildThumbnail() {
    if (submission.coverImageUrl != null &&
        submission.coverImageUrl!.isNotEmpty) {
      // Network image for remote submissions.
      return Image.network(
        submission.coverImageUrl!,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, error, stackTrace) => _placeholderThumbnail(),
      );
    }

    // Check if it's a local file path (for drafts).
    if (submission.coverImageUrl == null) {
      return _placeholderThumbnail();
    }

    final file = File(submission.coverImageUrl!);
    if (file.existsSync()) {
      return Image.file(
        file,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, error, stackTrace) => _placeholderThumbnail(),
      );
    }

    return _placeholderThumbnail();
  }

  Widget _placeholderThumbnail() {
    return Container(
      width: 72,
      height: 72,
      color: AppColors.extraLightGrey,
      child: const Icon(
        Icons.article_outlined,
        color: AppColors.lightGrey,
        size: 32,
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
