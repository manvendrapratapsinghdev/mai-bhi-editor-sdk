import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../../auth/auth_status.dart';
import '../../../../config/mai_bhi_editor_initializer.dart';
import '../../../profile/presentation/widgets/creator_badge_widget.dart';
import '../../domain/entities/feed_item.dart';

/// Reusable story card widget for feed, search results, and profile screens.
///
/// Displays cover image, title, creator info with badge, like/confirmation
/// counts, city tag, and relative time. Tapping navigates to story detail.
///
/// Supports interactive like and confirm buttons with optimistic UI updates.
/// When the user is not authenticated, tapping action buttons shows a login prompt.
class StoryCard extends StatefulWidget {
  final FeedItem story;

  /// Optional callback for the "Confirm" button.
  /// If null, the confirm button is hidden.
  final VoidCallback? onConfirm;

  /// Whether the user has already confirmed this story.
  final bool isConfirmed;

  /// Optional callback for the "Like" button.
  /// If null, the like button only shows the count (no interaction).
  final VoidCallback? onLike;

  /// Whether the user has already liked this story.
  final bool isLiked;

  /// Override for likes count (for optimistic updates from parent).
  final int? likesOverride;

  /// Override for confirmations count (for optimistic updates from parent).
  final int? confirmationsOverride;

  /// Whether to show a trending fire badge on this card.
  final bool showTrendingBadge;

  const StoryCard({
    super.key,
    required this.story,
    this.onConfirm,
    this.isConfirmed = false,
    this.onLike,
    this.isLiked = false,
    this.likesOverride,
    this.confirmationsOverride,
    this.showTrendingBadge = false,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> with TickerProviderStateMixin {
  late bool _isLiked;
  late bool _isConfirmed;
  late int _likesCount;
  late int _confirmationsCount;

  late AnimationController _likeAnimController;
  late AnimationController _confirmAnimController;
  late Animation<double> _likeScale;
  late Animation<double> _confirmScale;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isConfirmed = widget.isConfirmed;
    _likesCount = widget.likesOverride ?? widget.story.likes;
    _confirmationsCount =
        widget.confirmationsOverride ?? widget.story.confirmations;

    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _confirmAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_likeAnimController);
    _confirmScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_confirmAnimController);
  }

  @override
  void didUpdateWidget(covariant StoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked != oldWidget.isLiked) _isLiked = widget.isLiked;
    if (widget.isConfirmed != oldWidget.isConfirmed) {
      _isConfirmed = widget.isConfirmed;
    }
    if (widget.likesOverride != oldWidget.likesOverride) {
      _likesCount = widget.likesOverride ?? widget.story.likes;
    }
    if (widget.confirmationsOverride != oldWidget.confirmationsOverride) {
      _confirmationsCount =
          widget.confirmationsOverride ?? widget.story.confirmations;
    }
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    _confirmAnimController.dispose();
    super.dispose();
  }

  bool _isAuthenticated(BuildContext context) {
    return MaiBhiEditor.authProvider.authStatus == AuthStatus.authenticated;
  }

  Future<bool> _ensureAuthenticated() async {
    if (_isAuthenticated(context)) return true;
    return await MaiBhiEditor.authProvider.requestLogin();
  }

  void _onLikeTap() async {
    if (!await _ensureAuthenticated()) return;

    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
    _likeAnimController.forward(from: 0);
    widget.onLike?.call();
  }

  void _onConfirmTap() async {
    if (!await _ensureAuthenticated()) return;

    setState(() {
      _isConfirmed = !_isConfirmed;
      _confirmationsCount += _isConfirmed ? 1 : -1;
    });
    _confirmAnimController.forward(from: 0);
    widget.onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          '${widget.story.title} by ${widget.story.creatorName ?? "Anonymous"}${widget.showTrendingBadge ? ", trending" : ""}',
      child: Card(
        child: InkWell(
          onTap: () => context.push('/feed/${widget.story.id}'),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image with optional trending badge
              Stack(
                children: [
                  _CoverImage(imageUrl: widget.story.coverImageUrl),
                  if (widget.showTrendingBadge)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Semantics(
                        label: 'Trending story',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Trending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.story.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Creator row
                  _CreatorRow(
                    creatorName: widget.story.creatorName,
                    creatorLevel: widget.story.creatorLevel,
                  ),
                  const SizedBox(height: 10),

                  // Stats + actions row
                  Row(
                    children: [
                      // Like button/count
                      _InteractiveLikeChip(
                        isLiked: _isLiked,
                        count: _likesCount,
                        scaleAnimation: _likeScale,
                        onTap: widget.onLike != null ? _onLikeTap : null,
                      ),
                      const SizedBox(width: 12),

                      // Confirmation count
                      _StatChip(
                        icon: Icons.check_circle_outline,
                        count: _confirmationsCount,
                        color: AppColors.statusPublished,
                        semanticLabel:
                            '$_confirmationsCount confirmations',
                      ),

                      const Spacer(),

                      // Confirm button
                      if (widget.onConfirm != null)
                        _ConfirmButton(
                          isConfirmed: _isConfirmed,
                          onPressed: _onConfirmTap,
                          scaleAnimation: _confirmScale,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // City tag + time row
                  Row(
                    children: [
                      if (widget.story.city != null &&
                          widget.story.city!.isNotEmpty)
                        _CityChip(city: widget.story.city!),
                      const Spacer(),
                      Text(
                        formatRelativeTime(widget.story.publishedAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Cover image with caching and placeholder
class _CoverImage extends StatelessWidget {
  final String? imageUrl;

  const _CoverImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = ApiConstants.resolveImageUrl(imageUrl);
    if (resolvedUrl.isEmpty) {
      return ExcludeSemantics(
        child: Container(
          height: 180,
          width: double.infinity,
          color: AppColors.extraLightGrey,
          child: const Center(
            child: Icon(
              Icons.article_outlined,
              size: 48,
              color: AppColors.lightGrey,
            ),
          ),
        ),
      );
    }

    return Semantics(
      image: true,
      label: 'Story cover image',
      child: CachedNetworkImage(
        imageUrl: resolvedUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 180,
          width: double.infinity,
          color: AppColors.extraLightGrey,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 180,
          width: double.infinity,
          color: AppColors.extraLightGrey,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: AppColors.lightGrey,
            ),
          ),
        ),
      ),
    );
  }
}

// Creator row with name + badge
class _CreatorRow extends StatelessWidget {
  final String? creatorName;
  final String? creatorLevel;

  const _CreatorRow({
    required this.creatorName,
    required this.creatorLevel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = _parseCreatorLevel(creatorLevel);

    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: 16,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            creatorName ?? 'Anonymous',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (level != null) ...[
          const SizedBox(width: 6),
          CreatorBadgeWidget(
            level: level,
            size: 14,
            showLabel: false,
          ),
        ],
      ],
    );
  }

  CreatorLevel? _parseCreatorLevel(String? level) {
    if (level == null) return null;
    switch (level) {
      case 'basic_creator':
        return CreatorLevel.basicCreator;
      case 'ht_approved_creator':
        return CreatorLevel.htApprovedCreator;
      case 'trusted_reporter':
        return CreatorLevel.trustedReporter;
      default:
        return null;
    }
  }
}

// Interactive like chip with tap and scale animation
class _InteractiveLikeChip extends StatelessWidget {
  final bool isLiked;
  final int count;
  final Animation<double> scaleAnimation;
  final VoidCallback? onTap;

  const _InteractiveLikeChip({
    required this.isLiked,
    required this.count,
    required this.scaleAnimation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isLiked ? Icons.favorite : Icons.favorite_border;
    final color = isLiked ? AppColors.primaryRed : AppColors.primaryRed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: child,
          );
        },
        child: Semantics(
          label: '$count likes',
          button: onTap != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  icon,
                  key: ValueKey(isLiked),
                  size: 16,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _formatCount(count),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

// Stat chip (confirmations)
class _StatChip extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final String semanticLabel;

  const _StatChip({
    required this.icon,
    required this.count,
    required this.color,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            _formatCount(count),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

// City chip
class _CityChip extends StatelessWidget {
  final String city;

  const _CityChip({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.extraLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on_outlined,
              size: 12, color: AppColors.mediumGrey),
          const SizedBox(width: 3),
          Text(
            city,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.darkGrey,
                ),
          ),
        ],
      ),
    );
  }
}

// Confirm button with scale animation
class _ConfirmButton extends StatelessWidget {
  final bool isConfirmed;
  final VoidCallback onPressed;
  final Animation<double> scaleAnimation;

  const _ConfirmButton({
    required this.isConfirmed,
    required this.onPressed,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        );
      },
      child: SizedBox(
        height: 30,
        child: isConfirmed
            ? FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.check, size: 14),
                label: const Text('Confirmed'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.statusPublished,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                  minimumSize: Size.zero,
                ),
              )
            : OutlinedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.check_circle_outline, size: 14),
                label: const Text('Confirm'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.statusPublished,
                  side: const BorderSide(color: AppColors.statusPublished),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                  minimumSize: Size.zero,
                ),
              ),
      ),
    );
  }
}

