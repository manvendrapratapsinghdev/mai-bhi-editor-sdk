import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/editorial_queue_item.dart';
import '../bloc/editorial_queue_bloc.dart';

/// Editor review queue showing submissions sorted by AI confidence.
///
/// Implements S4-05: city filter, sort toggle, queue list with cards,
/// auto-refresh every 30 seconds, infinite scroll, pull-to-refresh.
class EditorialQueueScreen extends StatefulWidget {
  const EditorialQueueScreen({super.key});

  @override
  State<EditorialQueueScreen> createState() => _EditorialQueueScreenState();
}

class _EditorialQueueScreenState extends State<EditorialQueueScreen> {
  late EditorialQueueBloc _bloc;
  final ScrollController _scrollController = ScrollController();
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _bloc = context.read<EditorialQueueBloc>();
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
      _bloc.add(const LoadMore());
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
          title: Semantics(
            header: true,
            child: const Text('Editorial Queue'),
          ),
          actions: [
            Semantics(
              button: true,
              label: 'View editor analytics dashboard',
              child: IconButton(
                icon: const Icon(Icons.analytics_outlined),
                tooltip: 'Editor Analytics',
                onPressed: () => context.push('/editorial/analytics'),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // City filter + sort toggle bar.
            _buildFilterBar(context, theme),
            const Divider(height: 1),

            // Queue list.
            Expanded(
              child: BlocBuilder<EditorialQueueBloc, EditorialQueueState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.errorMessage != null && state.items.isEmpty) {
                    return _buildErrorState(context, state, theme);
                  }

                  if (state.isEmpty) {
                    return _buildEmptyState(theme);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _bloc.add(const RefreshQueue());
                      await _bloc.stream.firstWhere(
                        (s) => !s.isLoading,
                      );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      itemCount:
                          state.items.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final item = state.items[index];
                        return _QueueItemCard(
                          item: item,
                          onTap: () {
                            context.push(
                              '/editorial/${item.submission.id}',
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, ThemeData theme) {
    return BlocBuilder<EditorialQueueBloc, EditorialQueueState>(
      buildWhen: (prev, curr) =>
          prev.cityFilter != curr.cityFilter ||
          prev.sortOrder != curr.sortOrder ||
          prev.availableCities != curr.availableCities,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // City filter dropdown.
              Expanded(
                child: _buildCityDropdown(state, theme),
              ),
              const SizedBox(width: 12),
              // Sort toggle.
              Expanded(
                child: _buildSortToggle(state, theme),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCityDropdown(EditorialQueueState state, ThemeData theme) {
    final cities = ['All Cities', ...state.availableCities];

    return DropdownButtonFormField<String>(
      initialValue: state.cityFilter ?? 'All Cities',
      decoration: InputDecoration(
        labelText: 'City',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: cities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(
            city,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        final city = (value == 'All Cities') ? null : value;
        _bloc.add(FilterByCity(city));
      },
    );
  }

  Widget _buildSortToggle(EditorialQueueState state, ThemeData theme) {
    return DropdownButtonFormField<QueueSortOrder>(
      initialValue: state.sortOrder,
      decoration: InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: const [
        DropdownMenuItem(
          value: QueueSortOrder.confidenceScore,
          child: Text('Confidence Score'),
        ),
        DropdownMenuItem(
          value: QueueSortOrder.recent,
          child: Text('Recent'),
        ),
        DropdownMenuItem(
          value: QueueSortOrder.mostConfirmed,
          child: Text('Most Confirmed'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          _bloc.add(ChangeSortOrder(value));
        }
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 96,
              color: AppColors.lightGrey,
            ),
            const SizedBox(height: 24),
            Text(
              'No submissions pending review',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'New submissions will appear here when they are ready for editorial review.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    EditorialQueueState state,
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
              onPressed: () => _bloc.add(const LoadQueue()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single queue item card showing submission summary.
class _QueueItemCard extends StatelessWidget {
  final EditorialQueueItem item;
  final VoidCallback onTap;

  const _QueueItemCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final submission = item.submission;
    final aiReview = submission.aiReview;
    final confidence = item.aiConfidence;
    final hasDuplicate = aiReview?.duplicateOf != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                child: _buildThumbnail(submission.coverImageUrl),
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

                    // Creator name + badge.
                    if (submission.creator != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 14, color: AppColors.mediumGrey),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              submission.creator!.name,
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          _CreatorBadge(
                              level: submission.creator!.creatorLevel.name),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],

                    // AI confidence score bar.
                    _ConfidenceScoreBar(score: confidence),
                    const SizedBox(height: 4),

                    // Safety score + community confirmations + time row.
                    Row(
                      children: [
                        // Safety score indicator.
                        if (aiReview != null) ...[
                          _SafetyIndicator(score: aiReview.safetyScore),
                          const SizedBox(width: 8),
                        ],

                        // Community confirmations count.
                        const Icon(Icons.verified_outlined,
                            size: 14, color: AppColors.mediumGrey),
                        const SizedBox(width: 2),
                        Text(
                          '${item.communityConfirmations}',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),

                        // Time since submission.
                        if (submission.createdAt != null) ...[
                          const Icon(Icons.access_time,
                              size: 14, color: AppColors.mediumGrey),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              DateFormatter.timeAgo(submission.createdAt!),
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Duplicate alert badge.
                    if (hasDuplicate) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.confidenceLowBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.copy_all,
                                size: 12, color: AppColors.confidenceLow),
                            const SizedBox(width: 2),
                            Text(
                              'Possible duplicate',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.confidenceLow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
  }

  Widget _buildThumbnail(String? url) {
    if (url != null && url.isNotEmpty) {
      return Semantics(
        image: true,
        label: 'Submission thumbnail',
        child: Image.network(
          url,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _placeholderThumbnail(),
        ),
      );
    }
    return ExcludeSemantics(child: _placeholderThumbnail());
  }

  Widget _placeholderThumbnail() {
    return Container(
      width: 64,
      height: 64,
      color: AppColors.extraLightGrey,
      child: const Icon(
        Icons.article_outlined,
        color: AppColors.lightGrey,
        size: 28,
      ),
    );
  }
}

/// A small badge showing the creator level.
class _CreatorBadge extends StatelessWidget {
  final String level;

  const _CreatorBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (level) {
      case 'trustedReporter':
        label = 'Trusted';
        color = AppColors.statusPublished;
        break;
      case 'htApprovedCreator':
        label = 'HT Approved';
        color = AppColors.statusUnderReview;
        break;
      default:
        label = 'Basic';
        color = AppColors.mediumGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// A horizontal bar showing the AI confidence score with colour coding.
class _ConfidenceScoreBar extends StatelessWidget {
  final double score;

  const _ConfidenceScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.confidenceColor(score);
    final bgColor = AppColors.confidenceBackgroundColor(score);
    final percentage = (score * 100).toInt();

    return Row(
      children: [
        Text(
          'AI: $percentage%',
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score.clamp(0.0, 1.0),
              backgroundColor: bgColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}

/// A small safety score indicator icon.
class _SafetyIndicator extends StatelessWidget {
  final double score;

  const _SafetyIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    IconData icon;

    if (score >= 0.7) {
      color = AppColors.safetyGood;
      icon = Icons.shield_outlined;
    } else if (score >= 0.4) {
      color = AppColors.safetyWarning;
      icon = Icons.shield_outlined;
    } else {
      color = AppColors.safetyDanger;
      icon = Icons.warning_amber_outlined;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 2),
        Text(
          '${(score * 100).toInt()}%',
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
