import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Displays all reputation badges earned by a creator.
///
/// Each badge shows an icon, name, and visual styling matching its tier.
///
/// Badge types:
/// - "Century Reporter" (100pts) -- bronze star
/// - "Community Voice" (500pts) -- silver megaphone
/// - "HT Gifts Eligible" (1000pts) -- gold gift
/// - "Trusted Reporter" -- diamond shield
/// - "HT Approved" -- blue checkmark
///
/// Shows on both own profile and creator profile.
/// Empty state: "No badges earned yet. Start reporting to earn badges!"
class BadgeCollectionWidget extends StatelessWidget {
  /// List of badge names earned by the creator.
  final List<String> badges;

  /// If true, wraps badges in a Column. If false, uses horizontal scroll.
  final bool vertical;

  const BadgeCollectionWidget({
    super.key,
    required this.badges,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return _EmptyBadgesView();
    }

    final badgeWidgets = badges.map((badge) {
      final config = _badgeConfig(badge);
      return _BadgeTile(config: config);
    }).toList();

    if (vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < badgeWidgets.length; i++) ...[
            badgeWidgets[i],
            if (i < badgeWidgets.length - 1) const SizedBox(height: 8),
          ],
        ],
      );
    }

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badgeWidgets.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) => badgeWidgets[index],
      ),
    );
  }

  _BadgeDisplayConfig _badgeConfig(String badge) {
    final lower = badge.toLowerCase().replaceAll(' ', '_');

    switch (lower) {
      case 'century_reporter':
        return const _BadgeDisplayConfig(
          name: 'Century Reporter',
          description: '100+ reputation points',
          icon: Icons.star,
          color: AppColors.badgeBronze,
          backgroundColor: AppColors.badgeBronzeBg,
        );
      case 'community_voice':
        return const _BadgeDisplayConfig(
          name: 'Community Voice',
          description: '500+ reputation points',
          icon: Icons.campaign,
          color: AppColors.badgeSilver,
          backgroundColor: AppColors.badgeSilverBg,
        );
      case 'ht_gifts_eligible':
        return const _BadgeDisplayConfig(
          name: 'HT Gifts Eligible',
          description: '1000+ reputation points',
          icon: Icons.card_giftcard,
          color: AppColors.statusInProgress, // Gold
          backgroundColor: AppColors.statusInProgressBg,
        );
      case 'trusted_reporter':
        return const _BadgeDisplayConfig(
          name: 'Trusted Reporter',
          description: 'Trusted by the community',
          icon: Icons.shield,
          color: AppColors.badgePurple,
          backgroundColor: AppColors.badgePurpleBg,
        );
      case 'ht_approved':
        return const _BadgeDisplayConfig(
          name: 'HT Approved',
          description: 'Verified by Hindustan Times',
          icon: Icons.verified,
          color: AppColors.primary, // HT Blue
          backgroundColor: AppColors.primaryLight,
        );
      default:
        return _BadgeDisplayConfig(
          name: badge,
          description: 'Achievement badge',
          icon: Icons.military_tech,
          color: AppColors.mediumGrey,
          backgroundColor: AppColors.extraLightGrey,
        );
    }
  }
}

class _BadgeDisplayConfig {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _BadgeDisplayConfig({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

class _BadgeTile extends StatelessWidget {
  final _BadgeDisplayConfig config;

  const _BadgeTile({required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Badge: ${config.name}. ${config.description}',
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: config.color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: config.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                color: config.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              config.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: config.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBadgesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.extraLightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.military_tech_outlined,
            size: 40,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 8),
          Text(
            'No badges earned yet.\nStart reporting to earn badges!',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }
}
