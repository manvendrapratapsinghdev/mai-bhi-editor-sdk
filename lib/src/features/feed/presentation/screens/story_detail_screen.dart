import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/analytics/analytics_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../di/injection.dart';
import '../../../../auth/auth_status.dart';
import '../../../../config/mai_bhi_editor_initializer.dart';
import '../../../community/presentation/widgets/report_bottom_sheet.dart';
import '../../../profile/presentation/widgets/creator_badge_widget.dart';
import '../../domain/entities/story_detail.dart';
import '../bloc/story_detail_bloc.dart';
import '../widgets/share_button.dart';

/// Story detail page showing full content, gallery, and interaction buttons.
///
/// Features:
/// - Hero cover image (full width)
/// - Title, creator row with badge and "View Profile"
/// - Verification badges (AI Verified, Editor Verified)
/// - Full description, image gallery, editor verifier name
/// - Stats row: likes, confirmations
/// - Action bar: Like, Confirm, Share with animated transitions
/// - Report button in app bar menu
class StoryDetailScreen extends StatefulWidget {
  final String storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StoryDetailBloc>().add(LoadStoryDetail(widget.storyId));
    sl<AnalyticsService>().track(
      AnalyticsService.storyViewed,
      properties: {'story_id': widget.storyId},
    );
  }

  bool _isAuthenticated() {
    return MaiBhiEditor.authProvider.authStatus == AuthStatus.authenticated;
  }


  Future<bool> _ensureAuthenticated() async {
    if (_isAuthenticated()) return true;
    return await MaiBhiEditor.authProvider.requestLogin();
  }

  void _onLikeTap() async {
    if (!await _ensureAuthenticated()) return;
    sl<AnalyticsService>().track(
      AnalyticsService.storyLiked,
      properties: {'story_id': widget.storyId},
    );
    if (mounted) context.read<StoryDetailBloc>().add(const ToggleLike());
  }

  void _onConfirmTap() async {
    if (!await _ensureAuthenticated()) return;
    sl<AnalyticsService>().track(
      AnalyticsService.storyConfirmed,
      properties: {'story_id': widget.storyId},
    );
    if (mounted) context.read<StoryDetailBloc>().add(const ToggleConfirm());
  }

  void _showReportSheet(String storyId) async {
    if (!await _ensureAuthenticated()) return;
    if (!mounted) return;
    ReportBottomSheet.show(
      context,
      targetType: 'story',
      targetId: storyId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StoryDetailBloc, StoryDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.story == null) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: () => context
                  .read<StoryDetailBloc>()
                  .add(LoadStoryDetail(widget.storyId)),
            );
          }

          final story = state.story;
          if (story == null) {
            return const Center(child: Text('Story not found'));
          }

          return CustomScrollView(
            slivers: [
              // Hero cover image
              _HeroCoverImage(
                story: story,
                onReport: () => _showReportSheet(story.id),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        story.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),

                      // Published date
                      Text(
                        formatRelativeTime(story.publishedAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),

                      // Creator row
                      _CreatorRow(story: story),
                      const SizedBox(height: 16),

                      // Verification badges
                      _VerificationBadgesRow(story: story),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        story.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),

                      // Image gallery
                      if (story.images.isNotEmpty) ...[
                        _ImageGallery(images: story.images),
                        const SizedBox(height: 16),
                      ],

                      // Editor verifier name
                      if (story.editorName != null &&
                          story.editorName!.isNotEmpty) ...[
                        _EditorVerifierRow(
                            editorName: story.editorName!),
                        const SizedBox(height: 16),
                      ],

                      // Stats row with animated counters
                      _AnimatedStatsRow(state: state),
                      const SizedBox(height: 24),

                      // Action bar with animated buttons
                      _AnimatedActionBar(
                        state: state,
                        onLike: _onLikeTap,
                        onConfirm: _onConfirmTap,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Hero cover image with SliverAppBar + report menu
class _HeroCoverImage extends StatelessWidget {
  final StoryDetail story;
  final VoidCallback onReport;

  const _HeroCoverImage({required this.story, required this.onReport});

  @override
  Widget build(BuildContext context) {
    final hasImages = story.images.isNotEmpty;
    final coverUrl = hasImages ? story.images.first : null;

    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: coverUrl != null
            ? Semantics(
                image: true,
                label: 'Cover image for ${story.title}',
                child: CachedNetworkImage(
                  imageUrl: ApiConstants.resolveImageUrl(coverUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: AppColors.extraLightGrey,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.extraLightGrey,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 64,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  ),
                ),
              )
            : ExcludeSemantics(
                child: Container(
                  color: AppColors.extraLightGrey,
                  child: const Center(
                    child: Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ),
              ),
      ),
      actions: [
        ShareButton(storyId: story.id, storyTitle: story.title),
        Semantics(
          button: true,
          label: 'More options',
          child: PopupMenuButton<String>(
            tooltip: 'More options',
            onSelected: (value) {
              if (value == 'report') onReport();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Report Story'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Creator row
class _CreatorRow extends StatelessWidget {
  final StoryDetail story;

  const _CreatorRow({required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final creator = story.creator;

    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.extraLightGrey,
          backgroundImage: creator?.avatarUrl != null
              ? CachedNetworkImageProvider(ApiConstants.resolveImageUrl(creator!.avatarUrl!))
              : null,
          child: creator?.avatarUrl == null
              ? const Icon(Icons.person, color: AppColors.mediumGrey)
              : null,
        ),
        const SizedBox(width: 12),

        // Name + badge
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      creator?.name ?? 'Anonymous',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (creator != null) ...[
                    const SizedBox(width: 6),
                    CreatorBadgeWidget(
                      level: creator.creatorLevel,
                      size: 16,
                      showLabel: false,
                    ),
                  ],
                ],
              ),
              if (story.city != null)
                Text(
                  story.city!,
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
        ),

        // View Profile button
        if (creator != null)
          TextButton(
            onPressed: () => context.push('/creators/${creator.id}'),
            child: const Text('View Profile'),
          ),
      ],
    );
  }
}

// Verification badges
class _VerificationBadgesRow extends StatelessWidget {
  final StoryDetail story;

  const _VerificationBadgesRow({required this.story});

  @override
  Widget build(BuildContext context) {
    if (!story.aiVerified && !story.editorVerified) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (story.aiVerified)
          Semantics(
            label: 'This story has been verified by AI',
            child: const Chip(
              avatar: Icon(Icons.smart_toy, size: 16, color: Colors.white),
              label: Text('AI Verified'),
              backgroundColor: AppColors.statusUnderReview,
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
        if (story.editorVerified)
          Semantics(
            label: 'This story has been verified by an editor',
            child: const Chip(
              avatar:
                  Icon(Icons.verified, size: 16, color: Colors.white),
              label: Text('Editor Verified'),
              backgroundColor: AppColors.statusPublished,
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
      ],
    );
  }
}

// Image gallery
class _ImageGallery extends StatelessWidget {
  final List<String> images;

  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.length <= 1) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: ApiConstants.resolveImageUrl(images[index]),
                  width: 220,
                  height: 160,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 220,
                    height: 160,
                    color: AppColors.extraLightGrey,
                    child: const Center(
                      child:
                          CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 220,
                    height: 160,
                    color: AppColors.extraLightGrey,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Editor verifier row
class _EditorVerifierRow extends StatelessWidget {
  final String editorName;

  const _EditorVerifierRow({required this.editorName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.statusPublishedBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user,
            size: 20,
            color: AppColors.statusPublished,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Verified by $editorName',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.statusPublished,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated stats row with counter animation
class _AnimatedStatsRow extends StatelessWidget {
  final StoryDetailState state;

  const _AnimatedStatsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.extraLightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AnimatedStatItem(
            icon: Icons.favorite,
            count: state.likesCount,
            label: 'Likes',
            color: AppColors.primaryRed,
          ),
          Container(width: 1, height: 32, color: AppColors.divider),
          _AnimatedStatItem(
            icon: Icons.check_circle,
            count: state.confirmationsCount,
            label: 'Confirmations',
            color: AppColors.statusPublished,
          ),
          Container(width: 1, height: 32, color: AppColors.divider),
          Column(
            children: [
              Text(
                'Confirmed by',
                style: theme.textTheme.labelSmall,
              ),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: state.confirmationsCount),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, _) {
                  return Text(
                    '$value users',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.statusPublished,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedStatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const _AnimatedStatItem({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: count),
          duration: const Duration(milliseconds: 400),
          builder: (context, value, _) {
            return Text(
              value.toString(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            );
          },
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

// Action bar with animated transitions
class _AnimatedActionBar extends StatefulWidget {
  final StoryDetailState state;
  final VoidCallback onLike;
  final VoidCallback onConfirm;

  const _AnimatedActionBar({
    required this.state,
    required this.onLike,
    required this.onConfirm,
  });

  @override
  State<_AnimatedActionBar> createState() => _AnimatedActionBarState();
}

class _AnimatedActionBarState extends State<_AnimatedActionBar>
    with TickerProviderStateMixin {
  late AnimationController _likeAnimController;
  late AnimationController _confirmAnimController;
  late Animation<double> _likeScale;
  late Animation<double> _confirmScale;

  bool _prevLiked = false;
  bool _prevConfirmed = false;

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _confirmAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_likeAnimController);
    _confirmScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_confirmAnimController);

    _prevLiked = widget.state.isLiked;
    _prevConfirmed = widget.state.isConfirmed;
  }

  @override
  void didUpdateWidget(covariant _AnimatedActionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isLiked != _prevLiked) {
      _likeAnimController.forward(from: 0);
      _prevLiked = widget.state.isLiked;
    }
    if (widget.state.isConfirmed != _prevConfirmed) {
      _confirmAnimController.forward(from: 0);
      _prevConfirmed = widget.state.isConfirmed;
    }
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    _confirmAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Like button
        Expanded(
          child: ScaleTransition(
            scale: _likeScale,
            child: _ActionButton(
              icon: widget.state.isLiked
                  ? Icons.favorite
                  : Icons.favorite_border,
              label: widget.state.isLiked ? 'Liked' : 'Like',
              color: widget.state.isLiked
                  ? AppColors.primaryRed
                  : AppColors.mediumGrey,
              isFilled: widget.state.isLiked,
              onPressed: widget.onLike,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Confirm button
        Expanded(
          child: ScaleTransition(
            scale: _confirmScale,
            child: _ActionButton(
              icon: widget.state.isConfirmed
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
              label: widget.state.isConfirmed
                  ? 'Confirmed'
                  : 'Confirm',
              color: widget.state.isConfirmed
                  ? AppColors.statusPublished
                  : AppColors.mediumGrey,
              isFilled: widget.state.isConfirmed,
              onPressed: widget.onConfirm,
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Share button
        Expanded(
          child: ShareButton(
            storyId: widget.state.story?.id ?? '',
            storyTitle: widget.state.story?.title ?? '',
            asActionButton: true,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isFilled;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isFilled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isFilled) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        minimumSize: const Size(0, 44),
        textStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// Error view
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
