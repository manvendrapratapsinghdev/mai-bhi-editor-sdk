import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../feed/presentation/widgets/story_card.dart';
import '../../../profile/presentation/widgets/creator_badge_widget.dart';
import '../../domain/entities/creator_profile.dart';
import '../bloc/creator_profile_bloc.dart';
import '../widgets/badge_collection_widget.dart';
import '../widgets/report_bottom_sheet.dart';

/// Public creator profile page.
///
/// Shows profile header with avatar, name, creator level badge,
/// stats row, badge collection, published stories, and action menu.
class CreatorProfileScreen extends StatefulWidget {
  final String creatorId;

  const CreatorProfileScreen({super.key, required this.creatorId});

  @override
  State<CreatorProfileScreen> createState() => _CreatorProfileScreenState();
}

class _CreatorProfileScreenState extends State<CreatorProfileScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<CreatorProfileBloc>()
        .add(LoadCreatorProfile(widget.creatorId));
  }

  void _showBlockDialog(CreatorProfile profile, bool isBlocked) {
    final action = isBlocked ? 'Unblock' : 'Block';
    final message = isBlocked
        ? 'Unblock ${profile.name}? Their stories will appear in your feed again.'
        : 'Block ${profile.name}? Their stories will no longer appear in your feed.';

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$action Creator'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (isBlocked) {
                context
                    .read<CreatorProfileBloc>()
                    .add(UnblockCreator(widget.creatorId));
              } else {
                context
                    .read<CreatorProfileBloc>()
                    .add(BlockCreator(widget.creatorId));
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: isBlocked
                  ? AppColors.statusPublished
                  : AppColors.statusRejected,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }

  void _showReportSheet() {
    ReportBottomSheet.show(
      context,
      targetType: 'creator',
      targetId: widget.creatorId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CreatorProfileBloc, CreatorProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state.reportSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Report submitted. Our team will review it.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return _buildLoadingScaffold();
          }

          if (state.profile == null) {
            return _buildErrorScaffold(state.errorMessage);
          }

          return _buildProfileBody(context, state);
        },
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Creator Profile'),
          pinned: true,
        ),
        SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildErrorScaffold(String? errorMessage) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: Text('Creator Profile'),
          pinned: true,
        ),
        SliverFillRemaining(
          child: Center(
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
                    errorMessage ?? 'Failed to load profile.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.mediumGrey,
                        ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => context
                        .read<CreatorProfileBloc>()
                        .add(LoadCreatorProfile(widget.creatorId)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileBody(
      BuildContext context, CreatorProfileState state) {
    final profile = state.profile!;
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // App bar with action menu
        SliverAppBar(
          title: Text(profile.name),
          pinned: true,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'block') {
                  _showBlockDialog(profile, state.isBlocked);
                } else if (value == 'report') {
                  _showReportSheet();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      Icon(
                        state.isBlocked
                            ? Icons.check_circle_outline
                            : Icons.block,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(state.isBlocked
                          ? 'Unblock Creator'
                          : 'Block Creator'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'report',
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Report Creator'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Profile content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                _ProfileHeader(profile: profile),
                const SizedBox(height: 24),

                // Stats row
                _StatsRow(profile: profile),
                const SizedBox(height: 24),

                // Badge collection
                Text(
                  'Badges',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                BadgeCollectionWidget(badges: profile.badges),
                const SizedBox(height: 24),

                // Join date
                if (profile.joinedAt != null) ...[
                  _JoinDateRow(joinedAt: profile.joinedAt!),
                  const SizedBox(height: 24),
                ],

                // Published stories section
                Text(
                  'Published Stories',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        // Story list
        if (state.isLoadingStories)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (state.stories.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.extraLightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No published stories yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.mediumGrey,
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return StoryCard(story: state.stories[index]);
                },
                childCount: state.stories.length,
              ),
            ),
          ),

        // Bottom padding
        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}

// Profile header with large avatar, name, badge
class _ProfileHeader extends StatelessWidget {
  final CreatorProfile profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          // Large avatar
          Semantics(
            image: true,
            label: 'Profile picture for ${profile.name}',
            child: CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.primaryRedLight,
              backgroundImage: profile.avatarUrl != null
                  ? CachedNetworkImageProvider(ApiConstants.resolveImageUrl(profile.avatarUrl!))
                  : null,
              child: profile.avatarUrl == null
                  ? Text(
                      _initials(profile.name),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Semantics(
            header: true,
            child: Text(
              profile.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),

          // Creator badge
          CreatorBadgeWidget(
            level: profile.creatorLevel,
            size: 24,
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// Stats row: reputation, stories published, accuracy rate
class _StatsRow extends StatelessWidget {
  final CreatorProfile profile;

  const _StatsRow({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.star_outline,
            label: 'Reputation',
            value: profile.reputationPoints.toString(),
            color: AppColors.badgeGold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.article_outlined,
            label: 'Stories',
            value: profile.storiesPublished.toString(),
            color: AppColors.statusPublished,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.verified_outlined,
            label: 'Accuracy',
            value: '${(profile.accuracyRate * 100).toStringAsFixed(0)}%',
            color: AppColors.statusUnderReview,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '$label: $value',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Join date row
class _JoinDateRow extends StatelessWidget {
  final DateTime joinedAt;

  const _JoinDateRow({required this.joinedAt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = DateFormat('MMMM yyyy').format(joinedAt);

    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: AppColors.mediumGrey,
        ),
        const SizedBox(width: 8),
        Text(
          'Joined $formatted',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.mediumGrey,
          ),
        ),
      ],
    );
  }
}
