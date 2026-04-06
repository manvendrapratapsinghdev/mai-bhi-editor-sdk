import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'shimmer_widget.dart';

// ── Story Card Skeleton ────────────────────────────────────────────────

/// Matches the [StoryCard] layout with shimmer placeholders.
class StoryCardSkeleton extends StatelessWidget {
  const StoryCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ShimmerBox(width: double.infinity, height: 180, borderRadius: 0),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title — two lines
                  ShimmerBox(
                      width: double.infinity, height: 16, borderRadius: 4),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 200, height: 16, borderRadius: 4),
                  const SizedBox(height: 12),
                  // Creator row
                  Row(
                    children: [
                      ShimmerBox(width: 32, height: 32, borderRadius: 16),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                              width: 100, height: 12, borderRadius: 4),
                          const SizedBox(height: 4),
                          ShimmerBox(
                              width: 60, height: 10, borderRadius: 4),
                        ],
                      ),
                      const Spacer(),
                      ShimmerBox(width: 50, height: 10, borderRadius: 4),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Stats chips
                  Row(
                    children: [
                      ShimmerBox(width: 64, height: 28, borderRadius: 14),
                      const SizedBox(width: 8),
                      ShimmerBox(width: 64, height: 28, borderRadius: 14),
                    ],
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

// ── Feed Skeleton Loader ───────────────────────────────────────────────

/// Shows multiple [StoryCardSkeleton] items with shimmer animation.
class FeedSkeletonLoader extends StatelessWidget {
  const FeedSkeletonLoader({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: itemCount,
        itemBuilder: (context, index) => const StoryCardSkeleton(),
      ),
    );
  }
}

// ── Story Detail Skeleton ──────────────────────────────────────────────

/// Matches the [StoryDetailScreen] layout with shimmer placeholders.
class StoryDetailSkeleton extends StatelessWidget {
  const StoryDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            ShimmerBox(width: double.infinity, height: 260, borderRadius: 0),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  ShimmerBox(
                      width: double.infinity, height: 24, borderRadius: 4),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 260, height: 24, borderRadius: 4),
                  const SizedBox(height: 6),
                  // Date
                  ShimmerBox(width: 100, height: 12, borderRadius: 4),
                  const SizedBox(height: 16),
                  // Creator row
                  Row(
                    children: [
                      ShimmerBox(width: 40, height: 40, borderRadius: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                              width: 120, height: 14, borderRadius: 4),
                          const SizedBox(height: 4),
                          ShimmerBox(
                              width: 80, height: 12, borderRadius: 4),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description lines
                  for (final w in [1.0, 1.0, 0.9, 0.85, 0.6]) ...[
                    ShimmerBox(
                      width: MediaQuery.of(context).size.width * w - 32,
                      height: 14,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 16),
                  // Stats row
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.extraLightGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShimmerBox(width: 60, height: 40, borderRadius: 4),
                        ShimmerBox(width: 60, height: 40, borderRadius: 4),
                        ShimmerBox(width: 60, height: 40, borderRadius: 4),
                      ],
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

// ── Notification Skeleton ──────────────────────────────────────────────

/// Matches a single notification tile layout.
class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 40, height: 40, borderRadius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                    width: double.infinity, height: 14, borderRadius: 4),
                const SizedBox(height: 6),
                ShimmerBox(width: 200, height: 12, borderRadius: 4),
                const SizedBox(height: 6),
                ShimmerBox(width: 60, height: 10, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows multiple [NotificationSkeleton] items with shimmer animation.
class NotificationListSkeleton extends StatelessWidget {
  const NotificationListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) => const NotificationSkeleton(),
      ),
    );
  }
}
